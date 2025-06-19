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
    public partial class ManageTests : Classes.BasePage
    {
        #region +Properties

        #region RequiredPermission
        /// <summary>
        /// Sets the permission for the page
        /// </summary>
        public override UserClass.PermissionsEnum? RequiredPermission
        {
            get
            {
                return UserClass.PermissionsEnum.Admin_Tests;
            }
        }
        #endregion

        #region CurrentUsersPermission
        /// <summary>
        /// Gets the permissions for the user to see if they can add/edit/delete Tests/procedures
        /// </summary>
        private UserPermission _CurrentUsersPermission;
        public UserPermission CurrentUsersPermission
        {
            get
            {
                if (_CurrentUsersPermission == null)
                {
                    _CurrentUsersPermission = (from p in CurrentUser.UserPermissions
                                               where p.PermissionID == (int)UserClass.PermissionsEnum.Admin_Tests
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
            get { return SubNavigationTabEnum.AdminTests; }
        }
        #endregion

        #endregion

        #region +Events

        #region Page_Load
        /// <summary>
        /// Sets up the page
        /// </summary>
        protected void Page_Load(object sender, EventArgs e)
        {
            Title = Company.Name + " - Manage Tests";

            if (!Page.IsPostBack)
            {
                CheckUserPermission();
            }
        }
        #endregion

        #region grdTests_OnItemCommand
        //upon clicking the name of the tit_c, or edit, the onitemcommand will load the textbox with the name for editing
        //it will also change out the add button into two buttons for save and cancel
        protected void grdTests_OnItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs args)
        {
            if (args.CommandName == "lnkEdit" || args.CommandName == "btnView")
            {
                btnEdit_Click(args.CommandArgument.ToString());
            }
            else if (args.CommandName == "btnEdit")
                btnEdit_Click(args.CommandArgument.ToString());

        }
        #endregion

        #region btnEdit_Click
        //when the edit button is clicked, the textbox will be loaded with the name of the sis for editing
        //will also change add button into the save/cancel button combo
        protected void btnEdit_Click(string args)
        {
            if (CurrentUsersPermission.AllowEdit)
            {
                txtTestType.Enabled = true;
                int id;

                if (int.TryParse(args.ToString(), out id))
                {
                    Test myTest = TestClass.GetTestByID(id);
                    txtTestType.Text = myTest.Name;
                    hfID.Value = id.ToString();
                    divAdd.Visible = false;
                    divSaveCancel.Visible = true;
                    pnlDefaultButton.DefaultButton = "btnSave";
                }
            }
        }
        #endregion

        #region btnSave_Click
        /// <summary>
        /// updates the record in the database and reloads the grid
        /// </summary>
        protected void btnSave_Click(object sender, EventArgs e)
        {
            Page.Validate();

            if (Page.IsValid)
            {
                if (sender == btnAdd)
                {
                    Test newTest = new Test();
                    newTest.Name = txtTestType.Text.Trim();
                    newTest.CompanyID = CurrentUser.CompanyID;
                    newTest.Active = true;

                    TestClass.InsertTest(newTest);

                    txtTestType.Text = String.Empty;
                }
                else if (sender == btnSave)
                {
                    int id;
                    if (int.TryParse(hfID.Value, out id))
                    {
                        Test testToUpdate = TestClass.GetTestByID(id);
                        testToUpdate.Name = txtTestType.Text.Trim();

                        TestClass.UpdateTest(testToUpdate);

                        divSaveCancel.Visible = false;
                        divAdd.Visible = true;
                        pnlDefaultButton.DefaultButton = "btnAdd";
                    }

                    txtTestType.Text = String.Empty;
                    hfID.Value = String.Empty;
                    hfDeletedID.Value = String.Empty;
                }
            }

            //make sure the default button is set properly, if not done this way
            //the postback will reset the default button to "btnAdd"
            if (divSaveCancel.Visible)
            {
                pnlDefaultButton.DefaultButton = "btnSave";
            }
            else
                pnlDefaultButton.DefaultButton = "btnAdd";
    
            grdTests.Rebind();
        }
        #endregion

        #region btnCancel_Click
        /// <summary>
        /// cancels the edit
        /// </summary>
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            txtTestType.Text = String.Empty;
            divAdd.Visible = true;
            divSaveCancel.Visible = false;
            pnlDefaultButton.DefaultButton = "btnAdd";
        }
        #endregion

        #region grdTests_NeedDataSource
        /// <summary>
        /// Binds the datagrid
        /// </summary>
        protected void grdTests_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            grdTests.DataSource = (from t in TestClass.GetTestsByCompanyID(CurrentUser.CompanyID)
                                       orderby t.Name
                                       select t).ToList();
        }
        #endregion

        #region CheckForDuplicates
        //checks the names for duplicates and returns false if the name exists already in the database
        protected void CheckForDuplicates(object source, ServerValidateEventArgs args)
        {
            List<string> tests = (from t in TestClass.GetTestsByCompanyID(CurrentUser.CompanyID)
                                  select t.Name.ToLower().Trim()).ToList();

            int matchingTests = (from t in TestClass.GetTestsByCompanyID(CurrentUser.CompanyID)
                                 where t.Name.ToLower().Trim() == txtTestType.Text.ToLower().Trim()
                                 select t).ToList().Count;

            if (!tests.Contains(txtTestType.Text.ToLower().Trim()) && divAdd.Visible)
                args.IsValid = true;
            else if (divSaveCancel.Visible)
            {
                int editID;
                if (int.TryParse(hfID.Value, out editID))
                {
                    Test myTest = TestClass.GetTestByID(editID);
                    if ((matchingTests < 2 && myTest.Name.ToLower() == txtTestType.Text.ToLower().Trim()) || matchingTests == 0)
                        args.IsValid = true;
                    else
                        args.IsValid = false;
                }
            }
            else
                args.IsValid = false;
        }
        #endregion

        #region btnDeleteProcedure_Click
        //resets the edit area when an item is deleted and was the item being edited
        protected void btnDeleteProcedure_Click(object sender, EventArgs e)
        {
            if (!String.IsNullOrWhiteSpace(hfID.Value) && hfID.Value == hfDeletedID.Value)
            {
                if(divSaveCancel.Visible)
                {
                    txtTestType.Text = String.Empty;
                    hfID.Value = String.Empty;
                    divAdd.Visible = true;
                    divSaveCancel.Visible = false;
                    hfDeletedID.Value = String.Empty;
                    pnlDefaultButton.DefaultButton = "btnAdd";
                }
                else
                {
                    hfDeletedID.Value = String.Empty;
                    hfID.Value = String.Empty;
                    pnlDefaultButton.DefaultButton = "btnSave";
                }

            }
            
            grdTests.Rebind();
        }
        #endregion

        #endregion

        #region +Helpers

        #region CheckUserPermission
        /// <summary>
        /// Disables the add button if the user doesn'test have permission to add stuff
        /// </summary>
        private void CheckUserPermission()
        {
            if (!CurrentUsersPermission.AllowAdd)
            {
                btnAdd.Enabled = false;
                txtTestType.Enabled = false;
                btnAdd.ToolTip = TextUserDoesntHavePermissionText;
            }
        }
        #endregion

        #region GetDelete
        /// <summary>
        /// Either returns an image for the user to delete a tit_c or returns an inactive image
        /// </summary>
        public string GetDelete(int id)
        {
            return CurrentUsersPermission.AllowDelete ? "<span class='Pointer'><img src='/Images/icon_delete.png' onclick='Javascript:confirmDelete(" + id.ToString() + ")' /></span>" : "<img src='Images/icon_delete_inactive.png' title='" + TextUserDoesntHavePermissionText + "'/>";
        }
        #endregion

        #endregion
    }
}