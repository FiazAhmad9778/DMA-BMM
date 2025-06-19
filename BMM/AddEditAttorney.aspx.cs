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
    public partial class AddEditAttorney : Classes.BasePage
    {
        #region + Properties

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

        #region SelectedAttorney
        /// <summary>
        /// The selected attorney
        /// </summary>
        private Attorney _SelectedAttorney;
        public Attorney SelectedAttorney
        {
            get
            {
                int id;

                if (_SelectedAttorney == null)
                {
                    if (Request.QueryString["id"] != null && Int32.TryParse(Request.QueryString["id"], out id))
                    {
                        _SelectedAttorney = AttorneyClass.GetAttorneyByID(id, false, true, false);

                        if (_SelectedAttorney != null && _SelectedAttorney.CompanyID != Company.ID || !_SelectedAttorney.Active)
                            _SelectedAttorney = null;
                    }
                }

                return _SelectedAttorney;
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
                return UserClass.PermissionsEnum.Admin_Attorneys; ;
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

        #region + Events

        #region Page_Load
        /// <summary>
        /// Loads the page and sets some inital values
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            Title = Company.Name + " - Attorney";
            if (!IsPostBack)
            {                
                FillCombos();
                FillAttorney();
                CheckPermissions();
                rcbFirm.EmptyMessage = "Select";
                rcbState.EmptyMessage = "Select";
            }
        }
        #endregion

        #region btnConcel_Click
        /// <summary>
        /// redirects back to the manage attorney page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ucContacts.RemoveList();
            Response.Redirect("/ManageAttorneys.aspx");
        }
        #endregion

        #region btnSave_Click
        /// <summary>
        /// saves the attorney and redirects to the manage attorney'p page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnSave_Click(object sender, EventArgs e)
        {
            SaveAttorney();
            ucContacts.RemoveList();
            Response.Redirect("/ManageAttorneys.aspx");
        }
        #endregion

        #endregion

        #region + Helpers

        #region CheckPermissions
        private void CheckPermissions()
        {
            if (SelectedAttorney != null && CurrentUsersPermission.AllowEdit == false)
                DisableControls();
            else if (SelectedAttorney == null && CurrentUsersPermission.AllowAdd == false)
                DisableControls();
        }
        #endregion

        #region DisableControls
        private void DisableControls()
        {
            string ToolTipText = TextUserDoesntHavePermissionText;

            rspDiscount.Enabled = false;
            rspDiscount.ToolTip = ToolTipText;
            rspNotes.Enabled = false;
            rspNotes.ToolTip = ToolTipText;

            rcbFirm.Enabled = false;
            rcbFirm.ToolTip = ToolTipText;
            rcbState.Enabled = false;
            rcbState.ToolTip = ToolTipText; 
            rcbStatus.Enabled = false;
            rcbStatus.ToolTip = ToolTipText;

            ucContacts.DisableControls();

            btnSave.Enabled = false;
            btnSave.ToolTip = ToolTipText;

            foreach (Control c in Panel1.Controls)
            {
                if (c is TextBox)
                {
                    ((TextBox)(c)).Enabled = false;
                    ((TextBox)(c)).ToolTip = ToolTipText;
                }
            }
        }
        #endregion

        #region FillAttorney
        private void FillAttorney()
        {
            ucContacts.MyUserPermission = UserClass.PermissionsEnum.Admin_Attorneys;
            ucAttorneyTerms.MyUserPermission = UserClass.PermissionsEnum.Admin_Attorneys;

            if (SelectedAttorney != null)
            {
                litHeader.Text = "Attorney Record";
                ucContacts.isAddPage = false;
                ucContacts.ListOfContacts = SelectedAttorney.ContactList.Contacts.ToList();
                ucAttorneyTerms.SelectedAttorney = SelectedAttorney.ID;
                txtFirstName.Text = SelectedAttorney.FirstName;
                txtLastName.Text = SelectedAttorney.LastName;
                txtStreet1.Text = SelectedAttorney.Street1;
                txtStreet2.Text = SelectedAttorney.Street2;
                txtCity.Text = SelectedAttorney.City;
                rcbState.SelectedValue = SelectedAttorney.StateID.ToString();
                txtZip.Text = SelectedAttorney.ZipCode;
                txtPhone.Text = SelectedAttorney.Phone;
                txtFax.Text = SelectedAttorney.Fax;
                txtEmail.Text = SelectedAttorney.Email;
                txtNotes.Text = SelectedAttorney.Notes;
                rcbStatus.SelectedValue = SelectedAttorney.isActiveStatus == true ? "1" : "0";
                txtDiscountNotes.Text = SelectedAttorney.DiscountNotes;
                if (SelectedAttorney.DepositAmountRequired != null)
                    txtDeposit.Text = String.Format("{0:0.00}", ((decimal)(SelectedAttorney.DepositAmountRequired * 100))) + "%";
                rcbFirm.SelectedValue = SelectedAttorney.FirmID.ToString();
            }
            else
            {
                litHeader.Text = "Add New Attorney";
                ucContacts.isAddPage = true;
            }
        }
        #endregion

        #region FillCombos
        private void FillCombos()
        {
            rcbState.DataSource = StateClass.GetStates();
            rcbState.DataValueField = "ID";
            rcbState.DataTextField = "Name";
            rcbState.DataBind();

            rcbFirm.DataSource = from f in FirmClass.GetFirmsByCompanyID(CurrentUser.CompanyID, false)
                                 where f.Active == true
                                 && f.CompanyID == Company.ID
                                 select f;
            rcbFirm.DataTextField = "Name";
            rcbFirm.DataValueField = "ID";
            rcbFirm.DataBind();
        }
        #endregion

        #region SaveAttorney
        private void SaveAttorney()
        {
            Attorney myAttorney;
            int firmId;
            int stateId;
            decimal depositAmount;

            if (SelectedAttorney == null)
            {
                myAttorney = new Attorney();
                myAttorney.ContactList = new ContactList() { DateAdded = DateTime.Now };
                myAttorney.ContactList.Contacts.AddRange(ucContacts.GetListOfContacts());
            }
            else
            {
                myAttorney = SelectedAttorney;
                myAttorney.ContactList.Contacts.Clear();
                myAttorney.ContactList.Contacts.AddRange(ucContacts.GetListOfContacts());
            }

            myAttorney.FirstName = txtFirstName.Text.Trim();
            myAttorney.LastName = txtLastName.Text.Trim();
            myAttorney.Street1 = txtStreet1.Text.Trim();
            myAttorney.Street2 = txtStreet2.Text.Trim();
            myAttorney.City = txtCity.Text.Trim();
            if (int.TryParse(rcbState.SelectedValue, out stateId))
                myAttorney.StateID = stateId;
            myAttorney.ZipCode = txtZip.Text.Trim();
            myAttorney.Phone = txtPhone.Text.Trim();
            myAttorney.Fax = txtFax.Text.Trim();
            myAttorney.Email = txtEmail.Text.Trim();
            myAttorney.Notes = txtNotes.Text.Trim();
            myAttorney.isActiveStatus = rcbStatus.SelectedValue == "1" ? true : false;
            myAttorney.DiscountNotes = txtDiscountNotes.Text.Trim();
            if (decimal.TryParse(txtDeposit.Text.Replace("%", "").Trim(), out depositAmount))
                myAttorney.DepositAmountRequired = depositAmount / 100;
            if (int.TryParse(rcbFirm.SelectedValue, out firmId))
                myAttorney.FirmID = firmId;
            else
                myAttorney.FirmID = null;
            myAttorney.CompanyID = CurrentUser.CompanyID;

            if (SelectedAttorney == null)
                AttorneyClass.InsertAttorney(myAttorney);
            else
                AttorneyClass.UpdateAttorney(myAttorney);

        }
        #endregion

        #endregion

    }
}