namespace BMM.Reports
{
    partial class AttorneyLetterAllInvoice
    {
        #region Component Designer generated code
        /// <summary>
        /// Required method for telerik Reporting designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(AttorneyLetterAllInvoice));
            Telerik.Reporting.Group group1 = new Telerik.Reporting.Group();
            Telerik.Reporting.ReportParameter reportParameter1 = new Telerik.Reporting.ReportParameter();
            Telerik.Reporting.ReportParameter reportParameter2 = new Telerik.Reporting.ReportParameter();
            Telerik.Reporting.ReportParameter reportParameter3 = new Telerik.Reporting.ReportParameter();
            Telerik.Reporting.ReportParameter reportParameter4 = new Telerik.Reporting.ReportParameter();
            Telerik.Reporting.ReportParameter reportParameter5 = new Telerik.Reporting.ReportParameter();
            Telerik.Reporting.Drawing.StyleRule styleRule1 = new Telerik.Reporting.Drawing.StyleRule();
            Telerik.Reporting.Drawing.StyleRule styleRule2 = new Telerik.Reporting.Drawing.StyleRule();
            Telerik.Reporting.Drawing.StyleRule styleRule3 = new Telerik.Reporting.Drawing.StyleRule();
            Telerik.Reporting.Drawing.StyleRule styleRule4 = new Telerik.Reporting.Drawing.StyleRule();
            this.groupFooterSection = new Telerik.Reporting.GroupFooterSection();
            this.groupHeaderSection = new Telerik.Reporting.GroupHeaderSection();
            this.htmlTextBox1 = new Telerik.Reporting.HtmlTextBox();
            this.htmlTextBox2 = new Telerik.Reporting.HtmlTextBox();
            this.htmlTextBox3 = new Telerik.Reporting.HtmlTextBox();
            this.htmlTextBox5 = new Telerik.Reporting.HtmlTextBox();
            this.htmlTextBox6 = new Telerik.Reporting.HtmlTextBox();
            this.htmlTextBox7 = new Telerik.Reporting.HtmlTextBox();
            this.htmlTextBox8 = new Telerik.Reporting.HtmlTextBox();
            this.htmlTextBox9 = new Telerik.Reporting.HtmlTextBox();
            this.htmlTextBox14 = new Telerik.Reporting.HtmlTextBox();
            this.htmlTextBox13 = new Telerik.Reporting.HtmlTextBox();
            this.htmlTextBox12 = new Telerik.Reporting.HtmlTextBox();
            this.htmlTextBox11 = new Telerik.Reporting.HtmlTextBox();
            this.htmlTextBox10 = new Telerik.Reporting.HtmlTextBox();
            this.BMMDataSource1 = new Telerik.Reporting.SqlDataSource();
            this.pageFooter = new Telerik.Reporting.PageFooterSection();
            this.currentTimeTextBox = new Telerik.Reporting.TextBox();
            this.pageInfoTextBox = new Telerik.Reporting.TextBox();
            this.detail = new Telerik.Reporting.DetailSection();
            this.pageHeaderSection1 = new Telerik.Reporting.PageHeaderSection();
            ((System.ComponentModel.ISupportInitialize)(this)).BeginInit();
            // 
            // groupFooterSection
            // 
            this.groupFooterSection.Height = Telerik.Reporting.Drawing.Unit.Inch(0.07283782958984375D);
            this.groupFooterSection.Name = "groupFooterSection";
            this.groupFooterSection.Style.Visible = false;
            // 
            // groupHeaderSection
            // 
            this.groupHeaderSection.Height = Telerik.Reporting.Drawing.Unit.Inch(6.1997623443603516D);
            this.groupHeaderSection.Items.AddRange(new Telerik.Reporting.ReportItemBase[] {
            this.htmlTextBox1,
            this.htmlTextBox2,
            this.htmlTextBox3,
            this.htmlTextBox5,
            this.htmlTextBox6,
            this.htmlTextBox7,
            this.htmlTextBox8,
            this.htmlTextBox9,
            this.htmlTextBox14,
            this.htmlTextBox13,
            this.htmlTextBox12,
            this.htmlTextBox11,
            this.htmlTextBox10});
            this.groupHeaderSection.Name = "groupHeaderSection";
            this.groupHeaderSection.PageBreak = ((Telerik.Reporting.PageBreak)((Telerik.Reporting.PageBreak.Before | Telerik.Reporting.PageBreak.After)));
            this.groupHeaderSection.Style.Font.Bold = false;
            // 
            // htmlTextBox1
            // 
            this.htmlTextBox1.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(0.0416666679084301D), Telerik.Reporting.Drawing.Unit.Inch(0.19999997317790985D));
            this.htmlTextBox1.Name = "htmlTextBox1";
            this.htmlTextBox1.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(3.2791664600372314D), Telerik.Reporting.Drawing.Unit.Inch(0.2996830940246582D));
            this.htmlTextBox1.Value = "=Now().ToShortDateString()";
            // 
            // htmlTextBox2
            // 
            this.htmlTextBox2.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(0.02083333395421505D), Telerik.Reporting.Drawing.Unit.Inch(1.1000000238418579D));
            this.htmlTextBox2.Name = "htmlTextBox2";
            this.htmlTextBox2.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(6.8791666030883789D), Telerik.Reporting.Drawing.Unit.Inch(0.20023824274539948D));
            this.htmlTextBox2.Value = "= Replace(Fields.AttorneyFirstName, \"&\", \"&amp;\") + \" \" + Replace(Fields.Attorney" +
    "LastName, \"&\", \"&amp;\")";
            // 
            // htmlTextBox3
            // 
            this.htmlTextBox3.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(0.020793914794921875D), Telerik.Reporting.Drawing.Unit.Inch(1.3002382516860962D));
            this.htmlTextBox3.Name = "htmlTextBox3";
            this.htmlTextBox3.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(3.2999606132507324D), Telerik.Reporting.Drawing.Unit.Inch(0.19992136955261231D));
            this.htmlTextBox3.Value = "=Fields.AttorneyAddress1 + Fields.AttorneyAddress2";
            // 
            // htmlTextBox5
            // 
            this.htmlTextBox5.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(0.02083333395421505D), Telerik.Reporting.Drawing.Unit.Inch(1.5002384185791016D));
            this.htmlTextBox5.Name = "htmlTextBox5";
            this.htmlTextBox5.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(3.3000001907348633D), Telerik.Reporting.Drawing.Unit.Inch(0.20000012218952179D));
            this.htmlTextBox5.Value = "=Fields.AttorneyCity + \", \"+ Fields.AttorneyState + \" \" + Fields.AttorneyZipCode";
            // 
            // htmlTextBox6
            // 
            this.htmlTextBox6.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(0.0416666679084301D), Telerik.Reporting.Drawing.Unit.Inch(2.5999999046325684D));
            this.htmlTextBox6.Name = "htmlTextBox6";
            this.htmlTextBox6.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.1999998092651367D), Telerik.Reporting.Drawing.Unit.Inch(0.29976338148117065D));
            this.htmlTextBox6.Value = "Dear Attorney,";
            // 
            // htmlTextBox7
            // 
            this.htmlTextBox7.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(0.02083333395421505D), Telerik.Reporting.Drawing.Unit.Inch(2.8999996185302734D));
            this.htmlTextBox7.Name = "htmlTextBox7";
            this.htmlTextBox7.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(6.8791670799255371D), Telerik.Reporting.Drawing.Unit.Inch(0.69992130994796753D));
            this.htmlTextBox7.Value = resources.GetString("htmlTextBox7.Value");
            // 
            // htmlTextBox8
            // 
            this.htmlTextBox8.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(0.0416666679084301D), Telerik.Reporting.Drawing.Unit.Inch(3.5999996662139893D));
            this.htmlTextBox8.Name = "htmlTextBox8";
            this.htmlTextBox8.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(6.8583335876464844D), Telerik.Reporting.Drawing.Unit.Inch(0.49992117285728455D));
            this.htmlTextBox8.Value = null;
            // 
            // htmlTextBox9
            // 
            this.htmlTextBox9.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(0.0416666679084301D), Telerik.Reporting.Drawing.Unit.Inch(4.099998950958252D));
            this.htmlTextBox9.Name = "htmlTextBox9";
            this.htmlTextBox9.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(6.4791274070739746D), Telerik.Reporting.Drawing.Unit.Inch(0.29992103576660156D));
            this.htmlTextBox9.Value = "<span style=\"font-size: 9.75pt; font-family: arial; font-weight: 400; color: #000" +
    "000; font-style: normal; text-decoration: none\">Thank you for your continued coo" +
    "peration and your patronage.</span>";
            // 
            // htmlTextBox14
            // 
            this.htmlTextBox14.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(0.02083333395421505D), Telerik.Reporting.Drawing.Unit.Inch(5.89984130859375D));
            this.htmlTextBox14.Name = "htmlTextBox14";
            this.htmlTextBox14.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(6.4999604225158691D), Telerik.Reporting.Drawing.Unit.Inch(0.29992103576660156D));
            this.htmlTextBox14.Value = "<span style=\"font-size: 9.75pt; font-family: arial; font-weight: 400; color: #000" +
    "000; font-style: normal; text-decoration: none\">PLEASE CALL FOR YOUR PAYOFF QUOT" +
    "E.</span>";
            // 
            // htmlTextBox13
            // 
            this.htmlTextBox13.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(0.0416666679084301D), Telerik.Reporting.Drawing.Unit.Inch(5.5999999046325684D));
            this.htmlTextBox13.Name = "htmlTextBox13";
            this.htmlTextBox13.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(6.4791269302368164D), Telerik.Reporting.Drawing.Unit.Inch(0.29976272583007812D));
            this.htmlTextBox13.Value = resources.GetString("htmlTextBox13.Value");
            // 
            // htmlTextBox12
            // 
            this.htmlTextBox12.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(0.02083333395421505D), Telerik.Reporting.Drawing.Unit.Inch(4.9999995231628418D));
            this.htmlTextBox12.Name = "htmlTextBox12";
            this.htmlTextBox12.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.5791664123535156D), Telerik.Reporting.Drawing.Unit.Inch(0.40000024437904358D));
            this.htmlTextBox12.Value = "{Parameters.Position.Value}";
            // 
            // htmlTextBox11
            // 
            this.htmlTextBox11.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(0.02083333395421505D), Telerik.Reporting.Drawing.Unit.Inch(4.7999997138977051D));
            this.htmlTextBox11.Name = "htmlTextBox11";
            this.htmlTextBox11.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.5791664123535156D), Telerik.Reporting.Drawing.Unit.Inch(0.20000012218952179D));
            this.htmlTextBox11.Value = "{Parameters.FirstName.Value}&nbsp; {Parameters.LastName.Value}";
            // 
            // htmlTextBox10
            // 
            this.htmlTextBox10.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(0.02083333395421505D), Telerik.Reporting.Drawing.Unit.Inch(4.3999996185302734D));
            this.htmlTextBox10.Name = "htmlTextBox10";
            this.htmlTextBox10.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.1999999284744263D), Telerik.Reporting.Drawing.Unit.Inch(0.40000024437904358D));
            this.htmlTextBox10.Value = "<span style=\"font-size: 9.75pt; font-family: arial; font-weight: 400; color: #000" +
    "000; font-style: normal; text-decoration: none\">Sincerly,</span>";
            // 
            // BMMDataSource1
            // 
            this.BMMDataSource1.ConnectionString = "BMMConnectionString";
            this.BMMDataSource1.Name = "BMMDataSource1";
            this.BMMDataSource1.Parameters.AddRange(new Telerik.Reporting.SqlDataSourceParameter[] {
            new Telerik.Reporting.SqlDataSourceParameter("@CompanyId", System.Data.DbType.Int32, "=Parameters.CompanyId.Value"),
            new Telerik.Reporting.SqlDataSourceParameter("@AttorneyId", System.Data.DbType.Int32, "=Parameters.AttorneyId.Value")});
            this.BMMDataSource1.ProviderName = "System.Data.SqlClient";
            this.BMMDataSource1.SelectCommand = "dbo.procAttorneyLetter";
            this.BMMDataSource1.SelectCommandType = Telerik.Reporting.SqlDataSourceCommandType.StoredProcedure;
            // 
            // pageFooter
            // 
            this.pageFooter.Height = Telerik.Reporting.Drawing.Unit.Inch(0.44166669249534607D);
            this.pageFooter.Items.AddRange(new Telerik.Reporting.ReportItemBase[] {
            this.currentTimeTextBox,
            this.pageInfoTextBox});
            this.pageFooter.Name = "pageFooter";
            // 
            // currentTimeTextBox
            // 
            this.currentTimeTextBox.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(0.02083333395421505D), Telerik.Reporting.Drawing.Unit.Inch(0.02083333395421505D));
            this.currentTimeTextBox.Name = "currentTimeTextBox";
            this.currentTimeTextBox.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(3.1979167461395264D), Telerik.Reporting.Drawing.Unit.Inch(0.40000000596046448D));
            this.currentTimeTextBox.StyleName = "PageInfo";
            this.currentTimeTextBox.Value = "=NOW()";
            // 
            // pageInfoTextBox
            // 
            this.pageInfoTextBox.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(3.7020835876464844D), Telerik.Reporting.Drawing.Unit.Inch(0.02083333395421505D));
            this.pageInfoTextBox.Name = "pageInfoTextBox";
            this.pageInfoTextBox.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(3.1979167461395264D), Telerik.Reporting.Drawing.Unit.Inch(0.40000000596046448D));
            this.pageInfoTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right;
            this.pageInfoTextBox.StyleName = "PageInfo";
            this.pageInfoTextBox.Value = "=PageNumber + \" of \" + PageCount";
            // 
            // detail
            // 
            this.detail.Height = Telerik.Reporting.Drawing.Unit.Inch(0.0520833283662796D);
            this.detail.Name = "detail";
            this.detail.Style.Visible = false;
            // 
            // pageHeaderSection1
            // 
            this.pageHeaderSection1.Height = Telerik.Reporting.Drawing.Unit.Inch(0.5D);
            this.pageHeaderSection1.Name = "pageHeaderSection1";
            // 
            // AttorneyLetterAllInvoice
            // 
            this.DataSource = this.BMMDataSource1;
            this.DocumentName = "=\"AttorneyLetters_\" + ExecutionTime.ToString(\"yyyyMMdd-hhmmss\")";
            group1.GroupFooter = this.groupFooterSection;
            group1.GroupHeader = this.groupHeaderSection;
            group1.Groupings.Add(new Telerik.Reporting.Grouping("=Fields.AttorneyDisplayName"));
            group1.GroupKeepTogether = Telerik.Reporting.GroupKeepTogether.All;
            group1.Name = "DisplayName";
            group1.Sortings.Add(new Telerik.Reporting.Sorting("=Fields.AttorneyLastName", Telerik.Reporting.SortDirection.Asc));
            this.Groups.AddRange(new Telerik.Reporting.Group[] {
            group1});
            this.Items.AddRange(new Telerik.Reporting.ReportItemBase[] {
            this.groupHeaderSection,
            this.groupFooterSection,
            this.pageFooter,
            this.detail,
            this.pageHeaderSection1});
            this.Name = "AttorneyLetterAllInvoice";
            this.PageSettings.Landscape = false;
            this.PageSettings.Margins = new Telerik.Reporting.Drawing.MarginsU(Telerik.Reporting.Drawing.Unit.Inch(1D), Telerik.Reporting.Drawing.Unit.Inch(0.5D), Telerik.Reporting.Drawing.Unit.Inch(1D), Telerik.Reporting.Drawing.Unit.Inch(1D));
            this.PageSettings.PaperKind = System.Drawing.Printing.PaperKind.Letter;
            reportParameter1.Name = "Position";
            reportParameter2.Name = "FirstName";
            reportParameter3.Name = "LastName";
            reportParameter4.Name = "CompanyId";
            reportParameter4.Text = "CompanyId";
            reportParameter4.Type = Telerik.Reporting.ReportParameterType.Integer;
            reportParameter5.Name = "AttorneyId";
            reportParameter5.Text = "AttorneyId";
            reportParameter5.Type = Telerik.Reporting.ReportParameterType.Integer;
            this.ReportParameters.Add(reportParameter1);
            this.ReportParameters.Add(reportParameter2);
            this.ReportParameters.Add(reportParameter3);
            this.ReportParameters.Add(reportParameter4);
            this.ReportParameters.Add(reportParameter5);
            this.Style.BackgroundColor = System.Drawing.Color.White;
            styleRule1.Selectors.AddRange(new Telerik.Reporting.Drawing.ISelector[] {
            new Telerik.Reporting.Drawing.StyleSelector("Title")});
            styleRule1.Style.Color = System.Drawing.Color.Black;
            styleRule1.Style.Font.Bold = true;
            styleRule1.Style.Font.Italic = false;
            styleRule1.Style.Font.Name = "Tahoma";
            styleRule1.Style.Font.Size = Telerik.Reporting.Drawing.Unit.Point(18D);
            styleRule1.Style.Font.Strikeout = false;
            styleRule1.Style.Font.Underline = false;
            styleRule2.Selectors.AddRange(new Telerik.Reporting.Drawing.ISelector[] {
            new Telerik.Reporting.Drawing.StyleSelector("Caption")});
            styleRule2.Style.Color = System.Drawing.Color.Black;
            styleRule2.Style.Font.Name = "Tahoma";
            styleRule2.Style.Font.Size = Telerik.Reporting.Drawing.Unit.Point(10D);
            styleRule2.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle;
            styleRule3.Selectors.AddRange(new Telerik.Reporting.Drawing.ISelector[] {
            new Telerik.Reporting.Drawing.StyleSelector("Data")});
            styleRule3.Style.Font.Name = "Tahoma";
            styleRule3.Style.Font.Size = Telerik.Reporting.Drawing.Unit.Point(9D);
            styleRule3.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle;
            styleRule4.Selectors.AddRange(new Telerik.Reporting.Drawing.ISelector[] {
            new Telerik.Reporting.Drawing.StyleSelector("PageInfo")});
            styleRule4.Style.Font.Name = "Tahoma";
            styleRule4.Style.Font.Size = Telerik.Reporting.Drawing.Unit.Point(8D);
            styleRule4.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle;
            this.StyleSheet.AddRange(new Telerik.Reporting.Drawing.StyleRule[] {
            styleRule1,
            styleRule2,
            styleRule3,
            styleRule4});
            this.Width = Telerik.Reporting.Drawing.Unit.Inch(6.9000000953674316D);
            ((System.ComponentModel.ISupportInitialize)(this)).EndInit();

        }
        #endregion

        private Telerik.Reporting.SqlDataSource BMMDataSource1;
        private Telerik.Reporting.PageFooterSection pageFooter;
        private Telerik.Reporting.TextBox currentTimeTextBox;
        private Telerik.Reporting.TextBox pageInfoTextBox;
        private Telerik.Reporting.DetailSection detail;
        private Telerik.Reporting.GroupHeaderSection groupHeaderSection;
        private Telerik.Reporting.GroupFooterSection groupFooterSection;
        private Telerik.Reporting.HtmlTextBox htmlTextBox1;
        private Telerik.Reporting.HtmlTextBox htmlTextBox2;
        private Telerik.Reporting.HtmlTextBox htmlTextBox3;
        private Telerik.Reporting.HtmlTextBox htmlTextBox5;
        private Telerik.Reporting.HtmlTextBox htmlTextBox6;
        private Telerik.Reporting.HtmlTextBox htmlTextBox7;
        private Telerik.Reporting.HtmlTextBox htmlTextBox8;
        private Telerik.Reporting.HtmlTextBox htmlTextBox9;
        private Telerik.Reporting.HtmlTextBox htmlTextBox14;
        private Telerik.Reporting.HtmlTextBox htmlTextBox13;
        private Telerik.Reporting.HtmlTextBox htmlTextBox12;
        private Telerik.Reporting.HtmlTextBox htmlTextBox11;
        private Telerik.Reporting.HtmlTextBox htmlTextBox10;
        private Telerik.Reporting.PageHeaderSection pageHeaderSection1;

    }
}