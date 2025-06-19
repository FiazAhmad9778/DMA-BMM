using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BMM.Classes;
using BMM_BAL;
using BMM_Reports;
using Telerik.Reporting;

namespace BMM.ReportPages
{
    public partial class ProviderInvoiceReport : BasePage
    {
        #region Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                rptProviderInvoiceReport.Visible = false;
        }

        #endregion

        #region btnGenerate_OnClick
        /// <summary>
        /// User clicks to generate the report
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnGenerate_OnClick(object sender, EventArgs e)
        {
            rptProviderInvoiceReport.Visible = true;

            var reportDocument = new ProviderInvoice();
            reportDocument.ReportParameters["StartDate"].Value = rdpStartDate.SelectedDate.Value;
            reportDocument.ReportParameters["EndDate"].Value = rdpEndDate.SelectedDate.Value;
            reportDocument.ReportParameters["CompanyID"].Value = CurrentUser.CompanyID;
            reportDocument.ReportParameters["ProviderID"].Value = rblReportView.SelectedValue == "1"
                ? "-1"
                : rcbProviders.SelectedValue;
            reportDocument.ReportParameters["Provider"].Value = rblReportView.SelectedValue == "1"
                ? "All"
                : rcbProviders.SelectedItem.Text;
            reportDocument.SkipBlankPages = false;
            var instanceReportSource = new InstanceReportSource {ReportDocument = reportDocument};
            rptProviderInvoiceReport.ReportSource = instanceReportSource;
        }

        #endregion

        #region rblReportView_OnSelectedIndexChanged
        /// <summary>
        /// User toggles between all providers or a specific provider
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void rblReportView_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            if (rblReportView.SelectedValue == "1")
            {
                rcbProviders.Enabled = false;
            }
            else
            {
                rcbProviders.DataSource = ProviderClass.GetProvidersByCompanyID(CurrentUser.CompanyID).OrderBy(x => x.Name);
                rcbProviders.DataTextField = "Name";
                rcbProviders.DataValueField = "ID";
                rcbProviders.DataBind();
                rcbProviders.Enabled = true;
            }
        }

        #endregion

    }
}