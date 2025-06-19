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
    public partial class ConfirmDeleteProcedure : Classes.BasePage
    {
        #region + Events

        #region Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {
            int id;
            bool hasActiveInvoice;

            if (Int32.TryParse(Request.QueryString["id"], out id))
                hasActiveInvoice = !SurgeryClass.CanInactivateSurgery(id);
            else
                hasActiveInvoice = false;

            if (hasActiveInvoice)
            {
                litMessage.Text = "This surgery is currently assigned to an invoice. You will not be able to delete this surgery.";
                btnCancel.Text = "Ok";
                btnSubmit.Visible = false;
            }
            else
                litMessage.Text = "Are you sure you want to delete this procedure?";
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
                BMM_DAL.Surgery myProcedure = SurgeryClass.GetSurgeryByID(id);
                if (myProcedure.CompanyID == CurrentUser.CompanyID)
                {
                    myProcedure.Active = false;
                    SurgeryClass.UpdateSurgery(myProcedure);
                }
            }

            ClientScript.RegisterClientScriptBlock(Page.GetType(), "Close", "Close(true, " + Request.QueryString["id"] + ");", true);
        }
        #endregion

        #endregion
    }
}