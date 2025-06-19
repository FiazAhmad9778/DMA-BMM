using System;

namespace BMM.Reports
{
    /// <summary>
    /// Summary description for AccountsReceivablesAging.
    /// </summary>
    public partial class AccountsReceivablesAging : Telerik.Reporting.Report
    {
        public AccountsReceivablesAging(int companyID, DateTime startDate, DateTime endDate, int attorneyID)
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
            ReportParameters["AttorneyId"].Value = attorneyID;
        }
    }
}