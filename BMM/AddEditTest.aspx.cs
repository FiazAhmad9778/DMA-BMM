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
    public partial class AddEditTest : Classes.BasePage
    {
        #region + Properties

        #region RequiredPermission
        public override UserClass.PermissionsEnum? RequiredPermission
        {
            get
            {
                return UserClass.PermissionsEnum.Invoice_Tests;
            }
        }
        #endregion

        #region Invoice
        private Classes.TemporaryInvoice _Invoice;
        public Classes.TemporaryInvoice Invoice
        {
            get
            {
                if (_Invoice == null && Classes.TemporaryInvoice.Exists(Session, InvoiceSessionKey))
                {
                    _Invoice = new Classes.TemporaryInvoice(Session, Company.ID, null, InvoiceSessionKey);
                }
                return _Invoice;
            }
        }
        #endregion

        #region TestInvoice_TestID
        private int? _TestInvoice_TestID;
        public int? TestInvoice_TestID
        {
            get
            {
                if (!_TestInvoice_TestID.HasValue)
                {
                    int id;
                    if (int.TryParse(Request.QueryString["titid"], out id))
                    {
                        _TestInvoice_TestID = id;
                    }
                }
                return _TestInvoice_TestID;
            }
        }
        #endregion

        #region Test
        private TestInvoice_Test_Custom _Test;
        public TestInvoice_Test_Custom Test
        {
            get
            {
                if (_Test == null && Invoice != null)
                {
                    _Test = Invoice.GetTemporaryTest(TestSessionKey, TestInvoice_TestID);
                }
                return _Test;
            }
        }
        #endregion

        #region + Page Modes (View/Edit/Add)

        #region CurrentInvoiceTestsPermission
        /// <summary>
        /// Gets the permissions for the user to see if they can add/edit/delete invoice tests
        /// </summary>
        private UserPermission _CurrentInvoiceTestsPermission;
        public UserPermission CurrentInvoiceTestsPermission
        {
            get
            {
                if (_CurrentInvoiceTestsPermission == null)
                {
                    _CurrentInvoiceTestsPermission = GetCurrentUserPermission(UserClass.PermissionsEnum.Invoice_Tests);
                }
                return _CurrentInvoiceTestsPermission;
            }
        }
        #endregion

        #region IsViewMode
        /// <summary>
        /// Gets a boolean indicating if the page is in View mode
        /// </summary>
        public bool IsViewMode
        {
            get
            {
                return Test.ID.HasValue && !CurrentInvoiceTestsPermission.AllowEdit && CurrentInvoiceTestsPermission.AllowView;
            }
        }
        #endregion

        #region IsEditMode
        /// <summary>
        /// Gets a boolean indicating if the page is in Edit mode
        /// </summary>
        public bool IsEditMode
        {
            get
            {
                return Test.ID.HasValue && CurrentInvoiceTestsPermission.AllowEdit;
            }
        }
        #endregion

        #region IsAddMode
        /// <summary>
        /// Gets a boolean indicating if the page is in Add mode
        /// </summary>
        public bool IsAddMode
        {
            get
            {
                return !Test.ID.HasValue && CurrentInvoiceTestsPermission.AllowAdd;
            }
        }
        #endregion

        #endregion

        #endregion

        #region + Events

        #region Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {
            TestInvoice_Test_Custom test = Test;

            if (test == null) { GoBack("/Home.aspx"); }

            if (!IsPostBack)
            {
                txtProviderID.Text = test.ProviderID.ToString();
                txtInvoiceProviderID.Text = test.InvoiceProviderID.ToString();

                rcbTestID_LoadItems();
                rcbTestID.SelectedValue = test.TestID == -1 ? String.Empty : test.TestID.ToString();
                rcbProviderID_LoadItems();
                rcbProviderID.SelectedValue = test.TestID == -1 ? String.Empty : test.ProviderID.ToString();
                txtAccountNumber.Text = test.TestID == -1 ? string.Empty : test.AccountNumber;
                txtNotes.Text = test.Notes.Trim();
                if (test.TestDate.Date.CompareTo(DateTime.MinValue.Date) != 0) { rdpTestDate.SelectedDate = test.TestDate.Date; }
                if (test.TestTime.HasValue) { rtpTestTime.SelectedDate = DateTime.Today.Add(test.TestTime.Value); }
                txtNumberOfTests.Value = test.NumberOfTests;
                txtMRI.Value = test.MRI;
                if (test.isPositive.HasValue) { rcbResults.SelectedValue = test.isPositive.Value.ToString().ToLower(); }
                cbxCancelled.Checked = test.isCancelled;
                txtTestCost.Value = test.TestCost == -1 ? 0 : (double?)test.TestCost;
                txtPPODiscount.Value = test.PPODiscount == -1 ? 0 : (double?)test.PPODiscount;
                txtAmountToProvider.Value = test.AmountToProvider == -1 ? null : (double?)test.AmountToProvider;
                cbxCalculate.Checked = test.CalculateAmountToProvider;
                txtAmountToProvider.ReadOnly = test.CalculateAmountToProvider;
                rdpProviderDueDate.SelectedDate = test.ProviderDueDate;
                txtDepositToProvider.Value = (double?)test.DepositToProvider;
                txtAmountPaidToProvider.Value = (double?)test.AmountPaidToProvider;
                rdpDate.SelectedDate = test.Date;
                txtCheckNumber.Text = test.CheckNumber;

                ResetAddEditCPTCharge();

                if (IsViewMode) { SetViewMode(); }
                litAddEditHeader.Text = IsAddMode ? "Add New Test Record" : "Test Record";
            }
        }
        #endregion

        #region txtAmountToProvider_TextChanged
        protected void txtAmountToProvider_TextChanged(object sender, EventArgs e)
        {
            Test.AmountToProvider = (decimal)(txtAmountToProvider.Value ?? 0);
        }
        #endregion

        #region cbxCalculate_CheckedChanged
        protected void cbxCalculate_CheckedChanged(object sender, EventArgs e)
        {
            bool calculate = cbxCalculate.Checked;
            Test.CalculateAmountToProvider = calculate;
            txtAmountToProvider.ReadOnly = calculate;
            if (calculate)
            {
                RecalculateAmountToProvider();
            }
        }
        #endregion


        #region rcbCPTCodeID_ItemsRequested
        protected void rcbCPTCodeID_ItemsRequested(object sender, Telerik.Web.UI.RadComboBoxItemsRequestedEventArgs e)
        {
            string text = e.Text.Trim();
            if (text.Length > 2)
            {
                foreach (var item in (from p in CPTCodes
                                      where p.Code.Contains(text) &&
                                            p.Active == true
                                      select new Telerik.Web.UI.RadComboBoxItem(p.Code, p.ID.ToString())))
                {
                    rcbCPTCodeID.Items.Add(item);
                }
            }
        }
        #endregion

        #region rcbCPTCodeID_ValidateCPTCode
        protected void rcbCPTCodeID_ValidateCPTCode(object source, ServerValidateEventArgs args)
        {
            if ((from c in CPTCodes
                 where c.ID.ToString() == rcbCPTCodeID.SelectedValue
                 select c).Count() > 0)
            {
                args.IsValid = true;
            }
            else
                args.IsValid = false;
        }
        #endregion

        #region btnLetterToPatient_Click
        protected void btnLetterToPatient_Click(object sender, EventArgs e)
        {
            Response.Redirect("Documents/TestLetterToPatient.aspx?isk=" + InvoiceSessionKey + "&tsk=" + TestSessionKey);
        }
        #endregion

        #region btnGuarantorAuthorization_Click
        protected void btnGuarantorAuthorization_Click(object sender, EventArgs e)
        {
            Response.Redirect("Documents/TestGuarantorAuthorization.aspx?isk=" + InvoiceSessionKey + "&tsk=" + TestSessionKey);
        }
        #endregion

        #region rcbProviderID_SelectedIndexChanged
        protected void rcbProviderID_SelectedIndexChanged(object o, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
        {
            int id;
            if (int.TryParse(rcbProviderID.SelectedValue, out id))
            {
                Test.ProviderID = id;
                if (cbxCalculate.Checked)
                {
                    RecalculateAmountToProvider();
                }
                RecalculateProviderDueDate();
            }
        }
        #endregion

        #region rcbTestID_SelectedIndexChanged
        protected void rcbTestID_SelectedIndexChanged(object o, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
        {
            int id;
            if (int.TryParse(rcbTestID.SelectedValue, out id))
            {
                Test.TestID = id;
            }
        }
        #endregion

        #region txtAccountNumber_TextChanged
        protected void txtAccountNumber_TextChanged(object sender, EventArgs e)
        {
            Test.AccountNumber = String.IsNullOrWhiteSpace(txtAccountNumber.Text) ? null : txtAccountNumber.Text.Trim();
        }
        #endregion

        #region txtNotes_TextChanged
        protected void txtNotes_TextChanged(object sender, EventArgs e)
        {
            Test.Notes = String.IsNullOrWhiteSpace(txtNotes.Text) ? null : txtNotes.Text.Trim();
        }
        #endregion

        #region rdpTestDate_SelectedDateChanged
        protected void rdpTestDate_SelectedDateChanged(object sender, Telerik.Web.UI.Calendar.SelectedDateChangedEventArgs e)
        {
            Test.TestDate = rdpTestDate.SelectedDate.HasValue ? rdpTestDate.SelectedDate.Value.Date : DateTime.MinValue.Date;
        }
        #endregion

        #region rtpTestTime_SelectedDateChanged
        protected void rtpTestTime_SelectedDateChanged(object sender, Telerik.Web.UI.Calendar.SelectedDateChangedEventArgs e)
        {
            Test.TestTime = rtpTestTime.SelectedDate.HasValue ? rtpTestTime.SelectedDate.Value.TimeOfDay : (TimeSpan?)null;
        }
        #endregion

        #region txtNumberOfTests_TextChanged
        protected void txtNumberOfTests_TextChanged(object sender, EventArgs e)
        {
            Test.NumberOfTests = (int?)txtNumberOfTests.Value;
        }
        #endregion

        #region txtMRI_TextChanged
        protected void txtMRI_TextChanged(object sender, EventArgs e)
        {
            Test.MRI = (int)(txtMRI.Value ?? 0d);
            if (cbxCalculate.Checked)
            {
                RecalculateAmountToProvider();
            }
        }
        #endregion

        #region rcbResults_SelectedIndexChanged
        protected void rcbResults_SelectedIndexChanged(object sender, EventArgs e)
        {
            Test.isPositive = String.IsNullOrWhiteSpace(rcbResults.SelectedValue) ? null : (bool?)(rcbResults.SelectedValue == "true");
        }
        #endregion

        #region cbxCancelled_CheckedChanged
        protected void cbxCancelled_CheckedChanged(object sender, EventArgs e)
        {
            Test.isCancelled = cbxCancelled.Checked;
        }
        #endregion

        #region txtTestCost_TextChanged
        protected void txtTestCost_TextChanged(object sender, EventArgs e)
        {
            Test.TestCost = (decimal)(txtTestCost.Value ?? -1d);
            if (cbxCalculate.Checked)
            {
                RecalculateAmountToProvider();
            }
        }
        #endregion

        #region txtPPODiscount_TextChanged
        protected void txtPPODiscount_TextChanged(object sender, EventArgs e)
        {
            Test.PPODiscount = (decimal)txtPPODiscount.Value;
        }
        #endregion

        #region + CPT Charges

        #region grdCPTCharges_NeedDataSource
        /// <summary>
        /// Sets the data source for the grid
        /// </summary>
        protected void grdCPTCharges_NeedDataSource(object source, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            List<TestInvoice_Test_CPTCodes_Custom> cptCharges = (from c in Test.CPTCodeList
                                                                 where c.Active
                                                                 orderby GetCPTCode(c) ascending
                                                                 select c).ToList();
            grdCPTCharges.DataSource = cptCharges;
            txtTotalCTPCharges.Value = (double)(from c in cptCharges select c.Amount).Sum();
        }
        #endregion

        #region rcbCPTCodeID_SelectedIndexChanged
        protected void rcbCPTCodeID_SelectedIndexChanged(object sender, EventArgs e)
        {
            int cptCodeID;
            CPTCode cptCode = null;
            if (int.TryParse(rcbCPTCodeID.SelectedValue, out cptCodeID))
            {
                cptCode = (from c in CPTCodes
                           where c.ID == cptCodeID
                           select c).FirstOrDefault();
            }
            txtDescription.Text = cptCode == null ? String.Empty : cptCode.Description;
        }
        #endregion

        #region btnCPTChargeAdd_Click
        /// <summary>
        /// Adds a CPT Charge into session, resets the add/edit form, and rebinds the grid
        /// </summary>
        protected void btnCPTChargeAdd_Click(object sender, EventArgs e)
        {

            if (!string.IsNullOrEmpty(rcbCPTCodeID.SelectedValue)) { 
                // get the lowest current id
                int lowestID = (from c in Test.CPTCodeList
                                orderby c.ID ascending
                                select c.ID).FirstOrDefault();
                // add the charge
                Test.CPTCodeList.Add(new TestInvoice_Test_CPTCodes_Custom()
                {
                    Active = true,
                    Amount = (decimal)txtAmount.Value,
                    CPTCodeID = int.Parse(rcbCPTCodeID.SelectedValue),
                    Description = txtDescription.Text.Trim(),
                    ID = lowestID < 0 ? lowestID - 1 : -1
                });
                // reset the add/edit form
                ResetAddEditCPTCharge();
                // rebind the grid
                grdCPTCharges.Rebind();
            }
        }
        #endregion

        #region btnEditCPTCharge_Click
        /// <summary>
        /// Sets the Add/Edit form to Edit mode and loads it into its fields
        /// </summary>
        protected void btnEditCPTCharge_Click(object sender, EventArgs e)
        {
            int id;
            // get the id from the hidden form field (set by Javascript)
            if (int.TryParse(txtID.Text, out id))
            {
                // search for the cpt charge
                TestInvoice_Test_CPTCodes_Custom cptCode = (from c in Test.CPTCodeList
                                                            where c.ID == id
                                                            select c).FirstOrDefault();
                // if the comment was found
                if (cptCode != null)
                {
                    // show the add/edit comments table
                    tblAddEditCPTCharges.Visible = true;
                    // load the comment properties into the form fields
                    rcbCPTCodeID.SelectedValue = cptCode.CPTCodeID.ToString();
                    rcbCPTCodeID.Text = (from c in CPTCodes
                                         where c.ID == cptCode.CPTCodeID
                                         select c.Code).FirstOrDefault();
                    txtAmount.Value = (double)cptCode.Amount;
                    txtDescription.Text = cptCode.Description;
                    // load the comment id into the hidden field
                    txtCPTChargeID.Text = cptCode.ID.ToString();
                    // configure the buttons
                    btnCPTChargeAdd.Visible = false;
                    btnCPTChargeSave.Visible = true;
                    btnCPTChargeCancel.Visible = true;
                }
            }
        }
        #endregion

        #region btnDeleteCPTCharge_Click
        /// <summary>
        /// Rebinds the grid, resets the add/edit form if the deleted charge was being edited
        /// </summary>
        protected void btnDeleteCPTCharge_Click(object sender, EventArgs e)
        {
            // if deleted comment is being edited???
            if (!String.IsNullOrWhiteSpace(txtCPTChargeID.Text) && txtCPTChargeID.Text == txtID.Text)
            {
                // reset the add/edit comment form
                ResetAddEditCPTCharge();
            }
            // rebinds the comments grid
            grdCPTCharges.Rebind();
        }
        #endregion

        #region btnCPTChargeSave_Click
        /// <summary>
        /// Saves an edited charge to session, resets the add/edit charge form, and rebinds the charges grid
        /// </summary>
        protected void btnCPTChargeSave_Click(object sender, EventArgs e)
        {
            int id;
            // get the comment id from the hidded form field
            if (int.TryParse(txtCPTChargeID.Text, out id))
            {
                // search for the cpt charge
                TestInvoice_Test_CPTCodes_Custom cptCode = (from c in Test.CPTCodeList
                                                            where c.ID == id
                                                            select c).FirstOrDefault();
                // if the charge was found
                if (cptCode != null)
                {
                    // update the charge's properties
                    cptCode.Amount = (decimal)txtAmount.Value;
                    cptCode.CPTCodeID = int.Parse(rcbCPTCodeID.SelectedValue);
                    cptCode.Description = txtDescription.Text.Trim();
                    // reset the add/edit comment form
                    ResetAddEditCPTCharge();
                    // rebind the comments grid
                    grdCPTCharges.Rebind();
                }
            }
        }
        #endregion

        #region btnCPTChargeCancel_Click
        /// <summary>
        /// Resets the Add/Edit CPT Charge form
        /// </summary>
        protected void btnCPTChargeCancel_Click(object sender, EventArgs e)
        {
            ResetAddEditCPTCharge();
        }
        #endregion

        #endregion

        #region rdpProviderDueDate_SelectedDateChanged
        protected void rdpProviderDueDate_SelectedDateChanged(object sender, Telerik.Web.UI.Calendar.SelectedDateChangedEventArgs e)
        {
            Test.ProviderDueDate = rdpProviderDueDate.SelectedDate.HasValue ? rdpProviderDueDate.SelectedDate.Value.Date : DateTime.MinValue.Date;
        }
        #endregion

        #region txtDepositToProvider_TextChanged
        protected void txtDepositToProvider_TextChanged(object sender, EventArgs e)
        {
            Test.DepositToProvider = (decimal?)txtDepositToProvider.Value;
        }
        #endregion

        #region txtAmountPaidToProvider_TextChanged
        protected void txtAmountPaidToProvider_TextChanged(object sender, EventArgs e)
        {
            Test.AmountPaidToProvider = (decimal?)txtAmountPaidToProvider.Value;
        }
        #endregion

        #region rdpDate_SelectedDateChanged
        protected void rdpDate_SelectedDateChanged(object sender, Telerik.Web.UI.Calendar.SelectedDateChangedEventArgs e)
        {
            Test.Date = rdpDate.SelectedDate;
        }
        #endregion

        #region txtCheckNumber_TextChanged
        protected void txtCheckNumber_TextChanged(object sender, EventArgs e)
        {
            Test.CheckNumber = txtCheckNumber.Text;
        }
        #endregion

        #region btnCancel_Click
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Classes.TemporaryInvoice.RemoveTemporaryTest(Session, TestSessionKey);
            GoBack("Home.aspx");
        }
        #endregion

        #region btnSave_Click
        protected void btnSave_Click(object sender, EventArgs e)
        {
            TestInvoice_Test_Custom test = Test;
            List<TestInvoice_Test_Custom> invoiceTests = Invoice.Tests;
            TestInvoice_Test_Custom target = (from t in invoiceTests
                                              where t.ID == test.ID
                                              select t).FirstOrDefault();
            if (target != null)
            {
                target.CPTCodeList = test.CPTCodeList;
                target.isCancelled = test.isCancelled;
                target.isPositive = test.isPositive;
                target.MRI = test.MRI;
                target.AccountNumber = test.AccountNumber;
                target.Notes = test.Notes;
                target.NumberOfTests = test.NumberOfTests;
                target.PPODiscount = test.PPODiscount;
                target.TestCost = test.TestCost;
                target.TestDate = test.TestDate;
                target.TestTime = test.TestTime;
                target.TestID = test.TestID;
                target.AmountToProvider = test.AmountToProvider;
                target.CalculateAmountToProvider = test.CalculateAmountToProvider;
                target.ProviderDueDate = test.ProviderDueDate;
                target.DepositToProvider = test.DepositToProvider;
                target.AmountPaidToProvider = test.AmountPaidToProvider;
                target.Date = test.Date;
                target.CheckNumber = test.CheckNumber;

                if (target.ProviderID != test.ProviderID)
                {
                    target.InvoiceProviderID = null;
                    target.ProviderID = test.ProviderID;
                }
            }
            else
            {
                int lowestID = (from t in invoiceTests
                                where t.ID.HasValue
                                orderby t.ID ascending
                                select t.ID.Value).FirstOrDefault();
                test.ID = lowestID > 0 ? -1 : lowestID - 1;
                invoiceTests.Add(test);
            }
            Classes.TemporaryInvoice.RemoveTemporaryTest(Session, TestSessionKey);
            GoBack("Home.aspx");
        }
        #endregion

        #endregion

        #region + Helpers

        #region SetViewMode
        /// <summary>
        /// Disables controls on page when the user does not have edit permissions
        /// </summary>
        private void SetViewMode()
        {
            string toolTip = ToolTipTextUserDoesntHavePermission;
            rcbProviderID.Enabled = false;
            rcbProviderID.ToolTip = toolTip;
            rcbTestID.Enabled = false;
            rcbTestID.ToolTip = toolTip;
            splchkDescription.Enabled = false;
            splchkDescription.ToolTip = toolTip;
            txtNotes.Enabled = false;
            txtNotes.ToolTip = toolTip;
            rdpTestDate.Enabled = false;
            rdpTestDate.ToolTip = toolTip;
            rtpTestTime.Enabled = false;
            rtpTestTime.ToolTip = toolTip;
            txtNumberOfTests.Enabled = false;
            txtNumberOfTests.ToolTip = toolTip;
            txtMRI.Enabled = false;
            txtMRI.ToolTip = toolTip;
            rcbResults.Enabled = false;
            rcbResults.ToolTip = toolTip;
            cbxCancelled.Enabled = false;
            cbxCancelled.ToolTip = toolTip;
            txtTestCost.Enabled = false;
            txtTestCost.ToolTip = toolTip;
            txtPPODiscount.Enabled = false;
            txtPPODiscount.ToolTip = toolTip;
            //txtAmountToProvider.Enabled = false;
            //txtAmountToProvider.ToolTip = toolTip;
            rdpProviderDueDate.Enabled = false;
            rdpProviderDueDate.ToolTip = toolTip;
            txtDepositToProvider.Enabled = false;
            txtDepositToProvider.ToolTip = toolTip;
            txtAmountPaidToProvider.Enabled = false;
            txtAmountPaidToProvider.ToolTip = toolTip;
            rdpDate.Enabled = false;
            rdpDate.ToolTip = toolTip;
            txtCheckNumber.Enabled = false;
            txtCheckNumber.ToolTip = toolTip;
            btnSave.Enabled = false;
            btnSave.ToolTip = toolTip;
        }
        #endregion

        #region rcbProviderID_LoadItems
        protected void rcbProviderID_LoadItems()
        {
            rcbProviderID.Items.Clear();
            rcbProviderID.Items.Add(new Telerik.Web.UI.RadComboBoxItem(String.Empty, String.Empty));
            rcbProviderID.Items.AddRange(from s in BMM_BAL.ProviderClass.GetProvidersByCompanyID(Company.ID, false)
                                         orderby s.Name
                                         select new Telerik.Web.UI.RadComboBoxItem(s.Name, s.ID.ToString()));
        }
        #endregion

        #region rcbTestID_LoadItems
        protected void rcbTestID_LoadItems()
        {
            rcbTestID.Items.Clear();
            rcbTestID.Items.Add(new Telerik.Web.UI.RadComboBoxItem(String.Empty, String.Empty));
            rcbTestID.Items.AddRange(from s in BMM_BAL.TestClass.GetTestsByCompanyID(Company.ID)
                                     orderby s.Name
                                     select new Telerik.Web.UI.RadComboBoxItem(s.Name, s.ID.ToString()));
        }
        #endregion

        #region GetCPTCode
        protected string GetCPTCode(TestInvoice_Test_CPTCodes_Custom titc_c)
        {
            BMM_DAL.CPTCode cptCode = (from c in CPTCodes
                                       where c.ID == titc_c.CPTCodeID
                                       select c).FirstOrDefault();
            if (cptCode == null) { return "&nbsp;"; }
            else { return cptCode.Code; }
        }
        #endregion

        #region ResetAddEditCPTCharge
        /// <summary>
        /// Resets the Add/Edit CPT Charge section
        /// </summary>
        private void ResetAddEditCPTCharge()
        {
            // the table is visible if the page is not in view mode
            tblAddEditCPTCharges.Visible = !IsViewMode;
            // set the form fields to defaults
            rcbCPTCodeID.SelectedValue = String.Empty;
            rcbCPTCodeID.Text = String.Empty;
            txtAmount.Text = String.Empty;
            txtDescription.Text = String.Empty;
            // configure the buttons to add mode
            btnCPTChargeAdd.Visible = true;
            btnCPTChargeSave.Visible = false;
            btnCPTChargeCancel.Visible = false;
            // cleat the hidden field
            txtCPTChargeID.Text = String.Empty;
        }
        #endregion

        #region RecalculateAmountToProvider
        private void RecalculateAmountToProvider()
        {
            Test.RecalculateAmountToProvider();
            txtAmountToProvider.Value = Test.AmountToProvider == -1 ? null : (double?) Test.AmountToProvider;
        }
        #endregion

        #region RecalculateProviderDueDate
        private void RecalculateProviderDueDate()
        {
            Test.RecalculateProviderDueDate();
            rdpProviderDueDate.SelectedDate = Test.ProviderDueDate;
        }
        #endregion

        #endregion
    }
}