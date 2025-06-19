using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BMM.Classes;
using BMM.Reports;
using BMM_Reports;
using Telerik.Reporting;
using Telerik.Web.UI;
using BMM_BAL;

namespace BMM.ReportPages
{
    public partial class AttorneyStatementsReports : BasePage
    {
        //The reports on this page use procAccountsReceivableReport
        //This stored procedure has @StartDate and @EndDate as parameters
        //This report needs all invoices so the start date is set to 1/1/1900
        private readonly DateTime ArbitraryDateTime = new DateTime(1900, 1, 1);

        #region + Events

        #region Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //DateTime lastDay = new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1).AddMonths(1).AddDays(-1);
                rdpStatementDate.SelectedDate = DateTime.Now;
                LoadAllReport();
                
            }
        }
        #endregion

        #region btnGenerate_OnClick
        protected void btnGenerate_OnClick(object sender, EventArgs e)
        {
            if (rblAttorneyStatement.SelectedValue == "All")
            {
                rptvAttorneyStatement.Visible = true;
                LoadAllReport();
            }

            if (rblAttorneyStatement.SelectedValue == "Past")
            {
                    rptvAttorneyStatement.Visible = true;
                    LoadPastReport();
            }
        }
        #endregion

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
                rptvAttorneyStatement.Visible = false;
            }
            else
            {
                rcbAttorney.Visible = false;
                rfvAttorney.Enabled = false;
                rptvAttorneyStatement.Visible = false;
            }
        }

        #endregion

        #endregion

        #region + Helpers

        #region LoadPastReport
        /// <summary>
        /// Loads the report with only past reports
        /// </summary>
        private void LoadPastReport()
        {
            var reportDocument = new AttorneyStatementPastInvoices();
            if (rblServiceDate.SelectedValue == "1")
            {
                reportDocument.ReportParameters["StartDate"].Value = rdpStartDate.SelectedDate;
                reportDocument.ReportParameters["EndDate"].Value = rdpEndDate.SelectedDate;
                reportDocument.SkipBlankPages = false;
            }
            else
            {
                reportDocument.ReportParameters["StartDate"].Value = ArbitraryDateTime;
                reportDocument.ReportParameters["EndDate"].Value = DateTime.Now;
                reportDocument.SkipBlankPages = false;
            }
            reportDocument.ReportParameters["CompanyId"].Value = CurrentUser.CompanyID;
            reportDocument.ReportParameters["StatementDate"].Value = rdpStatementDate.SelectedDate;
            reportDocument.SkipBlankPages = false;
            if (rblAttorneys.SelectedValue == "1")
            {
                reportDocument.ReportParameters["AttorneyId"].Value = rcbAttorney.SelectedValue;
                reportDocument.SkipBlankPages = false;
            }
            else
            {
                reportDocument.ReportParameters["AttorneyId"].Value = -1;
                reportDocument.SkipBlankPages = false;
            }

            var instanceReportSource = new InstanceReportSource {ReportDocument = reportDocument};

            rptvAttorneyStatement.ReportSource = instanceReportSource;
        }

        //private void LoadPastReportDMA()
        //{
        //    var reportDocument = new AttorneyStatementPastInvoices_DMA();
        //    if (rblServiceDate.SelectedValue == "1")
        //    {
        //        reportDocument.ReportParameters["StartDate"].Value = rdpStartDate.SelectedDate;
        //        reportDocument.ReportParameters["EndDate"].Value = rdpEndDate.SelectedDate;
        //    }
        //    else
        //    {
        //        reportDocument.ReportParameters["StartDate"].Value = ArbitraryDateTime;
        //        reportDocument.ReportParameters["EndDate"].Value = DateTime.Now;
        //    }
        //    reportDocument.ReportParameters["CompanyId"].Value = CurrentUser.CompanyID;
        //    reportDocument.ReportParameters["StatementDate"].Value = rdpStatementDate.SelectedDate;
        //    if (rblAttorneys.SelectedValue == "1")
        //    {
        //        reportDocument.ReportParameters["AttorneyId"].Value = rcbAttorney.SelectedValue;
        //    }
        //    else
        //    {
        //        reportDocument.ReportParameters["AttorneyId"].Value = -1;
        //    }

        //    var instanceReportSource = new InstanceReportSource { ReportDocument = reportDocument };

        //    rptvAttorneyStatement.ReportSource = instanceReportSource;
        //}
        #endregion

        #region LoadAllReport
        /// <summary>
        /// Loads the report with all of the reports
        /// </summary>
        private void LoadAllReport()
        {
            var reportDocument = new AttorneyStatementAllInvoices();
            if (rblServiceDate.SelectedValue == "1")
            {
                reportDocument.ReportParameters["StartDate"].Value = rdpStartDate.SelectedDate;
                reportDocument.ReportParameters["EndDate"].Value = rdpEndDate.SelectedDate;
            }
            else
            {
                reportDocument.ReportParameters["StartDate"].Value = ArbitraryDateTime;
                reportDocument.ReportParameters["EndDate"].Value = DateTime.Now;
            }
            
            reportDocument.ReportParameters["CompanyId"].Value = CurrentUser.CompanyID;
            reportDocument.ReportParameters["StatementDate"].Value = rdpStatementDate.SelectedDate;

            if (rblAttorneys.SelectedValue == "1")
            {
                reportDocument.ReportParameters["AttorneyId"].Value = rcbAttorney.SelectedValue;
            }
            else
            {
                reportDocument.ReportParameters["AttorneyId"].Value = -1;
            }

            var instanceReportSource = new InstanceReportSource { ReportDocument = reportDocument };

            rptvAttorneyStatement.ReportSource = instanceReportSource;
        }
        #endregion

        protected void rblServiceDate_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rblServiceDate.SelectedValue == "1")
            {
                rdpStartDate.Visible = true;
                rdpEndDate.Visible = true;
                rfvStart.Enabled = true;
                rfvEnd.Enabled = true;
                divEDate.Visible = true;
                divSDate.Visible = true;
            }
            else
            {
                rdpStartDate.Visible = false;
                rdpEndDate.Visible = false;
                rfvStart.Enabled = false;
                rfvEnd.Enabled = false;
                divEDate.Visible = false;
                divSDate.Visible = false;
            }
        }

        #endregion
    }
}