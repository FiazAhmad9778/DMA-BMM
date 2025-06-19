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

namespace BMM.ReportPages
{
    public partial class ProviderPaymentsReport : BasePage
    {
        #region Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                rptProviderPaymentsReport.Visible = false;
        }
        #endregion

        #region btnGenerate_OnClick
        protected void btnGenerate_OnClick(object sender, EventArgs e)
        {
            rptProviderPaymentsReport.Visible = true;

            var reportDocument = new ProviderPayments();
            reportDocument.ReportParameters["StartDate"].Value = rdpStartDate.SelectedDate.Value;
            reportDocument.ReportParameters["EndDate"].Value = rdpEndDate.SelectedDate.Value;
            reportDocument.ReportParameters["CompanyId"].Value = CurrentUser.CompanyID;
            reportDocument.SkipBlankPages = false;

            var instanceReportSource = new InstanceReportSource { ReportDocument = reportDocument };

            rptProviderPaymentsReport.ReportSource = instanceReportSource;
        }
        #endregion
    }
}