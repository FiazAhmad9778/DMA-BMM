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
    public partial class ConfirmDeleteInvoice : Classes.BasePage
    {
        #region + Properties

        #region RequiredPermission
        public override UserClass.PermissionsEnum? RequiredPermission
        {
            get
            {
                return UserClass.PermissionsEnum.Invoices;
            }
        }
        #endregion

        #region CurrentInvoicesPermission
        /// <summary>
        /// Gets the permissions for the user to see if they can add/edit/delete invoices
        /// </summary>
        private UserPermission _CurrentInvoicesPermission;
        public UserPermission CurrentInvoicesPermission
        {
            get
            {
                if (_CurrentInvoicesPermission == null)
                {
                    _CurrentInvoicesPermission = (from p in CurrentUser.UserPermissions
                                                  where p.PermissionID == (int)UserClass.PermissionsEnum.Invoices
                                                  && p.Active
                                                  select p).FirstOrDefault();
                    // if there was no permission found, spoof a UserPermission object with all permission set to false
                    if (_CurrentInvoicesPermission == null)
                    {
                        _CurrentInvoicesPermission = new UserPermission()
                        {
                            ID = -1,
                            UserID = CurrentUser.ID,
                            PermissionID = (int)UserClass.PermissionsEnum.Invoices,
                            AllowView = false,
                            AllowEdit = false,
                            AllowAdd = false,
                            AllowDelete = false,
                            DateAdded = DateTime.Now,
                            Active = true
                        };
                    }
                }

                return _CurrentInvoicesPermission;
            }
        }
        #endregion

        #endregion

        #region + Events

        #region btnYes_Click
        /// <summary>
        /// sets the selected invoice to inactive and closes the window
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnYes_Click(object sender, EventArgs e)
        {
            int id;

            if (CurrentInvoicesPermission.AllowDelete && Int32.TryParse(Request.QueryString["id"], out id))
            {
                InvoiceClass.SetInvoiceActive(id, false);
            }

            ClientScript.RegisterClientScriptBlock(Page.GetType(), "Close", "Close(true);", true);
        }
        #endregion

        #endregion
    }
}