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
    public partial class ManageFirms : Classes.BasePage
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
                return UserClass.PermissionsEnum.Admin_Firms;
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
                                               where p.PermissionID == (int)UserClass.PermissionsEnum.Admin_Firms
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
            get { return SubNavigationTabEnum.AdminFirms; }
        }
        #endregion

        #endregion

        #region +Events

        #region Page_Load
        /// <summary>
        /// Sets up the page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            Title = Company.Name + " - Manage Firms";

            if (!Page.IsPostBack)
            {                
                CheckUserPermission();
            }
        }
        #endregion

        #region btnAdd_Click
        /// <summary>
        /// Redirects the user to the add/edit page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnAdd_Click(object sender, EventArgs e)
        {
            Response.Redirect("/AddEditFirm.aspx");
        }
        #endregion

        #region grdFirms_OnItemCommand
        //upon clicking the name of the firm, or edit, the onitemcommand will load the textbox with the name for editing
        //it will also change out the add button into two buttons for save and cancel
        protected void grdFirms_OnItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs args)
        {
            if (args.CommandName == "btnEdit")
                Response.Redirect("/AddEditFirm.aspx?id=" + args.CommandArgument.ToString());
            else if (args.CommandName == "btnView")
                Response.Redirect("/AddEditFirm.aspx?id=" + args.CommandArgument.ToString());
        }
        #endregion

        #region grdFirms_NeedDataSource
        /// <summary>
        /// Binds the datagrid
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void grdFirms_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            grdFirms.DataSource = (from f in FirmClass.GetFirmsByCompanyID(CurrentUser.CompanyID, true)
                                    orderby f.Name
                                    select f).ToList();
        }
        #endregion

        #region btnSearch_Click
        /// <summary>
        /// Redirects the user to the add/edit page
        /// </summary>
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            int id;

            if (int.TryParse(rcbFirmSearch.SelectedValue, out id))
            {
                Response.Redirect("/AddEditFirm.aspx?id=" + id);
            }
            else
                rcbFirmSearch.ClearSelection();
        }
        #endregion

        #region rcbAttorneySearch_ItemsRequested
        //loads the combo box with the firm names
        protected void rcbAttorneySearch_ItemsRequested(object sender, Telerik.Web.UI.RadComboBoxItemsRequestedEventArgs e)
        {
            string text = e.Text.ToLower().Trim();
            if (text.Length > 2)
            {
                foreach (var item in (from f in FirmClass.GetFirmsByNameSearch(text, CurrentUser.CompanyID)
                                      select new Telerik.Web.UI.RadComboBoxItem(f.Name, f.ID.ToString())))
                {
                    rcbFirmSearch.Items.Add(item);
                }
            }
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
                btnAdd.ToolTip = TextUserDoesntHavePermissionText;
            }
        }
        #endregion

        #region GetAddress
        //gets the address of the corresponding firm
        public String GetAddress(Firm f)
        {
            string address = f.Street1;

            if (!String.IsNullOrWhiteSpace(f.Street2))
                address += ", " + f.Street2;

            address += ", " + f.City + ", " + f.State.Abbreviation + " " + f.ZipCode;

            return address;
        }
        #endregion

        #region GetDelete
        /// <summary>
        /// Either returns an image for the user to delete a firm or returns an inactive image
        /// </summary>
        public string GetDelete(int id)
        {
            return CurrentUsersPermission.AllowDelete ? "<span class='Pointer'><img src='/Images/icon_delete.png' title='Delete' onclick='Javascript:confirmDelete(" + id.ToString() + ")' /></span>" : "<img src='Images/icon_delete_inactive.png' title='" + TextUserDoesntHavePermissionText + "'/>";
        }

        #endregion

        #endregion
    }
}