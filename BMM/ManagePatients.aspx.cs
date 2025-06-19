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
    public partial class ManagePatients : Classes.BasePage
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
                return UserClass.PermissionsEnum.Patients;
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

        #region +Events

        #region Page_Load
        /// <summary>
        /// Sets up the page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            Title = Company.Name + " - Manage Patients";

            if (!Page.IsPostBack)
            {                
                CheckUserPermission();
                rcbStatus.ClearSelection();
                rcbStatus.EmptyMessage = "Select";
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
            Response.Redirect("/AddEditPatient.aspx");
        }
        #endregion

        #region grdPatients_NeedDataSource
        /// <summary>
        /// Binds the datagrid
        /// </summary>
        protected void grdPatients_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            grdPatients.DataSource = (from p in PatientClass.GetPatientsByCompanyID(CurrentUser.CompanyID, true)
                                      orderby p.LastName, p.FirstName
                                       select p).ToList();
        }
        #endregion

        #region grdPatients_OnItemCommand
        //upon clicking the name of the patient, or edit, the onitemcommand will load the textbox with the name for editing
        //it will also change out the add button into two buttons for save and cancel
        protected void grdPatients_OnItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs args)
        {
            if (args.CommandName == "btnEdit")
                Response.Redirect("/AddEditPatient.aspx?id=" + args.CommandArgument.ToString());
            else if (args.CommandName == "btnView")
                Response.Redirect("/AddEditPatient.aspx?id=" + args.CommandArgument.ToString());
        }
        #endregion

        #region btnSearch_Click
        /// <summary>
        /// Redirects the user to the add/edit page
        /// </summary>
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            int fieldCount = 0;
            if (!String.IsNullOrWhiteSpace(rcbPatientSearchSSN.Text)) fieldCount++;
            if (!String.IsNullOrWhiteSpace(rcbPatientSearchName.Text)) fieldCount++;

            if (fieldCount == 0)
            {
                litError.Text = "Please enter search criteria in a field.";
            }
            // if more than one field is used
            else if (fieldCount > 1)
            {
                // display error message
                litError.Text = "Please enter search criteria in only one field.";
            }
            else if (!String.IsNullOrWhiteSpace(rcbPatientSearchSSN.Text))
            {
                // search by ssn
                Patient patient = String.IsNullOrWhiteSpace(rcbPatientSearchSSN.SelectedValue) ? null : PatientClass.GetPatientByID(int.Parse(rcbPatientSearchSSN.SelectedValue), false, false);
                if (patient == null)
                {
                    litError.Text = "SSN entered does not exist. Please try search again.";
                }
                else
                {
                    SearchPatient();
                }
            }
            else if (!String.IsNullOrWhiteSpace(rcbPatientSearchName.Text))
            {
                Patient patient = String.IsNullOrWhiteSpace(rcbPatientSearchName.SelectedValue) ? null : PatientClass.GetPatientByID(int.Parse(rcbPatientSearchName.SelectedValue), false, false);
                if (patient == null)
                {
                    litError.Text = "Patient name entered does not exist. Please try search again.";
                }
                else
                {
                    SearchPatient();
                }
            }
            else
            {
                SearchPatient();
            }
        }
        #endregion

        #region rcbPatientSearchName_ItemsRequested
        //loads the combo box with the Patient names
        protected void rcbPatientSearchName_ItemsRequested(object sender, Telerik.Web.UI.RadComboBoxItemsRequestedEventArgs e)
        {
            string text = e.Text.ToLower().Trim();
            if (text.Length > 2)
            {
                //load the Name search combo box
                foreach (var item in (from p in PatientClass.GetPatientsByNameSearch(text, CurrentUser.CompanyID)
                                      select new Telerik.Web.UI.RadComboBoxItem(p.LastName + ", " + p.FirstName + (String.IsNullOrWhiteSpace(p.SSN) ? String.Empty : " (" + p.SSN.Substring(p.SSN.Length - 4) + ")"), p.ID.ToString())))
                {
                    rcbPatientSearchName.Items.Add(item);
                }
            }
        }
        #endregion

        #region rcbPatientSearchSSN_ItemsRequested
        //loads the combo box with the Patient names
        protected void rcbPatientSearchSSN_ItemsRequested(object sender, Telerik.Web.UI.RadComboBoxItemsRequestedEventArgs e)
        {
            string text = e.Text.Trim();
            if (text.Length > 2)
            {
                foreach (var item in (from p in PatientClass.GetPatientsBySSNSearch(text, CurrentUser.CompanyID)
                                      select new Telerik.Web.UI.RadComboBoxItem(p.SSN.Substring(0, 3) + "-" + p.SSN.Substring(3, 2) + "-" + p.SSN.Substring(5, 4), p.ID.ToString())))
                {
                    rcbPatientSearchSSN.Items.Add(item);
                }
            }
        }
        #endregion

        #region rcbStatus_IndexChanged
        //filters the grid by active, inactive or all depending on what the user selects
        protected void rcbStatus_IndexChanged(object sender, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
        { 
            if(rcbStatus.SelectedItem.Text.ToString() == "Active")
            {
                grdPatients.DataSource = (from p in PatientClass.GetPatientsByCompanyID(CurrentUser.CompanyID, true)
                                          where p.isActiveStatus == true
                                          orderby p.FirstName, p.LastName
                                          select p).ToList();
                grdPatients.DataBind();
            }
            else if (rcbStatus.SelectedItem.Text.ToString() == "Inactive")
            {
                grdPatients.DataSource = (from p in PatientClass.GetPatientsByCompanyID(CurrentUser.CompanyID, true)
                                          where p.isActiveStatus == false
                                          orderby p.FirstName, p.LastName
                                          select p).ToList();
                grdPatients.DataBind();
            }
            else
                grdPatients.Rebind();
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
        //gets the address of the corresponding patient
        public String GetAddress(Patient p)
        {
            string address = p.Street1;

            if (!String.IsNullOrWhiteSpace(p.Street2))
                address += ", " + p.Street2;

            address += ", " + p.City + ", " + p.State.Abbreviation + " " + p.ZipCode;

            return address;
        }
        #endregion

        #region GetDelete
        /// <summary>
        /// Either returns an image for the user to delete a patient or returns an inactive image
        /// </summary>
        public string GetDelete(int id)
        {
            return CurrentUsersPermission.AllowDelete ? "<span class='Pointer'><img src='/Images/icon_delete.png' title='Delete' onclick='Javascript:confirmDelete(" + id.ToString() + ")' /></span>" : "<img src='Images/icon_delete_inactive.png' title='" + TextUserDoesntHavePermissionText + "'/>";
        }
        #endregion

        #region SearchPatient()
        //gets the information for the patient in the combobox that has the search item
        private void SearchPatient()
        {
            int id;

            if (int.TryParse(rcbPatientSearchSSN.SelectedValue, out id) || int.TryParse(rcbPatientSearchName.SelectedValue, out id))
            {
                Response.Redirect("/AddEditPatient.aspx?id=" + id);
            }
            else
            {
                rcbPatientSearchSSN.ClearSelection();
                rcbPatientSearchName.ClearSelection();
            }
        }
        #endregion

        #endregion
    }
}