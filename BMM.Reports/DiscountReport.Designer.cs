namespace BMM.Reports
{
    partial class DiscountReport
    {
        #region Component Designer generated code
        /// <summary>
        /// Required method for telerik Reporting designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            Telerik.Reporting.Group group1 = new Telerik.Reporting.Group();
            Telerik.Reporting.ReportParameter reportParameter1 = new Telerik.Reporting.ReportParameter();
            Telerik.Reporting.ReportParameter reportParameter2 = new Telerik.Reporting.ReportParameter();
            Telerik.Reporting.ReportParameter reportParameter3 = new Telerik.Reporting.ReportParameter();
            Telerik.Reporting.ReportParameter reportParameter4 = new Telerik.Reporting.ReportParameter();
            Telerik.Reporting.Drawing.StyleRule styleRule1 = new Telerik.Reporting.Drawing.StyleRule();
            Telerik.Reporting.Drawing.StyleRule styleRule2 = new Telerik.Reporting.Drawing.StyleRule();
            Telerik.Reporting.Drawing.StyleRule styleRule3 = new Telerik.Reporting.Drawing.StyleRule();
            Telerik.Reporting.Drawing.StyleRule styleRule4 = new Telerik.Reporting.Drawing.StyleRule();
            this.labelsGroupFooterSection = new Telerik.Reporting.GroupFooterSection();
            this.labelsGroupHeaderSection = new Telerik.Reporting.GroupHeaderSection();
            this.firmNameCaptionTextBox = new Telerik.Reporting.TextBox();
            this.attorneyNameCaptionTextBox = new Telerik.Reporting.TextBox();
            this.totalPrincipalDueCaptionTextBox = new Telerik.Reporting.TextBox();
            this.principalWaivedCaptionTextBox = new Telerik.Reporting.TextBox();
            this.totalServiceFeeDueCaptionTextBox = new Telerik.Reporting.TextBox();
            this.serviceFeeWaivedCaptionTextBox = new Telerik.Reporting.TextBox();
            this.totalAmountDueCaptionTextBox = new Telerik.Reporting.TextBox();
            this.totalAmountWaviedCaptionTextBox = new Telerik.Reporting.TextBox();
            this.discountReportSqlDataSource = new Telerik.Reporting.SqlDataSource();
            this.reportFooter = new Telerik.Reporting.ReportFooterSection();
            this.totalPrincipalDueSumFunctionTextBox = new Telerik.Reporting.TextBox();
            this.principalWaivedSumFunctionTextBox = new Telerik.Reporting.TextBox();
            this.totalServiceFeeDueSumFunctionTextBox = new Telerik.Reporting.TextBox();
            this.serviceFeeWaivedSumFunctionTextBox = new Telerik.Reporting.TextBox();
            this.totalAmountDueSumFunctionTextBox = new Telerik.Reporting.TextBox();
            this.totalAmountWaivedSumFunctionTextBox = new Telerik.Reporting.TextBox();
            this.textBox4 = new Telerik.Reporting.TextBox();
            this.shape1 = new Telerik.Reporting.Shape();
            this.pageHeader = new Telerik.Reporting.PageHeaderSection();
            this.titleTextBox = new Telerik.Reporting.TextBox();
            this.textBox5 = new Telerik.Reporting.TextBox();
            this.textBox6 = new Telerik.Reporting.TextBox();
            this.textBox7 = new Telerik.Reporting.TextBox();
            this.textBox8 = new Telerik.Reporting.TextBox();
            this.textBox9 = new Telerik.Reporting.TextBox();
            this.textBox10 = new Telerik.Reporting.TextBox();
            this.detail = new Telerik.Reporting.DetailSection();
            this.firmNameDataTextBox = new Telerik.Reporting.TextBox();
            this.attorneyNameDataTextBox = new Telerik.Reporting.TextBox();
            this.totalPrincipalDueDataTextBox = new Telerik.Reporting.TextBox();
            this.principalWaivedDataTextBox = new Telerik.Reporting.TextBox();
            this.totalServiceFeeDueDataTextBox = new Telerik.Reporting.TextBox();
            this.serviceFeeWaivedDataTextBox = new Telerik.Reporting.TextBox();
            this.totalAmountDueDataTextBox = new Telerik.Reporting.TextBox();
            this.totalAmountWaivedDataTextBox = new Telerik.Reporting.TextBox();
            ((System.ComponentModel.ISupportInitialize)(this)).BeginInit();
            // 
            // labelsGroupFooterSection
            // 
            this.labelsGroupFooterSection.Height = Telerik.Reporting.Drawing.Unit.Inch(0.052D);
            this.labelsGroupFooterSection.Name = "labelsGroupFooterSection";
            this.labelsGroupFooterSection.Style.Visible = false;
            // 
            // labelsGroupHeaderSection
            // 
            this.labelsGroupHeaderSection.Height = Telerik.Reporting.Drawing.Unit.Inch(0.325D);
            this.labelsGroupHeaderSection.Items.AddRange(new Telerik.Reporting.ReportItemBase[] {
            this.firmNameCaptionTextBox,
            this.attorneyNameCaptionTextBox,
            this.totalPrincipalDueCaptionTextBox,
            this.principalWaivedCaptionTextBox,
            this.totalServiceFeeDueCaptionTextBox,
            this.serviceFeeWaivedCaptionTextBox,
            this.totalAmountDueCaptionTextBox,
            this.totalAmountWaviedCaptionTextBox});
            this.labelsGroupHeaderSection.Name = "labelsGroupHeaderSection";
            this.labelsGroupHeaderSection.PrintOnEveryPage = true;
            // 
            // firmNameCaptionTextBox
            // 
            this.firmNameCaptionTextBox.CanGrow = true;
            this.firmNameCaptionTextBox.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(0D), Telerik.Reporting.Drawing.Unit.Inch(0.021D));
            this.firmNameCaptionTextBox.Name = "firmNameCaptionTextBox";
            this.firmNameCaptionTextBox.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.4D), Telerik.Reporting.Drawing.Unit.Inch(0.279D));
            this.firmNameCaptionTextBox.Style.BorderStyle.Bottom = Telerik.Reporting.Drawing.BorderType.Solid;
            this.firmNameCaptionTextBox.Style.BorderStyle.Top = Telerik.Reporting.Drawing.BorderType.Solid;
            this.firmNameCaptionTextBox.Style.BorderWidth.Bottom = Telerik.Reporting.Drawing.Unit.Pixel(1D);
            this.firmNameCaptionTextBox.Style.BorderWidth.Top = Telerik.Reporting.Drawing.Unit.Pixel(1D);
            this.firmNameCaptionTextBox.Style.Font.Bold = true;
            this.firmNameCaptionTextBox.Style.Padding.Top = Telerik.Reporting.Drawing.Unit.Pixel(5D);
            this.firmNameCaptionTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Left;
            this.firmNameCaptionTextBox.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Top;
            this.firmNameCaptionTextBox.StyleName = "Caption";
            this.firmNameCaptionTextBox.Value = "Firm";
            // 
            // attorneyNameCaptionTextBox
            // 
            this.attorneyNameCaptionTextBox.CanGrow = true;
            this.attorneyNameCaptionTextBox.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(1.4D), Telerik.Reporting.Drawing.Unit.Inch(0.021D));
            this.attorneyNameCaptionTextBox.Name = "attorneyNameCaptionTextBox";
            this.attorneyNameCaptionTextBox.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.4D), Telerik.Reporting.Drawing.Unit.Inch(0.279D));
            this.attorneyNameCaptionTextBox.Style.BorderStyle.Bottom = Telerik.Reporting.Drawing.BorderType.Solid;
            this.attorneyNameCaptionTextBox.Style.BorderStyle.Top = Telerik.Reporting.Drawing.BorderType.Solid;
            this.attorneyNameCaptionTextBox.Style.BorderWidth.Bottom = Telerik.Reporting.Drawing.Unit.Pixel(1D);
            this.attorneyNameCaptionTextBox.Style.BorderWidth.Top = Telerik.Reporting.Drawing.Unit.Pixel(1D);
            this.attorneyNameCaptionTextBox.Style.Font.Bold = true;
            this.attorneyNameCaptionTextBox.Style.Padding.Top = Telerik.Reporting.Drawing.Unit.Pixel(5D);
            this.attorneyNameCaptionTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Left;
            this.attorneyNameCaptionTextBox.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Top;
            this.attorneyNameCaptionTextBox.StyleName = "Caption";
            this.attorneyNameCaptionTextBox.Value = "Attorney";
            // 
            // totalPrincipalDueCaptionTextBox
            // 
            this.totalPrincipalDueCaptionTextBox.CanGrow = true;
            this.totalPrincipalDueCaptionTextBox.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(2.8D), Telerik.Reporting.Drawing.Unit.Inch(0.021D));
            this.totalPrincipalDueCaptionTextBox.Name = "totalPrincipalDueCaptionTextBox";
            this.totalPrincipalDueCaptionTextBox.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.265D), Telerik.Reporting.Drawing.Unit.Inch(0.279D));
            this.totalPrincipalDueCaptionTextBox.Style.BorderStyle.Bottom = Telerik.Reporting.Drawing.BorderType.Solid;
            this.totalPrincipalDueCaptionTextBox.Style.BorderStyle.Top = Telerik.Reporting.Drawing.BorderType.Solid;
            this.totalPrincipalDueCaptionTextBox.Style.BorderWidth.Bottom = Telerik.Reporting.Drawing.Unit.Pixel(1D);
            this.totalPrincipalDueCaptionTextBox.Style.BorderWidth.Top = Telerik.Reporting.Drawing.Unit.Pixel(1D);
            this.totalPrincipalDueCaptionTextBox.Style.Font.Bold = true;
            this.totalPrincipalDueCaptionTextBox.Style.Padding.Top = Telerik.Reporting.Drawing.Unit.Pixel(5D);
            this.totalPrincipalDueCaptionTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right;
            this.totalPrincipalDueCaptionTextBox.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Top;
            this.totalPrincipalDueCaptionTextBox.StyleName = "Caption";
            this.totalPrincipalDueCaptionTextBox.Value = "Total Principal Due";
            // 
            // principalWaivedCaptionTextBox
            // 
            this.principalWaivedCaptionTextBox.CanGrow = true;
            this.principalWaivedCaptionTextBox.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(4.065D), Telerik.Reporting.Drawing.Unit.Inch(0.021D));
            this.principalWaivedCaptionTextBox.Name = "principalWaivedCaptionTextBox";
            this.principalWaivedCaptionTextBox.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.265D), Telerik.Reporting.Drawing.Unit.Inch(0.279D));
            this.principalWaivedCaptionTextBox.Style.BorderStyle.Bottom = Telerik.Reporting.Drawing.BorderType.Solid;
            this.principalWaivedCaptionTextBox.Style.BorderStyle.Top = Telerik.Reporting.Drawing.BorderType.Solid;
            this.principalWaivedCaptionTextBox.Style.BorderWidth.Bottom = Telerik.Reporting.Drawing.Unit.Pixel(1D);
            this.principalWaivedCaptionTextBox.Style.BorderWidth.Top = Telerik.Reporting.Drawing.Unit.Pixel(1D);
            this.principalWaivedCaptionTextBox.Style.Font.Bold = true;
            this.principalWaivedCaptionTextBox.Style.Padding.Top = Telerik.Reporting.Drawing.Unit.Pixel(5D);
            this.principalWaivedCaptionTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right;
            this.principalWaivedCaptionTextBox.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Top;
            this.principalWaivedCaptionTextBox.StyleName = "Caption";
            this.principalWaivedCaptionTextBox.Value = "Principal Waived";
            // 
            // totalServiceFeeDueCaptionTextBox
            // 
            this.totalServiceFeeDueCaptionTextBox.CanGrow = true;
            this.totalServiceFeeDueCaptionTextBox.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(5.33D), Telerik.Reporting.Drawing.Unit.Inch(0.021D));
            this.totalServiceFeeDueCaptionTextBox.Name = "totalServiceFeeDueCaptionTextBox";
            this.totalServiceFeeDueCaptionTextBox.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.335D), Telerik.Reporting.Drawing.Unit.Inch(0.279D));
            this.totalServiceFeeDueCaptionTextBox.Style.BorderStyle.Bottom = Telerik.Reporting.Drawing.BorderType.Solid;
            this.totalServiceFeeDueCaptionTextBox.Style.BorderStyle.Top = Telerik.Reporting.Drawing.BorderType.Solid;
            this.totalServiceFeeDueCaptionTextBox.Style.BorderWidth.Bottom = Telerik.Reporting.Drawing.Unit.Pixel(1D);
            this.totalServiceFeeDueCaptionTextBox.Style.BorderWidth.Top = Telerik.Reporting.Drawing.Unit.Pixel(1D);
            this.totalServiceFeeDueCaptionTextBox.Style.Font.Bold = true;
            this.totalServiceFeeDueCaptionTextBox.Style.Padding.Top = Telerik.Reporting.Drawing.Unit.Pixel(5D);
            this.totalServiceFeeDueCaptionTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right;
            this.totalServiceFeeDueCaptionTextBox.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Top;
            this.totalServiceFeeDueCaptionTextBox.StyleName = "Caption";
            this.totalServiceFeeDueCaptionTextBox.Value = "Total Interest Due";
            // 
            // serviceFeeWaivedCaptionTextBox
            // 
            this.serviceFeeWaivedCaptionTextBox.CanGrow = true;
            this.serviceFeeWaivedCaptionTextBox.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(6.665D), Telerik.Reporting.Drawing.Unit.Inch(0.021D));
            this.serviceFeeWaivedCaptionTextBox.Name = "serviceFeeWaivedCaptionTextBox";
            this.serviceFeeWaivedCaptionTextBox.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.265D), Telerik.Reporting.Drawing.Unit.Inch(0.279D));
            this.serviceFeeWaivedCaptionTextBox.Style.BorderStyle.Bottom = Telerik.Reporting.Drawing.BorderType.Solid;
            this.serviceFeeWaivedCaptionTextBox.Style.BorderStyle.Top = Telerik.Reporting.Drawing.BorderType.Solid;
            this.serviceFeeWaivedCaptionTextBox.Style.BorderWidth.Bottom = Telerik.Reporting.Drawing.Unit.Pixel(1D);
            this.serviceFeeWaivedCaptionTextBox.Style.BorderWidth.Top = Telerik.Reporting.Drawing.Unit.Pixel(1D);
            this.serviceFeeWaivedCaptionTextBox.Style.Font.Bold = true;
            this.serviceFeeWaivedCaptionTextBox.Style.Padding.Top = Telerik.Reporting.Drawing.Unit.Pixel(5D);
            this.serviceFeeWaivedCaptionTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right;
            this.serviceFeeWaivedCaptionTextBox.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Top;
            this.serviceFeeWaivedCaptionTextBox.StyleName = "Caption";
            this.serviceFeeWaivedCaptionTextBox.Value = "Interest Waived";
            // 
            // totalAmountDueCaptionTextBox
            // 
            this.totalAmountDueCaptionTextBox.CanGrow = true;
            this.totalAmountDueCaptionTextBox.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(9.266D), Telerik.Reporting.Drawing.Unit.Inch(0.021D));
            this.totalAmountDueCaptionTextBox.Name = "totalAmountDueCaptionTextBox";
            this.totalAmountDueCaptionTextBox.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.234D), Telerik.Reporting.Drawing.Unit.Inch(0.279D));
            this.totalAmountDueCaptionTextBox.Style.BorderStyle.Bottom = Telerik.Reporting.Drawing.BorderType.Solid;
            this.totalAmountDueCaptionTextBox.Style.BorderStyle.Top = Telerik.Reporting.Drawing.BorderType.Solid;
            this.totalAmountDueCaptionTextBox.Style.BorderWidth.Bottom = Telerik.Reporting.Drawing.Unit.Pixel(1D);
            this.totalAmountDueCaptionTextBox.Style.BorderWidth.Top = Telerik.Reporting.Drawing.Unit.Pixel(1D);
            this.totalAmountDueCaptionTextBox.Style.Font.Bold = true;
            this.totalAmountDueCaptionTextBox.Style.Padding.Top = Telerik.Reporting.Drawing.Unit.Pixel(5D);
            this.totalAmountDueCaptionTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right;
            this.totalAmountDueCaptionTextBox.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Top;
            this.totalAmountDueCaptionTextBox.StyleName = "Caption";
            this.totalAmountDueCaptionTextBox.Value = "Total Amount Due";
            // 
            // totalAmountWaviedCaptionTextBox
            // 
            this.totalAmountWaviedCaptionTextBox.CanGrow = true;
            this.totalAmountWaviedCaptionTextBox.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(7.931D), Telerik.Reporting.Drawing.Unit.Inch(0.021D));
            this.totalAmountWaviedCaptionTextBox.Name = "totalAmountWaviedCaptionTextBox";
            this.totalAmountWaviedCaptionTextBox.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.335D), Telerik.Reporting.Drawing.Unit.Inch(0.279D));
            this.totalAmountWaviedCaptionTextBox.Style.BorderStyle.Bottom = Telerik.Reporting.Drawing.BorderType.Solid;
            this.totalAmountWaviedCaptionTextBox.Style.BorderStyle.Top = Telerik.Reporting.Drawing.BorderType.Solid;
            this.totalAmountWaviedCaptionTextBox.Style.BorderWidth.Bottom = Telerik.Reporting.Drawing.Unit.Pixel(1D);
            this.totalAmountWaviedCaptionTextBox.Style.BorderWidth.Top = Telerik.Reporting.Drawing.Unit.Pixel(1D);
            this.totalAmountWaviedCaptionTextBox.Style.Font.Bold = true;
            this.totalAmountWaviedCaptionTextBox.Style.Padding.Top = Telerik.Reporting.Drawing.Unit.Pixel(5D);
            this.totalAmountWaviedCaptionTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right;
            this.totalAmountWaviedCaptionTextBox.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Top;
            this.totalAmountWaviedCaptionTextBox.StyleName = "Caption";
            this.totalAmountWaviedCaptionTextBox.Value = "Total Amount Waived";
            // 
            // discountReportSqlDataSource
            // 
            this.discountReportSqlDataSource.CalculatedFields.Add(new Telerik.Reporting.CalculatedField("PercentPrincipalWaived", typeof(decimal), "= IIf(Fields.TotalPrincipalDue <> 0, Fields.PrincipalWaived / IIf(Fields.TotalPri" +
            "ncipalDue <> 0, Fields.TotalPrincipalDue, 1) , 0)"));
            this.discountReportSqlDataSource.CalculatedFields.Add(new Telerik.Reporting.CalculatedField("PercentServiceFeeWaved", typeof(decimal), "= IIf(Fields.TotalServiceFeeDue <> 0, Fields.ServiceFeeWaived / IIf(Fields.TotalS" +
            "erviceFeeDue <> 0, Fields.TotalServiceFeeDue, 1) , 0)"));
            this.discountReportSqlDataSource.CalculatedFields.Add(new Telerik.Reporting.CalculatedField("TotalAmountDue", typeof(decimal), "= Fields.TotalPrincipalDue + Fields.TotalServiceFeeDue - Fields.PrincipalWaived -" +
            " Fields.ServiceFeeWaived - Fields.InterestPayments - Fields.Deductions"));
            this.discountReportSqlDataSource.CalculatedFields.Add(new Telerik.Reporting.CalculatedField("TotalAmountWaived", typeof(decimal), "= Fields.PrincipalWaived + Fields.ServiceFeeWaived"));
            this.discountReportSqlDataSource.CalculatedFields.Add(new Telerik.Reporting.CalculatedField("PercentTotalAmountWaived", typeof(decimal), "= IIf(Fields.TotalAmountDue <> 0, Fields.TotalAmountWaived / IIf(Fields.TotalAmou" +
            "ntDue <> 0, Fields.TotalAmountDue, 1) , 0)"));
            this.discountReportSqlDataSource.CalculatedFields.Add(new Telerik.Reporting.CalculatedField("AttorneyName", typeof(string), "= Fields.AttLastName + \", \" + Fields.AttFirstName"));
            this.discountReportSqlDataSource.ConnectionString = "BMMConnectionString";
            this.discountReportSqlDataSource.Name = "discountReportSqlDataSource";
            this.discountReportSqlDataSource.Parameters.Add(new Telerik.Reporting.SqlDataSourceParameter("@CompanyID", System.Data.DbType.Int32, "=Parameters.CompanyID.Value"));
            this.discountReportSqlDataSource.Parameters.Add(new Telerik.Reporting.SqlDataSourceParameter("@StartDate", System.Data.DbType.Date, "=Parameters.StartDate.Value"));
            this.discountReportSqlDataSource.Parameters.Add(new Telerik.Reporting.SqlDataSourceParameter("@EndDate", System.Data.DbType.Date, "=Parameters.EndDate.Value"));
            this.discountReportSqlDataSource.Parameters.Add(new Telerik.Reporting.SqlDataSourceParameter("@AttorneyID", System.Data.DbType.Int32, "=Parameters.AttorneyID.Value"));
            this.discountReportSqlDataSource.ProviderName = "System.Data.SqlClient";
            this.discountReportSqlDataSource.SelectCommand = "dbo.procDiscountReport";
            this.discountReportSqlDataSource.SelectCommandType = Telerik.Reporting.SqlDataSourceCommandType.StoredProcedure;
            // 
            // reportFooter
            // 
            this.reportFooter.Height = Telerik.Reporting.Drawing.Unit.Inch(0.379D);
            this.reportFooter.Items.AddRange(new Telerik.Reporting.ReportItemBase[] {
            this.totalPrincipalDueSumFunctionTextBox,
            this.principalWaivedSumFunctionTextBox,
            this.totalServiceFeeDueSumFunctionTextBox,
            this.serviceFeeWaivedSumFunctionTextBox,
            this.totalAmountDueSumFunctionTextBox,
            this.totalAmountWaivedSumFunctionTextBox,
            this.textBox4,
            this.shape1});
            this.reportFooter.Name = "reportFooter";
            this.reportFooter.Style.Visible = true;
            // 
            // totalPrincipalDueSumFunctionTextBox
            // 
            this.totalPrincipalDueSumFunctionTextBox.CanGrow = true;
            this.totalPrincipalDueSumFunctionTextBox.Format = "{0:C2}";
            this.totalPrincipalDueSumFunctionTextBox.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(2.8D), Telerik.Reporting.Drawing.Unit.Inch(0.181D));
            this.totalPrincipalDueSumFunctionTextBox.Name = "totalPrincipalDueSumFunctionTextBox";
            this.totalPrincipalDueSumFunctionTextBox.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.265D), Telerik.Reporting.Drawing.Unit.Inch(0.198D));
            this.totalPrincipalDueSumFunctionTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right;
            this.totalPrincipalDueSumFunctionTextBox.StyleName = "Data";
            this.totalPrincipalDueSumFunctionTextBox.Value = "=Sum(Fields.TotalPrincipalDue)";
            // 
            // principalWaivedSumFunctionTextBox
            // 
            this.principalWaivedSumFunctionTextBox.CanGrow = true;
            this.principalWaivedSumFunctionTextBox.Format = "{0:C2}";
            this.principalWaivedSumFunctionTextBox.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(4.065D), Telerik.Reporting.Drawing.Unit.Inch(0.181D));
            this.principalWaivedSumFunctionTextBox.Name = "principalWaivedSumFunctionTextBox";
            this.principalWaivedSumFunctionTextBox.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.265D), Telerik.Reporting.Drawing.Unit.Inch(0.198D));
            this.principalWaivedSumFunctionTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right;
            this.principalWaivedSumFunctionTextBox.StyleName = "Data";
            this.principalWaivedSumFunctionTextBox.Value = "=Sum(Fields.PrincipalWaived)";
            // 
            // totalServiceFeeDueSumFunctionTextBox
            // 
            this.totalServiceFeeDueSumFunctionTextBox.CanGrow = true;
            this.totalServiceFeeDueSumFunctionTextBox.Format = "{0:C2}";
            this.totalServiceFeeDueSumFunctionTextBox.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(5.33D), Telerik.Reporting.Drawing.Unit.Inch(0.181D));
            this.totalServiceFeeDueSumFunctionTextBox.Name = "totalServiceFeeDueSumFunctionTextBox";
            this.totalServiceFeeDueSumFunctionTextBox.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.335D), Telerik.Reporting.Drawing.Unit.Inch(0.198D));
            this.totalServiceFeeDueSumFunctionTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right;
            this.totalServiceFeeDueSumFunctionTextBox.StyleName = "Data";
            this.totalServiceFeeDueSumFunctionTextBox.Value = "=Sum(Fields.TotalServiceFeeDue)";
            // 
            // serviceFeeWaivedSumFunctionTextBox
            // 
            this.serviceFeeWaivedSumFunctionTextBox.CanGrow = true;
            this.serviceFeeWaivedSumFunctionTextBox.Format = "{0:C2}";
            this.serviceFeeWaivedSumFunctionTextBox.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(6.665D), Telerik.Reporting.Drawing.Unit.Inch(0.181D));
            this.serviceFeeWaivedSumFunctionTextBox.Name = "serviceFeeWaivedSumFunctionTextBox";
            this.serviceFeeWaivedSumFunctionTextBox.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.265D), Telerik.Reporting.Drawing.Unit.Inch(0.198D));
            this.serviceFeeWaivedSumFunctionTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right;
            this.serviceFeeWaivedSumFunctionTextBox.StyleName = "Data";
            this.serviceFeeWaivedSumFunctionTextBox.Value = "=Sum(Fields.ServiceFeeWaived)";
            // 
            // totalAmountDueSumFunctionTextBox
            // 
            this.totalAmountDueSumFunctionTextBox.CanGrow = true;
            this.totalAmountDueSumFunctionTextBox.Format = "{0:C2}";
            this.totalAmountDueSumFunctionTextBox.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(9.266D), Telerik.Reporting.Drawing.Unit.Inch(0.181D));
            this.totalAmountDueSumFunctionTextBox.Name = "totalAmountDueSumFunctionTextBox";
            this.totalAmountDueSumFunctionTextBox.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.234D), Telerik.Reporting.Drawing.Unit.Inch(0.198D));
            this.totalAmountDueSumFunctionTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right;
            this.totalAmountDueSumFunctionTextBox.StyleName = "Data";
            this.totalAmountDueSumFunctionTextBox.Value = "=Sum(Fields.TotalAmountDue)";
            // 
            // totalAmountWaivedSumFunctionTextBox
            // 
            this.totalAmountWaivedSumFunctionTextBox.CanGrow = true;
            this.totalAmountWaivedSumFunctionTextBox.Format = "{0:C2}";
            this.totalAmountWaivedSumFunctionTextBox.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(7.931D), Telerik.Reporting.Drawing.Unit.Inch(0.181D));
            this.totalAmountWaivedSumFunctionTextBox.Name = "totalAmountWaivedSumFunctionTextBox";
            this.totalAmountWaivedSumFunctionTextBox.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.335D), Telerik.Reporting.Drawing.Unit.Inch(0.198D));
            this.totalAmountWaivedSumFunctionTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right;
            this.totalAmountWaivedSumFunctionTextBox.StyleName = "Data";
            this.totalAmountWaivedSumFunctionTextBox.Value = "=Sum(Fields.TotalAmountWaived)";
            // 
            // textBox4
            // 
            this.textBox4.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(0D), Telerik.Reporting.Drawing.Unit.Inch(0.181D));
            this.textBox4.Name = "textBox4";
            this.textBox4.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(2.8D), Telerik.Reporting.Drawing.Unit.Inch(0.198D));
            this.textBox4.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right;
            this.textBox4.StyleName = "Caption";
            this.textBox4.Value = "Totals:";
            // 
            // shape1
            // 
            this.shape1.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(0D), Telerik.Reporting.Drawing.Unit.Inch(0D));
            this.shape1.Name = "shape1";
            this.shape1.ShapeType = new Telerik.Reporting.Drawing.Shapes.LineShape(Telerik.Reporting.Drawing.Shapes.LineDirection.EW);
            this.shape1.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(10.5D), Telerik.Reporting.Drawing.Unit.Inch(0.181D));
            this.shape1.Style.LineStyle = Telerik.Reporting.Drawing.LineStyle.Dashed;
            // 
            // pageHeader
            // 
            this.pageHeader.Height = Telerik.Reporting.Drawing.Unit.Inch(1.4D);
            this.pageHeader.Items.AddRange(new Telerik.Reporting.ReportItemBase[] {
            this.titleTextBox,
            this.textBox5,
            this.textBox6,
            this.textBox7,
            this.textBox8,
            this.textBox9,
            this.textBox10});
            this.pageHeader.Name = "pageHeader";
            this.pageHeader.Style.BackgroundColor = System.Drawing.Color.White;
            // 
            // titleTextBox
            // 
            this.titleTextBox.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(0.1D), Telerik.Reporting.Drawing.Unit.Inch(0.3D));
            this.titleTextBox.Name = "titleTextBox";
            this.titleTextBox.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(3.9D), Telerik.Reporting.Drawing.Unit.Inch(0.3D));
            this.titleTextBox.StyleName = "Title";
            this.titleTextBox.Value = "= \"Reduction Report\" + IIf(Parameters.AttorneyID.Value <= 0, \" - All Attorneys Vi" +
    "ew\", \"\")";
            // 
            // textBox5
            // 
            this.textBox5.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(0.1D), Telerik.Reporting.Drawing.Unit.Inch(0D));
            this.textBox5.Name = "textBox5";
            this.textBox5.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(7.796D), Telerik.Reporting.Drawing.Unit.Inch(0.3D));
            this.textBox5.StyleName = "Title";
            this.textBox5.Value = "= First(Fields.CompanyName)";
            // 
            // textBox6
            // 
            this.textBox6.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(0.1D), Telerik.Reporting.Drawing.Unit.Inch(0.813D));
            this.textBox6.Name = "textBox6";
            this.textBox6.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(0.8D), Telerik.Reporting.Drawing.Unit.Inch(0.2D));
            this.textBox6.StyleName = "PageInfo";
            this.textBox6.Value = "Start Date:";
            // 
            // textBox7
            // 
            this.textBox7.Format = "{0:d}";
            this.textBox7.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(0.9D), Telerik.Reporting.Drawing.Unit.Inch(1.013D));
            this.textBox7.Name = "textBox7";
            this.textBox7.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(2.3D), Telerik.Reporting.Drawing.Unit.Inch(0.2D));
            this.textBox7.StyleName = "PageInfo";
            this.textBox7.Value = "= Parameters.EndDate.Value";
            // 
            // textBox8
            // 
            this.textBox8.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(0.1D), Telerik.Reporting.Drawing.Unit.Inch(1.013D));
            this.textBox8.Name = "textBox8";
            this.textBox8.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(0.8D), Telerik.Reporting.Drawing.Unit.Inch(0.2D));
            this.textBox8.StyleName = "PageInfo";
            this.textBox8.Value = "End Date:";
            // 
            // textBox9
            // 
            this.textBox9.Format = "{0:d}";
            this.textBox9.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(0.9D), Telerik.Reporting.Drawing.Unit.Inch(0.813D));
            this.textBox9.Name = "textBox9";
            this.textBox9.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(2.3D), Telerik.Reporting.Drawing.Unit.Inch(0.2D));
            this.textBox9.StyleName = "PageInfo";
            this.textBox9.Value = "= Parameters.StartDate.Value";
            // 
            // textBox10
            // 
            this.textBox10.Format = "";
            this.textBox10.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(8.1D), Telerik.Reporting.Drawing.Unit.Inch(0.041D));
            this.textBox10.Name = "textBox10";
            this.textBox10.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(2.203D), Telerik.Reporting.Drawing.Unit.Inch(0.2D));
            this.textBox10.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right;
            this.textBox10.StyleName = "PageInfo";
            this.textBox10.Value = "= \"As of \" + Format(\"{0:d}\", Now())";
            // 
            // detail
            // 
            this.detail.Height = Telerik.Reporting.Drawing.Unit.Inch(0.308D);
            this.detail.Items.AddRange(new Telerik.Reporting.ReportItemBase[] {
            this.firmNameDataTextBox,
            this.attorneyNameDataTextBox,
            this.totalPrincipalDueDataTextBox,
            this.principalWaivedDataTextBox,
            this.totalServiceFeeDueDataTextBox,
            this.serviceFeeWaivedDataTextBox,
            this.totalAmountDueDataTextBox,
            this.totalAmountWaivedDataTextBox});
            this.detail.Name = "detail";
            // 
            // firmNameDataTextBox
            // 
            this.firmNameDataTextBox.CanGrow = true;
            this.firmNameDataTextBox.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(0D), Telerik.Reporting.Drawing.Unit.Inch(0D));
            this.firmNameDataTextBox.Name = "firmNameDataTextBox";
            this.firmNameDataTextBox.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.4D), Telerik.Reporting.Drawing.Unit.Inch(0.267D));
            this.firmNameDataTextBox.StyleName = "Data";
            this.firmNameDataTextBox.Value = "=Fields.FirmName";
            // 
            // attorneyNameDataTextBox
            // 
            this.attorneyNameDataTextBox.CanGrow = true;
            this.attorneyNameDataTextBox.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(1.4D), Telerik.Reporting.Drawing.Unit.Inch(0D));
            this.attorneyNameDataTextBox.Name = "attorneyNameDataTextBox";
            this.attorneyNameDataTextBox.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.4D), Telerik.Reporting.Drawing.Unit.Inch(0.267D));
            this.attorneyNameDataTextBox.StyleName = "Data";
            this.attorneyNameDataTextBox.Value = "= Fields.AttorneyName";
            // 
            // totalPrincipalDueDataTextBox
            // 
            this.totalPrincipalDueDataTextBox.CanGrow = true;
            this.totalPrincipalDueDataTextBox.Format = "{0:C2}";
            this.totalPrincipalDueDataTextBox.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(2.8D), Telerik.Reporting.Drawing.Unit.Inch(0D));
            this.totalPrincipalDueDataTextBox.Name = "totalPrincipalDueDataTextBox";
            this.totalPrincipalDueDataTextBox.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.265D), Telerik.Reporting.Drawing.Unit.Inch(0.267D));
            this.totalPrincipalDueDataTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right;
            this.totalPrincipalDueDataTextBox.StyleName = "Data";
            this.totalPrincipalDueDataTextBox.Value = "=Fields.TotalPrincipalDue";
            // 
            // principalWaivedDataTextBox
            // 
            this.principalWaivedDataTextBox.CanGrow = true;
            this.principalWaivedDataTextBox.Format = "{0:C2}";
            this.principalWaivedDataTextBox.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(4.065D), Telerik.Reporting.Drawing.Unit.Inch(0D));
            this.principalWaivedDataTextBox.Name = "principalWaivedDataTextBox";
            this.principalWaivedDataTextBox.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.265D), Telerik.Reporting.Drawing.Unit.Inch(0.267D));
            this.principalWaivedDataTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right;
            this.principalWaivedDataTextBox.StyleName = "Data";
            this.principalWaivedDataTextBox.Value = "=Fields.PrincipalWaived";
            // 
            // totalServiceFeeDueDataTextBox
            // 
            this.totalServiceFeeDueDataTextBox.CanGrow = true;
            this.totalServiceFeeDueDataTextBox.Format = "{0:C2}";
            this.totalServiceFeeDueDataTextBox.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(5.33D), Telerik.Reporting.Drawing.Unit.Inch(0D));
            this.totalServiceFeeDueDataTextBox.Name = "totalServiceFeeDueDataTextBox";
            this.totalServiceFeeDueDataTextBox.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.335D), Telerik.Reporting.Drawing.Unit.Inch(0.267D));
            this.totalServiceFeeDueDataTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right;
            this.totalServiceFeeDueDataTextBox.StyleName = "Data";
            this.totalServiceFeeDueDataTextBox.Value = "=Fields.TotalServiceFeeDue";
            // 
            // serviceFeeWaivedDataTextBox
            // 
            this.serviceFeeWaivedDataTextBox.CanGrow = true;
            this.serviceFeeWaivedDataTextBox.Format = "{0:C2}";
            this.serviceFeeWaivedDataTextBox.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(6.665D), Telerik.Reporting.Drawing.Unit.Inch(0D));
            this.serviceFeeWaivedDataTextBox.Name = "serviceFeeWaivedDataTextBox";
            this.serviceFeeWaivedDataTextBox.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.265D), Telerik.Reporting.Drawing.Unit.Inch(0.267D));
            this.serviceFeeWaivedDataTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right;
            this.serviceFeeWaivedDataTextBox.StyleName = "Data";
            this.serviceFeeWaivedDataTextBox.Value = "=Fields.ServiceFeeWaived";
            // 
            // totalAmountDueDataTextBox
            // 
            this.totalAmountDueDataTextBox.CanGrow = true;
            this.totalAmountDueDataTextBox.Format = "{0:C2}";
            this.totalAmountDueDataTextBox.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(9.266D), Telerik.Reporting.Drawing.Unit.Inch(0D));
            this.totalAmountDueDataTextBox.Name = "totalAmountDueDataTextBox";
            this.totalAmountDueDataTextBox.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.234D), Telerik.Reporting.Drawing.Unit.Inch(0.267D));
            this.totalAmountDueDataTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right;
            this.totalAmountDueDataTextBox.StyleName = "Data";
            this.totalAmountDueDataTextBox.Value = "= Fields.TotalAmountDue";
            // 
            // totalAmountWaivedDataTextBox
            // 
            this.totalAmountWaivedDataTextBox.CanGrow = true;
            this.totalAmountWaivedDataTextBox.Format = "{0:C2}";
            this.totalAmountWaivedDataTextBox.Location = new Telerik.Reporting.Drawing.PointU(Telerik.Reporting.Drawing.Unit.Inch(7.931D), Telerik.Reporting.Drawing.Unit.Inch(0D));
            this.totalAmountWaivedDataTextBox.Name = "totalAmountWaivedDataTextBox";
            this.totalAmountWaivedDataTextBox.Size = new Telerik.Reporting.Drawing.SizeU(Telerik.Reporting.Drawing.Unit.Inch(1.335D), Telerik.Reporting.Drawing.Unit.Inch(0.267D));
            this.totalAmountWaivedDataTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right;
            this.totalAmountWaivedDataTextBox.StyleName = "Data";
            this.totalAmountWaivedDataTextBox.Value = "= Fields.TotalAmountWaived";
            // 
            // DiscountReport
            // 
            this.DataSource = this.discountReportSqlDataSource;
            this.DocumentName = "=\"DiscountReport_\" + ExecutionTime.ToString(\"yyyyMMdd-hhmmss\")";
            group1.GroupFooter = this.labelsGroupFooterSection;
            group1.GroupHeader = this.labelsGroupHeaderSection;
            group1.Name = "labelsGroup";
            this.Groups.AddRange(new Telerik.Reporting.Group[] {
            group1});
            this.Items.AddRange(new Telerik.Reporting.ReportItemBase[] {
            this.labelsGroupHeaderSection,
            this.labelsGroupFooterSection,
            this.reportFooter,
            this.pageHeader,
            this.detail});
            this.Name = "DiscountReport";
            this.PageSettings.Landscape = true;
            this.PageSettings.Margins = new Telerik.Reporting.Drawing.MarginsU(Telerik.Reporting.Drawing.Unit.Inch(0.25D), Telerik.Reporting.Drawing.Unit.Inch(0.25D), Telerik.Reporting.Drawing.Unit.Inch(0.25D), Telerik.Reporting.Drawing.Unit.Inch(0.25D));
            this.PageSettings.PaperKind = System.Drawing.Printing.PaperKind.Letter;
            reportParameter1.AllowBlank = false;
            reportParameter1.Name = "CompanyID";
            reportParameter1.Type = Telerik.Reporting.ReportParameterType.Integer;
            reportParameter2.AllowBlank = false;
            reportParameter2.Name = "StartDate";
            reportParameter2.Type = Telerik.Reporting.ReportParameterType.DateTime;
            reportParameter3.AllowBlank = false;
            reportParameter3.Name = "EndDate";
            reportParameter3.Type = Telerik.Reporting.ReportParameterType.DateTime;
            reportParameter4.AllowBlank = false;
            reportParameter4.Name = "AttorneyID";
            reportParameter4.Type = Telerik.Reporting.ReportParameterType.Integer;
            this.ReportParameters.Add(reportParameter1);
            this.ReportParameters.Add(reportParameter2);
            this.ReportParameters.Add(reportParameter3);
            this.ReportParameters.Add(reportParameter4);
            this.Sortings.Add(new Telerik.Reporting.Sorting("= IsNull(Fields.FirmName, \"\" )", Telerik.Reporting.SortDirection.Asc));
            this.Sortings.Add(new Telerik.Reporting.Sorting("=Fields.AttLastName", Telerik.Reporting.SortDirection.Asc));
            this.Sortings.Add(new Telerik.Reporting.Sorting("=Fields.AttFirstName", Telerik.Reporting.SortDirection.Asc));
            this.Style.BackgroundColor = System.Drawing.Color.White;
            styleRule1.Selectors.AddRange(new Telerik.Reporting.Drawing.ISelector[] {
            new Telerik.Reporting.Drawing.StyleSelector("Title")});
            styleRule1.Style.Color = System.Drawing.Color.Black;
            styleRule1.Style.Font.Bold = true;
            styleRule1.Style.Font.Italic = false;
            styleRule1.Style.Font.Name = "Arial";
            styleRule1.Style.Font.Size = Telerik.Reporting.Drawing.Unit.Point(14D);
            styleRule1.Style.Font.Strikeout = false;
            styleRule1.Style.Font.Underline = false;
            styleRule2.Selectors.AddRange(new Telerik.Reporting.Drawing.ISelector[] {
            new Telerik.Reporting.Drawing.StyleSelector("Caption")});
            styleRule2.Style.Color = System.Drawing.Color.Black;
            styleRule2.Style.Font.Bold = true;
            styleRule2.Style.Font.Name = "Arial";
            styleRule2.Style.Font.Size = Telerik.Reporting.Drawing.Unit.Point(8D);
            styleRule2.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle;
            styleRule3.Selectors.AddRange(new Telerik.Reporting.Drawing.ISelector[] {
            new Telerik.Reporting.Drawing.StyleSelector("Data")});
            styleRule3.Style.Font.Name = "Arial";
            styleRule3.Style.Font.Size = Telerik.Reporting.Drawing.Unit.Point(8D);
            styleRule3.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle;
            styleRule4.Selectors.AddRange(new Telerik.Reporting.Drawing.ISelector[] {
            new Telerik.Reporting.Drawing.StyleSelector("PageInfo")});
            styleRule4.Style.Font.Name = "Arial";
            styleRule4.Style.Font.Size = Telerik.Reporting.Drawing.Unit.Point(10D);
            styleRule4.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle;
            this.StyleSheet.AddRange(new Telerik.Reporting.Drawing.StyleRule[] {
            styleRule1,
            styleRule2,
            styleRule3,
            styleRule4});
            this.Width = Telerik.Reporting.Drawing.Unit.Inch(10.5D);
            ((System.ComponentModel.ISupportInitialize)(this)).EndInit();

        }
        #endregion

        private Telerik.Reporting.SqlDataSource discountReportSqlDataSource;
        private Telerik.Reporting.ReportFooterSection reportFooter;
        private Telerik.Reporting.TextBox totalPrincipalDueSumFunctionTextBox;
        private Telerik.Reporting.TextBox principalWaivedSumFunctionTextBox;
        private Telerik.Reporting.TextBox totalServiceFeeDueSumFunctionTextBox;
        private Telerik.Reporting.TextBox serviceFeeWaivedSumFunctionTextBox;
        private Telerik.Reporting.GroupHeaderSection labelsGroupHeaderSection;
        private Telerik.Reporting.TextBox firmNameCaptionTextBox;
        private Telerik.Reporting.TextBox attorneyNameCaptionTextBox;
        private Telerik.Reporting.TextBox totalPrincipalDueCaptionTextBox;
        private Telerik.Reporting.TextBox principalWaivedCaptionTextBox;
        private Telerik.Reporting.TextBox totalServiceFeeDueCaptionTextBox;
        private Telerik.Reporting.TextBox serviceFeeWaivedCaptionTextBox;
        private Telerik.Reporting.GroupFooterSection labelsGroupFooterSection;
        private Telerik.Reporting.PageHeaderSection pageHeader;
        private Telerik.Reporting.DetailSection detail;
        private Telerik.Reporting.TextBox firmNameDataTextBox;
        private Telerik.Reporting.TextBox attorneyNameDataTextBox;
        private Telerik.Reporting.TextBox totalPrincipalDueDataTextBox;
        private Telerik.Reporting.TextBox principalWaivedDataTextBox;
        private Telerik.Reporting.TextBox totalServiceFeeDueDataTextBox;
        private Telerik.Reporting.TextBox serviceFeeWaivedDataTextBox;
        private Telerik.Reporting.TextBox totalAmountDueCaptionTextBox;
        private Telerik.Reporting.TextBox totalAmountDueSumFunctionTextBox;
        private Telerik.Reporting.TextBox totalAmountDueDataTextBox;
        private Telerik.Reporting.TextBox totalAmountWaviedCaptionTextBox;
        private Telerik.Reporting.TextBox totalAmountWaivedSumFunctionTextBox;
        private Telerik.Reporting.TextBox textBox4;
        private Telerik.Reporting.Shape shape1;
        private Telerik.Reporting.TextBox titleTextBox;
        private Telerik.Reporting.TextBox totalAmountWaivedDataTextBox;
        private Telerik.Reporting.TextBox textBox5;
        private Telerik.Reporting.TextBox textBox6;
        private Telerik.Reporting.TextBox textBox7;
        private Telerik.Reporting.TextBox textBox8;
        private Telerik.Reporting.TextBox textBox9;
        private Telerik.Reporting.TextBox textBox10;

    }
}