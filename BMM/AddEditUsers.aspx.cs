using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BMM_BAL;
using BMM_DAL;

namespace BMM
{
    public partial class AddEditUsers : Classes.BasePage
    {
        #region + Properties

        #region SelectedUser
        private BMM_DAL.User _SelectedUser;
        public BMM_DAL.User SelectedUser
        {
            get
            {
                int id;
                if (_SelectedUser == null)
                {
                    if(Request.QueryString["id"] != null && Int32.TryParse(Request.QueryString["id"], out id))
                    {
                        _SelectedUser = UserClass.GetUserByID(id, true);

                        if (_SelectedUser.CompanyID != CurrentUser.CompanyID)
                            _SelectedUser = null;
                    }
                }

                return _SelectedUser;
            }
        }
        #endregion

        #region RequiredPermission
        /// <summary>
        /// Sets the permission for the page
        /// </summary>
        public override UserClass.PermissionsEnum? RequiredPermission
        {
            get
            {
                return UserClass.PermissionsEnum.Admin_Users; ;
            }
        }
        #endregion

        #region CurrentUsersPermission
        /// <summary>
        /// Gets the permissions for the user to see if they can add/edit/delete
        /// other users
        /// </summary>
        private UserPermission _CurrentUsersPermission;
        public UserPermission CurrentUsersPermission
        {
            get
            {
                if (_CurrentUsersPermission == null)
                {
                    _CurrentUsersPermission = (from p in CurrentUser.UserPermissions
                                               where p.PermissionID == (int)UserClass.PermissionsEnum.Admin_Users
                                               && p.Active
                                               select p).FirstOrDefault();
                }

                return _CurrentUsersPermission;
            }
        }
        #endregion

        #region SelectedNavigationTab
        /// <summary>
        /// sets the navigation tab
        /// </summary>
        public override NavigationTabEnum SelectedNavigationTab
        {
            get { return NavigationTabEnum.AdminConfiguration; }
        }
        #endregion

        #region SelectedSubNavigationTab
        /// <summary>
        /// Sets the sub nav tab
        /// </summary>
        public override SubNavigationTabEnum SelectedSubNavigationTab
        {
            get { return SubNavigationTabEnum.AdminUsers; }
        }
        #endregion

        #endregion

        #region + Events

        #region Page_Load
        /// <summary>
        /// Loads the page and sets some permissions
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!Page.IsPostBack)
            {
                Title = Company.Name + " - User";

                // fills the pages info
                FillPageInfo();

                // checks the permissions for the user and disables or enables controls
                // accordingly
                CheckUserPermissions();

                rfvPassword.Enabled = SelectedUser == null;
                rfvVerifyPassword.Enabled = rfvPassword.Enabled;
                //Adds two onblur attributes to the password text field along with function calls.
                txtPassword.Attributes.Add("onblur", "ComparePasswords()");
                txtPassword.Attributes.Add("onblur", "EnableRequiredField()");
            }

        }
        #endregion

        #region btnCancel_Click
        /// <summary>
        /// Redirects the user back a page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("/ManageUsers.aspx");
        }
        #endregion

        #region btnSubmit_Click
        /// <summary>
        /// casuses the page to validate and saves the user is everythign is cool
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            Page.Validate();

            if(Page.IsValid)
                SaveUser();
        }
        #endregion

        #region cvEmailAddress_ServerValidate
        /// <summary>
        /// Checks to see if the entered email is in use
        /// </summary>
        /// <param name="source"></param>
        /// <param name="args"></param>
        protected void cvEmailAddress_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (EmailNotTaken())
            {
                args.IsValid = true;
            }
            else
                args.IsValid = false;
        }
        #endregion

        #endregion 

        #region + Helpers

        #region CheckUserPermissions
        /// <summary>
        /// Checks the user'p permissions and disables or enables controls accordingly
        /// </summary>
        private void CheckUserPermissions()
        {
            if (SelectedUser != null)
            {
                if (CurrentUsersPermission.AllowEdit == false)
                    DisableControls();
            }
            else if (SelectedUser == null)
            {
                if (CurrentUsersPermission.AllowAdd == false)
                    DisableControls();
            }

        
        }

        private void DisableControls()
        {

            string ToolTipText = TextUserDoesntHavePermissionText;

            btnSubmit.Enabled = false;
            txtEmailAddress.Enabled = false;
            txtFirstName.Enabled = false;
            txtLastName.Enabled = false;
            txtPosition.Enabled = false;
            txtPassword.Enabled = false;
            txtVerifyPassword.Enabled = false;

            btnSubmit.ToolTip = ToolTipText;
            txtEmailAddress.ToolTip = ToolTipText;
            txtFirstName.ToolTip = ToolTipText;
            txtLastName.ToolTip = ToolTipText;
            txtPosition.ToolTip = ToolTipText;
            txtPassword.ToolTip = ToolTipText;
            txtVerifyPassword.ToolTip = ToolTipText;

            // loops throught the checkboxes in the panel and disables them
            // and adds the tool tip
            foreach (Control c in Panel1.Controls)
            {
                if (c is CheckBox)
                {
                    ((CheckBox)(c)).Enabled = false;
                    ((CheckBox)(c)).ToolTip = ToolTipText;
                }
            }
            
        }
        #endregion

        #region SaveUser
        /// <summary>
        /// Saves teh selected user
        /// </summary>
        private void SaveUser()
        {
            BMM_DAL.User myUser;

            if (SelectedUser == null)
                myUser = new User();
            else
            {
                myUser = SelectedUser;
            }

            myUser.FirstName = txtFirstName.Text.Trim();
            myUser.LastName = txtLastName.Text.Trim();
            myUser.Email = txtEmailAddress.Text.Trim();
            myUser.Position = txtPosition.Text.Trim();
            myUser.CompanyID = CurrentUser.CompanyID;

            if (!String.IsNullOrEmpty(txtPassword.Text.Trim()) && !String.IsNullOrEmpty(txtVerifyPassword.Text.Trim()))
                myUser.Password = txtPassword.Text.Trim();


            if (SelectedUser == null)
            {
                myUser.UserPermissions.AddRange(GetUsersPermissions(myUser.ID));
                UserClass.InsertUser(myUser);
            }
            else
            {
                myUser.UserPermissions.Clear();
                myUser.UserPermissions.AddRange(GetUsersPermissions(myUser.ID));
                UserClass.UpdateUser(myUser, true);
            }

            Response.Redirect("/ManageUsers.aspx");
        }
        #endregion

        #region EmailNotTaken
        /// <summary>
        /// checks to see if the email entered is in use or not
        /// </summary>
        /// <returns></returns>
        private bool EmailNotTaken()
        {
            BMM_DAL.User myUser = UserClass.GetUserByEmail(txtEmailAddress.Text.Trim(), Company.ID);
                            
            return ((myUser == null) || (myUser.Active == false) || (SelectedUser != null && (myUser.Email == SelectedUser.Email || myUser.CompanyID != CurrentUser.CompanyID)));
        }
        #endregion

        #region GetUsersPermissions
        /// <summary>
        /// Checks all those checkboxes to see what permissions the user needs set
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        private List<UserPermission> GetUsersPermissions(int id)
        {
            List<UserPermission> myPermissions = new List<UserPermission>();

            // Users GetPermission() to build the UserPermisson and add it to a list of Permissions
            myPermissions.Add(new UserPermission { AllowAdd = true, AllowDelete = false, AllowEdit = false, PermissionID = (int)UserClass.PermissionsEnum.HomePage, UserID = id });
            myPermissions.Add(GetPermission(chkInvoicesView.Checked, chkInvoicesEdit.Checked, chkInvoicesDelete.Checked, chkInvoicesAdd.Checked, (int)UserClass.PermissionsEnum.Invoices, id));
            myPermissions.Add(GetPermission(chkTestView.Checked, chkTestEdit.Checked, chkTestDelete.Checked, chkTestAdd.Checked, (int)UserClass.PermissionsEnum.Invoice_Tests, id));
            myPermissions.Add(GetPermission(chkPaymentInfoView.Checked, chkPaymentInfoEdit.Checked, chkPaymentInfoDelete.Checked, chkPaymentInfoAdd.Checked, (int)UserClass.PermissionsEnum.Invoice_PaymentInformation, id));
            myPermissions.Add(GetPermission(chkCommentsView.Checked, chkCommentsEdit.Checked, chkCommentsDelete.Checked, chkCommentsAdd.Checked, (int)UserClass.PermissionsEnum.Invoice_Comments, id));
            myPermissions.Add(GetPermission(chkSugeriesView.Checked, chkSugeriesEdit.Checked, chkSugeriesDelete.Checked, chkSugeriesAdd.Checked, (int)UserClass.PermissionsEnum.Invoice_Surgeries, id));
            myPermissions.Add(GetPermission(chkProvidersView.Checked, chkProvidersEdit.Checked, chkProvidersDelete.Checked, chkProvidersAdd.Checked, (int)UserClass.PermissionsEnum.Invoice_Providers, id));
            myPermissions.Add(GetPermission(chkPatientsView.Checked, chkPatientsEdit.Checked, chkPatientsDelete.Checked, chkPatientsAdd.Checked, (int)UserClass.PermissionsEnum.Patients, id));
            myPermissions.Add(GetPermission(ChkAdminProperties(), false, false, false, (int)UserClass.PermissionsEnum.Admin, id));
            myPermissions.Add(GetPermission(chkAdminFirmsView.Checked, chkAdminFirmsEdit.Checked, chkAdminFirmsDelete.Checked, chkAdminFirmsAdd.Checked, (int)UserClass.PermissionsEnum.Admin_Firms, id));
            myPermissions.Add(GetPermission(chkAdminAttorneysView.Checked, chkAdminAttorneysEdit.Checked, chkAdminAttorneysDelete.Checked, chkAdminAttorneysAdd.Checked, (int)UserClass.PermissionsEnum.Admin_Attorneys, id));
            myPermissions.Add(GetPermission(chkAdminProvidersView.Checked, chkAdminProvidersEdit.Checked, chkAdminProvidersDelete.Checked, chkAdminProvidersAdd.Checked, (int)UserClass.PermissionsEnum.Admin_Providers, id));
            myPermissions.Add(GetPermission(chkAdminPhysiciansView.Checked, chkAdminPhysiciansEdit.Checked, chkAdminPhysiciansDelete.Checked, chkAdminPhysiciansAdd.Checked, (int)UserClass.PermissionsEnum.Admin_Physicians, id));
            myPermissions.Add(GetPermission(chkAdminCPTView.Checked, chkAdminCPTEdit.Checked, chkAdminCPTDelete.Checked, chkAdminCPTAdd.Checked, (int)UserClass.PermissionsEnum.Admin_CPTCodes, id));
            myPermissions.Add(GetPermission(chkAdminProceduresView.Checked, chkAdminProceduresEdit.Checked, chkAdminProceduresDelete.Checked, chkAdminProceduresAdd.Checked, (int)UserClass.PermissionsEnum.Admin_Surgeries, id));
            myPermissions.Add(GetPermission(chkAdminTestsView.Checked, chkAdminTestsEdit.Checked, chkAdminTestsDelete.Checked, chkAdminTestsAdd.Checked, (int)UserClass.PermissionsEnum.Admin_Tests, id));
            myPermissions.Add(GetPermission(chkAdminLoanView.Checked, chkAdminLoanEdit.Checked, chkAdminLoanDelete.Checked, chkAdminLoanAdd.Checked, (int)UserClass.PermissionsEnum.Admin_LoanTerms, id));
            myPermissions.Add(GetPermission(chkAdminUsersView.Checked, chkAdminUsersEdit.Checked, chkAdminUsersDelete.Checked, chkAdminUsersAdd.Checked, (int)UserClass.PermissionsEnum.Admin_Users, id));
            myPermissions.Add(GetPermission(chkReportsView.Checked, true, true, true, (int)UserClass.PermissionsEnum.Reports, id));

            return myPermissions;
        }
        #endregion

        #region ChkAdminProperties
        /// <summary>
        /// Checks to see if any of the admin section is checked and if so we give them view
        /// permissions to the admin section
        /// </summary>
        /// <returns></returns>
        private bool ChkAdminProperties()
        {
            return (chkAdminAttorneysView.Checked || chkAdminCPTView.Checked || chkAdminFirmsView.Checked || chkAdminLoanView.Checked || chkAdminPhysiciansView.Checked || chkAdminProceduresView.Checked || chkAdminProvidersView.Checked || chkAdminTestsView.Checked || chkAdminUsersView.Checked);
        }
        #endregion

        #region GetPermission
        /// <summary>
        /// builds a new user permission to be added to the list of permissions
        /// </summary>
        /// <param name="view"></param>
        /// <param name="edit"></param>
        /// <param name="delete"></param>
        /// <param name="add"></param>
        /// <param name="permissionsID"></param>
        /// <param name="UserID"></param>
        /// <returns></returns>
        private UserPermission GetPermission(bool view, bool edit, bool delete, bool add, int permissionsID, int UserID)
        {
            return new UserPermission
            {
                AllowView = view,
                AllowEdit = edit,
                AllowDelete = delete,
                AllowAdd = add,
                PermissionID = permissionsID,
                UserID = UserID
            };
        }
        #endregion

        #region FillPageInfo
        /// <summary>
        /// Fills the page with the user'p info
        /// </summary>
        private void FillPageInfo()
        {
            if (SelectedUser == null)
            {
                litPageHeader.Text = "Add New User";
                CheckCheckBoxes();
            }
            else
            {
                litPageHeader.Text = "User Record";
                txtFirstName.Text = SelectedUser.FirstName;
                txtLastName.Text = SelectedUser.LastName;
                txtEmailAddress.Text = SelectedUser.Email;
                txtPosition.Text = SelectedUser.Position;
                SetUserPermissions();
            }
        }
        #endregion


        private void CheckCheckBoxes()
        {
            foreach (Control c in Panel1.Controls)
            {
                if (c is CheckBox)
                {
                    ((CheckBox)(c)).Checked = true;
                }
            }

            chkAdminUsersAdd.Checked = false;
            chkAdminUsersDelete.Checked = false;
            chkAdminUsersEdit.Checked = false;
            chkAdminUsersView.Checked = false;
        }


        #region SetUserPermissions
        /// <summary>
        /// Sets the values of the checkboxes
        /// </summary>
        private void SetUserPermissions()
        {
            chkAdminAttorneysAdd.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Attorneys).AllowAdd;
            chkAdminAttorneysEdit.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Attorneys).AllowEdit;
            chkAdminAttorneysDelete.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Attorneys).AllowDelete;
            chkAdminAttorneysView.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Attorneys).AllowView;

            chkAdminCPTAdd.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_CPTCodes).AllowAdd;
            chkAdminCPTEdit.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_CPTCodes).AllowEdit;
            chkAdminCPTDelete.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_CPTCodes).AllowDelete;
            chkAdminCPTView.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_CPTCodes).AllowView;

            chkInvoicesAdd.Checked = GetUserPermission(UserClass.PermissionsEnum.Invoices).AllowAdd;
            chkInvoicesEdit.Checked = GetUserPermission(UserClass.PermissionsEnum.Invoices).AllowEdit;
            chkInvoicesDelete.Checked = GetUserPermission(UserClass.PermissionsEnum.Invoices).AllowDelete;
            chkInvoicesView.Checked = GetUserPermission(UserClass.PermissionsEnum.Invoices).AllowView;

            chkTestAdd.Checked = GetUserPermission(UserClass.PermissionsEnum.Invoice_Tests).AllowAdd;
            chkTestEdit.Checked = GetUserPermission(UserClass.PermissionsEnum.Invoice_Tests).AllowEdit;
            chkTestDelete.Checked = GetUserPermission(UserClass.PermissionsEnum.Invoice_Tests).AllowDelete;
            chkTestView.Checked = GetUserPermission(UserClass.PermissionsEnum.Invoice_Tests).AllowView;

            chkPaymentInfoAdd.Checked = GetUserPermission(UserClass.PermissionsEnum.Invoice_PaymentInformation).AllowAdd;
            chkPaymentInfoEdit.Checked = GetUserPermission(UserClass.PermissionsEnum.Invoice_PaymentInformation).AllowEdit;
            chkPaymentInfoDelete.Checked = GetUserPermission(UserClass.PermissionsEnum.Invoice_PaymentInformation).AllowDelete;
            chkPaymentInfoView.Checked = GetUserPermission(UserClass.PermissionsEnum.Invoice_PaymentInformation).AllowView;

            chkCommentsAdd.Checked = GetUserPermission(UserClass.PermissionsEnum.Invoice_Comments).AllowAdd;
            chkCommentsEdit.Checked = GetUserPermission(UserClass.PermissionsEnum.Invoice_Comments).AllowEdit;
            chkCommentsDelete.Checked = GetUserPermission(UserClass.PermissionsEnum.Invoice_Comments).AllowDelete;
            chkCommentsView.Checked = GetUserPermission(UserClass.PermissionsEnum.Invoice_Comments).AllowView;

            chkSugeriesAdd.Checked = GetUserPermission(UserClass.PermissionsEnum.Invoice_Surgeries).AllowAdd;
            chkSugeriesEdit.Checked = GetUserPermission(UserClass.PermissionsEnum.Invoice_Surgeries).AllowEdit;
            chkSugeriesDelete.Checked = GetUserPermission(UserClass.PermissionsEnum.Invoice_Surgeries).AllowDelete;
            chkSugeriesView.Checked = GetUserPermission(UserClass.PermissionsEnum.Invoice_Surgeries).AllowView;

            chkProvidersAdd.Checked = GetUserPermission(UserClass.PermissionsEnum.Invoice_Providers).AllowAdd;
            chkProvidersEdit.Checked = GetUserPermission(UserClass.PermissionsEnum.Invoice_Providers).AllowEdit;
            chkProvidersDelete.Checked = GetUserPermission(UserClass.PermissionsEnum.Invoice_Providers).AllowDelete;
            chkProvidersView.Checked = GetUserPermission(UserClass.PermissionsEnum.Invoice_Providers).AllowView;

            chkPatientsAdd.Checked = GetUserPermission(UserClass.PermissionsEnum.Patients).AllowAdd;
            chkPatientsEdit.Checked = GetUserPermission(UserClass.PermissionsEnum.Patients).AllowEdit;
            chkPatientsDelete.Checked = GetUserPermission(UserClass.PermissionsEnum.Patients).AllowDelete;
            chkPatientsView.Checked = GetUserPermission(UserClass.PermissionsEnum.Patients).AllowView;
            
            chkAdminFirmsAdd.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Firms).AllowAdd;
            chkAdminFirmsEdit.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Firms).AllowEdit;
            chkAdminFirmsDelete.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Firms).AllowDelete;
            chkAdminFirmsView.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Firms).AllowView;

            chkAdminProvidersAdd.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Providers).AllowAdd;
            chkAdminProvidersEdit.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Providers).AllowEdit;
            chkAdminProvidersDelete.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Providers).AllowDelete;
            chkAdminProvidersView.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Providers).AllowView;

            chkAdminPhysiciansAdd.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Physicians).AllowAdd;
            chkAdminPhysiciansEdit.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Physicians).AllowEdit;
            chkAdminPhysiciansDelete.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Physicians).AllowDelete;
            chkAdminPhysiciansView.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Physicians).AllowView;

            chkAdminProceduresAdd.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Surgeries).AllowAdd;
            chkAdminProceduresEdit.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Surgeries).AllowEdit;
            chkAdminProceduresDelete.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Surgeries).AllowDelete;
            chkAdminProceduresView.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Surgeries).AllowView;

            chkAdminTestsAdd.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Tests).AllowAdd;
            chkAdminTestsEdit.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Tests).AllowEdit;
            chkAdminTestsDelete.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Tests).AllowDelete;
            chkAdminTestsView.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Tests).AllowView;

            chkAdminLoanAdd.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_LoanTerms).AllowAdd;
            chkAdminLoanEdit.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_LoanTerms).AllowEdit;
            chkAdminLoanDelete.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_LoanTerms).AllowDelete;
            chkAdminLoanView.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_LoanTerms).AllowView;

            chkAdminUsersAdd.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Users).AllowAdd;
            chkAdminUsersEdit.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Users).AllowEdit;
            chkAdminUsersDelete.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Users).AllowDelete;
            chkAdminUsersView.Checked = GetUserPermission(UserClass.PermissionsEnum.Admin_Users).AllowView;

            //chkReportsAdd.Checked = GetUserPermission(UserClass.PermissionsEnum.Reports).AllowAdd;
            //chkReportsEdit.Checked = GetUserPermission(UserClass.PermissionsEnum.Reports).AllowEdit;
            //chkReportsDelete.Checked = GetUserPermission(UserClass.PermissionsEnum.Reports).AllowDelete;
            chkReportsView.Checked = GetUserPermission(UserClass.PermissionsEnum.Reports).AllowView;

        }
        #endregion

        #region GetUserPermission
        /// <summary>
        /// Sets a new user permission for new users
        /// </summary>
        /// <param name="Enum"></param>
        /// <returns></returns>
        private UserPermission GetUserPermission(UserClass.PermissionsEnum Enum)
        {
            UserPermission myPermission = (from p in SelectedUser.UserPermissions
                                           where p.PermissionID == (int)Enum
                                           select p).FirstOrDefault();


            return myPermission != null ? myPermission : new UserPermission { AllowView = false, AllowAdd = false, AllowEdit = false };
        }
        #endregion

        #endregion
    }
}