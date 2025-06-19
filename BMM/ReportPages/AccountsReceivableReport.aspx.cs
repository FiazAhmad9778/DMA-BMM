using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BMM.Classes;
using Telerik.Reporting;
using Telerik.Web.UI;
using BMM_BAL;

namespace BMM.ReportPages
{
    public partial class AccountsReceivableReport : BasePage
    {
        #region Enum

        protected enum ReportTypeEnum
        {
            AccountsReceivables,
            AccountsReceivablesByDate,
            PastDueAccountsReceivables,
            AccountsReceivablesAging,
            AccountsReceivableHistory,
            AccountsReceivablesAgingHistory
        }

        #endregion

        #region + Page Events

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;

            LoadReportOptions();

            rblReportSelector.SelectedValue = ((int) ReportTypeEnum.AccountsReceivables).ToString("D");
            rvAccountsReceivables.Visible = false;

            //set default date to today
            rdpEndDate.SelectedDate = DateTime.Now;
        }

        protected void rblReportSelector_OnSelectedIndexChanged(object sender, EventArgs e)
        {
           //bool showDateRange = rblReportSelector.SelectedValue == ((int)ReportTypeEnum.AccountsReceivablesAging).ToString("D");
           // bool isPastDue = rblReportSelector.SelectedValue == ((int)ReportTypeEnum.PastDueAccountsReceivables).ToString("D");


            //SetDateRangeDisabled(rblReportSelector.SelectedValue == ((int)ReportTypeEnum.AccountsReceivablesAging).ToString("D") ||
            //     rblReportSelector.SelectedValue == ((int)ReportTypeEnum.PastDueAccountsReceivables).ToString("D"));
        }

        protected void btnGenerate_OnClick(object sender, EventArgs e)
        {
            rvAccountsReceivables.Visible = true;
            SetReportSource();
        }

        #region rcbAttorney_ItemsRequested
        protected void rcbAttorney_ItemsRequested(object sender, Telerik.Web.UI.RadComboBoxItemsRequestedEventArgs e)
        {
            string text = e.Text.Trim();
            if (text.Length > 2)
            {
                List<RadComboBoxItem> attorneys =
                    (from a in AttorneyClass.GetAttorneysByCompanyID(CurrentUser.CompanyID, true, false)
                     where a.FirstName.ToLower().Contains(text.ToLower()) || a.LastName.ToLower().Contains(text.ToLower())
                     orderby a.LastName, a.FirstName
                     select new RadComboBoxItem(a.LastName + ", " + a.FirstName, a.ID.ToString())).ToList
                        ();
                foreach (var item in attorneys)
                {
                    rcbAttorney.Items.Add(item);
                }
            }
        }
        #endregion

        #region rblAttorneys_SelectedIndexChanged

        protected void rblAttorneys_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rblAttorneys.SelectedValue == "1")
            {
                rcbAttorney.Visible = true;
                rfvAttorney.Enabled = true;
            }
            else
            {
                rcbAttorney.Visible = false;
                rfvAttorney.Enabled = false;
            }
        }

        #endregion

        #endregion

        #region + Helper Methods

        /// <summary>
        /// Load the radio button list with the available Account Receivables report options.
        /// </summary>
        private void LoadReportOptions()
        {
            rblReportSelector.Items.Add(new ListItem("Accounts Receivables", ((int)ReportTypeEnum.AccountsReceivables).ToString("D")));
            rblReportSelector.Items.Add(new ListItem("Accounts Receivables By Date", ((int)ReportTypeEnum.AccountsReceivablesByDate).ToString("D")));
            rblReportSelector.Items.Add(new ListItem("Past Due Accounts Receivables", ((int)ReportTypeEnum.PastDueAccountsReceivables).ToString("D")));
            rblReportSelector.Items.Add(new ListItem("Accounts Receivables Aging", ((int)ReportTypeEnum.AccountsReceivablesAging).ToString("D")));
            rblReportSelector.Items.Add(new ListItem("Accounts Receivables Aging (History)", ((int)ReportTypeEnum.AccountsReceivablesAgingHistory).ToString("D")));
            rblReportSelector.Items.Add(new ListItem("Ending Balance Log", ((int)ReportTypeEnum.AccountsReceivableHistory).ToString("D")));
        }

        /// <summary>
        /// Sets the report viewer's report source.
        /// </summary>
        private void SetReportSource()
        {
            int selectedReport;
            if (!int.TryParse(rblReportSelector.SelectedValue, out selectedReport)) return;

            IReportDocument reportDocument = null;

            DateTime startDate = new DateTime(1753, 1, 1);
            DateTime endDate = rdpEndDate.SelectedDate.Value;
            int attorneyID = -1;

            if (rblAttorneys.SelectedValue == "1")
            {
                attorneyID = Convert.ToInt32(rcbAttorney.SelectedValue);
            }
            else
            {
                attorneyID = -1;
            }

            bool showPastDueOnly = (selectedReport == (int) ReportTypeEnum.PastDueAccountsReceivables);
            bool showAttorneyGroups = (selectedReport != (int) ReportTypeEnum.AccountsReceivablesByDate);

            switch (selectedReport)
            {
                case (int) ReportTypeEnum.AccountsReceivablesAging:
                    reportDocument = new Reports.AccountsReceivablesAging(Company.ID, startDate, endDate, attorneyID);
                    break;
                case (int) ReportTypeEnum.PastDueAccountsReceivables:
                    //Check company
                    if (CurrentUser.CompanyID == 1) //BMM
                    {
                        reportDocument = new Reports.AccountsReceivables_BMM(Company.ID, startDate, endDate, attorneyID, showPastDueOnly,
                            showAttorneyGroups, true);
                    }
                    else if (CurrentUser.CompanyID == 2) //DMA
                    {
                        reportDocument = new Reports.AccountsReceivables_DMA(Company.ID, startDate, endDate, attorneyID, showPastDueOnly,
                            showAttorneyGroups, true);
                    }
                    break;
                case (int) ReportTypeEnum.AccountsReceivables:
                    reportDocument = new Reports.AccountsReceivables_BMM(Company.ID, startDate, endDate, attorneyID, showPastDueOnly,
                        showAttorneyGroups);
                    break;
                case (int) ReportTypeEnum.AccountsReceivablesByDate:
                    reportDocument = new Reports.AccountsReceivables_BMM(Company.ID, startDate, endDate, attorneyID, showPastDueOnly,
                        showAttorneyGroups);
                    break;
                case (int)ReportTypeEnum.AccountsReceivableHistory:
                    reportDocument = new Reports.AccountsReceivablesHistory(Company.ID, startDate, endDate);
                    break;
                case (int)ReportTypeEnum.AccountsReceivablesAgingHistory:
                    reportDocument = new Reports.AccountsReceivablesAgingHistory(Company.ID, startDate, endDate);
                    break;
                default:
                    return;
            }

            rvAccountsReceivables.ReportSource = new InstanceReportSource {ReportDocument = reportDocument};
        }

        /// <summary>
        /// Shows/hides the date range options and enables/disables the date validators.
        /// </summary>
        /// <param name="isDisabled"></param>
        private void SetDateRangeDisabled(bool isDisabled)
        {
            pnlDates.Visible = !isDisabled;
            //rfvStartDate.Enabled = !isDisabled;
            rfvEndDate.Enabled = !isDisabled;
            //cvDateRange.Enabled = !isDisabled;
        }
        
        #endregion

       
    }
}