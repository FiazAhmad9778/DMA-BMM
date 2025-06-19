using System;
using System.Linq;
using BMM.Classes;
using Telerik.Reporting;
using Telerik.Web.UI;
using BMM_BAL;
using BMM.Reports;

namespace BMM.ReportPages
{
    public partial class ClientPayoffQuotationReport : BasePage
    {
        #region Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                rptClientPayoffQuotation.Visible = false;

                FillComboBoxes();
            }          
        }
        #endregion

        #region btnGenerate_OnClick
        protected void btnGenerate_OnClick(object sender, EventArgs e)
        {
            rptClientPayoffQuotation.Visible = true;

            var reportDocument = new ClientPayoffQuotation();
            reportDocument.ReportParameters["PatientId"].Value = rcbName.SelectedValue;
            reportDocument.ReportParameters["PayoffDate"].Value = rdpPayoffDate.SelectedDate;
            reportDocument.ReportParameters["DateOfAccident"].Value = rdpDateOfAccident.SelectedDate;
            reportDocument.ReportParameters["Incomplete"].Value = cbIncomplete.Checked;
            reportDocument.ReportParameters["To"].Value = txtTo.Text;
            reportDocument.ReportParameters["Attention"].Value = txtAttention.Text;
            reportDocument.ReportParameters["Email"].Value = txtEmail.Text;
            reportDocument.ReportParameters["From"].Value = rcbFrom.SelectedValue;
            reportDocument.ReportParameters["Regarding"].Value = txtRegarding.Text;
            reportDocument.SkipBlankPages = false;
            var instanceReportSource = new InstanceReportSource { ReportDocument = reportDocument };
            rptClientPayoffQuotation.ReportSource = instanceReportSource;
        }
        #endregion

        #region rcbName_ItemsRequested
        protected void rcbName_ItemsRequested(object sender, Telerik.Web.UI.RadComboBoxItemsRequestedEventArgs e)
        {
            string text = e.Text.ToLower().Trim();
            if (text.Length > 2)
            {

                foreach (var item in (from p in PatientClass.GetPatientsByNameSearch(text, CurrentUser.CompanyID)
                                      select new Telerik.Web.UI.RadComboBoxItem(p.LastName + ", " + p.FirstName + (String.IsNullOrEmpty(p.SSN) ? String.Empty : " - " + p.SSN.Substring(p.SSN.Length - 4)), p.ID.ToString())))
                {
                    rcbName.Items.Add(item);
                }
            }
        }
        #endregion
      
        private void FillComboBoxes()
        {  
            //rcbFrom
            string[] itemsList = { "Bobbee Weiskopf", "Rhonda Cuccia", "Inez Joachim", "Ryan Jobert", "Marcela Onstott" };
            rcbFrom.DataSource = itemsList;
            rcbFrom.DataBind();
        }
    }
}