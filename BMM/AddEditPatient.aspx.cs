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
    public partial class AddEditPatient : Classes.BasePage
    {
        #region + Properties

        #region SelectedUser
        private BMM_DAL.Patient _SelectedPatient;
        public BMM_DAL.Patient SelectedPatient
        {
            get
            {
                int id;
                if (_SelectedPatient == null)
                {
                    if (Request.QueryString["id"] != null && Int32.TryParse(Request.QueryString["id"], out id))
                    {
                        _SelectedPatient = PatientClass.GetPatientByID(id, true, false);

                        if (_SelectedPatient != null && _SelectedPatient.CompanyID != Company.ID || _SelectedPatient.Active == false)
                            _SelectedPatient = null;
                    }
                }

                return _SelectedPatient;
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
                return UserClass.PermissionsEnum.Patients; ;
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
                                               where p.PermissionID == (int)UserClass.PermissionsEnum.Patients
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
            get { return NavigationTabEnum.Patients; }
        }
        #endregion

        #endregion

        #region + Events

        #region Page_Load
        /// <summary>
        /// we load the comboboxes, the user'p info and check to see what the user is able to do.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            Title = Company.Name + " - Patient";
            
            if (!IsPostBack)
            {

                rdpDateOfBirth.MinDate = new DateTime(1800, 1, 1);
                LoadComboBoxes();
                LoadPatientInfo();
                btnCreateInvoice.Visible = CheckQueryString() && String.IsNullOrEmpty(Request.QueryString["ReturnURL"]);
                CheckUserPermissions();
            }
        }
        #endregion

        #region btnCreateInvoice_Click
        /// <summary>
        /// Saves the user and redirects to the Invoice page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnCreateInvoice_Click(object sender, EventArgs e)
        {
            Response.Redirect("/AddEditInvoice.aspx?pid=" + SaveRecord());
        }
        #endregion

        #region grdPatientInfo_NeedDataSosurce
        /// <summary>
        /// Checks the selected user and fills the grid if we need to.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void grdPatientInfo_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            if (SelectedPatient != null)
                grdPatientInfo.DataSource = SelectedPatient.PatientChangeLogs;
        }
        #endregion

        #region btnCancel_Click
        /// <summary>
        /// Redirects the user back a page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            GoBack("/ManagePatients.aspx");
        }
        #endregion

        #region btnSubmit_Click
        /// <summary>
        /// Saves the record and redirects the user to the manage patients page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            SaveRecord();
            GoBack("/ManagePatients.aspx");
        }
        #endregion

        #endregion

        #region + Helpers

        #region CheckUserPermissions
        /// <summary>
        /// Checks the users permissions and either enables or disables the controls on the page
        /// </summary>
        private void CheckUserPermissions()
        {
            string ToolTipText = TextUserDoesntHavePermissionText;
            if ((SelectedPatient != null && CurrentUsersPermission.AllowEdit == false) || (SelectedPatient == null && CurrentUsersPermission.AllowAdd == false))
            {
                foreach (Control c in pnlPatient.Controls)
                {
                    if (c is TextBox)
                    {
                        ((TextBox)(c)).Enabled = false;
                        ((TextBox)(c)).ToolTip = ToolTipText;
                    }
                }

                rcbState.Enabled = false;
                rcbState.ToolTip = ToolTipText;

                rcbStatus.Enabled = false;
                rcbStatus.ToolTip = ToolTipText;

                rdpDateOfBirth.Enabled = false;
                rdpDateOfBirth.ToolTip = ToolTipText;

                btnCreateInvoice.Enabled = false;
                btnCreateInvoice.ToolTip = ToolTipText;

                btnSubmit.Enabled = false;
                btnSubmit.ToolTip = ToolTipText;
            }
        }
        #endregion

        #region LoadPatientInfo
        /// <summary>
        /// Loads teh patient'p info if there is any to be loaded.
        /// </summary>
        private void LoadPatientInfo()
        {
            if (SelectedPatient != null)
            {
                Title = Company.Name + " - Patient";
                litPatientInfo.Text = "Patient Record";
                txtFirstName.Text = SelectedPatient.FirstName;
                txtLastName.Text = SelectedPatient.LastName;
                txtSSN.Text = SelectedPatient.SSN.ToString();
                txtStreet.Text = SelectedPatient.Street1;
                txtAptSuite.Text = SelectedPatient.Street2;
                txtCity.Text = SelectedPatient.City;
                rcbState.SelectedValue = SelectedPatient.StateID.ToString();
                txtZipCode.Text = SelectedPatient.ZipCode.ToString();
                txtPhone.Text = SelectedPatient.Phone;
                txtWorkPhone.Text = SelectedPatient.WorkPhone;
                rdpDateOfBirth.SelectedDate = SelectedPatient.DateOfBirth;
                rcbStatus.SelectedValue = SelectedPatient.isActiveStatus == true ? "1" : "0";
            }
            else
            {
                Title = Company.Name + " - Patient";
                litPatientInfo.Text = "Add Patient";
                divReport.Style.Add("display", "none");
            }
        }
        #endregion

        #region LoadComboBoxes
        /// <summary>
        /// Loads the comboboxes and also sets the rad sisd pickers
        /// </summary>
        private void LoadComboBoxes()
        {
            rcbState.DataSource = StateClass.GetStates();
            rcbState.DataTextField = "Name";
            rcbState.DataValueField = "ID";
            rcbState.DataBind();

            rdpDateOfBirth.MaxDate = DateTime.Now;
            rdpDateOfBirth.SelectedDate = DateTime.Now;
        }
        #endregion

        #region SaveRecord
        /// <summary>
        /// Saves the Selected Patients record
        /// </summary>
        /// <returns></returns>
        private int SaveRecord()
        {
            Patient myPatient;
            int StateID;

            if (SelectedPatient == null)
                myPatient = new Patient();
            else
                myPatient = SelectedPatient;

            myPatient.FirstName = txtFirstName.Text.Trim();
            myPatient.LastName = txtLastName.Text.Trim();
            myPatient.SSN = txtSSN.Text.Trim().Replace("-", "");
            myPatient.Street1 = txtStreet.Text.Trim();
            myPatient.Street2 = txtAptSuite.Text.Trim();
            myPatient.City = txtCity.Text.Trim();
            if (int.TryParse(rcbState.SelectedValue, out StateID))
                myPatient.StateID = StateID;
            myPatient.ZipCode = txtZipCode.Text.Trim();
            myPatient.Phone = txtPhone.Text.Trim();
            myPatient.WorkPhone = txtWorkPhone.Text.Trim();
            myPatient.DateOfBirth = (DateTime)rdpDateOfBirth.SelectedDate;
            myPatient.isActiveStatus = rcbStatus.SelectedValue == "1" ? true : false;
            myPatient.CompanyID = CurrentUser.CompanyID;

            if (SelectedPatient == null)
                return PatientClass.InsertPatient(myPatient);
            else
            {
                PatientClass.UpdatePatient(myPatient, CurrentUser.ID);
                if (!CheckQueryString())
                    UpdateInvoicePatient(myPatient);
                return myPatient.ID;
            }
        }
        #endregion

        #region UpdateInvoicePatient
        private void UpdateInvoicePatient(Patient myPatient)
        {
            int ipid;

            if (int.TryParse(Request.QueryString["ipid"], out ipid))
            {
                if (ipid > 0)
                {
                    InvoicePatient myInvoicePatient = InvoiceClass.GetInvoicePatientByID(ipid, false, false);

                    myInvoicePatient.FirstName = myPatient.FirstName;
                    myInvoicePatient.LastName = myPatient.LastName;
                    myInvoicePatient.SSN = myPatient.SSN;
                    myInvoicePatient.Street1 = myPatient.Street1;
                    myInvoicePatient.Street2 = myPatient.Street2;
                    myInvoicePatient.City = myPatient.City;
                    myInvoicePatient.StateID = myPatient.StateID;
                    myInvoicePatient.ZipCode = myPatient.ZipCode;
                    myInvoicePatient.Phone = myPatient.Phone;
                    myInvoicePatient.WorkPhone = myPatient.WorkPhone;
                    myInvoicePatient.DateOfBirth = myPatient.DateOfBirth;
                    myInvoicePatient.isActiveStatus = myPatient.isActiveStatus;

                    InvoiceClass.UpdateInvoicePatient(myInvoicePatient);
                }
            }

        }
        #endregion

        #region CheckQuerySting
        private Boolean CheckQueryString()
        {
            int id;
            return !(int.TryParse(Request.QueryString["ipid"], out id) || id > 0);
        }
        #endregion

        #endregion
    }
}
