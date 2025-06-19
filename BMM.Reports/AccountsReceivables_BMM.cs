using System;

namespace BMM.Reports
{
    /// <summary>
    /// Summary description for AccountsReceivables.
    /// </summary>
    public partial class AccountsReceivables_BMM : Telerik.Reporting.Report
    {
        public AccountsReceivables_BMM(int companyID, DateTime startDate, DateTime endDate, int attorneyID, bool showPastDueOnly, bool showAttorneyGroups, bool isPastDue = false)
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
            ReportParameters["ShowPastDueOnly"].Value = showPastDueOnly;
            ReportParameters["ShowAttorneyGroups"].Value = showAttorneyGroups;

            //Set the datasource to the pastduedatasource
            if (isPastDue)
                this.DataSource = this.accountsReceivablesPastDueDataSource;
        }
    }
}