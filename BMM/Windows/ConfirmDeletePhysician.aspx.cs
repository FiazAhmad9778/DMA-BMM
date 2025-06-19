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
    public partial class ConfirmDeletePhysician : Classes.BasePage
    {
        #region + Events

        #region Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {
            int id;
            bool hasActiveInvoice;

            if (Int32.TryParse(Request.QueryString["id"], out id))
                hasActiveInvoice = !PhysicianClass.CanInactivatePhysician(id);
            else
                hasActiveInvoice = false;

            if (hasActiveInvoice)
            {
                litMessage.Text = "This physician is currently assigned to an invoice. You will not be able to delete this physician.";
                btnCancel.Text = "Ok";
                btnSubmit.Visible = false;
            }
            else
                litMessage.Text = "Are you sure you want to delete this physician?";
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
                BMM_DAL.Physician myPhysician = PhysicianClass.GetPhysicianByID(id, true, true);
                if (myPhysician.CompanyID == CurrentUser.CompanyID)
                {
                    myPhysician.Active = false;
                    PhysicianClass.UpdatePhysician(myPhysician);
                }
            }

            ClientScript.RegisterClientScriptBlock(Page.GetType(), "Close", "Close();", true);
        }
        #endregion

        #endregion
    }
}