namespace BMM.Reports
{
    using System;

    /// <summary>
    /// Summary description for DiscountReport.
    /// </summary>
    public partial class DiscountReport : Telerik.Reporting.Report
    {
        public DiscountReport(int companyID, DateTime startDate, DateTime endDate, int attorneyID = -1)
        {
            //
            // Required for telerik Reporting designer support
            //
            InitializeComponent();

            //
            // Add any constructor code after InitializeComponent call
            //

            // Set report parameters.
            ReportParameters["CompanyID"].Value = companyID;
            ReportParameters["StartDate"].Value = startDate;
            ReportParameters["EndDate"].Value = endDate;
            ReportParameters["AttorneyID"].Value = attorneyID;
        }
    }
}