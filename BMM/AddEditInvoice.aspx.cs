using System;
using Telerik.Web.UI;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using BMM_BAL;
using BMM_DAL;
using Microsoft.Reporting.WebForms;

namespace BMM
{
    public partial class AddEditInvoice : Classes.BasePage
    {
        #region + Properties

        #region ReturnURL

        /// <summary>
        ///     URL-Encoded URL to return to this page
        /// </summary>
        private string ReturnURL
        {
            get
            {
                return
                    this.Server.UrlEncode("/AddEditInvoice.aspx?isk=" + this.InvoiceSessionKey
                                          + (this.Invoice.ID.HasValue ? "&id=" + this.Invoice.ID.Value : String.Empty));
            }
        }

        #endregion

        #region RequiredPermission

        /// <summary>
        ///     Overrides the property in the base class, sets the required permission to Invoices
        /// </summary>
        public override UserClass.PermissionsEnum? RequiredPermission
        {
            get { return UserClass.PermissionsEnum.Invoices; }
        }

        #endregion

        #region SelectedNavigationTab

        /// <summary>
        ///     Overrides the property in the base class, sets the selected navigation tab to Invoices
        /// </summary>
        public override NavigationTabEnum SelectedNavigationTab
        {
            get { return NavigationTabEnum.Invoices; }
        }

        #endregion

        #region + Permissions

        #region CurrentInvoicesPermission

        /// <summary>
        ///     Gets the permissions for the user to see if they can add/edit/delete invoices
        /// </summary>
        private UserPermission _CurrentInvoicesPermission;

        public UserPermission CurrentInvoicesPermission
        {
            get
            {
                if (this._CurrentInvoicesPermission == null)
                {
                    this._CurrentInvoicesPermission = this.GetCurrentUserPermission(UserClass.PermissionsEnum.Invoices);
                }

                return this._CurrentInvoicesPermission;
            }
        }

        #endregion

        #region CurrentInvoiceTestsPermission

        /// <summary>
        ///     Gets the permissions for the user to see if they can add/edit/delete invoice tests
        /// </summary>
        private UserPermission _CurrentInvoiceTestsPermission;

        public UserPermission CurrentInvoiceTestsPermission
        {
            get
            {
                if (this._CurrentInvoiceTestsPermission == null)
                {
                    this._CurrentInvoiceTestsPermission = this.GetCurrentUserPermission(UserClass.PermissionsEnum.Invoice_Tests);
                }
                return this._CurrentInvoiceTestsPermission;
            }
        }

        #endregion

        #region CurrentInvoiceProvidersPermission

        /// <summary>
        ///     Gets the permissions for the user to see if they can add/edit/delete invoice surgeries
        /// </summary>
        private UserPermission _CurrentInvoiceSurgeriesPermission;

        public UserPermission CurrentInvoiceSurgeriesPermission
        {
            get
            {
                if (this._CurrentInvoiceSurgeriesPermission == null)
                {
                    this._CurrentInvoiceSurgeriesPermission = this.GetCurrentUserPermission(UserClass.PermissionsEnum.Invoice_Surgeries);
                }
                return this._CurrentInvoiceSurgeriesPermission;
            }
        }

        #endregion

        #region CurrentInvoiceProvidersPermission

        /// <summary>
        ///     Gets the permissions for the user to see if they can add/edit/delete invoice providers
        /// </summary>
        private UserPermission _CurrentInvoiceProvidersPermission;

        public UserPermission CurrentInvoiceProvidersPermission
        {
            get
            {
                if (this._CurrentInvoiceProvidersPermission == null)
                {
                    this._CurrentInvoiceProvidersPermission = this.GetCurrentUserPermission(UserClass.PermissionsEnum.Invoice_Providers);
                }
                return this._CurrentInvoiceProvidersPermission;
            }
        }

        #endregion

        #region CurrentInvoicePaymentInformationPermission

        /// <summary>
        ///     Gets the permissions for the user to see if they can add/edit/delete invoice attorneyPayments
        /// </summary>
        private UserPermission _CurrentInvoicePaymentInformationPermission;

        public UserPermission CurrentInvoicePaymentInformationPermission
        {
            get
            {
                if (this._CurrentInvoicePaymentInformationPermission == null)
                {
                    this._CurrentInvoicePaymentInformationPermission =
                        this.GetCurrentUserPermission(UserClass.PermissionsEnum.Invoice_PaymentInformation);
                }
                return this._CurrentInvoicePaymentInformationPermission;
            }
        }

        #endregion

        #region CurrentInvoiceCommentsPermission

        /// <summary>
        ///     Gets the permissions for the user to see if they can add/edit/delete invoice comments
        /// </summary>
        private UserPermission _CurrentInvoiceCommentsPermission;

        public UserPermission CurrentInvoiceCommentsPermission
        {
            get
            {
                if (this._CurrentInvoiceCommentsPermission == null)
                {
                    this._CurrentInvoiceCommentsPermission = this.GetCurrentUserPermission(UserClass.PermissionsEnum.Invoice_Comments);
                }
                return this._CurrentInvoiceCommentsPermission;
            }
        }

        #endregion

        #endregion

        #region + Page Modes (View/Edit/Add)

        #region IsViewMode

        /// <summary>
        ///     Gets a boolean indicating if the page is in View mode
        /// </summary>
        public bool IsViewMode
        {
            get { return this.Invoice.ID.HasValue && !this.CurrentInvoicesPermission.AllowEdit && this.CurrentInvoicesPermission.AllowView; }
        }

        #endregion

        #region IsEditMode

        /// <summary>
        ///     Gets a boolean indicating if the page is in Edit mode
        /// </summary>
        public bool IsEditMode
        {
            get { return this.Invoice.ID.HasValue && this.CurrentInvoicesPermission.AllowEdit; }
        }

        #endregion

        #region IsAddMode

        /// <summary>
        ///     Gets a boolean indicating if the page is in Add mode
        /// </summary>
        public bool IsAddMode
        {
            get { return !this.Invoice.ID.HasValue && this.CurrentInvoicesPermission.AllowAdd; }
        }

        #endregion

        #endregion

        #region InvoiceID

        private int? InvoiceID
        {
            get
            {
                if (ViewState["InvoiceID"] == null)
                {
                    int id;
                    ViewState["InvoiceID"] = !String.IsNullOrEmpty(this.Request.QueryString["id"])
                                             && int.TryParse(this.Request.QueryString["id"], out id)
                                                 ? id
                                                 : (int?) null;
                }
                return (int?)ViewState["InvoiceID"];
            }
            set { ViewState["InvoiceID"] = value; }
        }

        #endregion

        #region Invoice

        private Classes.TemporaryInvoice _Invoice;

        public Classes.TemporaryInvoice Invoice
        {
            get
            {
                if (this._Invoice == null)
                {
                    this._Invoice = new Classes.TemporaryInvoice(this.Session, this.Company.ID, this.InvoiceID, this.InvoiceSessionKey);
                }
                return this._Invoice;
            }
        }

        #endregion

        #region RequestedPatient

        private Patient _RequestedPatient;

        /// <summary>
        ///     The patient requested in the query string (null if not requested or invalid)
        /// </summary>
        protected Patient RequestedPatient
        {
            get
            {
                if (this._RequestedPatient == null && !String.IsNullOrEmpty(this.Request.QueryString["pid"]))
                {
                    int id;
                    if (int.TryParse(this.Request.QueryString["pid"], out id))
                    {
                        this._RequestedPatient = PatientClass.GetPatientByID(id);

                        if (this._RequestedPatient != null && (!this._RequestedPatient.Active || this._RequestedPatient.CompanyID != this.Company.ID))
                        {
                            this._RequestedPatient = null;
                        }
                    }
                }
                return this._RequestedPatient;
            }
        }

        #endregion       

        #endregion

        #region + Events

        #region Page_Load

        /// <summary>
        ///     Handler for page load event
        /// </summary>
        protected void Page_Load(object sender, EventArgs e)
        {
            this.Title = Company.Name + " - Invoice";
            
            // if not a post-back
            if (!this.IsPostBack || sender == this.btnSave)
            {

                // if there is a valid invoice requested in the query string
                if (this.Invoice.ID.HasValue)
                {
                    //if the invoice is not for the current user's company
                    if (this.Invoice.CompanyID != this.CurrentUser.CompanyID)
                    {
                        this.Response.Redirect("/Home.aspx");
                    }

                    // the page is either in edit or view mode
                    // set the header text
                    this.litAddEditInvoiceHeader.Text = "Invoice Record";
                
                }
                    // otherwise, the page is in add mode
                else
                {
                    // if the user doesn'test have add permissions
                    if (!this.CurrentInvoicesPermission.AllowAdd)
                    {
                        // kick the user to the home page
                        this.Response.Redirect("/Home.aspx");
                    }
                        // if a valid patient has been requested in the querystring
                    else if (this.RequestedPatient != null)
                    {
                        // set the patient id to session so that it will be selected in the combobox
                        this.Invoice.PatientID = this.RequestedPatient.ID;
                    }
                    // set the header text
                    this.litAddEditInvoiceHeader.Text = "Add New Invoice";
               
                }

                // Check to see if the Save Window should be opened
                CheckSaveWindow();
                // load all of the page sections from the data in session
                this.ConfigureInvoiceRecord();
                this.ConfigurePatientInformation();
                this.ConfigureTests();
                this.ConfigureSurgeries();
                this.ConfigureProviders();
                this.ConfigurePaymentInformation();
                this.ConfigureSummary();
                this.ConfigureComments();

                // if we are in view mode
                if (this.IsViewMode)
                {
                    // disable form elements
                    this.SetViewMode();
                }
            }
            else
            {
                // INVOICE
                this.Invoice.DateOfAccident = this.rdpDateOfAccident.SelectedDate;
                if (!String.IsNullOrWhiteSpace(this.rcbInvoiceType.SelectedValue))
                {
                    this.Invoice.TypeID = int.Parse(this.rcbInvoiceType.SelectedValue);
                }
                this.Invoice.IsComplete = this.cbxComplete.Checked;
                if (!String.IsNullOrWhiteSpace(this.rcbStatus.SelectedValue))
                {
                    this.Invoice.StatusID = int.Parse(this.rcbStatus.SelectedValue);
                }
                if (!String.IsNullOrWhiteSpace(this.rcbTestType.SelectedValue))
                {
                    this.Invoice.TestTypeID = int.Parse(this.rcbTestType.SelectedValue);
                }
               
                // PATIENT
                this.Invoice.PatientID = String.IsNullOrWhiteSpace(this.rcbPatient.SelectedValue)
                                             ? null
                                             : (int?) int.Parse(this.rcbPatient.SelectedValue);
                this.SetPatientLiterals();
                this.Invoice.AttorneyID = String.IsNullOrWhiteSpace(this.rcbAttorney.SelectedValue)
                                              ? null
                                              : (int?) int.Parse(this.rcbAttorney.SelectedValue);

                if (this.Invoice.AttorneyID != null)
                    SetAttorneyStatus((int)this.Invoice.AttorneyID);

                this.Invoice.PhysicianID = String.IsNullOrWhiteSpace(this.rcbPhysician.SelectedValue)
                                               ? null
                                               : (int?) int.Parse(this.rcbPhysician.SelectedValue);
                // PAYMENT INFORMATION
                this.Invoice.ClosedDate = this.rdpClosedDate.SelectedDate;
                this.Invoice.DatePaid = this.rdpDatePaid.SelectedDate;
                this.Invoice.ServiceFeeWaived = (decimal?) this.txtServiceFeeWaived.Value;
                this.Invoice.LossesAmount = (decimal?) this.txtLossesAmount.Value;
                this.ConfigureSummary();               
            }
        }

        private void SetAttorneyStatus(int attorneyID)
        {
            Attorney myAttorney = AttorneyClass.GetAttorneyByID(attorneyID, false, false, false);
            
            if(myAttorney != null)
                litAttorneyStatus.Text = myAttorney.isActiveStatus ? "&nbsp" : "Inactive";
        }

        #endregion

        #region btnWorksheet_Click

        protected void btnWorksheet_Click(object sender, EventArgs e)
        {
            if (this.Invoice.TypeIsTesting)
            {
                this.Response.Redirect("Documents/TestWorksheet.aspx?isk=" + this.InvoiceSessionKey);
            }
            else
            {
                this.Response.Redirect("Documents/SurgeryWorksheet.aspx?isk=" + this.InvoiceSessionKey);
            }
        }

        #endregion

        #region btnPrint_Click

        protected void btnPrint_Click(object sender, EventArgs e)
        {
            string fileName;
            ReportViewer rw = new ReportViewer();
            rw.LocalReport.DataSources.Clear();
            if (Invoice.TypeIsTesting)
            {
                fileName = "Test Invoice";
                rw.LocalReport.ReportPath = "Reports\\TestPrintOut.rdlc";
                var tests = new BMMDataSet.TemporaryInvoiceTestsDataTable();
                foreach (var invoiceTest in Invoice.Tests.Where(test => test.Active).Select(test => test))
                {
                    tests.AddTemporaryInvoiceTestsRow(GetTestProviderName(invoiceTest), GetTestName(invoiceTest), invoiceTest.Notes,
                                                      invoiceTest.TestDate, invoiceTest.TestCost);
                }
                rw.LocalReport.DataSources.Add(new ReportDataSource("Tests", (DataTable) tests));
                rw.LocalReport.SetParameters(new ReportParameter("TotalCost", Invoice.TotalCost.ToString()));
                rw.LocalReport.SetParameters(new ReportParameter("TotalPPODiscount", Invoice.TotalPPODiscount.ToString()));
                rw.LocalReport.SetParameters(new ReportParameter("CompanyID", CurrentUser.CompanyID.ToString()));
            }
            else
            {
                fileName = "Surgery Invoice";
                rw.LocalReport.ReportPath = "Reports\\SurgeryPrintOut.rdlc";
                var surgeries = new BMMDataSet.TemporaryInvoiceSurgeriesDataTable();
                foreach (var surgery in Invoice.Surgeries.Where(surgery => surgery.Active).Select(surgery => surgery))
                {
                    string surgeryName = GetSurgeryName(surgery);
                    foreach (var date in surgery.SurgeryDates)
                    {
                        surgeries.AddTemporaryInvoiceSurgeriesRow(surgeryName, date);
                    }
                }
                rw.LocalReport.DataSources.Add(new ReportDataSource("Surgeries", (DataTable) surgeries));
                var services = new BMMDataSet.TemporaryInvoiceServicesDataTable();
                foreach (var provider in Invoice.Providers.Where(provider => provider.Active).Select(provider => provider))
                {
                    string providerName = GetProviderName(provider);
                    foreach(var service in provider.ProviderServices.Where(service => service.Active).Select(service => service))
                    {
                        services.AddTemporaryInvoiceServicesRow(providerName, service.Cost, service.PPODiscount);
                    }
                }
                rw.LocalReport.DataSources.Add(new ReportDataSource("Services", (DataTable) services));
            }
            #region Set Common Parameters: Company, Attorney, Invoice #, Patient Name, Date of Accident, Summary
            rw.LocalReport.SetParameters(new ReportParameter("CompanyLongName", Company.LongName));
            rw.LocalReport.SetParameters(new ReportParameter("CompanyAddress", Company.Address));
            rw.LocalReport.SetParameters(new ReportParameter("CompanyCityStateZip", Company.CityStateZip));
            rw.LocalReport.SetParameters(new ReportParameter("CompanyPhone", Company.Phone));
            rw.LocalReport.SetParameters(new ReportParameter("CompanyFax", Company.Fax));
            rw.LocalReport.SetParameters(new ReportParameter("CompanyFederalID", Company.FederalID));
            rw.LocalReport.SetParameters(new ReportParameter("InvoiceNumber",
                                                             Invoice.InvoiceNumber.HasValue ? Invoice.InvoiceNumber.Value.ToString() : "N/A"));
            Action<string, string, string, string, string, string, string> setAttorney =
                (firstName, lastName, street1, street2, city, state, zipCode) =>
                {
                    rw.LocalReport.SetParameters(new ReportParameter("AttorneyName", String.Format("{0} {1}", firstName, lastName)));
                    rw.LocalReport.SetParameters(new ReportParameter("AttorneyStreet1", street1));
                    rw.LocalReport.SetParameters(new ReportParameter("AttorneyStreet2", street2));
                    rw.LocalReport.SetParameters(new ReportParameter("AttorneyCityStateZip", String.Format("{0}, {1} {2}", city, state, zipCode)));
                };
            Attorney attorney = !Invoice.AttorneyID.HasValue ? null : AttorneyClass.GetAttorneyByID(Invoice.AttorneyID.Value, false, false, true);
            if (attorney != null)
            {
                setAttorney(attorney.FirstName, attorney.LastName, attorney.Street1, attorney.Street2, attorney.City, attorney.State.Abbreviation,
                            attorney.ZipCode);
            }
            rw.LocalReport.SetParameters(new ReportParameter("PatientName", Invoice.GetPatientFullName()));
            if (Invoice.DateOfAccident.HasValue)
            {
                rw.LocalReport.SetParameters(new ReportParameter("DateOfAccident", Invoice.DateOfAccident.Value.ToShortDateString()));
            }
            rw.LocalReport.SetParameters(new ReportParameter("TotalCostMinusPPODiscounts", (Invoice.TotalCost - Invoice.TotalPPODiscount).ToString()));
            rw.LocalReport.SetParameters(new ReportParameter("DepositPaid", Invoice.DepositPaid.ToString()));
            rw.LocalReport.SetParameters(new ReportParameter("PrincipalPaid", Invoice.PrincipalPaid.ToString()));
            rw.LocalReport.SetParameters(new ReportParameter("AdditionalDeductions", Invoice.AdditionalDeductions.ToString()));
            rw.LocalReport.SetParameters(new ReportParameter("ServiceFeeReceived", Invoice.ServiceFeeReceived.ToString()));
            rw.LocalReport.SetParameters(new ReportParameter("BalanceDue", Invoice.BalanceDue.ToString()));
            rw.LocalReport.SetParameters(new ReportParameter("CumulativeServiceFee", Math.Abs(Invoice.CalculatedCumulativeInterest - Invoice.ServiceFeeReceived).ToString()));
            rw.LocalReport.SetParameters(new ReportParameter("EndingBalance", Invoice.EndingBalance.ToString()));          
            #endregion
            rw.LocalReport.Refresh();
            Warning[] warnings;
            string[] streamids;
            string mimeType,
                   encoding,
                   extension;
            byte[] bytes = rw.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamids, out warnings);
            fileName = String.Format("{0} {1} {2}.{3}",
                                     fileName,
                                     Invoice.InvoiceNumber.HasValue
                                        ? Invoice.InvoiceNumber.Value.ToString() 
                                        : "(Not Saved)",
                                     DateTime.Now.ToString("MM-dd-yyyy HH.mm"),
                                     extension);
            Response.Clear();
            Response.ContentType = mimeType;
            Response.AppendHeader("content-disposition", "attachment; filename=" + fileName);
            Response.BinaryWrite(bytes);
            Response.End();
        }

        #endregion

        #region btnEditLoanTerms_Click

        protected void btnEditLoanTerms_Click(object sender, EventArgs e)
        {
            InvoiceID = this.SaveInvoice();
            this.ClearInvoiceSession();
            this._Invoice = null;
            this._Providers = null;
            this._InvoiceProviders = null;
            this.Page_Load(this.btnSave, e);   
        }

        #endregion

        #region + Patient Information

        #region lnkUpdatePatientInformation_Click

        /// <summary>
        ///     Redirects the user to the Add/Edit Patient page
        /// </summary>
        protected void lnkUpdatePatientInformation_Click(object sender, EventArgs e)
        {
            if (this.Invoice.PatientID.HasValue)
            {
                InvoicePatient invoicePatient = this.Invoice.InvoicePatient;
                if (invoicePatient == null || invoicePatient.PatientID != this.Invoice.PatientID.Value)
                {
                    this.Response.Redirect("/AddEditPatient.aspx?id=" + this.Invoice.PatientID.Value + "&ReturnURL=" + this.ReturnURL);
                }
                else
                {
                    this.Response.Redirect("/AddEditPatient.aspx?id=" + this.Invoice.PatientID.Value + "&ipid=" + invoicePatient.ID + "&ReturnURL="
                                           + this.ReturnURL);
                }
            }
        }

        #endregion

        #endregion

        #region + Invoice Tests

        #region btnAddNewTest_Click

        /// <summary>
        ///     Redirects the user to the Add/Edit Test page
        /// </summary>
        protected void btnAddNewTest_Click(object sender, EventArgs e)
        {
            this.Response.Redirect("/AddEditTest.aspx?isk=" + this.InvoiceSessionKey + "&ReturnURL=" + this.ReturnURL);
        }

        #endregion

        #region grdTests_NeedDataSource

        /// <summary>
        ///     Sets the data source for the Tests grid
        /// </summary>
        protected void grdTests_NeedDataSource(object source, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            this.grdTests.DataSource = (from it in this.Invoice.Tests
                                        where it.Active
                                        orderby it.TestDate ascending
                                        select it);
        }

        #endregion

        #region btnViewTest_Click

        /// <summary>
        ///     Redirects the users to the View/Add/Edit Test page
        /// </summary>
        protected void btnViewTest_Click(object sender, EventArgs e)
        {
            this.Response.Redirect("/AddEditTest.aspx?titid=" + this.txtID.Text + "&isk=" + this.InvoiceSessionKey + "&ReturnURL=" + this.ReturnURL);
        }

        #endregion

        #region btnEditTest_Click

        /// <summary>
        ///     Redirects the users to the View/Add/Edit Test page
        /// </summary>
        protected void btnEditTest_Click(object sender, EventArgs e)
        {
            this.Response.Redirect("/AddEditTest.aspx?titid=" + this.txtID.Text + "&isk=" + this.InvoiceSessionKey + "&ReturnURL=" + this.ReturnURL);
        }

        #endregion

        #region btnDeleteTest_Click

        /// <summary>
        ///     Rebinds the Test grid
        /// </summary>
        protected void btnDeleteTest_Click(object sender, EventArgs e)
        {
            this.grdTests.Rebind();
            this.ConfigureSummary();
        }

        #endregion

        #endregion

        #region + Invoice Surgeries

        #region btnAddNewSurgery_Click

        /// <summary>
        ///     Redirects the user to the View/Add/Edit Provider page
        /// </summary>
        protected void btnAddNewSurgery_Click(object sender, EventArgs e)
        {
            this.Response.Redirect("/AddEditSurgery.aspx?isk=" + this.InvoiceSessionKey + "&ReturnURL=" + this.ReturnURL);
        }

        #endregion

        #region grdSurgeries_NeedDataSource

        /// <summary>
        ///     Sets the data source for the Surgeries grid
        /// </summary>
        protected void grdSurgeries_NeedDataSource(object source, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            this.grdSurgeries.DataSource = (from i in this.Invoice.Surgeries
                                            where i.Active
                                            select i);
        }

        #endregion

        #region btnViewSurgery_Click

        /// <summary>
        ///     Redirects the user to the View/Add/Edit Provider page
        /// </summary>
        protected void btnViewSurgery_Click(object sender, EventArgs e)
        {
            this.Response.Redirect("/AddEditSurgery.aspx?sisid=" + this.txtID.Text + "&isk=" + this.InvoiceSessionKey + "&ReturnURL=" + this.ReturnURL);
        }

        #endregion

        #region btnEditSurgery_Click

        /// <summary>
        ///     Redirects the user to the View/Add/Edit Provider page
        /// </summary>
        protected void btnEditSurgery_Click(object sender, EventArgs e)
        {
            this.Response.Redirect("/AddEditSurgery.aspx?sisid=" + this.txtID.Text + "&isk=" + this.InvoiceSessionKey + "&ReturnURL=" + this.ReturnURL);
        }

        #endregion

        #region btnDeleteSurgery_Click

        /// <summary>
        ///     Rebinds the Surgeries grid
        /// </summary>
        protected void btnDeleteSurgery_Click(object sender, EventArgs e)
        {
            this.grdSurgeries.Rebind();
        }

        #endregion

        #endregion

        #region + Invoice Providers

        #region btnAddNewProvider_Click

        /// <summary>
        ///     Redirects the user to the Add Provider page
        /// </summary>
        protected void btnAddNewProvider_Click(object sender, EventArgs e)
        {
            this.Response.Redirect("/AddEditSurgeryProvider.aspx?isk=" + this.InvoiceSessionKey + "&ReturnURL=" + this.ReturnURL);
        }

        #endregion

        #region grdProviders_NeedDataSource

        /// <summary>
        ///     Sets the data source on the Providers grid
        /// </summary>
        protected void grdProviders_NeedDataSource(object source, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            this.grdProviders.DataSource = (from ip in this.Invoice.Providers
                                            where ip.Active
                                            orderby this.GetProviderName(ip) ascending
                                            select ip);
        }

        #endregion

        #region btnViewProvider_Click

        /// <summary>
        ///     Redirects the user to the View/Edit Provider page
        /// </summary>
        protected void btnViewProvider_Click(object sender, EventArgs e)
        {
            this.Response.Redirect("/AddEditSurgeryProvider.aspx?mode=provider&isk=" + this.InvoiceSessionKey + "&id=" + this.txtID.Text
                                   + "&ReturnURL=" + this.ReturnURL);
        }

        #endregion

        #region btnEditProvider_Click

        /// <summary>
        ///     Redirects the user to the View/Edit Provider page
        /// </summary>
        protected void btnEditProvider_Click(object sender, EventArgs e)
        {
            this.Response.Redirect("/AddEditSurgeryProvider.aspx?mode=provider&isk=" + this.InvoiceSessionKey + "&id=" + this.txtID.Text
                                   + "&ReturnURL=" + this.ReturnURL);
        }

        #endregion

        #region btnDeleteProvider_Click

        /// <summary>
        ///     Rebinds the Providers grid
        /// </summary>
        protected void btnDeleteProvider_Click(object sender, EventArgs e)
        {
            this.grdProviders.Rebind();
            this.ConfigureSummary();
        }

        #endregion

        #endregion

        #region + Payment Information

        #region grdPayments_NeedDataSource

        /// <summary>
        ///     Sets the data source for the Payments grid and updates the Total Closed text
        /// </summary>
        protected void grdPayments_NeedDataSource(object source, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            List<Payment> payments = (from p in this.Invoice.Payments
                                      where p.Active
                                      orderby p.DatePaid ascending
                                      select p).ToList();
            this.grdPayments.DataSource = payments;
            decimal total = 0;
            foreach (Payment payment in payments)
            {
                total += payment.Amount;
            }
            this.litTotalPaid.Text = total.ToString("C");
        }

        #endregion

        #region btnPaymentAdd_Click

        /// <summary>
        ///     Adds a payment to the session, resets the add/edit payment form section, and rebinds the Payments grid
        /// </summary>
        protected void btnPaymentAdd_Click(object sender, EventArgs e)
        {
            // get the lowest current ID
            int lowestID = (from c in this.Invoice.Payments
                            orderby c.ID ascending
                            select c.ID).FirstOrDefault();

            // add the invoice to the session
            this.Invoice.Payments.Add(new Payment()
                                      {
                                          Active = true,
                                          DateAdded = DateTime.Now,
                                          // if the lowest id is less than 0, use the next smaller integer
                                          // if the lowest id is 0 or greater, use -1
                                          ID = lowestID < 0 ? lowestID - 1 : -1,
                                          InvoiceID = this.Invoice.ID.HasValue ? this.Invoice.ID.Value : -1,
                                          Amount = (decimal) this.txtPaymentAmount.Value,
                                          CheckNumber = this.txtPaymentCheckNumber.Text,
                                          PaymentTypeID = int.Parse(this.rcbPaymentType.SelectedValue),
                                          DatePaid = this.rdpPaymentDate.SelectedDate.Value
                                      });

            // reset the add/edit payment form
            this.ResetAddEditPayment();
            // rebind the grid
            this.grdPayments.Rebind();

            this.ConfigureSummary();
        }

        #endregion

        #region btnEditPayment_Click

        /// <summary>
        ///     Configures the Add/Edit Payment form section to Edit mode and loads the selected payment into its fields
        /// </summary>
        protected void btnEditPayment_Click(object sender, EventArgs e)
        {
            int id;
            // the payment id is passed via Javascript through a hidden field
            if (int.TryParse(this.txtID.Text, out id))
            {
                // search for the payment
                Payment payment = (from p in this.Invoice.Payments
                                   where p.ID == id
                                   select p).FirstOrDefault();
                // if the payment was found
                if (payment != null)
                {
                    // show the table
                    this.tblAddEditPayment.Visible = true;
                    // fill the fields
                    this.rdpPaymentDate.SelectedDate = payment.DatePaid;
                    this.txtPaymentAmount.Value = (double) payment.Amount;
                    this.txtPaymentCheckNumber.Text = payment.CheckNumber;
                    this.rcbPaymentType.SelectedValue = payment.PaymentTypeID.ToString();
                    // store the id in the hidden form field
                    this.txtPaymentID.Text = payment.ID.ToString();
                    // configure the buttons
                    this.btnPaymentAdd.Visible = false;
                    this.btnPaymentSave.Visible = true;
                    this.btnPaymentCancel.Visible = true;
                }
            }
        }

        #endregion

        #region btnDeletePayment_Click

        /// <summary>
        ///     Rebinds the Payments grid and resets the Add/Edit Payment form if the deleted payment was being edited
        /// </summary>
        protected void btnDeletePayment_Click(object sender, EventArgs e)
        {
            // if deleted payment is being edited???
            if (!String.IsNullOrWhiteSpace(this.txtPaymentID.Text) && this.txtPaymentID.Text == this.txtID.Text)
            {
                // reset the Add/Edit Payment form
                this.ResetAddEditPayment();
            }

            this.grdPayments.Rebind();

            this.ConfigureSummary();
        }

        #endregion

        #region btnPaymentSave_Click

        /// <summary>
        ///     Updates the edited payment in session, resets the Add/Edit payment form, and rebinds the Payments grid
        /// </summary>
        protected void btnPaymentSave_Click(object sender, EventArgs e)
        {
            int id;
            // get the id of the payment being edited from a hidden form field (set by Javascript)
            if (int.TryParse(this.txtPaymentID.Text, out id))
            {
                // search for the payment in session
                Payment payment = (from p in this.Invoice.Payments
                                   where p.ID == id
                                   select p).FirstOrDefault();
                // if it was found
                if (payment != null)
                {
                    // update the payment'p editable properties
                    payment.DatePaid = this.rdpPaymentDate.SelectedDate.Value;
                    payment.Amount = (decimal) this.txtPaymentAmount.Value;
                    payment.PaymentType = (from pt in InvoiceClass.GetPaymentTypes()
                                           where pt.ID.ToString() == this.rcbPaymentType.SelectedValue
                                           select pt).First();
                    payment.CheckNumber = this.txtPaymentCheckNumber.Text;
                    // reset the add/edit payment form
                    this.ResetAddEditPayment();
                    // rebind the attorneyPayments grid
                    this.grdPayments.Rebind();

                    this.ConfigureSummary();
                }
            }
        }

        #endregion

        #region btnPaymentCancel_Click

        /// <summary>
        ///     Resets the Add/Edit Payment form
        /// </summary>
        protected void btnPaymentCancel_Click(object sender, EventArgs e)
        {
            // reset the add/edit payment form
            this.ResetAddEditPayment();
        }

        #endregion

        #region grdPaymentComments_NeedDataSource

        /// <summary>
        ///     Sets the data source for the Payment Comments grid
        /// </summary>
        protected void grdPaymentComments_NeedDataSource(object source, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            this.grdPaymentComments.DataSource = (from c in this.Invoice.PaymentComments
                                                  where c.Active
                                                  orderby c.DateAdded descending
                                                  select c);
        }

        #endregion

        #region btnPaymentCommentAdd_Click

        /// <summary>
        ///     Adds a Payment Comment to the session, resets the Add/Edit payment comment form, and rebinds the payment comments grid
        /// </summary>
        protected void btnPaymentCommentAdd_Click(object sender, EventArgs e)
        {
            // get the lowest id of the current payment comments
            int lowestID = (from c in this.Invoice.PaymentComments
                            orderby c.ID ascending
                            select c.ID).FirstOrDefault();

            // add the comment
            this.Invoice.PaymentComments.Add(new Comment()
                                             {
                                                 Active = true,
                                                 CommentTypeID = (int) InvoiceClass.CommentTypeEnum.PaymentComment,
                                                 DateAdded = DateTime.Now,
                                                 isIncludedOnReports = true,
                                                 // if the lowest id is less than 0, use the next smaller integer
                                                 // if the lowest id is 0 or greater, use -1
                                                 ID = lowestID < 0 ? lowestID - 1 : -1,
                                                 InvoiceID = this.Invoice.ID.HasValue ? this.Invoice.ID.Value : -1,
                                                 Text = this.txtPaymentComment.Text,
                                                 UserID = this.CurrentUser.ID
                                             });

            InvoiceID = this.SaveInvoice();
            // clear the session data
            this.ClearInvoiceSession();
            // reload the invoice
            this._Invoice = null;
            this._Providers = null;
            this._InvoiceProviders = null;
            this.Page_Load(this.btnSave, e);
            // reset the add/edit payment comments form 
            this.ResetAddEditPaymentComment();

            // rebind the payment comments grid
            this.grdPaymentComments.Rebind();
        }

        #endregion

        #region btnEditPaymentComment_Click

        /// <summary>
        ///     Configures the Add/Edit Payment Comment form section to Edit mode and loads the selected comment into its fields
        /// </summary>
        protected void btnEditPaymentComment_Click(object sender, EventArgs e)
        {
            int id;
            // get the comment id from the hidden form field (set by Javascript)
            if (int.TryParse(this.txtID.Text, out id))
            {
                // search for the comment
                Comment comment = (from c in this.Invoice.PaymentComments
                                   where c.ID == id
                                   select c).FirstOrDefault();

                // if it was found
                if (comment != null)
                {
                    // show the table
                    this.tblAddEditPaymentComments.Visible = true;
                    // load the comment into the field
                    this.txtPaymentComment.Text = comment.Text;
                    // load the ID into the hidden field
                    this.txtPaymentCommentID.Text = comment.ID.ToString();
                    // configure the buttons
                    this.btnPaymentCommentAdd.Visible = false;
                    this.btnPaymentCommentSave.Visible = true;
                    this.btnPaymentCommentCancel.Visible = true;
                }
            }
        }

        #endregion

        #region btnDeletePaymentComment_Click

        /// <summary>
        ///     Rebinds the payment comments grid, resets the add/edit payment comments form if the deleted comment was being edited
        /// </summary>
        protected void btnDeletePaymentComment_Click(object sender, EventArgs e)
        {
            // if deleted comment is being edited???
            if (!String.IsNullOrWhiteSpace(this.txtPaymentCommentID.Text) && this.txtPaymentCommentID.Text == this.txtID.Text)
            {
                // reset the add/edit payment comment form
                this.ResetAddEditPaymentComment();
            }

            InvoiceID = this.SaveInvoice();
            // clear the session data
            this.ClearInvoiceSession();
            // reload the invoice
            this._Invoice = null;
            this._Providers = null;
            this._InvoiceProviders = null;
            this.Page_Load(this.btnSave, e);

            // rebind the payment comments grid
            this.grdPaymentComments.Rebind();
        }

        #endregion

        #region btnPaymentCommentSave_Click

        /// <summary>
        ///     Saves a comment that was being edited to session
        /// </summary>
        protected void btnPaymentCommentSave_Click(object sender, EventArgs e)
        {
            int id;
            // get the comment id from the hidden field (set by Javascript)
            if (int.TryParse(this.txtPaymentCommentID.Text, out id))
            {
                // search for the comment
                Comment comment = (from c in this.Invoice.PaymentComments
                                   where c.ID == id
                                   select c).FirstOrDefault();
                // if it was found
                if (comment != null)
                {
                    // update the comment'p properties
                    comment.DateAdded = DateTime.Now;
                    comment.User = this.CurrentUser;
                    comment.Text = this.txtPaymentComment.Text.Trim();
                    comment.isIncludedOnReports = true;
                    // reset the add/edit payment comments form
                    this.ResetAddEditPaymentComment();
                    // rebind the payment comments grid
                    this.grdPaymentComments.Rebind();
                }
            }
        }

        #endregion

        #region btnPaymentCommentCancel_Click

        /// <summary>
        ///     Resets the payment comments grid
        /// </summary>
        protected void btnPaymentCommentCancel_Click(object sender, EventArgs e)
        {
            this.ResetAddEditPaymentComment();
        }

        #endregion

        #endregion

        #region + General Comments

        #region grdComments_NeedDataSource

        /// <summary>
        ///     Sets the data source for the comments grid
        /// </summary>
        protected void grdComments_NeedDataSource(object source, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            this.grdComments.DataSource = (from c in this.Invoice.GeneralComments
                                           where c.Active
                                           orderby c.DateAdded ascending 
                                           select c);
        }

        #endregion

        #region btnCommentAdd_Click

        /// <summary>
        ///     Adds a comment into session, resets the add/edit comment form, and rebinds the comments grid
        /// </summary>
        protected void btnCommentAdd_Click(object sender, EventArgs e)
        {
            // get the lowest current comment id
            int lowestID = (from c in this.Invoice.GeneralComments
                            orderby c.ID ascending
                            select c.ID).FirstOrDefault();
            // add the comment
            this.Invoice.GeneralComments.Add(new Comment()
                                             {
                                                 Active = true,
                                                 CommentTypeID = (int) InvoiceClass.CommentTypeEnum.InvoiceComment,
                                                 DateAdded = DateTime.Now,
                                                 isIncludedOnReports = !this.cbxCommentNotIncludedOnReports.Checked,
                                                 // if the lowest id is less than 0, use the next smaller integer
                                                 // if the lowest id is 0 or greater, use -1
                                                 ID = lowestID < 0 ? lowestID - 1 : -1,
                                                 InvoiceID = this.Invoice.ID.HasValue ? this.Invoice.ID.Value : -1,
                                                 Text = this.txtComment.Text,
                                                 UserID = this.CurrentUser.ID
                                             });

            InvoiceID = this.SaveInvoice();
            // clear the session data
            this.ClearInvoiceSession();
            // reload the invoice
            this._Invoice = null;
            this._Providers = null;
            this._InvoiceProviders = null;
            this.Page_Load(this.btnSave, e);
            // reset the add/edit comment form
            this.ResetAddEditComment();
            // rebind the comments grid
            this.grdComments.Rebind();
        }

        #endregion

        #region btnEditComment_Click

        /// <summary>
        ///     Sets the Add/Edit Comment form to Edit mode and loads a comment into its fields
        /// </summary>
        protected void btnEditComment_Click(object sender, EventArgs e)
        {
            int id;
            // get the comment id from the hidden form field (set by Javascript)
            if (int.TryParse(this.txtID.Text, out id))
            {
                // search for the comment
                Comment comment = (from c in this.Invoice.GeneralComments
                                   where c.ID == id
                                   select c).FirstOrDefault();
                // if the comment was found
                if (comment != null)
                {
                    // show the add/edit comments table
                    this.tblAddEditComments.Visible = true;
                    // load the comment properties into the form fields
                    this.txtComment.Text = comment.Text;
                    this.cbxCommentNotIncludedOnReports.Checked = !comment.isIncludedOnReports;
                    // load the comment id into the hidden field
                    this.txtCommentID.Text = comment.ID.ToString();
                    // configure the buttons
                    this.btnCommentAdd.Visible = false;
                    this.btnCommentSave.Visible = true;
                    this.btnCommentCancel.Visible = true;
                }
            }
        }

        #endregion

        #region btnDeleteComment_Click

        /// <summary>
        ///     Rebinds the comments grid, resets the add/edit comment form if the deleted comment was being edited
        /// </summary>
        protected void btnDeleteComment_Click(object sender, EventArgs e)
        {
            // if deleted comment is being edited???
            if (!String.IsNullOrWhiteSpace(this.txtCommentID.Text) && this.txtCommentID.Text == this.txtID.Text)
            {
                // reset the add/edit comment form
                this.ResetAddEditComment();
            }

            InvoiceID = this.SaveInvoice();
            // clear the session data
            this.ClearInvoiceSession();
            // reload the invoice
            this._Invoice = null;
            this._Providers = null;
            this._InvoiceProviders = null;
            this.Page_Load(this.btnSave, e);
            // rebinds the comments grid
            this.grdComments.Rebind();
        }

        #endregion

        #region btnCommentSave_Click

        /// <summary>
        ///     Saves an edited comment to session, resets the add/edit comment form, and rebinds the comments grid
        /// </summary>
        protected void btnCommentSave_Click(object sender, EventArgs e)
        {
            int id;
            // get the comment id from the hidded form field
            if (int.TryParse(this.txtCommentID.Text, out id))
            {
                // search for the comment
                Comment comment = (from c in this.Invoice.GeneralComments
                                   where c.ID == id
                                   select c).FirstOrDefault();
                // if the comment was found
                if (comment != null)
                {
                    // update the comment'p properties
                    comment.DateAdded = DateTime.Now; // ??????????
                    comment.User = this.CurrentUser; // ??????????
                    comment.Text = this.txtComment.Text.Trim();
                    comment.isIncludedOnReports = !this.cbxCommentNotIncludedOnReports.Checked;
                    // reset the add/edit comment form
                    this.ResetAddEditComment();
                    // rebind the comments grid
                    this.grdComments.Rebind();
                }
            }
        }

        #endregion

        #region btnCommentCancel_Click

        /// <summary>
        ///     Resets the Add/Edit Comment form
        /// </summary>
        protected void btnCommentCancel_Click(object sender, EventArgs e)
        {
            this.ResetAddEditComment();
        }

        #endregion

        #endregion

        #region btnCancel_Click

        /// <summary>
        ///     Clears the invoice session and sends the user back to their previous page (default: InvoiceSearch.aspx)
        /// </summary>
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            this.ClearInvoiceSession();
            this.GoBack("/InvoiceSearch.aspx");
        }

        #endregion

        #region btnSave_Click

        /// <summary>
        ///     Saves the Invoice to the DB, alert the user that the invoice was saved
        /// </summary>
        protected void btnSave_Click(object sender, EventArgs e)
        {
            InvoiceID = this.SaveInvoice();
            // clear the session data
            this.ClearInvoiceSession();
            // reload the invoice
            this._Invoice = null;
            this._Providers = null;
            this._InvoiceProviders = null;
            this.Page_Load(this.btnSave, e);
            // alert the user
            this.InvoiceSaved.Visible = true;
            this.InvoiceSaved.VisibleOnPageLoad = true;
        }

        #endregion

        #region btnSaveAndClose_Click

        /// <summary>
        ///     Saves the Invoice to the DB, clears the Invoice from the Session, and sends the user back to their previous page (default: InvoiceSearch.aspx)
        /// </summary>
        protected void btnSaveAndClose_Click(object sender, EventArgs e)
        {
            this.SaveInvoice();
            // cleare the invoice from session
            this.ClearInvoiceSession();
            // return the user to the previous page
            this.GoBack("/InvoiceSearch.aspx");
        }

        #endregion

        #region btnSaveInvoice_Click
        /// <summary>
        /// saves an invoice to the DB from the popup window
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnSaveInvoice_Click(object sender, EventArgs e)
        {
            InvoiceID = this.SaveInvoice();
            this.ClearInvoiceSession();
            this._Invoice = null;
            this._Providers = null;
            this._InvoiceProviders = null;
            this.Page_Load(this.btnSave, e);        
        }
        #endregion

        #endregion

        #region + Helpers

        #region ClearInvoiceSession

        /// <summary>
        ///     Removes the current invoice's keys from the session
        /// </summary>
        private void ClearInvoiceSession()
        {
            this.Invoice.Remove();
        }

        #endregion

        #region SetViewMode

        /// <summary>
        ///     Disables controls on page when the user does not have edit permissions
        /// </summary>
        private void SetViewMode()
        {
            // Invoice Record
            this.rdpDateOfAccident.Enabled = false;
            this.rcbInvoiceType.Enabled = false;
            this.rcbStatus.Enabled = false;
            this.cbxComplete.Enabled = false;
            this.rcbTestType.Enabled = false;
            // Patient Information
            this.rcbPatient.Enabled = false;
            this.lnkUpdatePatientInformation.Enabled = false;
            this.rcbAttorney.Enabled = false;
            this.rcbPhysician.Enabled = false;
            // Payment Information
            this.rdpClosedDate.Enabled = false;
            this.rdpDatePaid.Enabled = false;
            this.txtServiceFeeWaived.Enabled = false;
            this.txtLossesAmount.Enabled = false;
        }

        #endregion

        #region ConfigureInvoiceRecord

        /// <summary>
        ///     Loads the Invoice Record from session to the page fields
        /// </summary>
        private void ConfigureInvoiceRecord()
        {
            // Load Invoice Record
            this.LoadComboBoxItems(this.rcbInvoiceType, typeof (InvoiceClass.InvoiceTypeEnum));
            this.LoadComboBoxItems(this.rcbStatus, typeof (InvoiceClass.InvoiceStatusEnum));
            this.LoadComboBoxItems(this.rcbTestType, typeof (TestClass.TestTypeEnum));
            this.btnWorksheet.Text = this.Company.Name + " Worksheet";

            this.litInvoiceNumber.Text = this.Invoice.InvoiceNumber.HasValue
                                             ? this.Invoice.InvoiceNumber.ToString()
                                             : "<invoice>Not Assigned</invoice>";
            this.rdpDateOfAccident.SelectedDate = this.Invoice.DateOfAccident;
            this.rcbInvoiceType.SelectedValue = this.Invoice.TypeID.ToString();
            this.rcbInvoiceType.Enabled = !this.Invoice.ID.HasValue;
            this.rcbStatus.SelectedValue = this.Invoice.StatusID.ToString();
            this.rcbStatus.Enabled = this.Invoice.IsComplete;
            this.cbxComplete.Checked = this.Invoice.IsComplete;

            this.rdpClosedDate.SelectedDate = this.Invoice.ClosedDate;
            this.rdpDatePaid.SelectedDate = this.Invoice.DatePaid;
            this.txtServiceFeeWaived.Value = (double?) this.Invoice.ServiceFeeWaived;
            this.txtLossesAmount.Value = (double?) this.Invoice.LossesAmount;

            if (this.Invoice.TypeID == (int) InvoiceClass.InvoiceTypeEnum.Testing)
            {
                this.rcbTestType.SelectedValue = this.Invoice.TestTypeID.ToString();
            }
        }

        #endregion

        #region + Patient Information

        #region ConfigurePatientInformation

        /// <summary>
        ///     Loads Patient Information from session to the page fields (also fills associated comboboxes)
        /// </summary>
        private void ConfigurePatientInformation()
        {
            // Fill Comboboxes
            this.FillPatientCombobox();
            this.FillAttorneyCombobox();
            this.FillPhysicianCombobox();
            // Select Values in Comboboxes
            if (this.Invoice.PatientID.HasValue)
            {
                this.rcbPatient.SelectedValue = this.Invoice.PatientID.Value.ToString();
            }
            if (this.Invoice.AttorneyID.HasValue)
            {
                this.rcbAttorney.SelectedValue = this.Invoice.AttorneyID.Value.ToString();
                SetAttorneyStatus((int)this.Invoice.AttorneyID);
            }
            if (this.Invoice.PhysicianID.HasValue)
            {
                this.rcbPhysician.SelectedValue = this.Invoice.PhysicianID.Value.ToString();
            }
            // Set the Patient Literals
            this.SetPatientLiterals();
            // Set Hidden Fields
            if (this.Invoice.InvoiceAttorneyID.HasValue)
            {
                this.txtInvoiceAttorneyID.Text = this.Invoice.InvoiceAttorneyID.ToString();
                this.txtAttorneyID.Text = this.Invoice.AttorneyID.ToString();
            }
            if (this.Invoice.InvoicePhysicianID.HasValue)
            {
                this.txtInvoicePhysicianID.Text = this.Invoice.InvoicePhysicianID.ToString();
                this.txtPhysicianID.Text = this.Invoice.PhysicianID.ToString();
            }
        }

        #endregion

        #region FillPatientCombobox

        /// <summary>
        ///     Fills the Patient combobox with all active patients. If there is an InvoicePatient, the associated Patient'p info is replaced with the InvoicePatient'p info.
        /// </summary>
        private void FillPatientCombobox()
        {
            // get all active patients
            List<Patient> patients = PatientClass.GetPatientsByCompanyID(this.CurrentUser.CompanyID, false);

            InvoicePatient invoicePatient = this.Invoice.InvoicePatient;
            // if there we have an invoice patient, overwrite the matching patient'p name with the invoice patient'p name
            if (invoicePatient != null)
            {
                int patientID = invoicePatient.PatientID;
                Patient patient = (from p in patients
                                   where p.ID == patientID
                                   select p).FirstOrDefault();
                if (patient != null)
                {
                    patient.FirstName = invoicePatient.FirstName;
                    patient.LastName = invoicePatient.LastName;
                    patient.SSN = invoicePatient.SSN;
                }
            }

            this.rcbPatient.Items.Clear();

            // add an empty item
            this.rcbPatient.Items.Add(new Telerik.Web.UI.RadComboBoxItem());

            // add each patient to the combobox
            foreach (Telerik.Web.UI.RadComboBoxItem item in (from p in patients
                                                             orderby p.LastName , p.FirstName
                                                             select
                                                                 new Telerik.Web.UI.RadComboBoxItem(
                                                                 p.LastName + ", " + p.FirstName
                                                                 +
                                                                 (String.IsNullOrEmpty(p.SSN)
                                                                      ? String.Empty
                                                                      : " - " + p.SSN.Substring(p.SSN.Length - 4)), p.ID.ToString())))
            {
                this.rcbPatient.Items.Add(item);
            }
        }

        #endregion

        #region FillAttorneyCombobox

        /// <summary>
        ///     Fills the Attorney combobox with all active attorneys. If there is an InvoiceAttorney, the associated Attorney'p info is replaced with the InvoiceAttorney'p info.
        /// </summary>
        private void FillAttorneyCombobox()
        {
            // get all active attorneys
            List<Attorney> attorneys = AttorneyClass.GetAttorneysByCompanyID(this.CurrentUser.CompanyID, true, false);

            this.rcbAttorney.Items.Clear();

            // add an empty item
            this.rcbAttorney.Items.Add(new Telerik.Web.UI.RadComboBoxItem());

            // add each attorney to the combobox
            foreach (Telerik.Web.UI.RadComboBoxItem item in (from a in attorneys
                                                             orderby a.LastName , a.FirstName
                                                             select
                                                                 new Telerik.Web.UI.RadComboBoxItem(
                                                                 a.LastName + ", " + a.FirstName
                                                                 + (a.Firm == null ? String.Empty : " (" + a.Firm.Name + ")"), a.ID.ToString())))
            {
                this.rcbAttorney.Items.Add(item);
            }
        }

        #endregion

        #region FillPhysicianCombobox

        /// <summary>
        ///     Fills the Physician combobox with all active physicians. If there is an InvoicePhysician, the associated Physician'p info is replaced with the InvoicePhysician'p info.
        /// </summary>
        private void FillPhysicianCombobox()
        {
            // get all active physicians
            List<Physician> physicians = PhysicianClass.GetPhysiciansByCompanyID(this.CurrentUser.CompanyID, false);

            InvoicePhysician invoicePhysician = this.Invoice.InvoicePhysician;
            // if there we have an invoice physician, overwrite the matching physician'p name with the invoice physician'p name
            if (invoicePhysician != null)
            {
                int physicianID = invoicePhysician.PhysicianID;
                Physician physician = (from p in physicians
                                       where p.ID == physicianID
                                       select p).FirstOrDefault();
                if (physician != null)
                {
                    physician.FirstName = invoicePhysician.FirstName;
                    physician.LastName = invoicePhysician.LastName;
                }
            }

            this.rcbPhysician.Items.Clear();

            // add an empty item
            this.rcbPhysician.Items.Add(new Telerik.Web.UI.RadComboBoxItem());

            // add each physician to the combobox
            foreach (Telerik.Web.UI.RadComboBoxItem item in (from p in physicians
                                                             orderby p.LastName , p.FirstName
                                                             select
                                                                 new Telerik.Web.UI.RadComboBoxItem(p.LastName + ", " + p.FirstName, p.ID.ToString()))
                )
            {
                this.rcbPhysician.Items.Add(item);
            }
        }

        #endregion

        #region SetPatientLiterals

        /// <summary>
        ///     Sets the literals on the page for currently selected patient (InvoicePatient data is given priority over Patient data)
        /// </summary>
        protected void SetPatientLiterals()
        {
            string ssn = this.Invoice.GetPatientSSN(true);
            string phone = this.Invoice.GetPatientPhone();
            string workphone = this.Invoice.GetPatientWorkPhone();
            string street1 = this.Invoice.GetPatientStreet1();
            string street2 = this.Invoice.GetPatientStreet2();
            string city = this.Invoice.GetPatientCity();
            string state = this.Invoice.GetPatientState();
            string zipcode = this.Invoice.GetPatientZipCode();
            string dateofbirth = this.Invoice.GetPatientDateOfBirth();

            this.litPatientSSN.Text = String.IsNullOrWhiteSpace(ssn) ? "N/A" : ssn;
            this.litPatientPhone.Text = String.IsNullOrWhiteSpace(phone) ? "N/A" : phone;
            this.litPatientWorkPhone.Text = String.IsNullOrWhiteSpace(workphone) ? "N/A" : workphone;
            this.litPatientAddress.Text = String.IsNullOrWhiteSpace(street1 + street2 + zipcode)
                                              ? "N/A"
                                              : street1 + "<br/>" + (String.IsNullOrWhiteSpace(street2) ? String.Empty : street2 + "<br/>") + city
                                                + ", " + state + " " + zipcode;
            this.litPatientDOB.Text = String.IsNullOrWhiteSpace(dateofbirth) ? String.Empty : dateofbirth;
        }

        #endregion

        #endregion

        #region + Tests

        #region ConfigureTests

        /// <summary>
        ///     Configures the tests section (hides, shows, enables, disables, etc)
        /// </summary>
        private void ConfigureTests()
        {
            // if the invoice has an id (view/edit mode) AND the invoice type is not "testing"
            if (this.Invoice.ID.HasValue && !this.Invoice.TypeIsTesting)
            {
                // hide the entire t1 section
                this.divTests.Visible = false;
            }
            else
            {
                // show the tests if the user can view them
                this.divCanViewTests.Visible = this.CurrentInvoiceTestsPermission.AllowView;
                // show the cannot view message if the user cannot view tests
                this.divCannotViewTests.Visible = !this.CurrentInvoiceTestsPermission.AllowView;
                // enable the add button if the user can add tests
                this.btnAddNewTest.Enabled = this.CurrentInvoiceTestsPermission.AllowAdd;
                if (!this.btnAddNewTest.Enabled)
                {
                    // if the add button is disabled, add the tooltip text
                    this.btnAddNewTest.ToolTip = this.ToolTipTextCannotAddTest;
                }
            }
        }

        #endregion

        #region GetTestProviderName

        /// <summary>
        ///     Gets the name of the Provider for a Test (gives priority to the Invoice Provider if available)
        /// </summary>
        public string GetTestProviderName(TestInvoice_Test_Custom tit_c)
        {
            Provider p = ProviderClass.GetProviderByID(tit_c.ProviderID, false, false, true);
            InvoiceProvider ip = tit_c.InvoiceProviderID.HasValue
                                     ? ProviderClass.GetInvoiceProviderByID(tit_c.InvoiceProviderID.Value, false, false)
                                     : null;
            if (ip != null && ip.ProviderID == p.ID)
            {
                return ip.Name;
            }
            return p.Name;
        }

        #endregion

        #region GetTestName

        /// <summary>
        ///     Gets the nme of a Test
        /// </summary>
        public string GetTestName(TestInvoice_Test_Custom tit_c)
        {
            Test test = TestClass.GetTestByID(tit_c.TestID);
            return test == null ? "N/A" : test.Name;
        }

        #endregion

        #endregion

        #region + InvoiceSurgeries

        #region ConfigureSurgeries

        /// <summary>
        ///     Configures the Surgeries section (hides, shows, enables, disables, etc)
        /// </summary>
        private void ConfigureSurgeries()
        {
            // if the invoice has an id (view/edit mode) AND the invoice type is not "surgery"
            if (this.Invoice.ID.HasValue && !this.Invoice.TypeIsSurgery)
            {
                // hide the entire surgeries section
                this.divSurgeries.Visible = false;
            }
            else
            {
                // show the cannot view section message if the user cannot view surgeries
                this.divCannotViewSurgeries.Visible = !this.CurrentInvoiceSurgeriesPermission.AllowView;
                // show the grid and add button if the user can view surgeries
                this.grdSurgeries.Visible = this.CurrentInvoiceSurgeriesPermission.AllowView;
                this.btnAddNewSurgery.Visible = this.CurrentInvoiceSurgeriesPermission.AllowView;
                // enable the add button if the page isn'test in view mode and the user can add surgeries
                this.btnAddNewSurgery.Enabled = !this.IsViewMode && this.CurrentInvoiceSurgeriesPermission.AllowAdd;
                if (!this.btnAddNewSurgery.Enabled)
                {
                    // if the add button is disabled add a tooltip
                    this.btnAddNewSurgery.ToolTip = this.ToolTipTextCannotAddSurgery;
                }
            }
        }

        #endregion

        #region GetSurgeryName

        /// <summary>
        ///     Gets the name of a surgery
        /// </summary>
        public string GetSurgeryName(SurgeryInvoice_Surgery_Custom sis_c)
        {
            Surgery surgery = SurgeryClass.GetSurgeryByID(sis_c.SurgeryID);
            return surgery == null ? "N/A" : surgery.Name;
        }

        #endregion

        #region GetSurgeryDate

        /// <summary>
        ///     Gets the date of a surgery
        /// </summary>
        public string GetSurgeryDate(SurgeryInvoice_Surgery_Custom surgery)
        {
            // the primary date is always the first in the list
            DateTime scheduledDate = (from sd in surgery.SurgeryDates
                                      select sd).FirstOrDefault();
            // return the date if found
            return scheduledDate == null ? "N/A" : scheduledDate.ToString("MM/dd/yyyy");
        }

        #endregion

        #endregion

        #region + InvoiceProviders

        #region ConfigureProviders

        /// <summary>
        ///     Configures the Providers section (hides, shows, enables, disables, etc)
        /// </summary>
        private void ConfigureProviders()
        {
            // if the invoice has an id (view/edit mode) AND the invoice type is not "surgery"
            if (this.Invoice.ID.HasValue && !this.Invoice.TypeIsSurgery)
            {
                // hide the entire providers section
                this.divProviders.Visible = false;
            }
            else
            {
                // show the cannot view section message if the user cannot view procedures
                this.divCannotViewProviders.Visible = !this.CurrentInvoiceProvidersPermission.AllowView;
                // show the grid and add button if the user can view procedures
                this.grdProviders.Visible = this.CurrentInvoiceProvidersPermission.AllowView;
                this.btnAddNewProvider.Visible = this.CurrentInvoiceProvidersPermission.AllowView;
                // enable the add button if the page isn'test in view mode and the user can add procedures
                this.btnAddNewProvider.Enabled = !this.IsViewMode && this.CurrentInvoiceProvidersPermission.AllowAdd;
                // if the add button is disabled
                if (!this.btnAddNewProvider.Enabled)
                {
                    // add the tooltip to the button
                    this.btnAddNewProvider.ToolTip = this.ToolTipTextCannotAddProvider;
                }
            }
        }

        #endregion

        #region GetProviderName

        private List<InvoiceProvider> _InvoiceProviders;
        private List<Provider> _Providers;

        /// <summary>
        ///     Gets the name of a Provider (gives priority to InvoiceProviders)
        /// </summary>
        public string GetProviderName(SurgeryInvoice_Provider_Custom sip_c)
        {
            Provider p = null;
            // if the provider list hasn't been instantiated
            if (this._Providers == null)
            {
                // instantiate it
                this._Providers = new List<Provider>();
            }
                // if it has been instantiated
            else
            {
                // look for the provider in the list
                p = (from x in this._Providers
                     where x.ID == sip_c.ProviderID
                     select x).FirstOrDefault();
            }
            // if the provider was not found in the list in memory
            if (p == null)
            {
                // get the provider from the db
                p = ProviderClass.GetProviderByID(sip_c.ProviderID, false, false, true);
                // add the provider to the list
                this._Providers.Add(p);
            }

            InvoiceProvider ip = null;
            // if the provider has an invoice provider id
            if (sip_c.InvoiceProviderID.HasValue)
            {
                // if the invoice provider list hasn't been instantiated
                if (this._InvoiceProviders == null)
                {
                    // instantiate it
                    this._InvoiceProviders = new List<InvoiceProvider>();
                }
                    // if it has been instantiated
                else
                {
                    // look for the invoice provider in the list
                    ip = (from x in this._InvoiceProviders
                          where x.ID == sip_c.InvoiceProviderID
                          select x).FirstOrDefault();
                }
                // if the invoice provider was not found in the list in memory
                if (ip == null)
                {
                    // get the invoice provider from the db
                    ip = ProviderClass.GetInvoiceProviderByID(sip_c.InvoiceProviderID.Value, false, false);
                    // add the invoice provider to the list
                    this._InvoiceProviders.Add(ip);

                    // if the invoice provider matches the provider
                    if (ip.ProviderID == p.ID)
                    {
                        // return the invoice provider name
                        return ip.Name;
                    }
                }
            }

            // return the provider name
            return p.Name;
        }

        #endregion

        #region GetProviderTotalEstimatedCost

        /// <summary>
        ///     Gets the total estimated cost of services
        /// </summary>
        public string GetProviderTotalEstimatedCost(SurgeryInvoice_Provider_Custom provider)
        {
            IEnumerable<SurgeryInvoice_Provider_Service_Custom> services = provider.ProviderServices.Where(s => s.Active && s.EstimatedCost.HasValue);
            return services.Count() == 0 ? "&nbsp;" : services.Sum(s => s.EstimatedCost.Value).ToString("c");
        }

        #endregion

        #region GetProviderTotalCost

        /// <summary>
        ///     Gets the total cost of services
        /// </summary>
        public string GetProviderTotalCost(SurgeryInvoice_Provider_Custom provider)
        {
            IEnumerable<SurgeryInvoice_Provider_Service_Custom> services = provider.ProviderServices.Where(s => s.Active);
            return services.Count() == 0 ? "&nbsp;" : services.Sum(s => s.Cost).ToString("c");
        }

        #endregion

        #region GetProviderTotalPPODiscount

        /// <summary>
        ///     Gets the total PPO Discount of services
        /// </summary>
        public string GetProviderTotalPPODiscount(SurgeryInvoice_Provider_Custom provider)
        {
            IEnumerable<SurgeryInvoice_Provider_Service_Custom> services = provider.ProviderServices.Where(s => s.Active);
            return services.Count() == 0 ? "&nbsp;" : services.Sum(s => s.PPODiscount).ToString("c");
        }

        #endregion

        #region GetProviderTotalAmountDue

        /// <summary>
        ///     Gets the total amount due for services
        /// </summary>
        public string GetProviderTotalAmountDue(SurgeryInvoice_Provider_Custom provider)
        {
            IEnumerable<SurgeryInvoice_Provider_Service_Custom> services = provider.ProviderServices.Where(s => s.Active);
            return services.Count() == 0 ? "&nbsp;" : services.Sum(s => s.AmountDue).ToString("c");
        }

        #endregion

        #endregion

        #region + Payment Imformation

        #region ConfigurePaymentInformation

        /// <summary>
        ///     Configures the Payment Information section (hides, shows, enables, disables, etc)
        /// </summary>
        protected void ConfigurePaymentInformation()
        {
            this.rdpDatePaid.MaxDate = DateTime.Today;
            this.rdpPaymentDate.MaxDate = DateTime.Today;
            // reset the add/edit payment form section
            this.ResetAddEditPayment();
            // reset the add/edit payment comment form section
            this.ResetAddEditPaymentComment();
            // load the payment types into the combobox
            this.rcbPaymentType.Items.Add(new Telerik.Web.UI.RadComboBoxItem("", ""));
            this.LoadComboBoxItems(this.rcbPaymentType, typeof (InvoiceClass.PaymentTypeEnum));
            this.rcbPaymentType.Items.Add(new Telerik.Web.UI.RadComboBoxItem("Collection Fee Principal", "6"));
            this.rcbPaymentType.Items.Add(new Telerik.Web.UI.RadComboBoxItem("Collection Fee Interest", "7"));
            // show the attorneyPayments section if the user has view access to attorneyPayments
            this.divCannotViewPayments.Visible = !this.CurrentInvoicePaymentInformationPermission.AllowView;
            // show the cannot view message if the user does not have view access to attorneyPayments
            this.divCanViewPayments.Visible = this.CurrentInvoicePaymentInformationPermission.AllowView;
        }

        #endregion

        #region ResetAddEditPayment

        /// <summary>
        ///     Resets the add/edit payment form
        /// </summary>
        private void ResetAddEditPayment()
        {
            // show the table if the page is not in view mode and the user has payment add permissions
            this.tblAddEditPayment.Visible = !this.IsViewMode && this.CurrentInvoicePaymentInformationPermission.AllowAdd;
            // empty the form fields
            this.rdpPaymentDate.SelectedDate = null;
            this.txtPaymentAmount.Value = null;
            this.txtPaymentCheckNumber.Text = String.Empty;
            this.rcbPaymentType.SelectedValue = String.Empty;
            this.rcbPaymentType.Text = string.Empty;
            // configure the buttons to add
            this.btnPaymentAdd.Visible = true;
            this.btnPaymentSave.Visible = false;
            this.btnPaymentCancel.Visible = false;
            // clear the hidden field value
            this.txtPaymentID.Text = String.Empty;
        }

        #endregion

        #region GetPaymentAmountText

        /// <summary>
        ///     Gets the Payment amount (as a javascript link if the user has edit permissions)
        /// </summary>
        public string GetPaymentAmountText(Payment payment)
        {
            // get the payment amount as currency formatted string
            string text = payment.Amount.ToString("C");
            // if the page is not in view mode and the user has payment edit permissions
            if (!this.IsViewMode && this.CurrentInvoicePaymentInformationPermission.AllowEdit)
            {
                // return the text wrapped in a javascript link
                return "<a href=\"javascript:EditPayment(" + payment.ID + ")\">" + text + "</a>";
            }
            // return the plain text
            return text;
        }

        #endregion

        #region GetPaymentType

        /// <summary>
        ///     Gets the name of the payment type
        /// </summary>
        protected string GetPaymentType(Payment payment)
        {
            // return the name of the payment type (from its enumerator)
            if (payment.PaymentTypeID == 6)
            {
                return "Collection Fee Principal";
            }
            else if (payment.PaymentTypeID == 7)
            {
                return "Collection Fee Interest";
            }
            else
            {
                return Enum.GetName(typeof(InvoiceClass.PaymentTypeEnum), payment.PaymentTypeID);
            }
        }

        #endregion

        #region ResetAddEditPaymentComment

        /// <summary>
        ///     Resets the Add/Edit Payment Comments form
        /// </summary>
        private void ResetAddEditPaymentComment()
        {
            // show the comment table if the page is not in view mode and the user has add permissions
            this.tblAddEditPaymentComments.Visible = !this.IsViewMode && this.CurrentInvoicePaymentInformationPermission.AllowAdd;
            // empty the comment field
            this.txtPaymentComment.Text = String.Empty;
            // configure the buttons to add mode
            this.btnPaymentCommentAdd.Visible = true;
            this.btnPaymentCommentSave.Visible = false;
            this.btnPaymentCommentCancel.Visible = false;
            // clear the hidden field
            this.txtPaymentCommentID.Text = String.Empty;
        }

        #endregion

        #region GetPaymentCommentText

        /// <summary>
        ///     Gets the text of a payment comment (wrapped in a javascript link if the user has edit permissions)
        /// </summary>
        public string GetPaymentCommentText(Comment comment)
        {
            // get the comment as an HTML encoded string (replace line breaks with HTML tags)
            string text = this.Server.HtmlEncode(comment.Text).Replace("\n", "<br/>");
            // if the page is not in view mode and the user has edit permissions for payment info
            if (!this.IsViewMode && this.CurrentInvoicePaymentInformationPermission.AllowEdit)
            {
                // return the text wrapped in a javascript link
                return "<a href=\"javascript:EditPaymentComment(" + comment.ID + ")\">" + text + "</a>";
            }
            // return the text
            return text;
        }

        #endregion

        #endregion

        #region ConfigureSummary

        /// <summary>
        ///     Gets the Invoice Summary and loads the data into appropriate form fields where available
        /// </summary>
        private void ConfigureSummary()
        {
            this.litDateServiceFee.Text = this.Invoice.DateServiceFeeBegins.HasValue
                                              ? this.Invoice.DateServiceFeeBegins.Value.ToString("MM/dd/yyyy")
                                              : "N/A";
            this.litDateMaturity.Text = this.Invoice.MaturityDate.HasValue ? this.Invoice.MaturityDate.Value.ToString("MM/dd/yyyy") : "N/A";
            this.litDateAmortization.Text = this.Invoice.AmortizationDate.HasValue
                                                ? this.Invoice.AmortizationDate.Value.ToString("MM/dd/yyyy")
                                                : "N/A";
            this.litCostMinusDiscount.Text = (this.Invoice.TotalCost - this.Invoice.TotalPPODiscount).ToString("c");
            this.litPPODiscount.Text = this.Invoice.TotalPPODiscount.ToString("c");
            this.litCostBeforePPODiscount.Text = this.Invoice.TotalCost.ToString("c");
            this.litPrincipaDeposits.Text = this.Invoice.PrincipalAndDepositPaid.ToString("c");
            this.litDeductions.Text = this.Invoice.AdditionalDeductions.ToString("c");
            this.litBalanceDue.Text = this.Invoice.BalanceDue.ToString("c");
            this.litServiceFeeDue.Text = this.Invoice.InterestDue.ToString("c");
            this.litEndingBalance.Text = this.Invoice.EndingBalance.ToString("c");
            this.litServiceFeeReceived.Text = this.Invoice.ServiceFeeReceived.ToString("c");
            this.litCostOfGoods.Text = this.Invoice.CostOfGoodsSold.ToString("c");
            this.litRevenue.Text = this.Invoice.TotalRevenue.ToString("c");
            this.litCPTs.Text = this.Invoice.TotalCPTs.ToString("c");
            this.litInterestWaived.Text = ((double?)this.Invoice.ServiceFeeWaived ?? 0).ToString("c");
        }

        #endregion

        #region + Comments

        #region ConfigureComments

        /// <summary>
        ///     Configures the Comments section (hides, shows, enables, disables, etc)
        /// </summary>
        private void ConfigureComments()
        {
            // resets the add/edit form
            this.ResetAddEditComment();
            // shows the comments grid if the user can view it
            this.grdComments.Visible = this.CurrentInvoiceCommentsPermission.AllowView;
            // shows the cannot view message if the user does not have permissions
            this.divCannotViewComments.Visible = !this.CurrentInvoiceCommentsPermission.AllowView;
        }

        #endregion

        #region ResetAddEditComment

        /// <summary>
        ///     Resets the Add/Edit Comment section
        /// </summary>
        private void ResetAddEditComment()
        {
            // the table is visible if the page is not in view mode and the user has add permissions
            this.tblAddEditComments.Visible = !this.IsViewMode && this.CurrentInvoiceCommentsPermission.AllowAdd;
            // set the form fields to defaults
            this.txtComment.Text = String.Empty;
            this.cbxCommentNotIncludedOnReports.Checked = false;
            // configure the buttons to add mode
            this.btnCommentAdd.Visible = true;
            this.btnCommentSave.Visible = false;
            this.btnCommentCancel.Visible = false;
            // cleat the hidden field
            this.txtCommentID.Text = String.Empty;
        }

        #endregion

        #region GetUserName

        /// <summary>
        ///     Gets the name of the user associated with a comment (Format: FirstName LastName)
        /// </summary>
        public string GetUserName(Comment comment)
        {
            User user = UserClass.GetUserByID(comment.UserID, false);
            return user == null ? "N/A" : user.FirstName + " " + user.LastName;
        }

        #endregion

        #region GetCommentText

        /// <summary>
        ///     Gets the HTML-formatted text of a comment (as a javascript link if the user has edit permissions)
        /// </summary>
        public string GetCommentText(Comment comment)
        {
            // get the comment as an HTML encoded string (replace line breaks with HTML tags)
            string text = this.Server.HtmlEncode(comment.Text).Replace("\n", "<br/>");
            // if the page is not in view mode and the user has edit permissions for comments
            if (!this.IsViewMode && this.CurrentInvoiceCommentsPermission.AllowEdit)
            {
                // return the text wrapped in a javascript link
                return "<a href=\"javascript:EditComment(" + comment.ID + ")\">" + text + "</a>";
            }
            // return the text
            return text;
        }

        #endregion

        #endregion

        #region SaveInvoice

        private int SaveInvoice()
        {
            int invoiceID;
            // If the Invoice is set to Open, override its status to Overdue if it is
            if (this.Invoice.Status == InvoiceClass.InvoiceStatusEnum.Open && this.Invoice.MaturityDate.HasValue
                && this.Invoice.MaturityDate.Value < DateTime.Today && this.Invoice.EndingBalance > 0)
            {
                this.Invoice.Status = InvoiceClass.InvoiceStatusEnum.Overdue;
            }
            
                using (DataModelDataContext db = new DataModelDataContext())
                {
                    if (!this.Invoice.ID.HasValue)
                    {
                        if (!this.Invoice.CustomTerms)
                        {
                            if (this.Invoice.TypeID == 1)
                            {
                                AttorneyTerm aT = (from e in db.AttorneyTerms
                                                   where e.AttorneyID == this.Invoice.AttorneyID
                                                   && e.TermType == 1 && e.Status == "Current" && e.Active == true && e.Deleted == false
                                                   orderby e.StartDate descending
                                                   select e).FirstOrDefault();
                                if (aT != null)
                                {
                                    this.Invoice.ServiceFeeWaivedMonths = aT.ServiceFeeWaivedMonths;
                                    this.Invoice.LoanTermMonths = aT.LoanTermsMonths;
                                    this.Invoice.YearlyInterest = aT.YearlyInterest;
                                    this.Invoice.UseAttorneyTerms = 1;
                                }


                            }
                            else
                            {
                                var aT = (from e in db.AttorneyTerms
                                          where e.AttorneyID == this.Invoice.AttorneyID
                                          && e.TermType == 2 && e.Status == "Current" && e.Active == true && e.Deleted == false
                                          orderby e.StartDate descending
                                          select e).FirstOrDefault();

                                if (aT != null)
                                {
                                    this.Invoice.ServiceFeeWaivedMonths = aT.ServiceFeeWaivedMonths;
                                    this.Invoice.LoanTermMonths = aT.LoanTermsMonths;
                                    this.Invoice.YearlyInterest = aT.YearlyInterest;
                                    this.Invoice.UseAttorneyTerms = 1;
                                }

                            }
                        }
                    }
                }
            
 
            // if the invoice already has an id
            if (this.Invoice.ID.HasValue)
            {               
                invoiceID = this.Invoice.ID.Value;
                // update it
                InvoiceClass.UpdateInvoice(this.CurrentUser.ID, this.Invoice.ID.Value, this.Invoice.StatusID, this.Invoice.IsComplete,
                                           this.Invoice.DateOfAccident, this.Invoice.TestTypeID, this.Invoice.PatientID.Value,
                                           this.Invoice.AttorneyID.Value, this.Invoice.PhysicianID, this.Invoice.Tests, this.Invoice.Providers,
                                           this.Invoice.Surgeries, this.Invoice.Payments, this.Invoice.PaymentComments, this.Invoice.GeneralComments,
                                           this.Invoice.ClosedDate, this.Invoice.DatePaid, this.Invoice.ServiceFeeWaived, this.Invoice.LossesAmount,
                                           this.Invoice.YearlyInterest, this.Invoice.LoanTermMonths, this.Invoice.ServiceFeeWaivedMonths, this.Invoice.UseAttorneyTerms);
            }
            else
            {
                // create it
                invoiceID = InvoiceClass.CreateInvoice(this.CurrentUser.ID, this.CurrentUser.CompanyID, this.Invoice.TypeID, this.Invoice.StatusID,
                                                       this.Invoice.IsComplete, this.Invoice.DateOfAccident, this.Invoice.TestTypeID,
                                                       this.Invoice.PatientID.Value, this.Invoice.AttorneyID.Value, this.Invoice.PhysicianID,
                                                       this.Invoice.Tests, this.Invoice.Providers, this.Invoice.Surgeries, this.Invoice.Payments,
                                                       this.Invoice.PaymentComments, this.Invoice.GeneralComments, this.Invoice.ClosedDate,
                                                       this.Invoice.DatePaid, this.Invoice.ServiceFeeWaived, this.Invoice.LossesAmount,
                                                       this.Invoice.YearlyInterest, this.Invoice.LoanTermMonths, this.Invoice.ServiceFeeWaivedMonths, this.Invoice.UseAttorneyTerms);
            }           
            return invoiceID;
        }

        #endregion

        #region CheckSaveWindow
        /// <summary>
        ///  Check to see if the save window is to be opened
        /// </summary>
        private void CheckSaveWindow()
        {
            if (Request.UrlReferrer != null)
            {
                string s = Request.UrlReferrer.Segments.Last();
                string pageName = s.Substring(0, s.LastIndexOf("."));

                switch (pageName)
                {
                    case "AddEditTest":
                    case "AddEditSurgery":
                    case "AddEditSurgeryProvider":                   
                        string openWindowScript = "<script language='javascript'>function f(){SaveInvoicePopup(); Sys.Application.remove_load(f);}; Sys.Application.add_load(f);</script>";
                        Page.ClientScript.RegisterStartupScript(this.GetType(), "SaveInvoicePopup", openWindowScript);                    
                        break;
                }
            }
        }
        #endregion

        #endregion
    }
}
