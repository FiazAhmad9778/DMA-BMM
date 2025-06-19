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
    public partial class ManageAttorneys : Classes.BasePage
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
                return UserClass.PermissionsEnum.Admin_Attorneys;
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
                                               where p.PermissionID == (int)UserClass.PermissionsEnum.Admin_Attorneys
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
            get { return SubNavigationTabEnum.AdminAttorneys; }
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
            if (!Page.IsPostBack)
            {
                Title = Company.Name + " - Manage Attorneys";
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
            Response.Redirect("/AddEditAttorney.aspx");
        }
        #endregion

        #region grdAttorneys_NeedDataSource
        /// <summary>
        /// Binds the datagrid
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void grdAttorneys_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            grdAttorneys.DataSource = (from a in AttorneyClass.GetAttorneysByCompanyID(CurrentUser.CompanyID, true, true)
                                       orderby a.LastName, a.FirstName
                                       select a).ToList();
        }
        #endregion

        #region grdAttorneys_OnItemCommand
        //upon clicking the name of the attorney, or edit, the onitemcommand will load the textbox with the name for editing
        //it will also change out the add button into two buttons for save and cancel
        protected void grdAttorneys_OnItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs args)
        {
            if (args.CommandName == "btnEdit")
                Response.Redirect("/AddEditAttorney.aspx?id=" + args.CommandArgument.ToString());
            else if (args.CommandName == "btnView")
                Response.Redirect("/AddEditAttorney.aspx?id=" + args.CommandArgument.ToString());
        }
        #endregion

        #region btnSearch_Click
        /// <summary>
        /// Redirects the user to teh add/edit page
        /// </summary>
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            int id;

            if (int.TryParse(rcbAttorneySearch.SelectedValue, out id))
            {
                Response.Redirect("/AddEditAttorney.aspx?id=" + id);
            }
            else
                rcbAttorneySearch.ClearSelection();
        }
        #endregion

        #region rcbAttorneySearch_ItemsRequested
        //loads the combo box with the attorney names
        protected void rcbAttorneySearch_ItemsRequested(object sender, Telerik.Web.UI.RadComboBoxItemsRequestedEventArgs e)
        {
            string text = e.Text.ToLower().Trim();
            if (text.Length > 2)
            {
                foreach (var item in (from a in AttorneyClass.GetAttorneysByNameSearch(text, CurrentUser.CompanyID, true)
                                      select new Telerik.Web.UI.RadComboBoxItem(a.LastName + ", " + a.FirstName + (a.Firm == null ? String.Empty : " (" + a.Firm.Name + ")"), a.ID.ToString())))
                {
                    rcbAttorneySearch.Items.Add(item);
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
        //gets the address of the corresponding attorney
        public String GetAddress(Attorney a)
        {
            string address = a.Street1;

            if(!String.IsNullOrWhiteSpace(a.Street2))
                address += ", " + a.Street2;

            address += ", " + a.City + ", " + a.State.Abbreviation + " " + a.ZipCode;

            return address;
        }
        #endregion

        #region GetDelete
        /// <summary>
        /// Either returns an image for the user to delete an attorney or returns an inactive image
        /// </summary>
        public string GetDelete(int id)
        {
            return CurrentUsersPermission.AllowDelete ? "<span class='Pointer'><img src='/Images/icon_delete.png' title='Delete' onclick='Javascript:confirmDelete(" + id.ToString() + ")' /></span>" : "<img src='Images/icon_delete_inactive.png' title='" + TextUserDoesntHavePermissionText + "'/>";
        }
        #endregion

        #endregion
    }
}
