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
using System.Collections.Specialized;
using Telerik.Web.UI;
using BMM_BAL;

namespace BMM.ReportPages
{
    public partial class AccountsPayableReport : BasePage
    {
        #region Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                rptAccountsPayable.Visible = false;
                //FillProviderComboBox();
            }
                
                
        }
        #endregion

        #region btnGenerate_OnClick
        protected void btnGenerate_OnClick(object sender, EventArgs e)
        {
            rptAccountsPayable.Visible = true;

            var reportDocument = new AccountsPayable();
            reportDocument.ReportParameters["StartDate"].Value = rdpStartDate.SelectedDate.Value;
            reportDocument.ReportParameters["EndDate"].Value = rdpEndDate.SelectedDate.Value;
            reportDocument.ReportParameters["CompanyId"].Value = CurrentUser.CompanyID;
            reportDocument.SkipBlankPages = false;

            if (rdoProviders.SelectedValue == "1")
            {
                reportDocument.ReportParameters["ProviderId"].Value = Convert.ToInt32(rcbProviders.SelectedValue);
            }
            else
            {
                reportDocument.ReportParameters["ProviderId"].Value = -1;
            }

            var instanceReportSource = new InstanceReportSource { ReportDocument = reportDocument };

            rptAccountsPayable.ReportSource = instanceReportSource;
        }
        #endregion

        protected void rdoProviders_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdoProviders.SelectedValue == "1")
            {
                rcbProviders.Visible = true;
                rfvProviders.Enabled = true;
            }
            else
            {
                 rcbProviders.Visible = false;
                 rfvProviders.Enabled = false;
            }
        }

        protected void FillProviderComboBox()
        {

            List<RadComboBoxItem> providers = (from a in ProviderClass.GetProvidersByCompanyID(CurrentUser.CompanyID)
                                               orderby a.Name
                                               select new RadComboBoxItem(a.Name, a.ID.ToString())).ToList();
            foreach (var i in providers)
            {
                rcbProviders.Items.Add(i);
            }

        }

        protected void rcbProviders_ItemsRequested(object sender, RadComboBoxItemsRequestedEventArgs e)
        {
            string text = e.Text.Trim();
            if (text.Length > 2)
            {
                List<RadComboBoxItem> providers = (from a in ProviderClass.GetProvidersByCompanyID(CurrentUser.CompanyID)
                                                   where a.Name.ToLower().Contains(text.ToLower())
                                                   orderby a.Name
                                                   select new RadComboBoxItem(a.Name, a.ID.ToString())).ToList();
                
                foreach (var item in providers)
                {
                    rcbProviders.Items.Add(item);
                }
            }
        }

    }
}