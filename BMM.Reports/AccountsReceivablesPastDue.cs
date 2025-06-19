using System;

namespace BMM.Reports
{
    /// <summary>
    /// Summary description for AccountsReceivables.
    /// </summary>
    public partial class AccountsReceivablesPastDue : Telerik.Reporting.Report
    {
        public AccountsReceivablesPastDue(int companyID, DateTime startDate, DateTime endDate, bool showPastDueOnly, bool showAttorneyGroups)
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

            ReportParameters["ShowPastDueOnly"].Value = showPastDueOnly;
            ReportParameters["ShowAttorneyGroups"].Value = showAttorneyGroups;
        }
    }
}