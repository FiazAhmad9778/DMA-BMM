using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BMM_DAL;
using BMM_BAL;

namespace BMM
{
    public partial class AddEditPhysician : Classes.BasePage
    {
        #region + Properties

        #region SelectedPhysician
        /// <summary>
        /// The Physician that is to be edited
        /// </summary>
        private Physician _SelectedPhysician;
        public Physician SelectedPhysician
        {
            get
            {
                int id;

                if (_SelectedPhysician == null)
                {
                    if (Request.QueryString["id"] != null && Int32.TryParse(Request.QueryString["id"], out id))
                    {
                        _SelectedPhysician = PhysicianClass.GetPhysicianByID(id, true, false);

                        if (_SelectedPhysician != null && !_SelectedPhysician.Active || _SelectedPhysician.CompanyID != Company.ID)
                            _SelectedPhysician = null;
                    }
                }

                return _SelectedPhysician;
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
                return UserClass.PermissionsEnum.Admin_Physicians;
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
                                               where p.PermissionID == (int)UserClass.PermissionsEnum.Admin_Physicians
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
            get { return SubNavigationTabEnum.AdminPhysicians; }
        }
        #endregion

        #endregion

        #region + Events

        #region Page_Load
        /// <summary>
        /// Loads some initial values
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            Title = Company.Name + " - Physician";
            if (!IsPostBack)
            {
                LoadStates();
                LoadPhysician();
                CheckPermissions();
            }
        }
        #endregion

        #region btnSave_Click
        /// <summary>
        /// Saves the physician and redirects to the managephysicians page 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnSave_Click(object sender, EventArgs e)
        {
            SavePhysician();
            ucContacts.RemoveList();
            Response.Redirect("/ManagePhysicians.aspx");
        }
        #endregion

        #region Cancel_onClick
        /// <summary>
        /// Redirects the user back to the managePhysicians page w/o saving
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Cancel_OnClick(object sender, EventArgs e)
        {
            ucContacts.RemoveList();
            Response.Redirect("/ManagePhysicians.aspx");
        }
        #endregion

        #endregion 

        #region + Helpers

        #region SavePhysician
        /// <summary>
        /// Inserts or Updates the Physician to the database
        /// </summary>
        private void SavePhysician()
        {
            Physician myPhysician;
            int stateId;

            if (SelectedPhysician == null)
                myPhysician = new Physician();
            else
                myPhysician = SelectedPhysician;

            myPhysician.FirstName = txtFirstName.Text.Trim();
            myPhysician.LastName = txtLastName.Text.Trim();
            myPhysician.Street1 = txtStreet1.Text.Trim();
            myPhysician.Street2 = txtStreet2.Text.Trim();
            myPhysician.City = txtCity.Text.Trim();
            if (int.TryParse(rcbState.SelectedValue, out stateId))
                myPhysician.StateID = stateId;
            myPhysician.ZipCode = txtZip.Text.Trim();
            myPhysician.Phone = txtPhone.Text.Trim();
            myPhysician.Fax = txtFax.Text.Trim();
            myPhysician.EmailAddress = txtEmail.Text.Trim();
            myPhysician.Notes = txtNotes.Text.Trim();
            myPhysician.isActiveStatus = rcbStatus.SelectedValue == "1" ? true : false;
            myPhysician.CompanyID = CurrentUser.CompanyID;

            if (SelectedPhysician == null)
            {
                myPhysician.ContactList = new ContactList();
                myPhysician.ContactList.DateAdded = DateTime.Now;
                myPhysician.ContactList.Contacts.AddRange(ucContacts.GetListOfContacts());

                PhysicianClass.InsertPhysician(myPhysician);
            }
            else
            {
                myPhysician.ContactList.Contacts.Clear();
                myPhysician.ContactList.Contacts.AddRange(ucContacts.GetListOfContacts());
                PhysicianClass.UpdatePhysician(myPhysician);
            }

        }
        #endregion

        #region CheckPermissions
        /// <summary>
        /// Checks to see if the user has permissions to view the page
        /// </summary>
        private void CheckPermissions()
        {
            if (SelectedPhysician != null && CurrentUsersPermission.AllowEdit == false)
                DisableControls();
            else if (SelectedPhysician == null && CurrentUsersPermission.AllowAdd == false)
                DisableControls();
        }
        #endregion

        #region DisableControls
        /// <summary>
        /// Disables the controls for the page
        /// </summary>
        private void DisableControls()
        {
            string ToolTipText = TextUserDoesntHavePermissionText;

            rcbState.Enabled = false;
            rcbState.ToolTip = ToolTipText;

            rcbStatus.Enabled = false;
            rcbStatus.ToolTip = ToolTipText;

            ucContacts.DisableControls();

            foreach (Control c in Panel1.Controls)
            {
                if (c is Button)
                {
                    ((Button)c).Enabled = false;
                    ((Button)c).ToolTip = ToolTipText;
                }
            }

            foreach (Control c in Panel1.Controls)
            {
                if (c is TextBox)
                {
                    ((TextBox)c).Enabled = false;
                    ((TextBox)c).ToolTip = ToolTipText;
                }
            }

            btnCancel.Enabled = true;
            btnCancel.ToolTip = "";

        }
        #endregion

        #region LoadPhysician
        /// <summary>
        /// Loads the physician'p info 
        /// </summary>
        private void LoadPhysician()
        {
            ucContacts.MyUserPermission = UserClass.PermissionsEnum.Admin_Physicians;

            if (SelectedPhysician != null)
            {
                litHeader.Text = "Add New Physician";
                ucContacts.isAddPage = false;
                ucContacts.ListOfContacts = SelectedPhysician.ContactList.Contacts.ToList();
                txtFirstName.Text = SelectedPhysician.FirstName;
                txtLastName.Text = SelectedPhysician.LastName;
                txtStreet1.Text = SelectedPhysician.Street1;
                txtStreet2.Text = SelectedPhysician.Street2;
                txtCity.Text = SelectedPhysician.City;
                rcbState.SelectedValue = SelectedPhysician.StateID.ToString();
                txtZip.Text = SelectedPhysician.ZipCode;
                txtPhone.Text = SelectedPhysician.Phone;
                txtFax.Text = SelectedPhysician.Fax;
                txtEmail.Text = SelectedPhysician.EmailAddress;
                txtNotes.Text = SelectedPhysician.Notes;
                rcbStatus.SelectedValue = SelectedPhysician.isActiveStatus == true ? "1" : "0";
            }
            else
            {
                litHeader.Text = "Add New Physician";
                ucContacts.isAddPage = true;
            }
        }
        #endregion

        #region LoadStates
        /// <summary>
        /// loads the states in the combobox
        /// </summary>
        private void LoadStates()
        {
            rcbState.EmptyMessage = "Select";
            rcbState.DataSource = StateClass.GetStates();
            rcbState.DataValueField = "ID";
            rcbState.DataTextField = "Name";
            rcbState.DataBind();

        }
        #endregion

        #endregion

    }
}