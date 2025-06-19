using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BMM.Reports;
using BMM_BAL;
using BMM_Reports;
using Telerik.Reporting;
using BMM.Classes;

namespace BMM.ReportPages
{
    public partial class TotalRevenueReport : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)           
                rvTotalRevenue.Visible = false;            
        }

        protected void btnGenerate_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                rvTotalRevenue.Visible = true;
                var TotalRevenueReport = new InstanceReportSource { ReportDocument = new TotalRevenue() };
                TotalRevenueReport.Parameters.Add("CompanyID", CurrentUser.CompanyID);
                TotalRevenueReport.Parameters.Add("StartDate", rdpStartDate.SelectedDate);
                TotalRevenueReport.Parameters.Add("EndDate", rdpEndDate.SelectedDate);
                TotalRevenueReport.Parameters.Add("CompanyName", Company.LongName);
               
                rvTotalRevenue.ReportSource = TotalRevenueReport;
                rvTotalRevenue.RefreshReport();
            }
        }
    }
}