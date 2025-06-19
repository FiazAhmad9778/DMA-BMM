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
    public partial class ConfirmDeleteCPTCode : Classes.BasePage
    {
        #region + Events

        #region Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {
            int id;
            bool hasActiveInvoice;

            if (Int32.TryParse(Request.QueryString["id"], out id))
                hasActiveInvoice = !CPTCodeClass.CanInactivateCPTCode(id);
            else
                hasActiveInvoice = false;

            if (hasActiveInvoice)
            {
                litMessage.Text = "This CPT Code is currently assigned to an invoice. You will not be able to delete this CPT Code.";
                btnCancel.Text = "Ok";
                btnSubmit.Visible = false;
            }
            else
                litMessage.Text = "Are you sure you want to delete this CPT Code?";
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
                BMM_DAL.CPTCode myCPTCode = CPTCodeClass.GetCPTCodeByID(id);
                if (myCPTCode.CompanyID == CurrentUser.CompanyID)
                {
                    myCPTCode.Active = false;
                    CPTCodeClass.UpdateCPTCode(myCPTCode);
                    ClearCompanyCPTCodeCache();
                }
            }

            ClientScript.RegisterClientScriptBlock(Page.GetType(), "Close", "Close(true, " + Request.QueryString["id"] + ");", true);
        }
        #endregion

        #endregion
    }
}