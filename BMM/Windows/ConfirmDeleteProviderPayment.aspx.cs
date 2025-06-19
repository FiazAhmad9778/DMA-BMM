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
    public partial class ConfirmDeleteProviderPayment : Classes.BasePage
    {
        #region + Properties

        #region RequiredPermission
        public override UserClass.PermissionsEnum? RequiredPermission
        {
            get
            {
                return UserClass.PermissionsEnum.Invoice_Providers;
            }
        }
        #endregion

        #region CurrentInvoicesProvidersPermission
        /// <summary>
        /// Gets the permissions for the user to see if they can add/edit/delete invoice providers
        /// </summary>
        private UserPermission _CurrentInvoicesProvidersPermission;
        public UserPermission CurrentInvoicesProvidersPermission
        {
            get
            {
                if (_CurrentInvoicesProvidersPermission == null)
                {
                    _CurrentInvoicesProvidersPermission = (from p in CurrentUser.UserPermissions
                                                           where p.PermissionID == (int)UserClass.PermissionsEnum.Invoice_Providers
                                                           && p.Active
                                                           select p).FirstOrDefault();
                    // if there was no permission found, spoof a UserPermission object with all permission set to false
                    if (_CurrentInvoicesProvidersPermission == null)
                    {
                        _CurrentInvoicesProvidersPermission = new UserPermission()
                        {
                            ID = -1,
                            UserID = CurrentUser.ID,
                            PermissionID = (int)UserClass.PermissionsEnum.Invoice_Tests,
                            AllowView = false,
                            AllowEdit = false,
                            AllowAdd = false,
                            AllowDelete = false,
                            DateAdded = DateTime.Now,
                            Active = true
                        };
                    }
                }

                return _CurrentInvoicesProvidersPermission;
            }
        }
        #endregion

        #region Provider
        public SurgeryInvoice_Provider_Custom Provider
        {
            get
            {
                return (SurgeryInvoice_Provider_Custom)Session["Provider_" + Request.QueryString["psk"]];
            }
        }
        #endregion

        #endregion

        #region + Events

        #region btnSubmit_Click
        /// <summary>
        /// sets the selected invoice to inactive and closes the window
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int id;
            if (int.TryParse(Request.QueryString["id"], out id) && CurrentInvoicesProvidersPermission.AllowEdit && Provider != null)
            {
                var payment = (from s in Provider.Payments
                               where s.ID == id
                               select s).FirstOrDefault();
                if (payment != null)
                {
                    if (payment.ID > 0) payment.Active = false;
                    else Provider.Payments.Remove(payment);
                }
            }

            ClientScript.RegisterClientScriptBlock(Page.GetType(), "Close", "Close(true);", true);
        }
        #endregion

        #endregion
    }
}