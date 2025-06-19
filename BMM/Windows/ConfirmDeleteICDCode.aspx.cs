using BMM_BAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BMM.Windows
{
    public partial class ConfirmDeleteICDCode : Classes.BasePage
    {
             #region + Events

        #region Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {
            int id;
            bool hasActiveInvoice;

            if (Int32.TryParse(Request.QueryString["id"], out id))
                hasActiveInvoice = !ICDCodeClass.CanInactivateICDCode(id);
            else
                hasActiveInvoice = false;

            if (hasActiveInvoice)
            {
                litMessage.Text = "This ICD Code is currently assigned to an invoice. You will not be able to delete this ICD Code.";
                btnCancel.Text = "Ok";
                btnSubmit.Visible = false;
            }
            else
                litMessage.Text = "Are you sure you want to delete this ICD Code?";
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
                BMM_DAL.ICDCode myICDCode = ICDCodeClass.GetICDCodeByID(id);
                if (myICDCode.CompanyID == CurrentUser.CompanyID)
                {
                    myICDCode.Active = false;
                    ICDCodeClass.UpdateICDCode(myICDCode);
                    ClearCompanyICDCodeCache();
                }
            }

            ClientScript.RegisterClientScriptBlock(Page.GetType(), "Close", "Close(true, " + Request.QueryString["id"] + ");", true);
        }
        #endregion

        #endregion
    }
}