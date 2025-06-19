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
    public partial class ConfirmDeleteAttorney : Classes.BasePage
    {
        #region + Events

        #region Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {
            int id;
            bool hasActiveInvoice;

            if (Int32.TryParse(Request.QueryString["id"], out id))
                hasActiveInvoice = !AttorneyClass.CanInactivateAttorney(id);
            else
                hasActiveInvoice = false;

            if (hasActiveInvoice)
            {
                litMessage.Text = "This attorney is currently assigned to an invoice.  You will not be able to delete this attorney.";
                btnCancel.Text = "OK";
                btnSubmit.Visible = false;
            }
            else
                litMessage.Text = "Are you sure you want to delete this attorney?";
        }
        #endregion

        #region btnSubmit_Click
        /// <summary>
        /// sets the selected user to inactive and closes the window
        /// </summary>
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int id;

            if (Int32.TryParse(Request.QueryString["id"], out id))
            {
                BMM_DAL.Attorney myAttorney = AttorneyClass.GetAttorneyByID(id, true, true, true);
                if (myAttorney.CompanyID == CurrentUser.CompanyID)
                {
                    myAttorney.Active = false;
                    AttorneyClass.UpdateAttorney(myAttorney);
                }
            }

            ClientScript.RegisterClientScriptBlock(Page.GetType(), "Close", "Close();", true);
        }
        #endregion

        #endregion
    }
}