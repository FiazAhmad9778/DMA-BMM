using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.XPath;
using System.Xml.Xsl;
using ASPPDFLib;
using BMM.Classes;
using BMM_BAL;
using BMM_DAL;
using iTextSharp.text;
using iTextSharp.text.pdf;
using Microsoft.Reporting.WebForms;
using Telerik.Web.UI;

namespace BMM
{
    public partial class InvoiceSearch : Classes.BasePage
    {        
        public Classes.TemporaryInvoice Invoice;
        //private List<Invoice> Invoices;
        private Dictionary<int, decimal?> _InvoiceAmounts;
        private List<Provider> _Providers = new List<Provider>();
        private List<InvoiceProvider> _InvoiceProviders = new List<InvoiceProvider>();

        double InvoiceTotal = 0;
        double CostOfGoodsSoldTotal = 0;
        double PPODiscountTotal = 0;
        double PrincipalTotal = 0;
        double InterestTotal = 0;
        double BalanceTotal = 0;

        #region AspPdfRegKey
        public string AspPdfRegKey
        {
            get
            {
                string value = System.Configuration.ConfigurationManager.AppSettings["AspPdfRegKey"];
                if (value == null) { throw new Exception("Missing AspPdfRegKey key from web.config."); }
                return value;
            }
        }
        #endregion

        #region XMLPath
        private string _XMLPath;
        private string XMLPath
        {
            get
            {
                if (_XMLPath == null)
                {

                    _XMLPath = System.Configuration.ConfigurationManager.AppSettings["XMLPath"];
                    if (_XMLPath == null)
                    {
                        throw new Exception("Missing XMLPath key from web.config.");
                    }
                }
                return _XMLPath;
            }
        }
        #endregion

        #region + Properties

        #region RequiredPermission
        public override UserClass.PermissionsEnum? RequiredPermission
        {
            get
            {
                return UserClass.PermissionsEnum.Invoices;
            }
        }
        #endregion

        #region SelectedNavigationTab
        public override NavigationTabEnum SelectedNavigationTab
        {
            get { return NavigationTabEnum.Invoices; }
        }
        #endregion

        #region SelectedPatient
        private Patient _SelectedPatient;
        protected Patient SelectedPatient
        {
            get
            {
                if (_SelectedPatient == null && ViewState["SelectedPatientID"] != null)
                {
                    _SelectedPatient = PatientClass.GetPatientByID((int)ViewState["SelectedPatientID"], false, true);
                }
                return _SelectedPatient;
            }
            set
            {
                _SelectedPatient = value;
                if (value == null) { ViewState["SelectedPatientID"] = null; }
                else { ViewState["SelectedPatientID"] = value.ID; }
            }
        }
        #endregion

        #region CurrentInvoicesPermission
        /// <summary>
        /// Gets the permissions for the user to see if they can add/edit/delete invoices
        /// </summary>
        private UserPermission _CurrentInvoicesPermission;
        public UserPermission CurrentInvoicesPermission
        {
            get
            {
                if (_CurrentInvoicesPermission == null)
                {
                    _CurrentInvoicesPermission = (from p in CurrentUser.UserPermissions
                                                  where p.PermissionID == (int)UserClass.PermissionsEnum.Invoices
                                                  && p.Active
                                                  select p).FirstOrDefault();
                    // if there was no permission found, spoof a UserPermission object with all permission set to false
                    if (_CurrentInvoicesPermission == null)
                    {
                        _CurrentInvoicesPermission = new UserPermission()
                        {
                            ID = -1,
                            UserID = CurrentUser.ID,
                            PermissionID = (int)UserClass.PermissionsEnum.Invoices,
                            AllowView = false,
                            AllowEdit = false,
                            AllowAdd = false,
                            AllowDelete = false,
                            DateAdded = DateTime.Now,
                            Active = true
                        };
                    }
                }

                return _CurrentInvoicesPermission;
            }
        }
        #endregion

        #endregion

        #region + Events

        #region Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {
            Title = Company.Name + " - Invoice Search";

            if (!IsPostBack)
            {
                rdpDateOfAccident.DateInput.Attributes.Add("autocomplete", "off");
                rdpDateOfService.DateInput.Attributes.Add("autocomplete", "off");
                LoadComboBoxItems(rcbStatus, typeof(InvoiceClass.InvoiceStatusEnum));
                rcbStatus.Items.Insert(0, new Telerik.Web.UI.RadComboBoxItem("All", "-2"));
                rcbStatus.Items.Add(new Telerik.Web.UI.RadComboBoxItem("Complete", "-1"));

                if (!CurrentInvoicesPermission.AllowAdd)
                {
                    btnAddNewInvoice.Enabled = false;
                    btnAddNewInvoice.ToolTip = ToolTipTextCannotAddInvoice;
                }
            }
        }
        #endregion

        #region rcbSSN_ItemsRequested
        protected void rcbSSN_ItemsRequested(object sender, Telerik.Web.UI.RadComboBoxItemsRequestedEventArgs e)
        {
            string text = e.Text.Trim();
            if (text.Length > 2)
            {
                foreach (var item in (from p in PatientClass.GetPatientsBySSNSearch(text, CurrentUser.CompanyID)
                                      where !String.IsNullOrEmpty(p.SSN)
                                      select new Telerik.Web.UI.RadComboBoxItem(p.SSN.Substring(0, 3) + "-" + p.SSN.Substring(3, 2) + "-" + p.SSN.Substring(5, 4), p.ID.ToString())))
                {
                    rcbSSN.Items.Add(item);
                }
            }
        }
        #endregion

        #region rcbName_ItemsRequested
        protected void rcbName_ItemsRequested(object sender, Telerik.Web.UI.RadComboBoxItemsRequestedEventArgs e)
        {
            string text = e.Text.ToLower().Trim();
            if (text.Length > 2)
            {

                foreach (var item in (from p in PatientClass.GetPatientsByNameSearch(text, CurrentUser.CompanyID)
                                      select new Telerik.Web.UI.RadComboBoxItem(p.LastName + ", " + p.FirstName + (String.IsNullOrEmpty(p.SSN) ? String.Empty : " - " + p.SSN.Substring(p.SSN.Length - 4)), p.ID.ToString())))
                {
                    rcbName.Items.Add(item);
                }
            }
        }
        #endregion

        #region btnSearch_Click
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            ClearResults();
            // count fields
            int fieldCount = 0;
            if (!String.IsNullOrWhiteSpace(rcbSSN.Text)) fieldCount++;
            if (!String.IsNullOrWhiteSpace(rcbName.Text)) fieldCount++;
            if (!String.IsNullOrWhiteSpace(txtInvoiceNumber.Text)) fieldCount++;
            if (rdpDateOfBirth.SelectedDate.HasValue) fieldCount++;
            if (rdpDateOfAccident.SelectedDate.HasValue) fieldCount++;
            if (rdpDateOfService.SelectedDate.HasValue) fieldCount++;
            // if no fields are used
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
            else if (!String.IsNullOrWhiteSpace(rcbSSN.Text))
            {
                // search by ssn
                Patient patient = String.IsNullOrWhiteSpace(rcbSSN.SelectedValue) ? null : PatientClass.GetPatientByID(int.Parse(rcbSSN.SelectedValue), false, true);
                if (patient == null)
                {
                    litError.Text = "SSN entered does not exist. Please try search again.";
                }
                else
                {
                    ShowResults(patient);
                }
            }
            else if (!String.IsNullOrWhiteSpace(rcbName.Text))
            {
                Patient patient = String.IsNullOrWhiteSpace(rcbName.SelectedValue) ? null : PatientClass.GetPatientByID(int.Parse(rcbName.SelectedValue), false, true);
                if (patient == null)
                {
                    litError.Text = "Patient name entered does not exist. Please try search again.";
                }
                else
                {
                    ShowResults(patient);
                }
            }
            else if (!String.IsNullOrWhiteSpace(txtInvoiceNumber.Text))
            {
                Patient patient = PatientClass.GetPatientByInvoiceNumber(int.Parse(txtInvoiceNumber.Text), Company.ID, true);
                if (patient == null)
                {
                    litError.Text = "Invoice number entered does not exist. Please try search again.";
                }
                else
                {
                    ShowResults(patient);
                }
            }
            else if (rdpDateOfAccident.SelectedDate.HasValue)
            {
                List<Patient> patients = PatientClass.GetPatientsByInvoiceDateOfAccident(rdpDateOfAccident.SelectedDate.Value, Company.ID, true);
                if (patients.Count == 0)
                {
                    litError.Text = "Accidents on date entered do not exist. Please try search again.";
                }
                else if (patients.Count == 1)
                {
                    ShowResults(patients[0]);
                }
                else
                {
                    ShowResults(patients);
                }
            }
            else if (rdpDateOfBirth.SelectedDate.HasValue)
            {
                List<Patient> patients = PatientClass.GetPatientsByDateOfBirth(rdpDateOfBirth.SelectedDate.Value, Company.ID, true);

                if (patients.Count == 0)
                {
                    litError.Text = "No patients found with the specified date of birth. Please try search again.";
                }
                else if (patients.Count == 1)
                {
                    ShowResults(patients[0]);
                }
                else
                {
                    ShowResults_DOB(patients);
                }
            }
            else if (rdpDateOfService.SelectedDate.HasValue)
            {
                List<Patient> patients = PatientClass.GetPatientsByFirstServiceDate(rdpDateOfService.SelectedDate.Value, Company.ID, true);
                if (patients.Count == 0)
                {
                    litError.Text = "Services on date entered do not exist. Please try search again.";
                }
                else if (patients.Count == 1)
                {
                    ShowResults(patients[0]);
                }
                else
                {
                    ShowResults_Service(patients);
                }
            }
        }
        #endregion

        #region btnAddNewInvoice_Click
        protected void btnAddNewInvoice_Click(object sender, EventArgs e)
        {
            Response.Redirect("/AddEditInvoice.aspx?pid=" + SelectedPatient.ID);
        }
        #endregion

        #region rptPatients_ItemCommand
        protected void rptPatients_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            Patient patient = PatientClass.GetPatientByID(int.Parse(e.CommandArgument.ToString()), false, true);
            if (patient != null)
            {
                ClearResults();
                ShowResults(patient);
            }
        }
        #endregion

        #region rcbStatus_SelectedIndexChanged
        protected void rcbStatus_SelectedIndexChanged(object sender, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs eventArgs)
        {
            grdInvoices.CurrentPageIndex = 0;
            grdInvoices.Rebind();
        }
        #endregion

        #region grdInvoices_OnNeedDataSource
        protected void grdInvoices_OnNeedDataSource(object source, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            Patient patient = SelectedPatient;
            if (patient != null)
            {
                List<Invoice> invoices;
                int status = int.Parse(rcbStatus.SelectedValue);
                if (status == -2)
                {
                    invoices = (from i in InvoiceClass.SearchInvoices_ByPatientID(patient.ID, true)
                                where i.Active
                                select i).ToList();
                }
                else if (status == -1)
                {
                    invoices = (from i in InvoiceClass.SearchInvoices_ByPatientID(patient.ID, true)
                                where i.InvoiceStatusTypeID == (int)InvoiceClass.InvoiceStatusEnum.Open
                                  && i.isComplete
                                  && i.Active
                                select i).ToList();
                }
                else
                {
                    invoices = (from i in InvoiceClass.SearchInvoices_ByPatientID(patient.ID, true)
                                where i.InvoiceStatusTypeID == status
                                  && i.Active
                                select i).ToList();
                }

                grdInvoices.DataSource = invoices;
                Utility.Invoices = invoices;

                //litInvoicesSubTotal.Text = (from i in invoices
                //                            select GetInvoiceAmount(i.ID) ?? 0m).Sum().ToString("c");

                //tblInvoicesSubTotal.Visible = invoices.Count > 0;
            }
        }
        #endregion

        #endregion

        #region + Helpers

        #region ClearResults
        private void ClearResults()
        {
            litError.Text = "";
            divPatientsList.Visible = false;
            divPatient.Visible = false;
        }
        #endregion

        #region ShowResults(List<Patient>)
        private void ShowResults(List<Patient> patients)
        {
            divPatientsList.Visible = true;
            litMultiplePatientsWithAccidentDate.Text = "The following patients have a Date of Accident of " + rdpDateOfAccident.SelectedDate.Value.ToShortDateString();
            rptPatients.DataSource = (from p in patients
                                      orderby p.LastName ascending, p.FirstName ascending, p.SSN ascending
                                      select new { DisplayName = p.LastName + ", " + p.FirstName + (String.IsNullOrEmpty(p.SSN) ? String.Empty : " - " + p.SSN.Substring(p.SSN.Length - 4)), ID = p.ID });
            rptPatients.DataBind();
        }
        #endregion

        #region ShowResults_Service(List<Patient>)
        private void ShowResults_Service(List<Patient> patients)
        {
            divPatientsList.Visible = true;
            litMultiplePatientsWithAccidentDate.Text = "The following patients have a Date of Service of " + rdpDateOfService.SelectedDate.Value.ToShortDateString();
            rptPatients.DataSource = (from p in patients
                                      orderby p.LastName ascending, p.FirstName ascending, p.SSN ascending
                                      select new { DisplayName = p.LastName + ", " + p.FirstName + (String.IsNullOrEmpty(p.SSN) ? String.Empty : " - " + p.SSN.Substring(p.SSN.Length - 4)), ID = p.ID });
            rptPatients.DataBind();
        }
        #endregion

        #region ShowResults_DOB
        private void ShowResults_DOB(List<Patient> patients)
        {
            divPatientsList.Visible = true;
            litMultiplePatientsWithAccidentDate.Text = "The following patients have a Date of Birth of " + rdpDateOfBirth.SelectedDate.Value.ToShortDateString();
            rptPatients.DataSource = (from p in patients
                                      orderby p.LastName ascending, p.FirstName ascending, p.SSN ascending
                                      select new { DisplayName = p.LastName + ", " + p.FirstName + (String.IsNullOrEmpty(p.SSN) ? String.Empty : " - " + p.SSN.Substring(p.SSN.Length - 4)), ID = p.ID });
            rptPatients.DataBind();
        }
        #endregion

        #region ShowResults(Patient)
        private void ShowResults(Patient patient)
        {
            divPatient.Visible = true;
            txtPatientId.Text = patient.ID.ToString();
            litPatientName.Text = patient.FirstName + " " + patient.LastName;
            litSSN.Text = String.IsNullOrEmpty(patient.SSN) ? "N/A" : Classes.Utility.FormatSSN(patient.SSN);
            litPhone.Text = patient.Phone;
            litAddress.Text = patient.Street1 + "<br/>" + (String.IsNullOrWhiteSpace(patient.Street2) ? String.Empty : patient.Street2 + "<br/>") + patient.City + ", " + patient.State.Abbreviation + " " + patient.ZipCode;
            litWorkPhone.Text = String.IsNullOrEmpty(patient.WorkPhone) ? "N/A" : patient.WorkPhone;
            litDateOfBirth.Text = patient.DateOfBirth.ToShortDateString();

            SelectedPatient = patient;

            rcbStatus.SelectedIndex = 0;
            grdInvoices.CurrentPageIndex = 0;
            grdInvoices.Rebind();
        }
        #endregion

        #region GetInvoiceType
        public string GetInvoiceType(Invoice invoice)
        {
            int[] values = (int[])Enum.GetValues(typeof(InvoiceClass.InvoiceTypeEnum));
            string[] names = Enum.GetNames(typeof(InvoiceClass.InvoiceTypeEnum));
            for (int i = 0; i < values.Length; i++)
            {
                if (values[i] == invoice.InvoiceTypeID)
                {
                    return names[i];
                }
            }
            return "N/A";
        }
        #endregion

        #region GetInvoiceStatus
        public string GetInvoiceStatus(Invoice invoice)
        {
            if (invoice.InvoiceStatusTypeID == (int)InvoiceClass.InvoiceStatusEnum.Open && invoice.isComplete)
            {
                return "Complete";
            }

            int[] values = (int[])Enum.GetValues(typeof(InvoiceClass.InvoiceStatusEnum));
            string[] names = Enum.GetNames(typeof(InvoiceClass.InvoiceStatusEnum));
            for (int i = 0; i < values.Length; i++)
            {
                if (values[i] == invoice.InvoiceStatusTypeID)
                {
                    return names[i];
                }
            }
            return "N/A";
        }
        #endregion

        #region GetInvoiceCancelled
        public Boolean GetInvoiceCancelled(Invoice invoice)
        {
            return InvoiceClass.GetInvoiceCancelled(invoice.ID);

        }
        #endregion

        #region GetFirstServiceDate
        public string GetFirstServiceDate(Invoice invoice)
        {
            return InvoiceClass.GetFirstServiceDate(invoice.ID);
        }
        #endregion

        #region GetInvoiceAmount
        public string GetInvoiceAmount(Invoice invoice)
        {
            decimal? amount = GetInvoiceAmount(invoice.ID);
            return amount.HasValue ? amount.Value.ToString("C") : "&nbsp;";
        }
        #endregion

        #region GetCostOfGoodsSold
        public string GetCostOfGoodsSold(Invoice invoice)
        {
            decimal? amount = GetCostOfGoodsSold(invoice.ID);
            return amount.HasValue ? amount.Value.ToString("C") : "&nbsp;";
        }

        public decimal? GetCostOfGoodsSold(int invoiceID)
        {
            //if (_InvoiceAmounts == null) _InvoiceAmounts = new Dictionary<int, decimal?>();
            //if (_InvoiceAmounts.ContainsKey(invoiceID))
            //{
            //    return _InvoiceAmounts[invoiceID];
            //}
            //else
            //{
            decimal? amount = InvoiceClass.GetCostOfGoodsSold(invoiceID);
            //    _InvoiceAmounts.Add(invoiceID, amount);
            return amount;
            //}
        }
        #endregion

        #region GetInvoiceBillAmount
        public string GetInvoiceBillAmount(Invoice invoice)
        {
            decimal? amount = InvoiceClass.GetInvoiceBillAmount(invoice.ID);
            return amount.HasValue ? amount.Value.ToString("C") : "&nbsp;";
        }
        #endregion

        #region GetInvoiceBillAmount
        public decimal? GetInvoiceBillAmount(int invoiceID)
        {
            if (_InvoiceAmounts == null) _InvoiceAmounts = new Dictionary<int, decimal?>();
            if (_InvoiceAmounts.ContainsKey(invoiceID))
            {
                return _InvoiceAmounts[invoiceID];
            }
            else
            {
                decimal? amount = InvoiceClass.GetInvoiceBillAmount(invoiceID);
                _InvoiceAmounts.Add(invoiceID, amount);
                return amount;
            }
        }
        #endregion

        #region GetInvoiceAmount
        public decimal? GetInvoiceAmount(int invoiceID)
        {
            //if (_InvoiceAmounts == null) _InvoiceAmounts = new Dictionary<int, decimal?>();
            //if (_InvoiceAmounts.ContainsKey(invoiceID))
            //{
            //    return _InvoiceAmounts[invoiceID];
            //}
            //else
            //{
            decimal? amount = InvoiceClass.GetInvoiceAmount(invoiceID);
            //    _InvoiceAmounts.Add(invoiceID, amount);
            return amount;
            //}
        }
        #endregion

        #region GetPPODiscount
        public string GetPPODiscount(Invoice invoice)
        {
            decimal? amount = GetPPODiscount(invoice.ID);
            return amount.HasValue ? amount.Value.ToString("C") : "&nbsp;";
        }

        public decimal? GetPPODiscount(int invoiceID)
        {
            decimal? amount = InvoiceClass.GetPPODiscount(invoiceID);
            return amount;
        }
        #endregion

        #region GetPrincipal
        public string GetPrincipal(Invoice invoice)
        {
            decimal? invoiceAmount = GetInvoiceAmount(invoice.ID);
            decimal? ppoDiscount = GetPPODiscount(invoice.ID);            
            decimal? principalAmount = (invoiceAmount.HasValue ? invoiceAmount : 0) - (ppoDiscount.HasValue ? ppoDiscount : 0);

            return principalAmount.HasValue ? principalAmount.Value.ToString("C") : "&nbsp;";
        }
        #endregion

        #region GetCumulativeServiceFee
        public string GetCumulativeServiceFee(Invoice invoice)
        {
            decimal? amount = GetCumulativeServiceFee(invoice.ID);
            return amount.HasValue ? amount.Value.ToString("C") : "&nbsp;";
        }

        public decimal? GetCumulativeServiceFee(int invoiceID)
        {
            decimal? amount = InvoiceClass.GetCumulativeServiceFee(invoiceID);
            return amount;
        }
        #endregion

        #endregion

        protected void grdInvoices_DataBound(object sender, EventArgs e)
        {
            foreach (var dataItem in Utility.Invoices)
            {
                InvoiceTotal += double.Parse(GetInvoiceAmount(dataItem), NumberStyles.Currency);
                CostOfGoodsSoldTotal += double.Parse(GetCostOfGoodsSold(dataItem), NumberStyles.Currency);
                PPODiscountTotal += double.Parse(GetPPODiscount(dataItem), NumberStyles.Currency);
                PrincipalTotal += double.Parse(GetPrincipal(dataItem), NumberStyles.Currency);
                InterestTotal += double.Parse(GetCumulativeServiceFee(dataItem), NumberStyles.Currency);
                BalanceTotal += double.Parse(GetInvoiceBillAmount(dataItem), NumberStyles.Currency);
            }

            GridFooterItem footer = (GridFooterItem)grdInvoices.MasterTableView.GetItems(GridItemType.Footer)[0];
            (footer["InvoiceAmount"].FindControl("litInvoiceTotal") as Literal).Text = InvoiceTotal.ToString("c");
            (footer["CostOfGoodsSold"].FindControl("litCostOfGoodsSoldTotal") as Literal).Text = CostOfGoodsSoldTotal.ToString("c");
            (footer["PPODiscount"].FindControl("litPPODiscountTotal") as Literal).Text = PPODiscountTotal.ToString("c");
            (footer["Principal"].FindControl("litPrincipalTotal") as Literal).Text = PrincipalTotal.ToString("c");
            (footer["Interest"].FindControl("litInterestTotal") as Literal).Text = InterestTotal.ToString("c");
            (footer["Balance"].FindControl("litBalanceTotal") as Literal).Text = BalanceTotal.ToString("c");
        }

        protected void btnPrintWorksheet_Click(object sender, EventArgs e)
        {
            List<byte[]> worksheets = new List<byte[]>();

            grdInvoices.AllowPaging = false;
            grdInvoices.Rebind();

            foreach (GridDataItem invoice in grdInvoices.Items)
            //foreach (var invoice in Utility.Invoices)
            {
                int ID = Convert.ToInt32(invoice.GetDataKeyValue("ID"));

                Invoice = new Classes.TemporaryInvoice(this.Session, this.Company.ID, ID, this.InvoiceSessionKey);

                if (Invoice.TypeIsTesting)
                {
                    XslCompiledTransform transform = new XslCompiledTransform();
                    transform.Load(Server.MapPath(XMLPath) + "TestWorksheet.xsl");
                    MemoryStream stream = new MemoryStream();
                    string xml = SerializeToXML_Test();
                    transform.Transform(new XPathDocument(new StringReader(SerializeToXML_Test())), null, stream);

                    PdfManager pdfManager = new PdfManager();
                    pdfManager.RegKey = AspPdfRegKey;
                    IPdfDocument objDoc = pdfManager.CreateDocument();
                    stream.Position = 0;
                    string html = new StreamReader(stream).ReadToEnd();
                    objDoc.ImportFromUrl(html, "Landscape=false, LeftMargin=36, RightMargin=36, TopMargin=36, BottomMargin=36");
                    stream.Close();

                    byte[] content = (byte[])objDoc.SaveToMemory();
                    worksheets.Add(content);
                }
                else
                {
                    XslCompiledTransform transform = new XslCompiledTransform();
                    transform.Load(Server.MapPath(XMLPath) + "SurgeryWorksheet.xsl");
                    MemoryStream stream = new MemoryStream();
                    string xml = SerializeToXML_Surgery();
                    transform.Transform(new XPathDocument(new StringReader(SerializeToXML_Surgery())), null, stream);

                    PdfManager pdfManager = new PdfManager();
                    pdfManager.RegKey = AspPdfRegKey;
                    IPdfDocument objDoc = pdfManager.CreateDocument();
                    stream.Position = 0;
                    string html = new StreamReader(stream).ReadToEnd();
                    objDoc.ImportFromUrl(html, "Landscape=false, LeftMargin=36, RightMargin=36, TopMargin=36, BottomMargin=36");
                    stream.Close();

                    byte[] content = (byte[])objDoc.SaveToMemory();
                    worksheets.Add(content);
                }

                this.Invoice.Remove();
            }

            grdInvoices.AllowPaging = true;
            grdInvoices.Rebind();

            using (var ms = new MemoryStream())
            {
                using (var doc = new Document())
                {
                    using (var copy = new PdfSmartCopy(doc, ms))
                    {
                        doc.Open();

                        //Loop through each byte array
                        foreach (var p in worksheets)
                        {

                            //Create a PdfReader bound to that byte array
                            using (var reader = new PdfReader(p))
                            {

                                //Add the entire document instead of page-by-page
                                copy.AddDocument(reader);
                            }
                        }

                        doc.Close();
                    }
                }

                byte[] content = ms.ToArray();
                Page.Response.Clear();
                Page.Response.AddHeader("Content-Disposition", "attachment; filename=Worksheets.pdf");
                Page.Response.AddHeader("Content-Length", content.Length.ToString());
                Page.Response.ContentType = "application/pdf";
                Page.Response.BinaryWrite(content);
                Page.Response.End();
            }
        }

        private string SerializeToXML_Test()
        {
            System.Text.StringBuilder xml = new System.Text.StringBuilder();
            xml.Append("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
            xml.Append("<Details>");

            #region Company
            xml.Append("<CompanyName>" + Server.HtmlEncode(Company.Name) + "</CompanyName>");
            #endregion

            #region Invoice Basics
            if (Invoice.ID.HasValue) xml.Append("<InvoiceID>" + Invoice.InvoiceNumber.Value + "</InvoiceID>");
            xml.Append("<Type>" + Invoice.TypeName + "</Type>");
            xml.Append("<Status>" + Invoice.StatusName + "</Status>");
            xml.Append("<Complete>" + (Invoice.IsComplete ? "Yes" : "No") + "</Complete>");
            if (Invoice.DateOfAccident.HasValue) xml.Append("<DateOfAccident>" + Invoice.DateOfAccident.Value.ToString("MM/dd/yyyy") + "</DateOfAccident>");
            #endregion

            #region Patient
            xml.Append("<Patient>");
            {
                xml.Append("<Name>" + Server.HtmlEncode(Invoice.GetPatientFirstName() + " " + Invoice.GetPatientLastName()) + "</Name>");
                if (!String.IsNullOrWhiteSpace(Invoice.GetPatientSSN())) xml.Append("<SSN>" + Server.HtmlEncode(Invoice.GetPatientSSN(true)) + "</SSN>");
                xml.Append("<Phone>" + Server.HtmlEncode(Invoice.GetPatientPhone()) + "</Phone>");
                xml.Append("<DateOfBirth>" + Invoice.GetPatientDateOfBirth() + "</DateOfBirth>");
                xml.Append("<Street1>" + Server.HtmlEncode(Invoice.GetPatientStreet1()) + "</Street1>");
                if (!String.IsNullOrWhiteSpace(Invoice.GetPatientStreet2())) xml.Append("<Street2>" + Server.HtmlEncode(Invoice.GetPatientStreet2()) + "</Street2>");
                xml.Append("<City>" + Server.HtmlEncode(Invoice.GetPatientCity()) + "</City>");
                xml.Append("<State>" + Server.HtmlEncode(Invoice.GetPatientState()) + "</State>");
                xml.Append("<ZipCode>" + Server.HtmlEncode(Invoice.GetPatientZipCode()) + "</ZipCode>");
            }
            xml.Append("</Patient>");
            #endregion

            #region Attorney
            Attorney attorney = !Invoice.AttorneyID.HasValue ? null : AttorneyClass.GetAttorneyByID(Invoice.AttorneyID.Value, true, true, true);
            if (attorney != null)
            {
                xml.Append("<Attorney>");
                {
                    xml.Append("<Name>" + Server.HtmlEncode(attorney.FirstName + " " + attorney.LastName) + "</Name>");
                    if (attorney.Firm != null) xml.Append("<FirmName>" + Server.HtmlEncode(attorney.Firm.Name) + "</FirmName>");
                    xml.Append("<Phone>" + Server.HtmlEncode(attorney.Phone) + "</Phone>");
                    if (!String.IsNullOrWhiteSpace(attorney.Fax)) xml.Append("<Fax>" + Server.HtmlEncode(attorney.Fax) + "</Fax>");
                    xml.Append("<Street1>" + Server.HtmlEncode(attorney.Street1) + "</Street1>");
                    if (!String.IsNullOrWhiteSpace(attorney.Street2)) xml.Append("<Street2>" + Server.HtmlEncode(attorney.Street2) + "</Street2>");
                    xml.Append("<City>" + Server.HtmlEncode(attorney.City) + "</City>");
                    xml.Append("<State>" + Server.HtmlEncode(attorney.State.Abbreviation) + "</State>");
                    xml.Append("<ZipCode>" + Server.HtmlEncode(attorney.ZipCode) + "</ZipCode>");
                    xml.Append("<Contacts>");
                    foreach (var contact in attorney.ContactList.Contacts)
                    {
                        xml.Append("<Contact>");
                        xml.Append("<Name>" + Server.HtmlEncode(contact.Name) + "</Name>");
                        xml.Append("<Position>" + Server.HtmlEncode(contact.Position) + "</Position>");
                        if (!String.IsNullOrWhiteSpace(contact.Phone)) xml.Append("<Phone>" + Server.HtmlEncode(contact.Phone) + "</Phone>");
                        xml.Append("</Contact>");
                    }
                    xml.Append("</Contacts>");
                }
                xml.Append("</Attorney>");
            }
            #endregion

            #region Physician
            InvoicePhysician invoicePhysician = !Invoice.InvoicePhysicianID.HasValue ? null : PhysicianClass.GetInvoicePhysicianByID(Invoice.InvoicePhysicianID.Value, false, true);
            if (invoicePhysician != null && invoicePhysician.PhysicianID == Invoice.PhysicianID)
            {
                xml.Append("<Physician>");
                {
                    xml.Append("<Name>" + Server.HtmlEncode(invoicePhysician.FirstName + " " + invoicePhysician.LastName) + "</Name>");
                    xml.Append("<Phone>" + Server.HtmlEncode(invoicePhysician.Phone) + "</Phone>");
                    if (!String.IsNullOrWhiteSpace(invoicePhysician.Fax)) xml.Append("<Fax>" + Server.HtmlEncode(invoicePhysician.Fax) + "</Fax>");
                    xml.Append("<Street1>" + Server.HtmlEncode(invoicePhysician.Street1) + "</Street1>");
                    if (!String.IsNullOrWhiteSpace(invoicePhysician.Street2)) xml.Append("<Street2>" + Server.HtmlEncode(invoicePhysician.Street2) + "</Street2>");
                    xml.Append("<City>" + Server.HtmlEncode(invoicePhysician.City) + "</City>");
                    xml.Append("<State>" + Server.HtmlEncode(invoicePhysician.State.Abbreviation) + "</State>");
                    xml.Append("<ZipCode>" + Server.HtmlEncode(invoicePhysician.ZipCode) + "</ZipCode>");
                }
                xml.Append("</Physician>");
            }
            else
            {
                Physician physician = !Invoice.PhysicianID.HasValue ? null : PhysicianClass.GetPhysicianByID(Invoice.PhysicianID.Value, false, true);
                if (physician != null)
                {
                    xml.Append("<Physician>");
                    {
                        xml.Append("<Name>" + Server.HtmlEncode(physician.FirstName + " " + physician.LastName) + "</Name>");
                        xml.Append("<Phone>" + Server.HtmlEncode(physician.Phone) + "</Phone>");
                        if (!String.IsNullOrWhiteSpace(physician.Fax)) xml.Append("<Fax>" + Server.HtmlEncode(physician.Fax) + "</Fax>");
                        xml.Append("<Street1>" + Server.HtmlEncode(physician.Street1) + "</Street1>");
                        if (!String.IsNullOrWhiteSpace(physician.Street2)) xml.Append("<Street2>" + Server.HtmlEncode(physician.Street2) + "</Street2>");
                        xml.Append("<City>" + Server.HtmlEncode(physician.City) + "</City>");
                        xml.Append("<State>" + Server.HtmlEncode(physician.State.Abbreviation) + "</State>");
                        xml.Append("<ZipCode>" + Server.HtmlEncode(physician.ZipCode) + "</ZipCode>");
                    }
                    xml.Append("</Physician>");
                }
            }
            #endregion

            #region Tests
            xml.Append("<Tests>");
            foreach (var test in (from test in Invoice.Tests where test.Active select test))
            {
                xml.Append("<Test>");
                {
                    InvoiceProvider invoiceProvider = !test.InvoiceProviderID.HasValue ? null : ProviderClass.GetInvoiceProviderByID(test.InvoiceProviderID.Value, false, true);
                    if (invoiceProvider != null && invoiceProvider.ProviderID == test.ProviderID)
                    {
                        xml.Append("<Provider>");
                        {
                            xml.Append("<Name>" + Server.HtmlEncode(invoiceProvider.Name) + "</Name>");
                            xml.Append("<Phone>" + Server.HtmlEncode(invoiceProvider.Phone) + "</Phone>");
                            if (!String.IsNullOrWhiteSpace(invoiceProvider.Fax)) xml.Append("<Fax>" + Server.HtmlEncode(invoiceProvider.Fax) + "</Fax>");
                            xml.Append("<Street1>" + Server.HtmlEncode(invoiceProvider.Street1) + "</Street1>");
                            if (!String.IsNullOrWhiteSpace(invoiceProvider.Street2)) xml.Append("<Street2>" + Server.HtmlEncode(invoiceProvider.Street2) + "</Street2>");
                            xml.Append("<City>" + Server.HtmlEncode(invoiceProvider.City) + "</City>");
                            xml.Append("<State>" + Server.HtmlEncode(invoiceProvider.State.Abbreviation) + "</State>");
                            xml.Append("<ZipCode>" + Server.HtmlEncode(invoiceProvider.ZipCode) + "</ZipCode>");
                        }
                        xml.Append("</Provider>");
                    }
                    else
                    {
                        Provider provider = ProviderClass.GetProviderByID(test.ProviderID, false, true);
                        if (provider != null)
                        {
                            xml.Append("<Provider>");
                            {
                                xml.Append("<Name>" + Server.HtmlEncode(provider.Name) + "</Name>");
                                xml.Append("<Phone>" + Server.HtmlEncode(provider.Phone) + "</Phone>");
                                if (!String.IsNullOrWhiteSpace(provider.Fax)) xml.Append("<Fax>" + Server.HtmlEncode(provider.Fax) + "</Fax>");
                                xml.Append("<Street1>" + Server.HtmlEncode(provider.Street1) + "</Street1>");
                                if (!String.IsNullOrWhiteSpace(provider.Street2)) xml.Append("<Street2>" + Server.HtmlEncode(provider.Street2) + "</Street2>");
                                xml.Append("<City>" + Server.HtmlEncode(provider.City) + "</City>");
                                xml.Append("<State>" + Server.HtmlEncode(provider.State.Abbreviation) + "</State>");
                                xml.Append("<ZipCode>" + Server.HtmlEncode(provider.ZipCode) + "</ZipCode>");
                            }
                            xml.Append("</Provider>");
                        }
                    }
                    var t = TestClass.GetTestByID(test.TestID);
                    if (t != null) xml.Append("<Name>" + Server.HtmlEncode(t.Name) + "</Name>");
                    if (!String.IsNullOrWhiteSpace(test.AccountNumber)) xml.Append("<AccountNumber>" + Server.HtmlEncode(test.AccountNumber) + "</AccountNumber>");
                    if (!String.IsNullOrWhiteSpace(test.Notes)) xml.Append("<Notes>" + Server.HtmlEncode(test.Notes) + "</Notes>");
                    if (test.TestDate != DateTime.MinValue) xml.Append("<TestDate>" + test.TestDate.ToString("MM/dd/yyyy") + "</TestDate>");
                    if (test.TestTime.HasValue) xml.Append("<TestTime>" + DateTime.Today.Add(test.TestTime.Value).ToString("hh:mm tt") + "</TestTime>");
                    if (test.isPositive.HasValue) xml.Append("<Result>" + (test.isPositive.Value ? "Positive" : "Negative") + "</Result>");
                    xml.Append("<Canceled>" + (test.isCancelled ? "Yes" : "No") + "</Canceled>");
                    xml.Append("<AmountDue>" + test.AmountToProvider.ToString("c") + "</AmountDue>");
                    xml.Append("<DueDate>" + test.ProviderDueDate.ToString("MM/dd/yyyy") + "</DueDate>");
                    xml.Append("<TotalCost>" + test.TestCost.ToString("c") + "</TotalCost>");
                    if (test.DepositToProvider.HasValue) xml.Append("<DepositToProvider>" + test.DepositToProvider.Value.ToString("c") + "</DepositToProvider>");
                    if (test.AmountPaidToProvider.HasValue) xml.Append("<AmountPaidToProvider>" + test.AmountPaidToProvider.Value.ToString("c") + "</AmountPaidToProvider>");
                    if (test.Date.HasValue) xml.Append("<Date>" + test.Date.Value.ToString("MM/dd/yyyy") + "</Date>");
                    if (!String.IsNullOrWhiteSpace(test.CheckNumber)) xml.Append("<CheckNo>" + Server.HtmlEncode(test.CheckNumber) + "</CheckNo>");
                }
                xml.Append("</Test>");
            }
            xml.Append("</Tests>");
            #endregion           

            #region Attorney Payments
            var payments = (from p in Invoice.Payments where p.Active orderby p.DatePaid ascending select p).ToList();
            if (payments.Count > 0)
            {
                xml.Append("<Payments>");
                foreach (var payment in payments)
                {
                    xml.Append("<Payment>");
                    {
                        xml.Append("<Date>" + payment.DatePaid.ToString("MM/dd/yyyy") + "</Date>");
                        xml.Append("<Type>" + Enum.GetName(typeof(InvoiceClass.PaymentTypeEnum), payment.PaymentTypeID) + "</Type>");
                        xml.Append("<Amount>" + payment.Amount.ToString("c") + "</Amount>");
                        xml.Append("<CheckNo>" + Server.HtmlEncode(payment.CheckNumber) + "</CheckNo>");
                    }
                    xml.Append("</Payment>");
                }
                xml.Append("</Payments>");
            }
            #endregion

            #region Summary
            xml.Append("<TotalCostMinusPPODiscounts>" + (Invoice.TotalCost - Invoice.TotalPPODiscount).ToString("c") + "</TotalCostMinusPPODiscounts>");
            xml.Append("<PrincipalAndDepositPaid>" + Invoice.PrincipalAndDepositPaid.ToString("c") + "</PrincipalAndDepositPaid>");
            xml.Append("<AdditionalDeductions>" + Invoice.AdditionalDeductions.ToString("c") + "</AdditionalDeductions>");
            xml.Append("<BalanceDue>" + Invoice.BalanceDue.ToString("c") + "</BalanceDue>");
            xml.Append("<ServiceFeeReceived>" + (Invoice.CalculatedCumulativeInterest - Invoice.ServiceFeeReceived).ToString("c") + "</ServiceFeeReceived>");
            xml.Append("<LossesAmount>" + (Invoice.LossesAmount ?? 0m).ToString("c") + "</LossesAmount>");
            xml.Append("<ServiceFeeWaived>" + (Invoice.ServiceFeeWaived ?? 0m).ToString("c") + "</ServiceFeeWaived>");
            xml.Append("<EndingBalance>" + Invoice.EndingBalance.ToString("c") + "</EndingBalance>");
            #endregion

            #region Payment Comments
            if (Invoice.PaymentComments.Count > 0)
            {
                xml.Append("<Comments>");
                foreach (var pay in Invoice.PaymentComments.OrderByDescending(a => a.DateAdded))
                {
                    User u = UserClass.GetUserByID(pay.UserID, false);
                    xml.Append("<Comment>");
                    {
                        xml.Append("<User>" + Server.HtmlEncode(u.FirstName) + " " + Server.HtmlEncode(u.LastName) + "</User>");
                        xml.Append("<Date>" + pay.DateAdded + "</Date>");
                        xml.Append("<Text>" + Server.HtmlEncode(pay.Text) + "</Text>");
                    }
                    xml.Append("</Comment>");
                }
                xml.Append("</Comments>");
            }
            #endregion

            xml.Append("</Details>");
            return xml.ToString();
        }

        private string SerializeToXML_Surgery()
        {
            System.Text.StringBuilder xml = new System.Text.StringBuilder();
            xml.Append("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
            xml.Append("<Details>");

            #region Company
            xml.Append("<CompanyName>" + Server.HtmlEncode(Company.Name) + "</CompanyName>");
            #endregion

            #region Invoice Basics
            if (Invoice.ID.HasValue) xml.Append("<InvoiceID>" + Invoice.InvoiceNumber.Value + "</InvoiceID>");
            xml.Append("<Type>" + Invoice.TypeName + "</Type>");
            xml.Append("<Status>" + Invoice.StatusName + "</Status>");
            xml.Append("<Complete>" + (Invoice.IsComplete ? "Yes" : "No") + "</Complete>");
            if (Invoice.DateOfAccident.HasValue) xml.Append("<DateOfAccident>" + Invoice.DateOfAccident.Value.ToString("MM/dd/yyyy") + "</DateOfAccident>");
            #endregion

            #region Patient
            xml.Append("<Patient>");
            {
                xml.Append("<Name>" + Server.HtmlEncode(Invoice.GetPatientFirstName() + " " + Invoice.GetPatientLastName()) + "</Name>");
                if (!String.IsNullOrWhiteSpace(Invoice.GetPatientSSN())) xml.Append("<SSN>" + Invoice.GetPatientSSN(true) + "</SSN>");
                xml.Append("<Phone>" + Server.HtmlEncode(Invoice.GetPatientPhone()) + "</Phone>");
                xml.Append("<DateOfBirth>" + Invoice.GetPatientDateOfBirth() + "</DateOfBirth>");
                xml.Append("<Street1>" + Server.HtmlEncode(Invoice.GetPatientStreet1()) + "</Street1>");
                if (!String.IsNullOrWhiteSpace(Invoice.GetPatientStreet2())) xml.Append("<Street2>" + Server.HtmlEncode(Invoice.GetPatientStreet2()) + "</Street2>");
                xml.Append("<City>" + Server.HtmlEncode(Invoice.GetPatientCity()) + "</City>");
                xml.Append("<State>" + Server.HtmlEncode(Invoice.GetPatientState()) + "</State>");
                xml.Append("<ZipCode>" + Server.HtmlEncode(Invoice.GetPatientZipCode()) + "</ZipCode>");
            }
            xml.Append("</Patient>");
            #endregion

            #region Attorney
            Attorney attorney = !Invoice.AttorneyID.HasValue ? null : AttorneyClass.GetAttorneyByID(Invoice.AttorneyID.Value, true, true, true);
            if (attorney != null)
            {
                xml.Append("<Attorney>");
                {
                    xml.Append("<Name>" + Server.HtmlEncode(attorney.FirstName + " " + attorney.LastName) + "</Name>");
                    if (attorney.Firm != null) xml.Append("<FirmName>" + Server.HtmlEncode(attorney.Firm.Name) + "</FirmName>");
                    xml.Append("<Phone>" + Server.HtmlEncode(attorney.Phone) + "</Phone>");
                    if (!String.IsNullOrWhiteSpace(attorney.Fax)) xml.Append("<Fax>" + Server.HtmlEncode(attorney.Fax) + "</Fax>");
                    xml.Append("<Street1>" + Server.HtmlEncode(attorney.Street1) + "</Street1>");
                    if (!String.IsNullOrWhiteSpace(attorney.Street2)) xml.Append("<Street2>" + Server.HtmlEncode(attorney.Street2) + "</Street2>");
                    xml.Append("<City>" + Server.HtmlEncode(attorney.City) + "</City>");
                    xml.Append("<State>" + Server.HtmlEncode(attorney.State.Abbreviation) + "</State>");
                    xml.Append("<ZipCode>" + Server.HtmlEncode(attorney.ZipCode) + "</ZipCode>");
                    xml.Append("<Contacts>");
                    foreach (var contact in attorney.ContactList.Contacts)
                    {
                        xml.Append("<Contact>");
                        xml.Append("<Name>" + Server.HtmlEncode(contact.Name) + "</Name>");
                        xml.Append("<Position>" + Server.HtmlEncode(contact.Position) + "</Position>");
                        if (!String.IsNullOrWhiteSpace(contact.Phone)) xml.Append("<Phone>" + Server.HtmlEncode(contact.Phone) + "</Phone>");
                        xml.Append("</Contact>");
                    }
                    xml.Append("</Contacts>");
                }
                xml.Append("</Attorney>");
            }
            #endregion

            #region Physician
            InvoicePhysician invoicePhysician = !Invoice.InvoicePhysicianID.HasValue ? null : PhysicianClass.GetInvoicePhysicianByID(Invoice.InvoicePhysicianID.Value, false, true);
            if (invoicePhysician != null && invoicePhysician.PhysicianID == Invoice.PhysicianID)
            {
                xml.Append("<Physician>");
                {
                    xml.Append("<Name>" + Server.HtmlEncode(invoicePhysician.FirstName + " " + invoicePhysician.LastName) + "</Name>");
                    xml.Append("<Phone>" + Server.HtmlEncode(invoicePhysician.Phone) + "</Phone>");
                    if (!String.IsNullOrWhiteSpace(invoicePhysician.Fax)) xml.Append("<Fax>" + Server.HtmlEncode(invoicePhysician.Fax) + "</Fax>");
                    xml.Append("<Street1>" + Server.HtmlEncode(invoicePhysician.Street1) + "</Street1>");
                    if (!String.IsNullOrWhiteSpace(invoicePhysician.Street2)) xml.Append("<Street2>" + Server.HtmlEncode(invoicePhysician.Street2) + "</Street2>");
                    xml.Append("<City>" + Server.HtmlEncode(invoicePhysician.City) + "</City>");
                    xml.Append("<State>" + Server.HtmlEncode(invoicePhysician.State.Abbreviation) + "</State>");
                    xml.Append("<ZipCode>" + Server.HtmlEncode(invoicePhysician.ZipCode) + "</ZipCode>");
                }
                xml.Append("</Physician>");
            }
            else
            {
                Physician physician = !Invoice.PhysicianID.HasValue ? null : PhysicianClass.GetPhysicianByID(Invoice.PhysicianID.Value, false, true);
                if (physician != null)
                {
                    xml.Append("<Physician>");
                    {
                        xml.Append("<Name>" + Server.HtmlEncode(physician.FirstName + " " + physician.LastName) + "</Name>");
                        xml.Append("<Phone>" + Server.HtmlEncode(physician.Phone) + "</Phone>");
                        if (!String.IsNullOrWhiteSpace(physician.Fax)) xml.Append("<Fax>" + Server.HtmlEncode(physician.Fax) + "</Fax>");
                        xml.Append("<Street1>" + Server.HtmlEncode(physician.Street1) + "</Street1>");
                        if (!String.IsNullOrWhiteSpace(physician.Street2)) xml.Append("<Street2>" + Server.HtmlEncode(physician.Street2) + "</Street2>");
                        xml.Append("<City>" + Server.HtmlEncode(physician.City) + "</City>");
                        xml.Append("<State>" + Server.HtmlEncode(physician.State.Abbreviation) + "</State>");
                        xml.Append("<ZipCode>" + Server.HtmlEncode(physician.ZipCode) + "</ZipCode>");
                    }
                    xml.Append("</Physician>");
                }
            }
            #endregion

            #region Surgeries
            xml.Append("<Surgeries>");
            foreach (var surgery in (from surgery in Invoice.Surgeries where surgery.Active select surgery))
            {
                xml.Append("<Surgery>");
                {
                    var s = SurgeryClass.GetSurgeryByID(surgery.SurgeryID);
                    if (s != null) xml.Append("<Name>" + Server.HtmlEncode(s.Name) + "</Name>");
                    if (!String.IsNullOrWhiteSpace(surgery.Notes)) xml.Append("<Notes>" + Server.HtmlEncode(surgery.Notes) + "</Notes>");
                    xml.Append("<Dates>");
                    foreach (var date in (from date in surgery.SurgeryDates select date).Distinct())
                    {
                        xml.Append("<Date>" + date.ToString("MM/dd/yyyy") + "</Date>");
                    }
                    xml.Append("</Dates>");
                    xml.Append("<InOutPatient>" + (surgery.isInpatient ? "Inpatient" : "Outpatient") + "</InOutPatient>");
                }
                xml.Append("</Surgery>");
            }
            xml.Append("</Surgeries>");
            #endregion

            #region Providers
            xml.Append("<Providers>");
            foreach (var pc in (from provider in Invoice.Providers where provider.Active select provider))
            {
                xml.Append("<Provider>");
                {
                    InvoiceProvider invoiceProvider = !pc.InvoiceProviderID.HasValue ? null : GetInvoiceProvider(pc.InvoiceProviderID.Value);
                    if (invoiceProvider != null && invoiceProvider.ProviderID == pc.ProviderID)
                    {
                        xml.Append("<Name>" + Server.HtmlEncode(invoiceProvider.Name) + "</Name>");
                        xml.Append("<Phone>" + Server.HtmlEncode(invoiceProvider.Phone) + "</Phone>");
                        if (!String.IsNullOrWhiteSpace(invoiceProvider.Fax)) xml.Append("<Fax>" + Server.HtmlEncode(invoiceProvider.Fax) + "</Fax>");
                        if (!String.IsNullOrWhiteSpace(invoiceProvider.FacilityAbbreviation)) xml.Append("<Abbreviation>" + Server.HtmlEncode(invoiceProvider.FacilityAbbreviation) + "</Abbreviation>");
                        xml.Append("<Street1>" + Server.HtmlEncode(invoiceProvider.Street1) + "</Street1>");
                        if (!String.IsNullOrWhiteSpace(invoiceProvider.Street2)) xml.Append("<Street2>" + Server.HtmlEncode(invoiceProvider.Street2) + "</Street2>");
                        xml.Append("<City>" + Server.HtmlEncode(invoiceProvider.City) + "</City>");
                        xml.Append("<State>" + Server.HtmlEncode(invoiceProvider.State.Abbreviation) + "</State>");
                        xml.Append("<ZipCode>" + Server.HtmlEncode(invoiceProvider.ZipCode) + "</ZipCode>");
                    }
                    else
                    {
                        Provider provider = GetProvider(pc.ProviderID);
                        if (provider != null)
                        {
                            xml.Append("<Name>" + Server.HtmlEncode(provider.Name) + "</Name>");
                            xml.Append("<Phone>" + Server.HtmlEncode(provider.Phone) + "</Phone>");
                            if (!String.IsNullOrWhiteSpace(provider.Fax)) xml.Append("<Fax>" + Server.HtmlEncode(provider.Fax) + "</Fax>");
                            if (!String.IsNullOrWhiteSpace(provider.FacilityAbbreviation)) xml.Append("<Abbreviation>" + Server.HtmlEncode(provider.FacilityAbbreviation) + "</Abbreviation>");
                            xml.Append("<Street1>" + Server.HtmlEncode(provider.Street1) + "</Street1>");
                            if (!String.IsNullOrWhiteSpace(provider.Street2)) xml.Append("<Street2>" + Server.HtmlEncode(provider.Street2) + "</Street2>");
                            xml.Append("<City>" + Server.HtmlEncode(provider.City) + "</City>");
                            xml.Append("<State>" + Server.HtmlEncode(provider.State.Abbreviation) + "</State>");
                            xml.Append("<ZipCode>" + Server.HtmlEncode(provider.ZipCode) + "</ZipCode>");
                        }
                    }
                    xml.Append("<Services>");
                    foreach (var service in (from service in pc.ProviderServices where service.Active select service))
                    {
                        xml.Append("<Service>");
                        {
                            xml.Append("<Cost>" + service.Cost.ToString("c") + "</Cost>");
                            xml.Append("<AmountDue>" + service.AmountDue.ToString("c") + "</AmountDue>");
                            xml.Append("<DueDate>" + service.DueDate.ToString("MM/dd/yyyy") + "</DueDate>");
                        }
                        xml.Append("</Service>");
                    }
                    xml.Append("</Services>");
                }
                xml.Append("</Provider>");
            }
            xml.Append("</Providers>");
            #endregion

            #region Attorney Payments
            var attorneyPayments = (from p in Invoice.Payments
                                    where p.Active
                                    orderby p.DatePaid ascending
                                    select p).ToList();
            if (attorneyPayments.Count > 0)
            {
                xml.Append("<AttorneyPayments>");
                foreach (var payment in attorneyPayments)
                {
                    xml.Append("<Payment>");
                    {
                        xml.Append("<Date>" + payment.DatePaid.ToString("MM/dd/yyyy") + "</Date>");
                        xml.Append("<Type>" + Enum.GetName(typeof(InvoiceClass.PaymentTypeEnum), payment.PaymentTypeID) + "</Type>");
                        xml.Append("<Amount>" + payment.Amount.ToString("c") + "</Amount>");
                        xml.Append("<CheckNo>" + Server.HtmlEncode(payment.CheckNumber) + "</CheckNo>");
                    }
                    xml.Append("</Payment>");
                }
                xml.Append("</AttorneyPayments>");
            }
            #endregion

            #region Provider Payments
            var providerPayments = (from provider in Invoice.Providers
                                    where provider.Active
                                    from payment in provider.Payments
                                    where payment.Active
                                    orderby payment.DatePaid ascending
                                    select new
                                    {
                                        Provider = GetProvider(provider.ProviderID),
                                        InvoiceProvider = !provider.InvoiceProviderID.HasValue ? null : GetInvoiceProvider(provider.InvoiceProviderID.Value),
                                        DatePaid = payment.DatePaid,
                                        Amount = payment.Amount,
                                        CheckNumber = payment.CheckNumber,
                                    }).ToList();
            if (providerPayments.Count > 0)
            {
                xml.Append("<ProviderPayments>");
                foreach (var payment in providerPayments)
                {
                    xml.Append("<Payment>");
                    {
                        xml.Append("<Date>" + payment.DatePaid.ToString("MM/dd/yyyy") + "</Date>");
                        if (payment.InvoiceProvider != null && payment.Provider != null && payment.InvoiceProvider.ProviderID == payment.Provider.ID)
                        {
                            xml.Append("<Recipient>" + Server.HtmlEncode(payment.InvoiceProvider.Name) + "</Recipient>");
                        }
                        else if (payment.Provider != null)
                        {
                            xml.Append("<Recipient>" + Server.HtmlEncode(payment.Provider.Name) + "</Recipient>");
                        }
                        xml.Append("<Amount>" + payment.Amount.ToString("c") + "</Amount>");
                        xml.Append("<CheckNo>" + Server.HtmlEncode(payment.CheckNumber) + "</CheckNo>");
                    }
                    xml.Append("</Payment>");
                }
                xml.Append("</ProviderPayments>");
            }
            #endregion

            #region Summary
            if (Invoice.DateServiceFeeBegins.HasValue) xml.Append("<DateServiceFeeBegins>" + Invoice.DateServiceFeeBegins.Value.ToString("MM/dd/yyyy") + "</DateServiceFeeBegins>");
            if (Invoice.MaturityDate.HasValue) xml.Append("<MaturityDate>" + Invoice.MaturityDate.Value.ToString("MM/dd/yyyy") + "</MaturityDate>");

            xml.Append("<TotalCostMinusPPODiscounts>" + (Invoice.TotalCost - Invoice.TotalPPODiscount).ToString("c") + "</TotalCostMinusPPODiscounts>");
            xml.Append("<PrincipalAndDepositPaid>" + Invoice.PrincipalAndDepositPaid.ToString("c") + "</PrincipalAndDepositPaid>");
            xml.Append("<AdditionalDeductions>" + Invoice.AdditionalDeductions.ToString("c") + "</AdditionalDeductions>");
            xml.Append("<BalanceDue>" + Invoice.BalanceDue.ToString("c") + "</BalanceDue>");
            xml.Append("<LossesAmount>" + (Invoice.LossesAmount ?? 0m).ToString("c") + "</LossesAmount>");
            xml.Append("<ServiceFeeWaived>" + (Invoice.ServiceFeeWaived ?? 0m).ToString("c") + "</ServiceFeeWaived>");
            xml.Append("<CumulativeServiceFee>" + (Invoice.CalculatedCumulativeInterest - Invoice.ServiceFeeReceived).ToString("c") + "</CumulativeServiceFee>");
            xml.Append("<EndingBalance>" + Invoice.EndingBalance.ToString("c") + "</EndingBalance>");

            xml.Append("<TotalPPODiscount>" + Invoice.TotalPPODiscount.ToString("c") + "</TotalPPODiscount>");
            xml.Append("<CostOfGoodsSold>" + Invoice.CostOfGoodsSold.ToString("c") + "</CostOfGoodsSold>");
            xml.Append("<TotalRevenue>" + Invoice.TotalRevenue.ToString("c") + "</TotalRevenue>");
            #endregion

            #region Payment Comments
            if (Invoice.PaymentComments.Count > 0)
            {
                xml.Append("<Comments>");
                foreach (var pay in Invoice.PaymentComments.OrderByDescending(a => a.DateAdded))
                {
                    User u = UserClass.GetUserByID(pay.UserID, false);
                    xml.Append("<Comment>");
                    {
                        xml.Append("<User>" + Server.HtmlEncode(u.FirstName) + " " + Server.HtmlEncode(u.LastName) + "</User>");
                        xml.Append("<Date>" + pay.DateAdded + "</Date>");
                        xml.Append("<Text>" + Server.HtmlEncode(pay.Text) + "</Text>");
                    }
                    xml.Append("</Comment>");
                }
                xml.Append("</Comments>");
            }
            #endregion

            xml.Append("</Details>");
            return xml.ToString();
        }

        private Provider GetProvider(int id)
        {
            Provider provider = (from p in _Providers
                                 where p.ID == id
                                 select p).FirstOrDefault();
            if (provider == null)
            {
                provider = ProviderClass.GetProviderByID(id, false, true);
                if (provider != null)
                {
                    _Providers.Add(provider);
                }
            }
            return provider;
        }

        private InvoiceProvider GetInvoiceProvider(int id)
        {
            InvoiceProvider invoiceProvider = (from p in _InvoiceProviders
                                               where p.ID == id
                                               select p).FirstOrDefault();
            if (invoiceProvider == null)
            {
                invoiceProvider = ProviderClass.GetInvoiceProviderByID(id, false, true);
                if (invoiceProvider != null)
                {
                    _InvoiceProviders.Add(invoiceProvider);
                }
            }
            return invoiceProvider;
        }

        protected void btnPrintInvoice_Click(object sender, EventArgs e)
        {
            List<byte[]> invoices = new List<byte[]>();
            ReportViewer rw = new ReportViewer();

            grdInvoices.AllowPaging = false;
            grdInvoices.Rebind();

            foreach(GridDataItem invoice in grdInvoices.Items)
            //foreach (var invoice in Utility.Invoices)
            {
                rw.LocalReport.DataSources.Clear();

                int ID = Convert.ToInt32(invoice.GetDataKeyValue("ID"));

                Invoice = new Classes.TemporaryInvoice(this.Session, this.Company.ID, ID, this.InvoiceSessionKey);

                if (Invoice.TypeIsTesting)
                {
                    rw.LocalReport.ReportPath = "Reports\\TestPrintOut.rdlc";
                    var tests = new BMMDataSet.TemporaryInvoiceTestsDataTable();
                    foreach (var invoiceTest in Invoice.Tests.Where(test => test.Active).Select(test => test))
                    {
                        tests.AddTemporaryInvoiceTestsRow(GetTestProviderName(invoiceTest), GetTestName(invoiceTest), invoiceTest.Notes,
                                                          invoiceTest.TestDate, invoiceTest.TestCost);
                    }
                    rw.LocalReport.DataSources.Add(new ReportDataSource("Tests", (DataTable)tests));
                    rw.LocalReport.SetParameters(new ReportParameter("TotalCost", Invoice.TotalCost.ToString()));
                    rw.LocalReport.SetParameters(new ReportParameter("TotalPPODiscount", Invoice.TotalPPODiscount.ToString()));
                    rw.LocalReport.SetParameters(new ReportParameter("CompanyID", CurrentUser.CompanyID.ToString()));

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

                    invoices.Add(bytes);
                }
                else
                {
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
                    rw.LocalReport.DataSources.Add(new ReportDataSource("Surgeries", (DataTable)surgeries));
                    var services = new BMMDataSet.TemporaryInvoiceServicesDataTable();
                    foreach (var provider in Invoice.Providers.Where(provider => provider.Active).Select(provider => provider))
                    {
                        string providerName = GetProviderName(provider);
                        foreach (var service in provider.ProviderServices.Where(service => service.Active).Select(service => service))
                        {
                            services.AddTemporaryInvoiceServicesRow(providerName, service.Cost, service.PPODiscount);
                        }
                    }
                    rw.LocalReport.DataSources.Add(new ReportDataSource("Services", (DataTable)services));

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

                    invoices.Add(bytes);
                }

                this.Invoice.Remove();
            }

            grdInvoices.AllowPaging = true;
            grdInvoices.Rebind();

            using (var ms = new MemoryStream())
            {
                using (var doc = new Document())
                {
                    using (var copy = new PdfSmartCopy(doc, ms))
                    {
                        doc.Open();

                        //Loop through each byte array
                        foreach (var p in invoices)
                        {

                            //Create a PdfReader bound to that byte array
                            using (var reader = new PdfReader(p))
                            {

                                //Add the entire document instead of page-by-page
                                copy.AddDocument(reader);
                            }
                        }

                        doc.Close();
                    }
                }

                byte[] content = ms.ToArray();
                Page.Response.Clear();
                Page.Response.AddHeader("Content-Disposition", "attachment; filename=Invoices.pdf");
                Page.Response.AddHeader("Content-Length", content.Length.ToString());
                Page.Response.ContentType = "application/pdf";
                Page.Response.BinaryWrite(content);
                Page.Response.End();
            }
        }

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

        public string GetSurgeryName(SurgeryInvoice_Surgery_Custom sis_c)
        {
            Surgery surgery = SurgeryClass.GetSurgeryByID(sis_c.SurgeryID);
            return surgery == null ? "N/A" : surgery.Name;
        }

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

        public string GetTestName(TestInvoice_Test_Custom tit_c)
        {
            Test test = TestClass.GetTestByID(tit_c.TestID);
            return test == null ? "N/A" : test.Name;
        }
    }
}