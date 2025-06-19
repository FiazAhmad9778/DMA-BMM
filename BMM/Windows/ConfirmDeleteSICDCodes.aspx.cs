using BMM_BAL;
using BMM_DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BMM.Windows
{
    public partial class ConfirmDeleteSICDCodes : Classes.BasePage
    {
        #region + Enums

        private enum Mode
        {
            Test,
            Provider
        }

        #endregion

        #region + Properties

        #region RequiredPermission
        public override UserClass.PermissionsEnum? RequiredPermission
        {
            get
            {
                return PageMode == Mode.Test ? UserClass.PermissionsEnum.Invoice_Tests : UserClass.PermissionsEnum.Invoice_Providers;
            }
        }
        #endregion

        #region CurrentInvoicesPermission
        /// <summary>
        /// Gets the permissions for the user to see if they can add/edit/delete invoice tests
        /// </summary>
        private UserPermission _CurrentInvoicesSurgeryPermission;
        public UserPermission CurrentInvoicesSurgeryPermission
        {
            get
            {
                if (_CurrentInvoicesSurgeryPermission == null)
                {
                    _CurrentInvoicesSurgeryPermission = (from p in CurrentUser.UserPermissions
                                                       where p.PermissionID == (int)UserClass.PermissionsEnum.Invoice_Surgeries
                                                       && p.Active
                                                       select p).FirstOrDefault();
                    // if there was no permission found, spoof a UserPermission object with all permission set to false
                    if (_CurrentInvoicesSurgeryPermission == null)
                    {
                        _CurrentInvoicesSurgeryPermission = new UserPermission()
                        {
                            ID = -1,
                            UserID = CurrentUser.ID,
                            PermissionID = (int)UserClass.PermissionsEnum.Invoice_Surgeries,
                            AllowView = false,
                            AllowEdit = false,
                            AllowAdd = false,
                            AllowDelete = false,
                            DateAdded = DateTime.Now,
                            Active = true
                        };
                    }
                }

                return _CurrentInvoicesSurgeryPermission;
            }
        }
        #endregion

        #region CurrentInvoicesPermission
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

        #region Test
        public SurgeryInvoice_Surgery_Custom Surgery
        {
            get
            {
                return (SurgeryInvoice_Surgery_Custom)Session["Surgery_" + Request.QueryString["tsk"]];
            }
        }
        #endregion


        #region PageMode
        private Mode PageMode
        {
            get
            {
                return Request.QueryString["mode"] == "provider" ? Mode.Provider : Mode.Test;
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
            if (int.TryParse(Request.QueryString["id"], out id))
            {
                if (PageMode == Mode.Test && CurrentInvoicesSurgeryPermission.AllowEdit && Surgery != null)
                {

                        var icdCharge = (from c in Surgery.icdCodesList
                                         where c.ID == id
                                         select c).FirstOrDefault();
                        if (icdCharge != null)
                        {
                            if (icdCharge.ID > 0)
                            {
                                icdCharge.Active = false;
                            }
                        }
                    }
                    
                
            }

            ClientScript.RegisterClientScriptBlock(Page.GetType(), "Close", "Close(true);", true);
        }
        #endregion

        #endregion
    }
}