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
    public partial class AddEditSurgeryProvider : Classes.BasePage
    {
        #region + Properties

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

        #region RequiredPermission
        public override UserClass.PermissionsEnum? RequiredPermission
        {
            get
            {
                return UserClass.PermissionsEnum.Invoice_Providers;
            }
        }
        #endregion

        #region SurgeryInvoice_ProviderID
        private int? _SurgeryInvoice_ProviderID;
        public int? SurgeryInvoice_ProviderID
        {
            get
            {
                if (!_SurgeryInvoice_ProviderID.HasValue && !String.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    int id;
                    if (int.TryParse(Request.QueryString["id"], out id))
                    {
                        _SurgeryInvoice_ProviderID = id;
                    }
                }
                return _SurgeryInvoice_ProviderID;
            }
        }
        #endregion

        #region Provider
        private SurgeryInvoice_Provider_Custom _Provider;
        public SurgeryInvoice_Provider_Custom Provider
        {
            get
            {
                if (_Provider == null && Invoice != null)
                {
                    _Provider = Invoice.GetTemporaryProvider(ProviderSessionKey, SurgeryInvoice_ProviderID);
                }
                return _Provider;
            }
        }
        #endregion

        #region DiscountPercentage
        private decimal? _DiscountPercentage = null;
        private decimal DiscountPercentage
        {
            get
            {
                if (!_DiscountPercentage.HasValue)
                {
                    if (Provider.InvoiceProviderID.HasValue)
                    {
                        var invoiceProvider = ProviderClass.GetInvoiceProviderByID(Provider.InvoiceProviderID.Value);
                        if (invoiceProvider.DiscountPercentage.HasValue)
                        {
                            _DiscountPercentage = invoiceProvider.DiscountPercentage.Value;
                            return _DiscountPercentage.Value;
                        }
                    }
                    else if (Provider.ProviderID != 0)
                    {
                        var provider = ProviderClass.GetProviderByID(Provider.ProviderID);
                        if (provider.DiscountPercentage.HasValue)
                        {
                            _DiscountPercentage = provider.DiscountPercentage.Value;
                            return _DiscountPercentage.Value;
                        }
                    }
                    _DiscountPercentage = 0;
                }
                return _DiscountPercentage.Value;
            }

        }
        #endregion

        #region + Page Modes (View/Edit/Add)

        #region CurrentInvoiceProvidersPermission
        /// <summary>
        /// Gets the permissions for the user to see if they can add/edit/delete invoice providers
        /// </summary>
        private UserPermission _CurrentInvoiceProvidersPermission;
        public UserPermission CurrentInvoiceProvidersPermission
        {
            get
            {
                if (_CurrentInvoiceProvidersPermission == null)
                {
                    _CurrentInvoiceProvidersPermission = GetCurrentUserPermission(UserClass.PermissionsEnum.Invoice_Providers);
                }
                return _CurrentInvoiceProvidersPermission;
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
                return Provider.ID != 0 && !CurrentInvoiceProvidersPermission.AllowEdit && CurrentInvoiceProvidersPermission.AllowView;
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
                return Provider.ID != 0 && CurrentInvoiceProvidersPermission.AllowEdit;
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
                return Provider.ID == 0 && CurrentInvoiceProvidersPermission.AllowAdd;
            }
        }
        #endregion

        #endregion

        #endregion

        #region + Events

        #region Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {
            SurgeryInvoice_Provider_Custom provider = Provider;

            if (provider == null) { GoBack("/Home.aspx"); }

            if (!IsPostBack)
            {
                litAddEditHeader.Text = IsAddMode ? "Add New Provider" : "Provider";

                txtProviderID.Text = provider.ProviderID.ToString();
                txtInvoiceProviderID.Text = provider.InvoiceProviderID.HasValue ? provider.InvoiceProviderID.Value.ToString() : String.Empty;

                rcbProviderID_LoadItems();
                rcbProviderID.SelectedValue = !String.IsNullOrWhiteSpace(Request.QueryString["pid"]) ? Request.QueryString["pid"] : (provider.ProviderID == 0 ? String.Empty : provider.ProviderID.ToString());

                UpdateDiscount();
                ResetAddEditService();

                rcbPaymentType_LoadItems();
                ResetAddEditPayment();

                ResetAddEditCPTCharge();

                rdpDatePaid.MaxDate = DateTime.Today;

                if (IsViewMode) { SetViewMode(); }
            }
        }
        #endregion

        #region rcbProviderID_SelectedIndexChanged
        protected void rcbProviderID_SelectedIndexChanged(object o, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
        {
            int id;
            if (int.TryParse(rcbProviderID.SelectedValue, out id))
            {
                Provider.ProviderID = id;
                if (txtProviderID.Text == rcbProviderID.SelectedValue && int.TryParse(txtInvoiceProviderID.Text, out id))
                {
                    Provider.InvoiceProviderID = id;
                }
                else
                {
                    Provider.InvoiceProviderID = null;
                }
                UpdateDiscount(true);
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

        #region btnGuarantorAuthorization_Click
        protected void btnGuarantorAuthorization_Click(object sender, EventArgs e)
        {
            Response.Redirect("Documents/SurgeryGuarantorAuthorization.aspx?isk=" + InvoiceSessionKey + "&psk=" + ProviderSessionKey);
        }
        #endregion

        #region + Services

        #region cbxCalculate_CheckedChanged
        protected void cbxCalculate_CheckedChanged(object sender, EventArgs e)
        {
            bool calculate = cbxCalculate.Checked;
            txtAmountDue.ReadOnly = calculate;
            if(calculate)
            {
                UpdateDiscount();
            }
        }
        #endregion

        #region grdServices_NeedDataSource
        /// <summary>
        /// Sets the data source for the grid
        /// </summary>
        protected void grdServices_NeedDataSource(object source, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            List<SurgeryInvoice_Provider_Service_Custom> services = (from s in Provider.ProviderServices
                                                                     where s.Active
                                                                     orderby s.DueDate ascending
                                                                     select s).ToList();
            grdServices.DataSource = services;
        }
        #endregion

        #region txtCost_TextChanged
        protected void txtCost_TextChanged(object sender, EventArgs e)
        {
            UpdateDiscount();
        }
        #endregion

        #region btnEditService_Click
        /// <summary>
        /// Sets the Add/Edit form to Edit mode and loads it into its fields
        /// </summary>
        protected void btnEditService_Click(object sender, EventArgs e)
        {
            int id;
            // get the id from the hidden form field (set by Javascript)
            if (int.TryParse(txtID.Text, out id))
            {
                // search for the service
                SurgeryInvoice_Provider_Service_Custom service = (from s in Provider.ProviderServices
                                                                  where s.ID == id
                                                                  select s).FirstOrDefault();
                // if the service was found
                if (service != null)
                {
                    tblAddEditServices.Visible = true;
                    txtEstimatedCost.Value = service.EstimatedCost.HasValue ? (double)service.EstimatedCost.Value : (double?)null;
                    txtCost.Value = (double)service.Cost;
                    txtDiscount.Value = (double)service.Discount * 100;
                    txtPPODiscount.Value = (double)service.PPODiscount;
                    rdpDueDate.SelectedDate = service.DueDate;
                    txtAmountDue.Value = (double)service.AmountDue;
                    txtAmountDue.ReadOnly = service.CalculateAmountDue;
                    cbxCalculate.Checked = service.CalculateAmountDue;
                    txtAccountNumber.Text = service.AccountNumber;
                    // load the comment id into the hidden field
                    txtServiceID.Text = service.ID.ToString();
                    // show/hide buttons
                    btnServiceAdd.Visible = false;
                    btnServiceSave.Visible = true;
                    btnServiceCancel.Visible = true;
                }
            }
        }
        #endregion

        #region btnDeleteService_Click
        /// <summary>
        /// Rebinds the grid, resets the add/edit form if the deleted charge was being edited
        /// </summary>
        protected void btnDeleteService_Click(object sender, EventArgs e)
        {
            // if deleted comment is being edited???
            if (!String.IsNullOrWhiteSpace(txtServiceID.Text) && txtServiceID.Text == txtID.Text)
            {
                // reset the add/edit comment form
                ResetAddEditService();
            }
            // rebinds the comments grid
            grdServices.Rebind();
        }
        #endregion

        #region btnServiceAdd_Click
        /// <summary>
        /// Adds a service into session, resets the add/edit form, and rebinds the grid
        /// </summary>
        protected void btnServiceAdd_Click(object sender, EventArgs e)
        {
            Page.Validate("Service");
            if (IsValid)
            {
                // get the lowest current id
                int lowestID = (from s in Provider.ProviderServices
                                orderby s.ID ascending
                                select s.ID).FirstOrDefault();
                // add the charge
                decimal discountPercentage = DiscountPercentage;
                decimal cost = decimal.Parse(txtCost.Text, System.Globalization.NumberStyles.Currency);
                Provider.ProviderServices.Add(new SurgeryInvoice_Provider_Service_Custom()
                {
                    Active = true,
                    AccountNumber = txtAccountNumber.Text.Trim(),
                    AmountDue = (decimal)(txtAmountDue.Value ?? 0),
                    CalculateAmountDue = cbxCalculate.Checked,
                    Cost = cost,
                    Discount = discountPercentage,
                    DueDate = rdpDueDate.SelectedDate.Value,
                    EstimatedCost = (decimal?)txtEstimatedCost.Value,
                    ID = lowestID < 0 ? lowestID - 1 : -1,
                    PPODiscount = (decimal)txtPPODiscount.Value
                });
                // reset the add/edit form
                ResetAddEditService();
                // rebind the grid
                grdServices.Rebind();
            }
        }
        #endregion

        #region btnServiceSave_Click
        /// <summary>
        /// Saves an edited charge to session, resets the add/edit charge form, and rebinds the charges grid
        /// </summary>
        protected void btnServiceSave_Click(object sender, EventArgs e)
        {
            Page.Validate("Service");
            if (IsValid)
            {
                int id;
                // get the comment id from the hidded form field
                if (int.TryParse(txtServiceID.Text, out id))
                {
                    // search for the service
                    SurgeryInvoice_Provider_Service_Custom service = (from s in Provider.ProviderServices
                                                                      where s.ID == id
                                                                      select s).FirstOrDefault();
                    // if the service was found
                    if (service != null)
                    {
                        // update the service's properties
                        decimal discountPercentage = DiscountPercentage;
                        service.AccountNumber = txtAccountNumber.Text.Trim();
                        service.AmountDue = (decimal)(txtAmountDue.Value ?? 0);
                        service.CalculateAmountDue = cbxCalculate.Checked;
                        service.Cost = (decimal)txtCost.Value;
                        service.Discount = discountPercentage;
                        service.DueDate = rdpDueDate.SelectedDate.Value;
                        service.EstimatedCost = (decimal?)txtEstimatedCost.Value;
                        service.PPODiscount = (decimal)txtPPODiscount.Value;
                        // reset the add/edit comment form
                        ResetAddEditService();
                        // rebind the comments grid
                        grdServices.Rebind();
                    }
                }
            }
        }
        #endregion

        #region btnServiceCancel_Click
        /// <summary>
        /// Resets the Add/Edit CPT Charge form
        /// </summary>
        protected void btnServiceCancel_Click(object sender, EventArgs e)
        {
            ResetAddEditService();
        }
        #endregion

        #endregion

        #region + Payments

        #region grdPayments_NeedDataSource
        /// <summary>
        /// Sets the data source for the grid
        /// </summary>
        protected void grdPayments_NeedDataSource(object source, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            grdPayments.DataSource = (from p in Provider.Payments
                                      where p.Active
                                      orderby p.DatePaid ascending
                                      select p).ToList(); ;
        }
        #endregion

        #region btnEditPayment_Click
        /// <summary>
        /// Sets the Add/Edit form to Edit mode and loads it into its fields
        /// </summary>
        protected void btnEditPayment_Click(object sender, EventArgs e)
        {
            int id;
            // get the id from the hidden form field (set by Javascript)
            if (int.TryParse(txtID.Text, out id))
            {
                // search for the service
                SurgeryInvoice_Provider_Payment_Custom payment = (from s in Provider.Payments
                                                                  where s.ID == id
                                                                  select s).FirstOrDefault();
                // if the service was found
                if (payment != null)
                {
                    tblPayments.Visible = true;
                    txtPaymentAmount.Value = (double)payment.Amount;
                    txtCheckNumber.Text = payment.CheckNumber;
                    rdpDatePaid.SelectedDate = payment.DatePaid;
                    rcbPaymentType.SelectedValue = payment.PaymentTypeID.ToString();
                    // load the comment id into the hidden field
                    txtPaymentID.Text = payment.ID.ToString();
                    // show/hide buttons
                    btnPaymentAdd.Visible = false;
                    btnPaymentSave.Visible = true;
                    btnPaymentCancel.Visible = true;
                }
            }
        }
        #endregion

        #region btnDeletePayment_Click
        /// <summary>
        /// Rebinds the grid, resets the add/edit form if the deleted charge was being edited
        /// </summary>
        protected void btnDeletePayment_Click(object sender, EventArgs e)
        {
            // if deleted comment is being edited???
            if (!String.IsNullOrWhiteSpace(txtPaymentID.Text) && txtPaymentID.Text == txtID.Text)
            {
                // reset the add/edit comment form
                ResetAddEditPayment();
            }
            // rebinds the comments grid
            grdPayments.Rebind();
        }
        #endregion

        #region btnPaymentAdd_Click
        /// <summary>
        /// Adds a service into session, resets the add/edit form, and rebinds the grid
        /// </summary>
        protected void btnPaymentAdd_Click(object sender, EventArgs e)
        {
            Page.Validate("Payment");
            if (IsValid)
            {
                // get the lowest current id
                int lowestID = (from s in Provider.Payments
                                orderby s.ID ascending
                                select s.ID).FirstOrDefault();
                // add the charge
                Provider.Payments.Add(new SurgeryInvoice_Provider_Payment_Custom()
                {
                    ID = lowestID < 0 ? lowestID - 1 : -1,
                    Active = true,
                    Amount = (decimal)txtPaymentAmount.Value,
                    CheckNumber = txtCheckNumber.Text,
                    DatePaid = rdpDatePaid.SelectedDate.Value,
                    PaymentTypeID = int.Parse(rcbPaymentType.SelectedValue)
                });
                // reset the add/edit form
                ResetAddEditPayment();
                // rebind the grid
                grdPayments.Rebind();
            }
        }
        #endregion

        #region btnPaymentSave_Click
        /// <summary>
        /// Saves an edited charge to session, resets the add/edit charge form, and rebinds the charges grid
        /// </summary>
        protected void btnPaymentSave_Click(object sender, EventArgs e)
        {
            Page.Validate("Payment");
            if (IsValid)
            {
                int id;
                // get the comment id from the hidded form field
                if (int.TryParse(txtPaymentID.Text, out id))
                {
                    // search for the service
                    SurgeryInvoice_Provider_Payment_Custom payment = (from s in Provider.Payments
                                                                      where s.ID == id
                                                                      select s).FirstOrDefault();
                    // if the service was found
                    if (payment != null)
                    {
                        // update the service's properties
                        payment.Amount = (decimal)txtPaymentAmount.Value;
                        payment.CheckNumber = txtCheckNumber.Text;
                        payment.DatePaid = rdpDatePaid.SelectedDate.Value;
                        payment.PaymentTypeID = int.Parse(rcbPaymentType.SelectedValue);
                        // reset the add/edit comment form
                        ResetAddEditPayment();
                        // rebind the comments grid
                        grdPayments.Rebind();
                    }
                }
            }
        }
        #endregion

        #region btnPaymentCancel_Click
        /// <summary>
        /// Resets the Add/Edit CPT Charge form
        /// </summary>
        protected void btnPaymentCancel_Click(object sender, EventArgs e)
        {
            ResetAddEditPayment();
        }
        #endregion

        #endregion

        #region + CPT Charges

        #region grdCPTCharges_NeedDataSource
        /// <summary>
        /// Sets the data source for the grid
        /// </summary>
        protected void grdCPTCharges_NeedDataSource(object source, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            List<SurgeryInvoice_Provider_CPTCode_Custom> cptCharges = (from c in Provider.CPTCodes
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
            Validate("CPTCharge");
            if(Page.IsValid)
            {
                // get the lowest current id
                int lowestID = (from c in Provider.CPTCodes
                                orderby c.ID ascending
                                select c.ID).FirstOrDefault();
                // add the charge
                Provider.CPTCodes.Add(new SurgeryInvoice_Provider_CPTCode_Custom()
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
                SurgeryInvoice_Provider_CPTCode_Custom cptCode = (from c in Provider.CPTCodes
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
            Validate("CPTCharge");
            if (Page.IsValid)
            {
                int id;
                // get the comment id from the hidded form field
                if (int.TryParse(txtCPTChargeID.Text, out id))
                {
                    // search for the cpt charge
                    SurgeryInvoice_Provider_CPTCode_Custom cptCode = (from c in Provider.CPTCodes
                                                                        where c.ID == id
                                                                        select c).FirstOrDefault();
                    // if the charge was found
                    if (cptCode != null)
                    {
                        // update the charge'p properties
                        cptCode.Amount = (decimal) txtAmount.Value;
                        cptCode.CPTCodeID = int.Parse(rcbCPTCodeID.SelectedValue);
                        cptCode.Description = txtDescription.Text.Trim();
                        // reset the add/edit comment form
                        ResetAddEditCPTCharge();
                        // rebind the comments grid
                        grdCPTCharges.Rebind();
                    }
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

        #region btnCancel_Click
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Classes.TemporaryInvoice.RemoveTemporaryProvider(Session, ProviderSessionKey);
            GoBack("Home.aspx");
        }
        #endregion

        #region btnSave_Click
        protected void btnSave_Click(object sender, EventArgs e)
        {
            SurgeryInvoice_Provider_Custom provider = Provider;
            List<SurgeryInvoice_Provider_Custom> invoiceProviders = Invoice.Providers;
            SurgeryInvoice_Provider_Custom target = (from p in invoiceProviders
                                                     where p.ID == provider.ID
                                                     select p).FirstOrDefault();
            if (target != null)
            {
                target.CPTCodes = provider.CPTCodes;
                target.InvoiceProviderID = provider.InvoiceProviderID;
                target.Payments = provider.Payments;
                target.ProviderServices = provider.ProviderServices;

                if (target.ProviderID != provider.ProviderID)
                {
                    target.ProviderID = provider.ProviderID;
                    target.InvoiceProviderID = null;
                }
            }
            else
            {
                int lowestID = (from p in invoiceProviders
                                where p.ID.HasValue
                                orderby p.ID ascending
                                select p.ID.Value).FirstOrDefault();
                provider.ID = lowestID > 0 ? -1 : lowestID - 1;
                invoiceProviders.Add(provider);
            }
            Classes.TemporaryInvoice.RemoveTemporaryProvider(Session, ProviderSessionKey);
            GoBack("Home.aspx");
        }
        #endregion

        #endregion

        #region + Helpers

        #region rcbProviderID_LoadItems
        private void rcbProviderID_LoadItems()
        {
            rcbProviderID.Items.Clear();
            rcbProviderID.Items.Add(new Telerik.Web.UI.RadComboBoxItem("", ""));
            rcbProviderID.Items.AddRange(from p in BMM_BAL.ProviderClass.GetProvidersByCompanyID(Company.ID)
                                         orderby p.Name
                                         select new Telerik.Web.UI.RadComboBoxItem(p.Name, p.ID.ToString()));
        }
        #endregion

        #region UpdateDiscount
        private void UpdateDiscount(bool allServices = false)
        {
            decimal discountPercentage = DiscountPercentage;
            txtDiscount.Value = (double) discountPercentage*100;

            double cost = txtCost.Value.HasValue ? txtCost.Value.Value : 0;
            if (cbxCalculate.Checked)
            {
                txtAmountDue.Value = cost*(double) discountPercentage;
            }

            if (allServices)
            {
                foreach (var service in Provider.ProviderServices)
                {
                    service.Discount = discountPercentage;
                    if (service.CalculateAmountDue)
                    {
                        service.AmountDue = service.Cost * discountPercentage;
                    }
                }
                grdServices.Rebind();
            }
        }
        #endregion

        #region ResetAddEditService
        private void ResetAddEditService()
        {
            // the table is visible if the page is not in view mode
            tblAddEditServices.Visible = !IsViewMode;
            // set the form fields to defaults
            txtEstimatedCost.Value = null;
            txtCost.Value = null;
            txtPPODiscount.Value = 0;
            rdpDueDate.SelectedDate = null;
            txtAmountDue.Value = null;
            txtAmountDue.ReadOnly = true;
            cbxCalculate.Checked = true;
            txtAccountNumber.Text = String.Empty;
            // configure the buttons to add mode
            btnServiceAdd.Visible = true;
            btnServiceSave.Visible = false;
            btnServiceCancel.Visible = false;
            // clear the hidden field
            txtServiceID.Text = String.Empty;
        }
        #endregion

        #region rcbPaymentType_LoadItems
        protected void rcbPaymentType_LoadItems()
        {
            rcbPaymentType.Items.Clear();
            rcbPaymentType.Items.Add(new Telerik.Web.UI.RadComboBoxItem(String.Empty, String.Empty));
            rcbPaymentType.Items.Add(new Telerik.Web.UI.RadComboBoxItem("Principal", ((int)InvoiceClass.PaymentTypeEnum.Principal).ToString()));
            rcbPaymentType.Items.Add(new Telerik.Web.UI.RadComboBoxItem("Interest", ((int)InvoiceClass.PaymentTypeEnum.Interest).ToString()));
            rcbPaymentType.Items.Add(new Telerik.Web.UI.RadComboBoxItem("Deposit", ((int)InvoiceClass.PaymentTypeEnum.Deposit).ToString()));
        }
        #endregion

        #region GetPaymentType
        protected String GetPaymentType(SurgeryInvoice_Provider_Payment_Custom payment)
        {
            //InvoiceClass.PaymentTypeEnum paymentType = (InvoiceClass.PaymentTypeEnum)payment.PaymentTypeID;
            return System.Enum.GetName(typeof(InvoiceClass.PaymentTypeEnum), payment.PaymentTypeID);
        }
        #endregion

        #region ResetAddEditPayment
        private void ResetAddEditPayment()
        {
            // the table is visible if the page is not in view mode
            tblPayments.Visible = !IsViewMode;
            // set the form fields to defaults
            rdpDatePaid.SelectedDate = null;
            txtPaymentAmount.Value = null;
            rcbPaymentType.SelectedValue = String.Empty;
            txtCheckNumber.Text = String.Empty;
            // configure the buttons to add mode
            btnPaymentAdd.Visible = true;
            btnPaymentSave.Visible = false;
            btnPaymentCancel.Visible = false;
            // clear the hidden field
            txtPaymentID.Text = String.Empty;
        }
        #endregion

        #region GetCPTCode
        protected string GetCPTCode(SurgeryInvoice_Provider_CPTCode_Custom sipc_c)
        {
            return (from c in CPTCodes
                    where c.ID == sipc_c.CPTCodeID
                    select c.Code).FirstOrDefault() ?? "&nbsp;";
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
            txtAmount.Value = null;
            txtDescription.Text = String.Empty;
            // configure the buttons to add mode
            btnCPTChargeAdd.Visible = true;
            btnCPTChargeSave.Visible = false;
            btnCPTChargeCancel.Visible = false;
            // clear the hidden field
            txtCPTChargeID.Text = String.Empty;
        }
        #endregion

        #region SetViewMode
        private void SetViewMode()
        {
            
        }
        #endregion

        #endregion
    }
}
