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
    public partial class TotalTestsAndSurgeriesByAttorney : BasePage
    {
        #region + Events

        #region Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                rptTotals.Visible = false;
                //Load the drop down list
                for (int x = DateTime.Now.Year; x >= 1995; x--)
                {
                    ddlYears.Items.Add(new RadComboBoxItem(x.ToString(),x.ToString()));
                }

            }
        }
        #endregion

        #region btnGenerate_OnClick
        protected void btnGenerate_OnClick(object sender, EventArgs e)
        {
            rptTotals.Visible = true;
            LoadTotalsReport();
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
                rptTotals.Visible = false;
            }
            else
            {
                rcbAttorney.Visible = false;
                rfvAttorney.Enabled = false;
                rptTotals.Visible = false;
            }
        }

        #endregion

        #endregion

        #region + Helpers

        #region LoadTotalsReport
        /// <summary>
        /// Loads all of the attorneys into the report
        /// </summary>
        private void LoadTotalsReport()
        {
            var reportDocument = new AllTestsAndProceduresForAttorneys();
            reportDocument.ReportParameters["Year"].Value = ddlYears.SelectedValue;
            reportDocument.ReportParameters["CompanyId"].Value = CurrentUser.CompanyID;
            reportDocument.SkipBlankPages = false;

            if (rblAttorneys.SelectedValue == "1")
            {
                reportDocument.ReportParameters["AttorneyId"].Value = Convert.ToInt32(rcbAttorney.SelectedValue);
                reportDocument.SkipBlankPages = false;
            }
            else
            {
                reportDocument.ReportParameters["AttorneyId"].Value = -1;
                reportDocument.SkipBlankPages = false;
            }

            var instanceReportSource = new InstanceReportSource { ReportDocument = reportDocument };

            rptTotals.ReportSource = instanceReportSource;
        }
        #endregion


        #endregion
    }
}