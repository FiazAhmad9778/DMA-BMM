using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using BMM.Classes;
using BMM_BAL;
using Telerik.Reporting;
using Telerik.Web.UI;

namespace BMM.ReportPages
{
    public partial class PercentCash_LossCollected_ByDays : BasePage
    {
        #region + Events

        #region Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;

            rvPercentCash_LossCollected_ByDays.Visible = false;
            rcbAttorney.Style["display"] = "none";
        }
        #endregion

        #region btnGenerate_OnClick
        protected void btnGenerate_OnClick(object sender, EventArgs e)
        {
            if (rdpEndDate.SelectedDate == null) return;

            rvPercentCash_LossCollected_ByDays.Visible = true;

            var reportDocument = new BMM_Reports.PercentCash_LossCollected_ByDays();
            reportDocument.ReportParameters["EndDate"].Value = rdpEndDate.SelectedDate.Value;
            reportDocument.ReportParameters["CompanyId"].Value = CurrentUser.CompanyID;
            reportDocument.SkipBlankPages = false;

            if (rfvAttorney.Enabled)
            {
                reportDocument.ReportParameters["AttorneyID"].Value = Convert.ToInt32(rcbAttorney.SelectedValue);
                reportDocument.SkipBlankPages = false;
            }
            else
            {
                reportDocument.ReportParameters["AttorneyID"].Value = -1;
                reportDocument.SkipBlankPages = false;
            }

            var instanceReportSource = new InstanceReportSource { ReportDocument = reportDocument };

            rvPercentCash_LossCollected_ByDays.ReportSource = instanceReportSource;
        }
        #endregion

        #region rblAttorney_OnSelectedIndexChanged
        protected void rblAttorney_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            if (rblAttorney.SelectedIndex == 1)
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
            if (text.Length <= 2) return;

            List<RadComboBoxItem> attorneys =
                (from a in AttorneyClass.GetAttorneysByCompanyID(CurrentUser.CompanyID, true, false)
                 where
                     a.FirstName.ToLower().Contains(text.ToLower()) || a.LastName.ToLower().Contains(text.ToLower())
                 orderby a.LastName, a.FirstName
                 select
                     new RadComboBoxItem(a.LastName + ", " + a.FirstName, a.ID.ToString(CultureInfo.InvariantCulture)))
                    .ToList();

            foreach (var item in attorneys)
            {
                rcbAttorney.Items.Add(item);
            }
        }
        #endregion

        #endregion
    }
}