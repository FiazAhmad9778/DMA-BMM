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
    public partial class ManageICDCodes : Classes.BasePage
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
                return UserClass.PermissionsEnum.Admin_CPTCodes;
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
                                               where p.PermissionID == (int)UserClass.PermissionsEnum.Admin_CPTCodes
                                               && p.Active
                                               select p).FirstOrDefault();
                }

                return _CurrentUsersPermission;
            }
        }
        #endregion

        #region SelectedICDCodes

        private List<ICDCode> _SelectedICDCodes;
        public List<ICDCode> SelectedICDCodes
        {
            get
            {
                if (_SelectedICDCodes == null)
                {
                    if (String.IsNullOrEmpty(txtSearch.Text))
                    {
                        _SelectedICDCodes = (from c in ICDCodes
                                             where c.Active == true
                                             orderby c.Code
                                             select c).ToList();
                    }
                    else
                    {
                        string text = txtSearch.Text.Trim();
                        _SelectedICDCodes = (from c in ICDCodes
                                                  where c.Active == true && (c.Code.ToLower().Contains(text.ToLower()) || c.ShortDescription.ToLower().Contains(text.ToLower()))
                                                  orderby c.Code
                                                  select c).ToList();
                    }
                   
                }
                return _SelectedICDCodes;
            }
            set
            {
                _SelectedICDCodes = value;
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
            get { return SubNavigationTabEnum.AdminICDCodes; }
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
            Title = Company.Name + " - Manage ICD Codes";

            if (!Page.IsPostBack)
            {
                CheckUserPermission();
            }
        }
        #endregion

        #region grdICDCodes_OnItemCommand
        //upon clicking the name of the cpt sipc, or edit, the onitemcommand will load the textbox with the name for editing
        //it will also change out the add button into two buttons for save and cancel
        protected void grdICDCodes_OnItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs args)
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
                txtICDCode.Enabled = true;
                txtShortDescription.Enabled = true;
                txtLongDescription.Enabled = true;
                int id;

                if (int.TryParse(args, out id))
                {
                    ICDCode myCode = ICDCodeClass.GetICDCodeByID(id);
                    if (CurrentUser.CompanyID == myCode.CompanyID)
                    {
                        txtICDCode.Text = myCode.Code;
                        txtShortDescription.Text = myCode.ShortDescription;
                        txtLongDescription.Text = myCode.LongDescription;
                        hfID.Value = myCode.ID.ToString();
                        divAdd.Visible = false;
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
                if (sender == btnAdd)
                {

                    
                   
                        ICDCode newCode = new ICDCode();
                        newCode.Code = txtICDCode.Text.ToUpper().Trim();
                        newCode.CompanyID = CurrentUser.CompanyID;
                        newCode.ICDVersion = System.Configuration.ConfigurationManager.AppSettings["ICDVersion"];
                        newCode.ShortDescription = txtShortDescription.Text.Trim();
                        newCode.LongDescription = txtLongDescription.Text.Trim();
                        newCode.Active = true;

                        ICDCodeClass.InsertICDCode(newCode);

                        txtICDCode.Text = String.Empty;
                        txtShortDescription.Text = String.Empty;
                        txtLongDescription.Text = String.Empty;
                        hfID.Value = String.Empty;

                    
                }
                else if (sender == btnSave)
                {
                    int id;
                    if (int.TryParse(hfID.Value, out id))
                    {
                        ICDCode codeToUpdate = ICDCodeClass.GetICDCodeByID(id);
                        codeToUpdate.Code = txtICDCode.Text.ToUpper().Trim();
                        codeToUpdate.ShortDescription = txtShortDescription.Text.Trim();
                        codeToUpdate.LongDescription = txtLongDescription.Text.Trim();

                        ICDCodeClass.UpdateICDCode(codeToUpdate);

                        divSaveCancel.Visible = false;
                        divAdd.Visible = true;
                        cvCPTCode.Enabled = true;
                    }

                    txtICDCode.Text = String.Empty;
                    txtShortDescription.Text = String.Empty;
                    txtLongDescription.Text = String.Empty;
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
            ClearCompanyICDCodeCache();
            grdICDCodes.Rebind();
        }
        #endregion

        #region btnCancel_Click
        /// <summary>
        /// cancels the edit
        /// </summary>
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            txtICDCode.Text = String.Empty;
            txtShortDescription.Text = String.Empty;
            txtLongDescription.Text = String.Empty;
            hfDeletedID.Value = String.Empty;
            hfID.Value = String.Empty;
            divAdd.Visible = true;
            divSaveCancel.Visible = false;
            pnlDefaultButton.DefaultButton = "btnAdd";
            cvCPTCode.Enabled = true;
        }
        #endregion

        #region grdICDCodes_NeedDataSource
        /// <summary>
        /// Binds the datagrid
        /// </summary>
        protected void grdICDCodes_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            grdICDCodes.DataSource = SelectedICDCodes;

        }
        #endregion

        #region CheckForDuplicates
        //checks the names for duplicates and returns false if the name exists already in the database
        protected void CheckForDuplicates(object source, ServerValidateEventArgs args)
        {
            string code = txtICDCode.Text.Trim().ToUpper();

            List<string> codes = (from c in ICDCodeClass.GetICDCodesByCompanyID(CurrentUser.CompanyID)
                                  where c.Active
                                  select c.Code.ToUpper()).ToList();

            int matchingCodes = (from c in codes
                                 where c == code
                                 select c).ToList().Count;

            if (!codes.Contains(code) && divAdd.Visible)
                args.IsValid = true;
            else if (divSaveCancel.Visible)
            {
                int editID;
                if (int.TryParse(hfID.Value, out editID))
                {
                    ICDCode myCode = ICDCodeClass.GetICDCodeByID(editID);
                    if ((matchingCodes < 2 && myCode.Code == txtICDCode.Text.ToUpper()) || matchingCodes == 0)
                        args.IsValid = true;
                    else
                        args.IsValid = false;
                }
            }
            else
                args.IsValid = false;
        }
        #endregion

        #region btnDeleteCode_Click
        //resets the edit area when an item is deleted and was the item being edited
        protected void btnDeleteCode_Click(object sender, EventArgs e)
        {
            if (!String.IsNullOrWhiteSpace(hfID.Value) && hfID.Value == hfDeletedID.Value)
            {
                if (divSaveCancel.Visible)
                {
                    txtICDCode.Text = String.Empty;
                    txtShortDescription.Text = String.Empty;
                    txtLongDescription.Text = String.Empty;
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

            grdICDCodes.Rebind();
        }
        #endregion

        #region rcbICDCodes_ItemsRequested
        protected void rcbICDCodes_ItemsRequested(object sender, Telerik.Web.UI.RadComboBoxItemsRequestedEventArgs e)
        {
            string text = e.Text.Trim();
            var x = (from c in SelectedICDCodes
                                      where c.Active == true && (c.Code.ToLower().Contains(text.ToLower()) || c.ShortDescription.ToLower().Contains(text.ToLower()))
                                      orderby c.Code
                                      select c).ToList();

            SelectedICDCodes = x;
            
            grdICDCodes.Rebind();
            //grdICDCodes.DataBind();
        }
        #endregion

        #region btnSearch_Click
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            grdICDCodes.Rebind();
            //grdICDCodes.DataBind();
        }
        #endregion

        #region btnClear_Click
        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            grdICDCodes.Rebind();
        }
        #endregion

        #endregion

        #region +Helpers

        #region CheckUserPermission
        /// <summary>
        /// Disables the add button if the user doesn't have permission to add stuff
        /// </summary>
        private void CheckUserPermission()
        {
            if (!CurrentUsersPermission.AllowAdd)
            {
                btnAdd.Enabled = false;
                txtICDCode.Enabled = false;
                txtShortDescription.Enabled = false;
                txtLongDescription.Enabled = false;
                //spellCheck.Enabled = false;
                btnAdd.ToolTip = TextUserDoesntHavePermissionText;
            }
        }
        #endregion

        #region GetDelete
        /// <summary>
        /// Either returns an image for the user to delete a cpt tit_c or returns an inactive image
        /// </summary>
        public string GetDelete(int id)
        {
            return CurrentUsersPermission.AllowDelete ? "<span class='Pointer'><img src='/Images/icon_delete.png' onclick='Javascript:confirmDelete(" + id.ToString() + ")' /></span>" : "<img src='Images/icon_delete_inactive.png' title='" + TextUserDoesntHavePermissionText + "' />";
        }
        #endregion

        #region GetDescription()
        //replaces line breaks in the description with <br /> so that it renders properly in the grid
        protected string GetDescription(string description)
        {
            return description.Replace("\r\n", "<br />");
        }
        #endregion

       

        #endregion


    }
}