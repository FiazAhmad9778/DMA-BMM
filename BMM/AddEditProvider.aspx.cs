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
    public partial class AddEditProvider : Classes.BasePage
    {
        #region + Properties

        #region SelectedProvider
        /// <summary>
        /// The Provider that is to be edited
        /// </summary>
        private Provider _SelectedProvider;
        public Provider SelectedProvider
        {
            get
            {
                int id;

                if (_SelectedProvider == null)
                {
                    if (Request.QueryString["id"] != null && Int32.TryParse(Request.QueryString["id"], out id))
                    {
                        _SelectedProvider = ProviderClass.GetProviderByID(id, true, true, false);

                        if (_SelectedProvider != null && !_SelectedProvider.Active || _SelectedProvider.CompanyID != Company.ID)
                            _SelectedProvider = null;
                    }
                }

                return _SelectedProvider;
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
                return UserClass.PermissionsEnum.Admin_Providers;
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
                                               where p.PermissionID == (int)UserClass.PermissionsEnum.Admin_Providers
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
            get { return SubNavigationTabEnum.AdminProviders; }
        }
        #endregion

        #endregion

        #region + Events

        #region Page_Load
        /// <summary>
        /// On the page load it loads some inital values
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            Title = Company.Name + " - Provider";
            if (!IsPostBack)
            {
                LoadStates();
                loadProvider();
                CheckPermissions();
            }
        }
        #endregion

        #region btnSave_Click
        /// <summary>
        /// Saves the page and redirects the user
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnSave_Click(object sender, EventArgs e)
        {
            SaveProvider();
            ucContacts.RemoveList();
            Response.Redirect("/ManageProviders.aspx");
        }
        #endregion

        #region btnCancel_OnClick
        /// <summary>
        /// redirects the user to the Manage Providers page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnCancel_OnClick(object sender, EventArgs e)
        {
            ucContacts.RemoveList();
            Response.Redirect("/ManageProviders.aspx");
        }
        #endregion

        #endregion

        #region + Helpers

        #region SaveProvider
        /// <summary>
        /// Saves the Provider'p information
        /// </summary>
        private void SaveProvider()
        {
            Provider myProvider;
            int stateId;
            int daysTillPayment;
            decimal deposits;
            decimal discountPercentage;

            if (SelectedProvider != null)
                myProvider = SelectedProvider;
            else
                myProvider = new Provider();

            myProvider.Name = txtName.Text.Trim();
            myProvider.Street1 = txtStreet1.Text.Trim();
            myProvider.Street2 = txtStreet2.Text.Trim();
            myProvider.City = txtCity.Text.Trim();
            if (int.TryParse(rcbState.SelectedValue, out stateId))
                myProvider.StateID = stateId;
            myProvider.ZipCode = txtZip.Text.Trim();
            myProvider.Phone = txtPhone.Text.Trim();
            myProvider.Fax = txtFax.Text.Trim();
            myProvider.Email = txtEmail.Text.Trim();
            myProvider.Street1_Billing = txtStreet1_Billing.Text.Trim();
            myProvider.Street2_Billing = txtStreet2_Billing.Text.Trim();
            myProvider.City_Billing = txtCity_Billing.Text.Trim();
            if (int.TryParse(rcbState_Billing.SelectedValue, out stateId))
                myProvider.StateID_Billing = stateId;
            myProvider.ZipCode_Billing = txtZip_Billing.Text.Trim();
            myProvider.Phone_Billing = txtPhone_Billing.Text.Trim();
            myProvider.Fax_Billing = txtFax_Billing.Text.Trim();
            myProvider.Email_Billing = txtEmail_Billing.Text.Trim();
            myProvider.Notes = txtNotes.Text.Trim();
            myProvider.isActiveStatus = rcbStatus.SelectedValue == "1" ? true : false;
            myProvider.FacilityAbbreviation = txtFacilityAbbreviation.Text.Trim();

            if (decimal.TryParse(txtDiscountPercentage.Text.Replace("%", "").Trim(), out discountPercentage))
                myProvider.DiscountPercentage = discountPercentage / 100;

            if (rdoFlatRate.Checked == true)
            {
                decimal flatRate;
                myProvider.MRICostTypeID = (int)ProviderClass.MRICostTypeEnum.Flat_Rate;
                if (decimal.TryParse(txtMRICost.Text.Replace("$", "").Trim(), out flatRate))
                    myProvider.MRICostFlatRate = (decimal?)flatRate;
            }
            else if (rdoPercentage.Checked == true)
            {
                decimal percentage;
                myProvider.MRICostTypeID = (int)ProviderClass.MRICostTypeEnum.Percentage;
                if (decimal.TryParse(txtMRICost.Text.Replace("%", "").Trim(), out percentage))
                    myProvider.MRICostPercentage = percentage / 100;
            }

            if (decimal.TryParse(txtDeposits.Text.Replace("$", "").Trim(), out deposits))
                myProvider.Deposits = deposits;

            myProvider.TaxID = txtTaxID.Text.Trim();

            if (int.TryParse(txtDaysUntilPaymentDue.Text.Trim(), out daysTillPayment))
                myProvider.DaysUntilPaymentDue = daysTillPayment;

            myProvider.CompanyID = CurrentUser.CompanyID;

            if (SelectedProvider == null)
            {
                myProvider.ContactList = new ContactList();
                myProvider.ContactList.DateAdded = DateTime.Now;
                myProvider.ContactList.Contacts.AddRange(ucContacts.GetListOfContacts());

                ProviderClass.InsertProvider(myProvider);
            }
            else
            {
                myProvider.ContactList.Contacts.Clear();
                myProvider.ContactList.Contacts.AddRange(ucContacts.GetListOfContacts());

                ProviderClass.UpdateProvider(myProvider);
            }
        }
        #endregion

        #region LoadProvider
        private void loadProvider()
        {
            ucContacts.MyUserPermission = UserClass.PermissionsEnum.Admin_Providers;

            if (SelectedProvider != null)
            {
                ucContacts.isAddPage = false;
                litHeader.Text = "Provider Record";
                ucContacts.ListOfContacts = SelectedProvider.ContactList.Contacts.ToList();
                txtName.Text = SelectedProvider.Name;
                txtStreet1.Text = SelectedProvider.Street1;
                txtStreet2.Text = SelectedProvider.Street2;
                txtCity.Text = SelectedProvider.City;
                rcbState.SelectedValue = SelectedProvider.StateID.ToString();
                txtZip.Text = SelectedProvider.ZipCode;
                txtPhone.Text = SelectedProvider.Phone;
                txtFax.Text = SelectedProvider.Fax;
                txtEmail.Text = SelectedProvider.Email;
                txtStreet1_Billing.Text = SelectedProvider.Street1_Billing;
                txtStreet2_Billing.Text = SelectedProvider.Street2_Billing;
                txtCity_Billing.Text = SelectedProvider.City_Billing;
                rcbState_Billing.SelectedValue = SelectedProvider.StateID_Billing.ToString();
                txtZip_Billing.Text = SelectedProvider.ZipCode_Billing;
                txtPhone_Billing.Text = SelectedProvider.Phone_Billing;
                txtFax_Billing.Text = SelectedProvider.Fax_Billing;
                txtEmail_Billing.Text = SelectedProvider.Email_Billing;
                txtNotes.Text = SelectedProvider.Notes;
                rcbStatus.SelectedValue = SelectedProvider.isActiveStatus == true ? "1" : "0";
                txtFacilityAbbreviation.Text = SelectedProvider.FacilityAbbreviation;
                if (SelectedProvider.DiscountPercentage != null)
                    txtDiscountPercentage.Text = String.Format("{0:0.00}", ((decimal)(SelectedProvider.DiscountPercentage * 100))) + "%";
                if (SelectedProvider.MRICostTypeID == (int)ProviderClass.MRICostTypeEnum.Flat_Rate)
                {
                    rdoFlatRate.Checked = true;
                    if (SelectedProvider.MRICostFlatRate != null)
                        txtMRICost.Text = String.Format("{0:C}", SelectedProvider.MRICostFlatRate);
                    hdnValidator.Value = "1";
                }
                else if (SelectedProvider.MRICostTypeID == (int)ProviderClass.MRICostTypeEnum.Percentage)
                {
                    rdoPercentage.Checked = true;
                    if (SelectedProvider.MRICostPercentage != null)
                        txtMRICost.Text = String.Format("{0:0.00}", ((decimal)(SelectedProvider.MRICostPercentage * 100))) + "%";
                    hdnValidator.Value = "2";
                }
                txtDeposits.Text = String.Format("{0:C}", SelectedProvider.Deposits);
                txtDaysUntilPaymentDue.Text = SelectedProvider.DaysUntilPaymentDue.ToString();
                txtTaxID.Text = SelectedProvider.TaxID;
            }
            else
            {
                ucContacts.isAddPage = true;
                litHeader.Text = "Add New Provider";
                hdnValidator.Value = "1";
            }
        }
        #endregion

        #region CheckPermissions
        /// <summary>
        /// Checks to see if the user has permissions to view the page
        /// </summary>
        private void CheckPermissions()
        {
            if (SelectedProvider != null && CurrentUsersPermission.AllowEdit == false)
                DisableControls();
            else if (SelectedProvider == null && CurrentUsersPermission.AllowAdd == false)
                DisableControls();
        }
        #endregion

        #region DisableControls
        private void DisableControls()
        {
            string ToolTipText = TextUserDoesntHavePermissionText;

            rcbState.Enabled = false;
            rcbState.ToolTip = ToolTipText;

            rcbStatus.Enabled = false;
            rcbStatus.ToolTip = ToolTipText;

            rdoFlatRate.Enabled = false;
            rdoFlatRate.ToolTip = ToolTipText;

            rdoPercentage.Enabled = false;
            rdoPercentage.ToolTip = ToolTipText;

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

            rcbState_Billing.EmptyMessage = "Select";
            rcbState_Billing.DataSource = StateClass.GetStates();
            rcbState_Billing.DataValueField = "ID";
            rcbState_Billing.DataTextField = "Name";
            rcbState_Billing.DataBind();

        }
        #endregion

        #endregion
    }
}