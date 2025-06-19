using BMM.Classes;
using BMM_BAL;
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
    public partial class CPTReport : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                rdpStartDate.SelectedDate = DateTime.Today.AddYears(-1);
                rdpEndDate.SelectedDate = DateTime.Today;
            }
        }

        protected void rcbCPTCode_ItemsRequested(object sender, Telerik.Web.UI.RadComboBoxItemsRequestedEventArgs e)
        {
            string text = e.Text.Trim();
            if (text.Length > 2)
            {
                foreach (var item in (from p in CPTCodes
                                      where p.Code.Contains(text) &&
                                            p.Active == true
                                      select new Telerik.Web.UI.RadComboBoxItem(p.Code + ": " + p.Description, p.ID.ToString())))
                {
                    rcbCPTCode.Items.Add(item);
                }
            }
        }

        protected void btnGenerate_Click(object sender, EventArgs e)
        {
            if (rcbCPTCode.SelectedValue == "")
            {
                litError.Visible = true;
                litError.Text = "<br/>Select an existing CPT code from the list";
            }
            else
            {
                litError.Visible = false;
                rptvCPT.Visible = true;
                LoadReport();
            }
        }

        private void LoadReport()
        {
            var reportDocument = new BMM_Reports.CPTReport();

            reportDocument.ReportParameters["StartDate"].Value = rdpStartDate.SelectedDate;
            reportDocument.ReportParameters["EndDate"].Value = rdpEndDate.SelectedDate;
            reportDocument.ReportParameters["CompanyId"].Value = CurrentUser.CompanyID;
            reportDocument.ReportParameters["CPTCodeID"].Value = Convert.ToInt32(rcbCPTCode.SelectedValue);
            reportDocument.ReportParameters["CPTDescription"].Value = rcbCPTCode.Text;
            reportDocument.SkipBlankPages = false;

            var instanceReportSource = new InstanceReportSource { ReportDocument = reportDocument };
            
            rptvCPT.ReportSource = instanceReportSource;

        }

        #region CheckCodeExists
        //checks the names for duplicates and returns false if the name exists already in the database
        protected void CheckCodeExists(object source, ServerValidateEventArgs args)
        {
            string code = rcbCPTCode.Text.Trim().ToUpper();

            List<string> codes = (from c in CPTCodeClass.GetCPTCodesByCompanyID(CurrentUser.CompanyID)
                                  where c.Active
                                  select c.Code.ToUpper()).ToList();

            int matchingCodes = (from c in codes
                                 where c == code
                                 select c).ToList().Count;

            if (matchingCodes > 0)
                args.IsValid = true;
            else
                args.IsValid = false;
        }
        #endregion
    }
}