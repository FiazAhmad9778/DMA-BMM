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
    public partial class SurgeryGuarantorAuthorization : Classes.BasePage
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

        #region Provider
        private SurgeryInvoice_Provider_Custom _Provider;
        public SurgeryInvoice_Provider_Custom Provider
        {
            get
            {
                if (_Provider == null && Invoice != null)
                {
                    _Provider = Invoice.GetTemporaryProvider(ProviderSessionKey);
                }
                return _Provider;
            }
        }
        #endregion


        protected void Page_Load(object sender, EventArgs e)
        {
            if (Invoice != null && Provider != null)
                BuildPDF();
        }

        private void BuildPDF()
        {
            XslCompiledTransform transform = new XslCompiledTransform();
            transform.Load(Server.MapPath(XMLPath) + "SurgeryGuarantorAuthorization.xsl");
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
            Page.Response.AddHeader("Content-Disposition", "attachment; filename=GuarantorAuthorization.pdf");
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

            xml.Append("<Company>");
            xml.Append("<LongName>" + Server.HtmlEncode(Company.LongName) + "</LongName>");
            xml.Append("<Name>" + Server.HtmlEncode(Company.Name) + "</Name>");
            xml.Append("<Address>" + Server.HtmlEncode(Company.Address) + "</Address>");
            xml.Append("<CityStateZip>" + Server.HtmlEncode(Company.CityStateZip) + "</CityStateZip>");
            xml.Append("<Phone>" + Server.HtmlEncode(Company.Phone) + "</Phone>");
            xml.Append("</Company>");

            xml.Append("<Patient>");
            xml.Append("<FirstName>" + Server.HtmlEncode(Invoice.GetPatientFirstName()) + "</FirstName>");
            xml.Append("<LastName>" + Server.HtmlEncode(Invoice.GetPatientLastName()) + "</LastName>");
            xml.Append("<SSN>" + Server.HtmlEncode(Invoice.GetPatientSSN(true)) + "</SSN>");
            xml.Append("<DateOfBirth>" + Invoice.GetPatientDateOfBirth() + "</DateOfBirth>");
            xml.Append("<Phone>" + Server.HtmlEncode(Invoice.GetPatientPhone()) + "</Phone>");
            xml.Append("<Street1>" + Server.HtmlEncode(Invoice.GetPatientStreet1()) + "</Street1>");
            xml.Append("<Street2>" + Server.HtmlEncode(Invoice.GetPatientStreet2()) + "</Street2>");
            xml.Append("<City>" + Server.HtmlEncode(Invoice.GetPatientCity()) + "</City>");
            xml.Append("<State>" + Server.HtmlEncode(Invoice.GetPatientState()) + "</State>");
            xml.Append("<ZipCode>" + Server.HtmlEncode(Invoice.GetPatientZipCode()) + "</ZipCode>");
            xml.Append("</Patient>");

            if (Invoice.DateOfAccident.HasValue)
            {
                xml.Append("<DateOfAccident>" + Invoice.DateOfAccident.Value.ToString("MM/dd/yyyy") + "</DateOfAccident>");
            }

            xml.Append("<Provider>");
            Provider provider = ProviderClass.GetProviderByID(Provider.ProviderID);
            InvoiceProvider invoiceProvider = !Provider.InvoiceProviderID.HasValue ? null : ProviderClass.GetInvoiceProviderByID(Provider.InvoiceProviderID.Value);
            if (invoiceProvider != null && invoiceProvider.ProviderID == Provider.ProviderID)
            {
                xml.Append("<Name>" + Server.HtmlEncode(invoiceProvider.Name) + "</Name>");
            }
            else
            {
                xml.Append("<Name>" + Server.HtmlEncode(provider.Name) + "</Name>");
            }
            xml.Append("</Provider>");

            Physician physician = !Invoice.PhysicianID.HasValue ? null : PhysicianClass.GetPhysicianByID(Invoice.PhysicianID.Value, true);
            if (physician != null)
            {
                xml.Append("<Physician>");
                InvoicePhysician invoicePhysician = !Invoice.InvoicePhysicianID.HasValue ? null : PhysicianClass.GetInvoicePhysicianByID(Invoice.InvoicePhysicianID.Value, true);
                if (invoicePhysician != null && invoicePhysician.PhysicianID == physician.ID)
                {
                    xml.Append("<FirstName>" + Server.HtmlEncode(invoicePhysician.FirstName) + "</FirstName>");
                    xml.Append("<LastName>" + Server.HtmlEncode(invoicePhysician.LastName) + "</LastName>");
                    if (invoicePhysician.InvoiceContactList.InvoiceContacts.Count > 0)
                    {
                        xml.Append("<Contacts>");
                        foreach (var contact in invoicePhysician.InvoiceContactList.InvoiceContacts)
                        {
                            xml.Append("<Contact>");
                            xml.Append("<Name>" + Server.HtmlEncode(contact.Name) + "</Name>");
                            xml.Append("<Position>" + Server.HtmlEncode(contact.Position) + "</Position>");
                            if (!String.IsNullOrEmpty(contact.Phone)) xml.Append("<Phone>" + Server.HtmlEncode(contact.Phone) + "</Phone>");
                            xml.Append("</Contact>");
                        }
                        xml.Append("</Contacts>");
                    }
                }
                else
                {
                    xml.Append("<FirstName>" + Server.HtmlEncode(physician.FirstName) + "</FirstName>");
                    xml.Append("<LastName>" + Server.HtmlEncode(physician.LastName) + "</LastName>");
                    if (physician.ContactList.Contacts.Count > 0)
                    {
                        xml.Append("<Contacts>");
                        foreach (var contact in physician.ContactList.Contacts)
                        {
                            xml.Append("<Contact>");
                            xml.Append("<Name>" + Server.HtmlEncode(contact.Name) + "</Name>");
                            xml.Append("<Position>" + Server.HtmlEncode(contact.Position) + "</Position>");
                            if(!String.IsNullOrEmpty(contact.Phone)) xml.Append("<Phone>" + Server.HtmlEncode(contact.Phone) + "</Phone>");
                            xml.Append("</Contact>");
                        }
                        xml.Append("</Contacts>");
                    }
                }
                xml.Append("</Physician>");
            }

            xml.Append("<Procedures>");
            foreach (var procedure in Invoice.Surgeries)
            {
                if (procedure.Active)
                {
                    xml.Append("<Procedure>");
                    Surgery surgery = SurgeryClass.GetSurgeryByID(procedure.SurgeryID);
                    if (surgery != null)
                    {
                        xml.Append("<Name>" + Server.HtmlEncode(surgery.Name) + "</Name>");
                    }
                    xml.Append("<Dates>");
                    foreach (var date in procedure.SurgeryDates)
                    {
                        xml.Append("<Date>" + date.ToString("MM/dd/yyyy") + "</Date>");
                    }
                    xml.Append("</Dates>");
                    xml.Append("</Procedure>");
                }
            }
            xml.Append("</Procedures>");

            xml.Append("<User>");
            xml.Append("<FirstName>" + Server.HtmlEncode(CurrentUser.FirstName) + "</FirstName>");
            xml.Append("<LastName>" + Server.HtmlEncode(CurrentUser.LastName) + "</LastName>");
            xml.Append("<Position>" + Server.HtmlEncode(CurrentUser.Position) + "</Position>");
            xml.Append("</User>");

            xml.Append("</Details>");
            return xml.ToString();
        }
    }
}