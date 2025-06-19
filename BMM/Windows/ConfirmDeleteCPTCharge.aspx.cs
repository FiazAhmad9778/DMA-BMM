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
    public partial class ConfirmDeleteCPTCharge : Classes.BasePage
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
        private UserPermission _CurrentInvoicesTestsPermission;
        public UserPermission CurrentInvoicesTestsPermission
        {
            get
            {
                if (_CurrentInvoicesTestsPermission == null)
                {
                    _CurrentInvoicesTestsPermission = (from p in CurrentUser.UserPermissions
                                                       where p.PermissionID == (int)UserClass.PermissionsEnum.Invoice_Tests
                                                       && p.Active
                                                       select p).FirstOrDefault();
                    // if there was no permission found, spoof a UserPermission object with all permission set to false
                    if (_CurrentInvoicesTestsPermission == null)
                    {
                        _CurrentInvoicesTestsPermission = new UserPermission()
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

                return _CurrentInvoicesTestsPermission;
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
        public TestInvoice_Test_Custom Test
        {
            get
            {
                return (TestInvoice_Test_Custom)Session["Test_" + Request.QueryString["tsk"]];
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
                if (PageMode == Mode.Test && CurrentInvoicesTestsPermission.AllowEdit && Test != null)
                {
                    var cptCharge = (from c in Test.CPTCodeList
                                     where c.ID == id
                                     select c).FirstOrDefault();
                    if (cptCharge != null)
                    {
                        if (cptCharge.ID > 0)
                        {
                            cptCharge.Active = false;
                        }
                        else
                        {
                            Test.CPTCodeList.Remove(cptCharge);
                        }
                    }
                }
                else if (PageMode == Mode.Provider && CurrentInvoicesProvidersPermission.AllowEdit && Provider != null)
                {
                    var cptCharge = (from c in Provider.CPTCodes
                                     where c.ID == id
                                     select c).FirstOrDefault();
                    if (cptCharge != null)
                    {
                        if (cptCharge.ID > 0)
                        {
                            cptCharge.Active = false;
                        }
                        else
                        {
                            Provider.CPTCodes.Remove(cptCharge);
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