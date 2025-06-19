using BMM.Classes;
using BMM_Reports;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Reporting;

namespace BMM.ReportPages
{
    public partial class AttorneyListReports : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            LoadReport();
        }

        private void LoadReport()
        {
            var reportDocument = new AttorneyListReport();


            reportDocument.ReportParameters["CompanyID"].Value = CurrentUser.CompanyID;
            reportDocument.SkipBlankPages = false;
            var instanceReportSource = new InstanceReportSource { ReportDocument = reportDocument };

            rptvAttorneyList.ReportSource = instanceReportSource;

        }
    }
}