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
    public partial class SurgeryWorksheet : Classes.BasePage
    {
        private List<Provider> _Providers = new List<Provider>();
        private List<InvoiceProvider> _InvoiceProviders = new List<InvoiceProvider>();

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
            transform.Load(Server.MapPath(XMLPath) + "SurgeryWorksheet.xsl");
            MemoryStream stream = new MemoryStream();
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
            Page.Response.AddHeader("Content-Disposition", "attachment; filename=SurgeryWorksheet.pdf");
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
                        xml.Append("<Text>" + Server.HtmlEncode(pay.Text)  + "</Text>");
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
    }
}