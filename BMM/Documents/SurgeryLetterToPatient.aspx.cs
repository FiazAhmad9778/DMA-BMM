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
    public partial class SurgeryLetterToPatient : Classes.BasePage
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

        #region Surgery
        private SurgeryInvoice_Surgery_Custom _Surgery;
        public SurgeryInvoice_Surgery_Custom Surgery
        {
            get
            {
                if (_Surgery == null && Invoice != null)
                {
                    _Surgery = Invoice.GetTemporarySurgery(SurgerySessionKey);
                }
                return _Surgery;
            }
        }
        #endregion


        protected void Page_Load(object sender, EventArgs e)
        {
            if (Invoice != null && Surgery != null)
                BuildPDF();
        }

        private void BuildPDF()
        {
            XslCompiledTransform transform = new XslCompiledTransform();
            transform.Load(Server.MapPath(XMLPath) + "SurgeryLetterToPatient.xsl");
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
            Page.Response.AddHeader("Content-Disposition", "attachment; filename=LetterToPatient.pdf");
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

            xml.Append("<Date>" + DateTime.Today.ToString("MM/dd/yyyy") + "</Date>");

            xml.Append("<Patient>");
            xml.Append("<FirstName>" + Server.HtmlEncode(Invoice.GetPatientFirstName()) + "</FirstName>");
            xml.Append("<LastName>" + Server.HtmlEncode(Invoice.GetPatientLastName()) + "</LastName>");
            xml.Append("<Phone>" + Server.HtmlEncode(Invoice.GetPatientPhone()) + "</Phone>");
            xml.Append("<Street1>" + Server.HtmlEncode(Invoice.GetPatientStreet1()) + "</Street1>");
            if (!String.IsNullOrWhiteSpace(Invoice.GetPatientStreet2())) xml.Append("<Street2>" + Server.HtmlEncode(Invoice.GetPatientStreet2()) + "</Street2>");
            xml.Append("<City>" + Server.HtmlEncode(Invoice.GetPatientCity()) + "</City>");
            xml.Append("<State>" + Server.HtmlEncode(Invoice.GetPatientState()) + "</State>");
            xml.Append("<ZipCode>" + Server.HtmlEncode(Invoice.GetPatientZipCode()) + "</ZipCode>");
            xml.Append("</Patient>");

            xml.Append("<Procedure>");
            var surgery = SurgeryClass.GetSurgeryByID(Surgery.SurgeryID);
            if (surgery != null)
                xml.Append("<Name>" + Server.HtmlEncode(surgery.Name) + "</Name>");
            xml.Append("<Dates>");
            foreach (var date in (from d in Surgery.SurgeryDates where d > DateTime.MinValue orderby d ascending select d).Distinct())
            {
                xml.Append("<Date>" + date.ToString("dddd, MMMM d, yyyy") + "</Date>");
            }
            xml.Append("</Dates>");
            xml.Append("</Procedure>");

            xml.Append("<Providers>");
            foreach(var provider in Invoice.Providers)
            {
                if (provider.Active)
                {
                    xml.Append("<Provider>");
                    InvoiceProvider ip = !provider.InvoiceProviderID.HasValue ? null : ProviderClass.GetInvoiceProviderByID(provider.InvoiceProviderID.Value, false, true);
                    if (ip != null && ip.ProviderID == provider.ProviderID)
                    {
                        xml.Append("<Name>" + Server.HtmlEncode(ip.Name) + "</Name>");
                        xml.Append("<Street1>" + Server.HtmlEncode(ip.Street1) + "</Street1>");
                        if (!String.IsNullOrWhiteSpace(ip.Street2)) xml.Append("<Street2>" + Server.HtmlEncode(ip.Street2) + "</Street2>");
                        xml.Append("<City>" + Server.HtmlEncode(ip.City) + "</City>");
                        xml.Append("<State>" + Server.HtmlEncode(ip.State.Abbreviation) + "</State>");
                        xml.Append("<ZipCode>" + Server.HtmlEncode(ip.ZipCode) + "</ZipCode>");
                    }
                    else
                    {
                        Provider p = ProviderClass.GetProviderByID(provider.ProviderID, false, true);
                        if (p != null)
                        {
                            xml.Append("<Name>" + Server.HtmlEncode(p.Name) + "</Name>");
                            xml.Append("<Street1>" + Server.HtmlEncode(p.Street1) + "</Street1>");
                            if (!String.IsNullOrWhiteSpace(p.Street2)) xml.Append("<Street2>" + Server.HtmlEncode(p.Street2) + "</Street2>");
                            xml.Append("<City>" + Server.HtmlEncode(p.City) + "</City>");
                            xml.Append("<State>" + Server.HtmlEncode(p.State.Abbreviation) + "</State>");
                            xml.Append("<ZipCode>" + Server.HtmlEncode(p.ZipCode) + "</ZipCode>");
                        }
                    }
                    xml.Append("</Provider>");
                }
            }
            xml.Append("</Providers>");

            Attorney attorney = !Invoice.AttorneyID.HasValue ? null : AttorneyClass.GetAttorneyByID(Invoice.AttorneyID.Value);
            if (attorney != null)
            {
                xml.Append("<Attorney>");
                xml.Append("<FirstName>" + Server.HtmlEncode(attorney.FirstName) + "</FirstName>");
                xml.Append("<LastName>" + Server.HtmlEncode(attorney.LastName) + "</LastName>");
                xml.Append("</Attorney>");
            }

            if (Invoice.DateOfAccident.HasValue)
            {
                xml.Append("<DateOfAccident>" + Invoice.DateOfAccident.Value.ToString("MM/dd/yyyy") + "</DateOfAccident>");
            }


            xml.Append("<Company>");
            xml.Append("<Phone>" + Server.HtmlEncode(Company.Phone) + "</Phone>");
            xml.Append("</Company>");

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