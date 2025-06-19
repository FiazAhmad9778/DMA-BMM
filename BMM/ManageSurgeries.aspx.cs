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
    public partial class ManageSurgeries : Classes.BasePage
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
                return UserClass.PermissionsEnum.Admin_Surgeries;
            }
        }
        #endregion

        #region CurrentUsersPermission
        /// <summary>
        /// Gets the permissions for the user to see if they can add/edit/delete surgeries/procedures
        /// </summary>
        private UserPermission _CurrentUsersPermission;
        public UserPermission CurrentUsersPermission
        {
            get
            {
                if (_CurrentUsersPermission == null)
                {
                    _CurrentUsersPermission = (from p in CurrentUser.UserPermissions
                                               where p.PermissionID == (int)UserClass.PermissionsEnum.Admin_Surgeries
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
            get { return SubNavigationTabEnum.AdminProcedures; }
        }
        #endregion

        #region DoRedirect
        protected bool DoRedirect
        {
            get
            {
                return Request.QueryString["ReturnURL"] != null;
            }
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
            Title = Company.Name + " - Manage Surgeries";

            if (!Page.IsPostBack)
            {
                CheckUserPermission();
                btnAddCancel.Visible = DoRedirect;
                btnAdd.Text = DoRedirect ? "Save" : "Add";
            }
        }
        #endregion

        #region grdSurgeries_OnItemCommand
        //upon clicking the name of the procedure/sis, or edit, the onitemcommand will load the textbox with the name for editing
        //it will also change out the add button into two buttons for save and cancel
        protected void grdSurgeries_OnItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs args)
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
        //when the edit button is clicked, the textbox will be loaded with the name of the procedure for editing
        //will also change add button into the save/cancel button combo
        protected void btnEdit_Click(string args)
        {
            if (CurrentUsersPermission.AllowEdit)
            {
                txtSurgeriesType.Enabled = true;
                int procedureID;

                if (int.TryParse(args, out procedureID))
                {
                    Surgery myProcedure = SurgeryClass.GetSurgeryByID(procedureID);
                    if (CurrentUser.CompanyID == myProcedure.CompanyID)
                    {
                        txtSurgeriesType.Text = myProcedure.Name;
                        divAdd.Visible = false;
                        hfID.Value = procedureID.ToString();
                        divSaveCancel.Visible = true;
                        pnlDefaultButton.DefaultButton = "btnSave";
                    }
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
                int surgeryID;

                if (sender == btnAdd)
                {
                    Surgery newProcedure = new Surgery();
                    newProcedure.Name = txtSurgeriesType.Text;
                    newProcedure.CompanyID = CurrentUser.CompanyID;
                    newProcedure.Active = true;

                    surgeryID = SurgeryClass.InsertSurgery(newProcedure);

                    txtSurgeriesType.Text = String.Empty;
                }
                else //if (sender == btnSave)
                {
                    surgeryID = int.Parse(hfID.Value);

                    Surgery procedureToUpdate = SurgeryClass.GetSurgeryByID(surgeryID);
                    procedureToUpdate.Name = txtSurgeriesType.Text;

                    SurgeryClass.UpdateSurgery(procedureToUpdate);

                    divSaveCancel.Visible = false;
                    divAdd.Visible = true;
                    pnlDefaultButton.DefaultButton = "btnAdd";
                    cvSurgeriesType.Enabled = true;

                    txtSurgeriesType.Text = String.Empty;
                    hfID.Value = String.Empty;
                    hfDeletedID.Value = String.Empty;
                }

                if (DoRedirect)
                {
                    Response.Redirect(Request.QueryString["ReturnURL"] + "&sid=" + surgeryID);
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

            grdSurgeries.Rebind();
        }
        #endregion

        #region btnCancel_Click
        /// <summary>
        /// cancels the edit
        /// </summary>
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            txtSurgeriesType.Text = String.Empty;
            divAdd.Visible = true;
            divSaveCancel.Visible = false;
            pnlDefaultButton.DefaultButton = "btnAdd";
            cvSurgeriesType.Enabled = true;

            if (DoRedirect)
            {
                Response.Redirect(Request.QueryString["ReturnURL"]);
            }
        }
        #endregion

        #region grdSurgeries_NeedDataSource
        /// <summary>
        /// Binds the datagrid
        /// </summary>
        protected void grdSurgeries_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            grdSurgeries.DataSource = (from sp in SurgeryClass.GetSurgerysByCompanyID(CurrentUser.CompanyID)
                                       orderby sp.Name
                                       select sp).ToList();
        }
        #endregion

        #region CheckForDuplicates
        //checks the names for duplicates and returns false if the name exists already in the database
        protected void CheckForDuplicates(object source, ServerValidateEventArgs args)
        {
            List<string> procedures = (from s in SurgeryClass.GetSurgerysByCompanyID(CurrentUser.CompanyID)
                                       select s.Name.ToLower()).ToList();

            int matchingSurgeries = (from s in SurgeryClass.GetSurgerysByCompanyID(CurrentUser.CompanyID)
                                     where s.Name == txtSurgeriesType.Text.ToLower().Trim()
                                     select s).ToList().Count;

            if (!procedures.Contains(txtSurgeriesType.Text.ToLower().Trim()) && divAdd.Visible)
                args.IsValid = true;
            else if (divSaveCancel.Visible)
            {
                int editID;
                if (int.TryParse(hfID.Value, out editID))
                {
                    Surgery myProcedure = SurgeryClass.GetSurgeryByID(editID);
                    if ((matchingSurgeries < 2 && myProcedure.Name == txtSurgeriesType.Text.ToLower().Trim()) || matchingSurgeries == 0)
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
                if (divSaveCancel.Visible)
                {
                    txtSurgeriesType.Text = String.Empty;
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

            grdSurgeries.Rebind();
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
                txtSurgeriesType.Enabled = false;
                btnAdd.ToolTip = TextUserDoesntHavePermissionText;
            }
        }
        #endregion

        #region GetDelete
        /// <summary>
        /// Either returns an image for the user to delete a procedure or returns an inactive image
        /// </summary>
        public string GetDelete(int id)
        {
            return CurrentUsersPermission.AllowDelete ? "<span class='Pointer'><img src='/Images/icon_delete.png' onclick='Javascript:confirmDelete(" + id.ToString() + ")' /></span>" : "<img src='Images/icon_delete_inactive.png' title='" + TextUserDoesntHavePermissionText + "'/>";
        }
        #endregion
        #endregion
    }
}