using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BMM.Classes;
using BMM.Reports;
using BMM_BAL;
using BMM_Reports;
using Telerik.Reporting;
using Telerik.Web.UI;

namespace BMM.ReportPages
{
    public partial class AttorneyCashReport : BasePage
    {
        #region + Events

        #region Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                rcbAttorney.Style["display"] = "none";
                rptAttorneyCash.Visible = false;
            }
        }
        #endregion

        #region btnGenerate_OnClick
        protected void btnGenerate_OnClick(object sender, EventArgs e)
        {
            rptAttorneyCash.Visible = true;
            if (rfvAttorney.Enabled)
                LoadAttorneySpecificReport();
            else
                LoadAllAttorneysReport();
        }
        #endregion

        #region rblCashReport_OnSelectedIndexChanged
        protected void rblCashReport_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            if (rblCashReport.SelectedIndex == 1)
            {
                rcbAttorney.Style["display"] = "block";
                rfvAttorney.Enabled = true;
            }
            else
            {
                rcbAttorney.Style["display"] = "none";
                rfvAttorney.Enabled = false;
            }
        }
        #endregion

        #region rcbAttorney_OnItemsRequested
        protected void rcbAttorney_OnItemsRequested(object sender, RadComboBoxItemsRequestedEventArgs e)
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

        #endregion

        #region + Helpers

        #region LoadAllAttorneysReport
        /// <summary>
        /// Loads all of the attorneys into the report
        /// </summary>
        private void LoadAllAttorneysReport()
        {
            var reportDocument = new CashReport();
            reportDocument.ReportParameters["StartDate"].Value = rdpStartDate.SelectedDate.Value;
            reportDocument.ReportParameters["EndDate"].Value = rdpEndDate.SelectedDate.Value;
            reportDocument.ReportParameters["CompanyId"].Value = CurrentUser.CompanyID;
            reportDocument.SkipBlankPages = false;
            var instanceReportSource = new InstanceReportSource { ReportDocument = reportDocument };

            rptAttorneyCash.ReportSource = instanceReportSource;
        }
        #endregion

        #region LoadAttorneySpecificReport
        /// <summary>
        /// Loads only the items for a selected attorney
        /// </summary>
        private void LoadAttorneySpecificReport()
        {
            var reportDocument = new CashReportAttorneyView();
            reportDocument.ReportParameters["StartDate"].Value = rdpStartDate.SelectedDate.Value;
            reportDocument.ReportParameters["EndDate"].Value = rdpEndDate.SelectedDate.Value;
            reportDocument.ReportParameters["CompanyId"].Value = CurrentUser.CompanyID;
            reportDocument.ReportParameters["AttorneyID"].Value = Convert.ToInt32(rcbAttorney.SelectedValue);
            reportDocument.SkipBlankPages = false;
            var instanceReportSource = new InstanceReportSource { ReportDocument = reportDocument };

            rptAttorneyCash.ReportSource = instanceReportSource;
        }
        #endregion

        #endregion
    }
}