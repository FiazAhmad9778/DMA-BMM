using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml;
using System.Xml.Xsl;
using System.Xml.XPath;
using System.IO;
using ASPPDFLib;
using BMM_BAL;
using BMM_DAL;

namespace BMM.Documents
{
    public partial class TestWorksheet : Classes.BasePage
    {
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

        #region RequiredPermission
        /// <summary>
        /// Sets the permission for the page
        /// </summary>
        public override UserClass.PermissionsEnum? RequiredPermission
        {
            get
            {
                return UserClass.PermissionsEnum.Invoice_Providers;
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

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Invoice != null)
                BuildPDF();
        }

        private void BuildPDF()
        {
            XslCompiledTransform transform = new XslCompiledTransform();
            transform.Load(Server.MapPath(XMLPath) + "TestWorksheet.xsl");
            MemoryStream stream = new MemoryStream();
            string xml = SerializeToXML();
            transform.Transform(new XPathDocument(new StringReader(SerializeToXML())), null, stream);

            PdfManager pdfManager = new PdfManager();
            pdfManager.RegKey = AspPdfRegKey;
            IPdfDocument objDoc = pdfManager.CreateDocument();
            stream.Position = 0;
            string html = new StreamReader(stream).ReadToEnd();
            objDoc.ImportFromUrl(html, "Landscape=false, LeftMargin=36, RightMargin=36, TopMargin=36, BottomMargin=36");
            stream.Close();

            byte[] content = (byte[])objDoc.SaveToMemory();
            Page.Response.Clear();
            Page.Response.AddHeader("Content-Disposition", "attachment; filename=TestWorksheet.pdf");
            Page.Response.AddHeader("Content-Length", content.Length.ToString());
            Page.Response.ContentType = "application/pdf";
            Page.Response.BinaryWrite(content);
            Page.Response.End();
        }

        private string SerializeToXML()
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
    }
}