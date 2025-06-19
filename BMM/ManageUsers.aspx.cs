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
    public partial class ManageUsers : Classes.BasePage
    {
        #region + Properties

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
        /// Sets up the page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                Title = Company.Name + " - Manage Users";
                CheckUserPermission();
            }
        }
        #endregion

        #region btnAdd_Click
        /// <summary>
        /// Redirects the user to teh add/edit page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnAdd_Click(object sender, EventArgs e)
        {
            Response.Redirect("/AddEditUsers.aspx");
        }
        #endregion

        #region grdUsers_NeedDataSource
        /// <summary>
        /// Binds the datagrid
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void grdUsers_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            grdUsers.DataSource = (from u in UserClass.GetUsersByCompanyID(CurrentUser.CompanyID)
                                   orderby u.FirstName, u.LastName
                                   select u).ToList();
        }
        #endregion

        #region grdUsers_OnItemCommand
        //upon clicking the name of the procedure/sis, or edit, the onitemcommand will load the textbox with the name for editing
        //it will also change out the add button into two buttons for save and cancel
        protected void grdUsers_OnItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs args)
        {
            if (args.CommandName == "btnEdit")
                Response.Redirect("/AddEditUsers.aspx?id=" + args.CommandArgument.ToString());
            else if (args.CommandName == "btnView")
                Response.Redirect("/AddEditUsers.aspx?id=" + args.CommandArgument.ToString());
        }
        #endregion

        #endregion

        #region + Helpers

        #region CheckUserPermission
        /// <summary>
        /// Disables the add button if they user doesn'test have permissions to add stuff
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

        #region GetAvailableActions
        /// <summary>
        /// Gets the actions that the user is allowed to do
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public String GetAvailableActions(int id)
        {
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.Append("<a href='/AddEditUsers.aspx?id=" + id.ToString() + "'>View</a>&nbsp;");
            sb.Append(EditUserLink(id));
            sb.Append(DeleteUserLink(id));

            return sb.ToString();
        }
        #endregion

        #region EditUserLink
        /// <summary>
        /// Either returns a link for the user to edit another user or doesn'test
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        private string EditUserLink(int id)
        {
            if (CurrentUsersPermission.AllowEdit)
                return "<a href='/AddEditUsers.aspx?id=" + id.ToString() + "'>Edit</a>&nbsp;";
            else
                return "<span title='" + TextUserDoesntHavePermissionText + "'>Edit</span>&nbsp;";

        }
        #endregion

        #region DeleteUserLink
        /// <summary>
        /// Either returns a link for the user to delete another user or doesn'test
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        private string DeleteUserLink(int id)
        {
            if (CurrentUsersPermission.AllowDelete)
                return "<a href='Javascript:confirmDelete(" + id.ToString() + ")'>Delete</a>&nbsp;";
            else
                return "<span title='" + TextUserDoesntHavePermissionText + "'>Delete</span>&nbsp;";

        }
        #endregion

        #region GetDelete
        /// <summary>
        /// Either returns an image for the user to delete a tit_c or returns an inactive image
        /// </summary>
        public string GetDelete(int id)
        {
            return CurrentUsersPermission.AllowDelete ? "<span class='Pointer'><img src='/Images/icon_delete.png' onclick='Javascript:confirmDelete(" + id.ToString() + ")' /></span>" : "<img src='Images/icon_delete_inactive.png'  title='" + TextUserDoesntHavePermissionText + "' />";
        }
        #endregion

        #endregion
    }
}