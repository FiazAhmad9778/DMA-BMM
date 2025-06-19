using System;
using BMM.Classes;
using Telerik.Reporting;

namespace BMM.ReportPages
{
    public partial class PatientReport : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;

            var reportDocument = new Reports.Patient();
            reportDocument.ReportParameters.Add("CompanyID", ReportParameterType.Integer, Company.ID);
            reportDocument.SkipBlankPages = false;

            rvPatientReport.ReportSource = new InstanceReportSource { ReportDocument = reportDocument };
        }
    }
}