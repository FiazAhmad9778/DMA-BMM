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
    public partial class TestPrintOut : Classes.BasePage
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
            transform.Load(Server.MapPath(XMLPath) + "TestPrintOut.xsl");
            MemoryStream stream = new MemoryStream();
            transform.Transform(new XPathDocument(new StringReader(SerializeToXML())), null, stream);

            PdfManager pdfManager = new PdfManager();
            pdfManager.RegKey = AspPdfRegKey;
            IPdfDocument objDoc = pdfManager.CreateDocument();
            stream.Position = 0;
            string html = new StreamReader(stream).ReadToEnd();
            objDoc.ImportFromUrl(html, "Landscape=false, LeftMargin=36, RightMargin=36, TopMargin=36, BottomMargin=76");
            stream.Close();

            AddDisclaimerFooter(objDoc);

            byte[] content = (byte[])objDoc.SaveToMemory();
            Page.Response.Clear();
            Page.Response.AddHeader("Content-Disposition", "attachment; filename=TestPrintOut.pdf");
            Page.Response.AddHeader("Content-Length", content.Length.ToString());
            Page.Response.ContentType = "application/pdf";
            Page.Response.BinaryWrite(content);
            Page.Response.End();
        }

        private void AddDisclaimerFooter(IPdfDocument objDoc)
        {
            float width = 400;
            float height = 32;
            IPdfTable table = objDoc.CreateTable("Width=" + width + ", Height=" + height + ", Rows=1, Cols=1");
            table.Rows[1].Cells[1].AddText("This is not a final invoice. Interest will accumulate accordingly. Please call for a final payout.", "Alignment=Center, IndentY=2", objDoc.Fonts["Times-Roman"]);
            table.Rows[1].Cells[1].AddText("\nFOR YOUR RECORDS ONLY. PLEASE DO NOT DISTRIBUTE.", "Alignment=Center, IndentY=4", objDoc.Fonts["Times-Bold"]);
            foreach (IPdfPage page in objDoc.Pages)
            {
                float x = 0.5f * (page.Width - width);
                float y = 32 + height;
                page.Canvas.DrawTable(table, "X=" + x + ", Y=" + y);
            }
        }

        private string SerializeToXML()
        {
            System.Text.StringBuilder xml = new System.Text.StringBuilder();
            xml.Append("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
            xml.Append("<Details>");

            #region Company
            xml.Append("<Company>");
            {
                xml.Append("<Name>" + Server.HtmlEncode(Company.Name) + "</Name>");
                xml.Append("<LongName>" + Server.HtmlEncode(Company.LongName) + "</LongName>");
                xml.Append("<Address>" + Server.HtmlEncode(Company.Address) + "</Address>");
                xml.Append("<CityStateZip>" + Server.HtmlEncode(Company.CityStateZip) + "</CityStateZip>");
                xml.Append("<Phone>" + Server.HtmlEncode(Company.Phone) + "</Phone>");
                xml.Append("<Fax>" + Server.HtmlEncode(Company.Fax) + "</Fax>");
                xml.Append("<FederalID>" + Server.HtmlEncode(Company.FederalID) + "</FederalID>");
            }
            xml.Append("</Company>");
            #endregion

            #region Invoice Basics
            xml.Append("<Date>" + DateTime.Today.ToString("MM/dd/yyyy") + "</Date>");
            if (Invoice.ID.HasValue) xml.Append("<InvoiceID>" + Invoice.InvoiceNumber.Value + "</InvoiceID>");
            string patientName = Invoice.GetPatientFirstName() + " " + Invoice.GetPatientLastName();
            if(!String.IsNullOrWhiteSpace(patientName)) xml.Append("<PatientName>" + Server.HtmlEncode(patientName) + "</PatientName>");
            if (Invoice.DateOfAccident.HasValue) xml.Append("<DateOfAccident>" + Invoice.DateOfAccident.Value.ToString("MM/dd/yyyy") + "</DateOfAccident>");
            #endregion

            #region Attorney
            InvoiceAttorney invoiceAttorney = !Invoice.InvoiceAttorneyID.HasValue ? null : AttorneyClass.GetInvoiceAttorneyByID(Invoice.InvoiceAttorneyID.Value, false, false, true);
            if (invoiceAttorney != null && invoiceAttorney.AttorneyID == Invoice.AttorneyID)
            {
                xml.Append("<Attorney>");
                {
                    xml.Append("<Name>" + Server.HtmlEncode(invoiceAttorney.FirstName + " " + invoiceAttorney.LastName) + "</Name>");
                    xml.Append("<Street1>" + Server.HtmlEncode(invoiceAttorney.Street1) + "</Street1>");
                    if (!String.IsNullOrWhiteSpace(invoiceAttorney.Street2)) xml.Append("<Street2>" + Server.HtmlEncode(invoiceAttorney.Street2) + "</Street2>");
                    xml.Append("<City>" + Server.HtmlEncode(invoiceAttorney.City) + "</City>");
                    xml.Append("<State>" + Server.HtmlEncode(invoiceAttorney.State.Abbreviation) + "</State>");
                    xml.Append("<ZipCode>" + Server.HtmlEncode(invoiceAttorney.ZipCode) + "</ZipCode>");
                }
                xml.Append("</Attorney>");
            }
            else
            {
                Attorney attorney = !Invoice.AttorneyID.HasValue ? null : AttorneyClass.GetAttorneyByID(Invoice.AttorneyID.Value, false, false, true);
                if (attorney != null)
                {
                    xml.Append("<Attorney>");
                    {
                        xml.Append("<Name>" + Server.HtmlEncode(attorney.FirstName + " " + attorney.LastName) + "</Name>");
                        xml.Append("<Street1>" + Server.HtmlEncode(attorney.Street1) + "</Street1>");
                        if (!String.IsNullOrWhiteSpace(attorney.Street2)) xml.Append("<Street2>" + Server.HtmlEncode(attorney.Street2) + "</Street2>");
                        xml.Append("<City>" + Server.HtmlEncode(attorney.City) + "</City>");
                        xml.Append("<State>" + Server.HtmlEncode(attorney.State.Abbreviation) + "</State>");
                        xml.Append("<ZipCode>" + Server.HtmlEncode(attorney.ZipCode) + "</ZipCode>");
                    }
                    xml.Append("</Attorney>");
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
                        xml.Append("<Provider>" + Server.HtmlEncode(invoiceProvider.Name) + "</Provider>");
                    }
                    else
                    {
                        Provider provider = ProviderClass.GetProviderByID(test.ProviderID, false, true);
                        if (provider != null)
                        {
                            xml.Append("<Provider>" + Server.HtmlEncode(provider.Name) + "</Provider>");
                        }
                    }
                    var t = TestClass.GetTestByID(test.TestID);
                    if (t != null) xml.Append("<Name>" + Server.HtmlEncode(t.Name) + "</Name>");
                    if (!String.IsNullOrWhiteSpace(test.Notes)) xml.Append("<Notes>" + Server.HtmlEncode(test.Notes) + "</Notes>");
                    if (test.TestDate != DateTime.MinValue) xml.Append("<TestDate>" + test.TestDate.ToString("MM/dd/yyyy") + "</TestDate>");
                    xml.Append("<TestCost>" + test.TestCost.ToString("c") + "</TestCost>");
                }
                xml.Append("</Test>");
            }
            xml.Append("</Tests>");
            #endregion

            #region Summary
            xml.Append("<TotalCost>" + Invoice.TotalCost.ToString("c") + "</TotalCost>");
            xml.Append("<TotalPPODiscount>" + Invoice.TotalPPODiscount.ToString("c") + "</TotalPPODiscount>");
            xml.Append("<TotalCostMinusPPODiscounts>" + (Invoice.TotalCost - Invoice.TotalPPODiscount).ToString("c") + "</TotalCostMinusPPODiscounts>");
            xml.Append("<DepositPaid>" + Invoice.DepositPaid.ToString("c") + "</DepositPaid>");
            xml.Append("<PrincipalPaid>" + Invoice.PrincipalPaid.ToString("c") + "</PrincipalPaid>");
            xml.Append("<AdditionalDeductions>" + Invoice.AdditionalDeductions.ToString("c") + "</AdditionalDeductions>");
            xml.Append("<CumulativeServiceFee>" + Math.Abs(Invoice.CalculatedCumulativeInterest - Invoice.ServiceFeeReceived).ToString("c") + "</CumulativeServiceFee>");
            xml.Append("<ServiceFeeReceived>" + Invoice.ServiceFeeReceived.ToString("c") + "</ServiceFeeReceived>");
            xml.Append("<EndingBalance>" + Invoice.EndingBalance.ToString("c") + "</EndingBalance>");
            #endregion

            #region Payment Comments
            //xml.Append("<Comments>");
            //foreach (var comment in (from c in Invoice.PaymentComments where c.Active orderby c.DateAdded select c))
            //{
            //    xml.Append("<Comment>");
            //    {
            //        xml.Append("<Date>" + comment.DateAdded.ToString("MM/dd/yyyy") + "</Date>");
            //        xml.Append("<Text>" + Server.HtmlEncode(comment.Text) + "</Text>");
            //    }
            //    xml.Append("</Comment>");
            //}
            //xml.Append("</Comments>");
            #endregion

            xml.Append("</Details>");
            return xml.ToString();
        }
    }
}