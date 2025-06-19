using System;
using System.Linq;
using System.Web.UI.WebControls;
using BMM.Classes;
using BMM_BAL;
using Telerik.Reporting;
using Telerik.Web.UI;

namespace BMM
{
    public partial class DiscountReport : BasePage
    {
        #region + Properties

        private bool IsSpecificAttorneyViewSelected
        {
            get { return rblReportViews.SelectedValue == "one"; }
        }

        #endregion

        #region + Page Events

        #region Page_Load

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            rcbAttorney.Style["display"] = "none";
            rvDiscount.Visible = false;
        }

        #endregion

        #region rblReportViews_OnSelectedIndexChanged

        protected void rblReportViews_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            if (IsSpecificAttorneyViewSelected)
            {
                rcbAttorney.Style["display"] = "block";
                rfvAttorney.Enabled = true;
                cvAttorney.Enabled = true;
            }
            else
            {
                rcbAttorney.Style["display"] = "none";
                rfvAttorney.Enabled = false;
                cvAttorney.Enabled = false;
            }
        }

        #endregion

        #region rcbAttorney_OnItemsRequested

        protected void rcbAttorney_OnItemsRequested(object sender, RadComboBoxItemsRequestedEventArgs e)
        {
            string text = e.Text.Trim().ToLower();

            if (text.Length <= 2) return;

            var attorneys =
                AttorneyClass.GetAttorneysByCompanyID(CurrentUser.CompanyID, true, false)
                    .Where(a => a.FirstName.ToLower().Contains(text) || a.LastName.ToLower().Contains(text))
                    .OrderBy(a => a.LastName);

            foreach (var item in attorneys.Select(attorney => new RadComboBoxItem(attorney.LastName + ", " + attorney.FirstName, attorney.ID.ToString("D"))))
            {
                rcbAttorney.Items.Add(item);
                item.DataBind();
            }
        }

        #endregion

        #region btnGenerate_OnClick

        protected void btnGenerate_OnClick(object sender, EventArgs e)
        {
            SetReportSource();
        }

        #endregion

        #endregion

        #region + Helper Methods

        #region SetReportSource

        private void SetReportSource()
        {
            if (!rdpStartDate.SelectedDate.HasValue || !rdpEndDate.SelectedDate.HasValue) return;

            Reports.DiscountReport reportDocument;
            int attorneyID;

            if (IsSpecificAttorneyViewSelected
                && int.TryParse(rcbAttorney.SelectedValue, out attorneyID)
                && attorneyID > 0)
            {
                reportDocument = new Reports.DiscountReport(CurrentUser.CompanyID, rdpStartDate.SelectedDate.Value,
                    rdpEndDate.SelectedDate.Value, attorneyID);
                reportDocument.SkipBlankPages = false;
            }
            else
            {
                reportDocument = new Reports.DiscountReport(CurrentUser.CompanyID, rdpStartDate.SelectedDate.Value,
                    rdpEndDate.SelectedDate.Value);
                reportDocument.SkipBlankPages = false;
            }

            rvDiscount.Visible = true;
            rvDiscount.ReportSource = new InstanceReportSource
            {
                ReportDocument = reportDocument

            };
        }

        #endregion

        #endregion

        protected void cvAttorney_OnServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = !string.IsNullOrEmpty(rcbAttorney.SelectedValue);
        }
    }
}