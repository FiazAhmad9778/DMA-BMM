using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BMM_BAL;
using BMM_DAL;

namespace BMM.Windows
{
    public partial class ConfirmDeleteFirm : Classes.BasePage
    {
        #region + Events

        #region Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {
            int id;
            bool hasActiveInvoice;

            if (Int32.TryParse(Request.QueryString["id"], out id))
                hasActiveInvoice = !FirmClass.CanInactivateFirm(id);
            else
                hasActiveInvoice = false;

            if (hasActiveInvoice)
            {
                litMessage.Text = "This firm is currently assigned to an invoice.  You will not be able to delete this firm.";
                btnCancel.Text = "Ok";
                btnSubmit.Visible = false;
            }
            else
                litMessage.Text = "Are you sure you want to delete this firm?";
        }
        #endregion

        #region btnSubmit_Click
        /// <summary>
        /// sets the selected user to inactive and closes the window
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int id;

            if (Int32.TryParse(Request.QueryString["id"], out id))
            {
                BMM_DAL.Firm firm = FirmClass.GetFirmByID(id, true, false);
                if (CurrentUser.CompanyID == firm.CompanyID)
                {
                    firm.Active = false;
                    FirmClass.UpdateFirm(firm);

                    foreach (Attorney a in firm.Attorneys)
                    {                         
                        a.FirmID = null;
                        AttorneyClass.UpdateAttorney(a);
                    }
                }
            }

            ClientScript.RegisterClientScriptBlock(Page.GetType(), "Close", "Close();", true);
        }
        #endregion

        #endregion
    }
}