using BMM.Classes;
using BMM.Reports;
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
    public partial class ICDCodeReport : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                rdpStartDate.SelectedDate = DateTime.Today.AddYears(-1);
                rdpEndDate.SelectedDate = DateTime.Today;
            }
        }

        protected void rcbICDCode_ItemsRequested(object sender, Telerik.Web.UI.RadComboBoxItemsRequestedEventArgs e)
        {
            string text = e.Text.Trim();
            if (text.Length > 2)
            {
                foreach (var item in (from p in ICDCodes
                                      where p.Code.ToLower().Contains(text.ToLower()) &&
                                            p.Active == true
                                      select new Telerik.Web.UI.RadComboBoxItem(p.Code + ": " + p.ShortDescription, p.ID.ToString())))
                {
                    rcbICDCode.Items.Add(item);
                }
            }
        }

        protected void btnGenerate_Click(object sender, EventArgs e)
        {
            if (rcbICDCode.SelectedValue == "")
            {
                litError.Visible = true;
                litError.Text = "<br/>Select an existing ICD code from the list";
            }
            else {
                litError.Visible = false;
                rptvICD.Visible = true;
                LoadReport();
            }
            
        }

        private void LoadReport()
        {
            var reportDocument = new ICDReport();

            reportDocument.ReportParameters["StartDate"].Value = rdpStartDate.SelectedDate;
            reportDocument.ReportParameters["EndDate"].Value = rdpEndDate.SelectedDate;
            reportDocument.ReportParameters["CompanyId"].Value = CurrentUser.CompanyID;
            reportDocument.ReportParameters["ICDCodeID"].Value = Convert.ToInt32(rcbICDCode.SelectedValue);
            reportDocument.ReportParameters["ICDName"].Value = rcbICDCode.Text;
            reportDocument.SkipBlankPages = false;

            var instanceReportSource = new InstanceReportSource { ReportDocument = reportDocument };

            rptvICD.ReportSource = instanceReportSource;
            
        }

        #region CheckCodeExists
        //checks the names for duplicates and returns false if the name exists already in the database
        protected Boolean CheckCodeExists()
        {
            string code = rcbICDCode.Text.Trim().ToUpper();

            List<string> codes = (from c in ICDCodeClass.GetICDCodesByCompanyID(CurrentUser.CompanyID)
                                  where c.Active
                                  select c.Code.ToUpper()).ToList();

            int matchingCodes = (from c in codes
                                 where c == code
                                 select c).ToList().Count;

            if (matchingCodes > 0)
                return true;
            else
                return false;
        }
        #endregion

    }
}