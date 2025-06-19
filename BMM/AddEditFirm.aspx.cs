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
    public partial class AddEditFirm : Classes.BasePage
    {
        #region + Properties

        #region SelectedFirm
        /// <summary>
        /// The firm that is to be edited
        /// </summary>
        private Firm _SelectedFirm;
        public Firm SelectedFirm
        {
            get
            {
                int id;

                if (_SelectedFirm == null)
                {
                    if (Request.QueryString["id"] != null && Int32.TryParse(Request.QueryString["id"], out id))
                    {
                        _SelectedFirm = FirmClass.GetFirmByID(id, true, true, false);

                        if (_SelectedFirm != null && _SelectedFirm.CompanyID != Company.ID || !_SelectedFirm.Active)
                            _SelectedFirm = null;
                    }
                }

                return _SelectedFirm;
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

        #region + Events

        #region Page_Load
        /// <summary>
        /// Loads some initial values and checks user permissions
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            Title = Company.Name + " - Firm";
            if (!IsPostBack)
            {
                LoadStates();
                loadFirm();
                CheckPermissions();
            }
        }
        #endregion

        #region btnSave_Click
        /// <summary>
        /// saves the firm
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnSave_Click(object sender, EventArgs e)
        {
            SaveFirm();
            ucContacts.RemoveList();
            Response.Redirect("/ManageFirms.aspx");
        }
        #endregion

        #region btnCancel_Click
        /// <summary>
        /// redirects a user back to the managefirms page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ucContacts.RemoveList();
            Response.Redirect("/ManageFirms.aspx");
        }
        #endregion

        #region grdAttorneys_NeedDataSource
        /// <summary>
        /// if the selected firm isn'test null we load it'p attorneys
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void grdAttorneys_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            if (SelectedFirm != null)
                grdAttorneys.DataSource = from a in SelectedFirm.Attorneys
                                          where a.Active == true
                                          orderby a.LastName, a.FirstName
                                          select a;
        }
        #endregion

        #endregion

        #region + Helpers

        #region CheckPermissions
        /// <summary>
        /// Checks to see if the user has permissions to view the page
        /// </summary>
        private void CheckPermissions()
        {
            if (SelectedFirm != null && CurrentUsersPermission.AllowEdit == false)
                DisableControls();
            else if (SelectedFirm == null && CurrentUsersPermission.AllowAdd == false)
                DisableControls();
        }
        #endregion

        #region DisableControls
        /// <summary>
        /// disables the controls on the page
        /// </summary>
        private void DisableControls()
        {
            const string ToolTipText = TextUserDoesntHavePermissionText;

            rcbState.Enabled = false;
            rcbState.ToolTip = ToolTipText;

            rcbStats.Enabled = false;
            rcbStats.ToolTip = ToolTipText;

            ucContacts.DisableControls();

            foreach (Control c in Panel1.Controls)
            {
                if (c is Button)
                {
                    ((Button)c).Enabled = false;
                    ((Button)c).ToolTip = ToolTipText;
                }
            }

            foreach(Control c in Panel1.Controls)
            {
                if(c is TextBox)
                {
                    ((TextBox)c).Enabled = false;
                    ((TextBox)c).ToolTip = ToolTipText;
                }
            }

            btnCancel.Enabled = true;
            btnCancel.ToolTip = "";
        }
        #endregion

        #region LoadFirm
        /// <summary>
        /// loads the firms information
        /// </summary>
        private void loadFirm()
        {
            ucContacts.MyUserPermission = UserClass.PermissionsEnum.Admin_Firms;

            if (SelectedFirm != null)
            {
                litHeader.Text = "Firm Record";
                ucContacts.isAddPage = false;
                ucContacts.ListOfContacts = SelectedFirm.ContactList.Contacts.ToList();
                txtName.Text = SelectedFirm.Name;
                txtStreet.Text = SelectedFirm.Street1;
                txtAptSuite.Text = SelectedFirm.Street2;
                txtCity.Text = SelectedFirm.City;
                rcbState.SelectedValue = SelectedFirm.StateID.ToString();
                txtZip.Text = SelectedFirm.ZipCode;
                txtPhone.Text = SelectedFirm.Phone;
                txtFax.Text = SelectedFirm.Fax;
                rcbStats.SelectedValue = SelectedFirm.isActiveStatus == true ? "1" : "0";

            }
            else
            {
                ucContacts.isAddPage = true;
                litHeader.Text = "Add New Firm";
                divAttorneys.Style.Add("display", "none");
            }
        }
        #endregion

        #region LoadStates
        /// <summary>
        /// loads the states in the combobox
        /// </summary>
        private void LoadStates()
        {
            rcbStats.EmptyMessage = "Select";
            rcbState.EmptyMessage = "Select";
            rcbState.DataSource = StateClass.GetStates();
            rcbState.DataValueField = "ID";
            rcbState.DataTextField = "Name";
            rcbState.DataBind();

        }
        #endregion

        #region SaveFirm
        /// <summary>
        /// saves teh firms information
        /// </summary>
        private void SaveFirm()
        {
            Firm myFirm;

            if (SelectedFirm == null)
                myFirm = new Firm();
            else
                myFirm = SelectedFirm;

            myFirm.Name = txtName.Text.Trim();
            myFirm.Street1 = txtStreet.Text.Trim();
            myFirm.Street2 = txtAptSuite.Text.Trim();
            myFirm.City = txtCity.Text.Trim();
            myFirm.StateID = int.Parse(rcbState.SelectedValue);
            myFirm.ZipCode = txtZip.Text.Trim();
            myFirm.Phone = txtPhone.Text.Trim();
            myFirm.Fax = txtFax.Text.Trim();
            myFirm.isActiveStatus = rcbStats.SelectedValue == "1" ? true : false;
            myFirm.CompanyID = CurrentUser.CompanyID;

            if (SelectedFirm == null)
            {
                myFirm.ContactList = new ContactList();
                myFirm.ContactList.DateAdded = DateTime.Now;
                myFirm.ContactList.Contacts.AddRange(ucContacts.GetListOfContacts());
                FirmClass.InsertFirm(myFirm);
            }
            else
            {
                myFirm.ContactList.Contacts.Clear();
                myFirm.ContactList.Contacts.AddRange(ucContacts.GetListOfContacts());
                FirmClass.UpdateFirm(myFirm);
            }


        }
        #endregion

        #region GetAttorneyLink
        /// <summary>
        /// determines if a user has permissions to view an attorney
        /// </summary>
        /// <param name="a"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public String GetAttorneyLink(String a, int id)
        {
            UserPermission myPermission = GetUserPermission(UserClass.PermissionsEnum.Admin_Attorneys);
            if (myPermission.AllowView || myPermission.AllowEdit)
            {
                return "<a href='/AddEditAttorney.aspx?id=" + id.ToString() + "' />" + a + "</a>";
            }
            else
                return a;
        }
        #endregion

        #region GetUserPermission
        /// <summary>
        /// gets a user'p permission based on the enum that is passed
        /// </summary>
        /// <param name="permissionsEnum"></param>
        /// <returns></returns>
        private UserPermission GetUserPermission(UserClass.PermissionsEnum permissionsEnum)
        {
            return (from p in CurrentUser.UserPermissions
                    where p.PermissionID == (int)permissionsEnum
                    && p.Active
                    select p).FirstOrDefault(); 
        }
        #endregion

        #endregion

    }
}