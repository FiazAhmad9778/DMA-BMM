using System;

namespace BMM.Reports
{
    /// <summary>
    /// Summary description for AccountsReceivablesHistory.
    /// </summary>
    public partial class AccountsReceivablesHistory : Telerik.Reporting.Report
    {
        public AccountsReceivablesHistory(int companyID, DateTime startDate, DateTime endDate)
        {
            //
            // Required for telerik Reporting designer support
            //
            InitializeComponent();

            //
            // Add any constructor code after InitializeComponent call
            //

            // Set parameters
            ReportParameters["CompanyId"].Value = companyID;
            ReportParameters["StartDate"].Value = startDate;
            ReportParameters["EndDate"].Value = endDate;
        }
    }
}