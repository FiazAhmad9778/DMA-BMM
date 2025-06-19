using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BMM.Reports;
using Telerik.Reporting;
using BMM.Classes;
using Telerik.Web.UI;
using BMM_BAL;


namespace BMM.ReportPages
{
    public partial class AttorneyLettersReport : BasePage
    {
        #region Page_Load
        /// <summary>
        /// Load the Report
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)           
                rvAttorneyLetter.Visible = false;            
        }
        #endregion

        #region rcbAttorney_ItemsRequested
        protected void rcbAttorney_ItemsRequested(object sender, Telerik.Web.UI.RadComboBoxItemsRequestedEventArgs e)
        {
            string text = e.Text.Trim();
            if (text.Length > 2)
            {
                List<RadComboBoxItem> attorneys =
                    (from a in AttorneyClass.GetAttorneysByCompanyID(CurrentUser.CompanyID, true, false)
                     where a.FirstName.ToLower().Contains(text.ToLower()) || a.LastName.ToLower().Contains(text.ToLower())
                     orderby a.LastName, a.FirstName
                     select new RadComboBoxItem(a.LastName + ", " + a.FirstName, a.ID.ToString())).ToList
                        ();
                foreach (var item in attorneys)
                {
                    rcbAttorney.Items.Add(item);
                }
            }
        }
        #endregion

        #region btnGenerate_Click
        /// <summary>
        /// Refresh the Report
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnGenerate_Click(object sender, EventArgs e)
        {
            int attorneyID;
            if (rblAttorneyLetter.SelectedValue == "1")
            {
                attorneyID = Convert.ToInt32(rcbAttorney.SelectedValue);
            }
            else
            {
                attorneyID = -1;
            }
            var attorneyLetterReport = new InstanceReportSource {ReportDocument = new AttorneyLetterAllInvoice()};
            attorneyLetterReport.Parameters.Add("Position", CurrentUser.Position);
            attorneyLetterReport.Parameters.Add("FirstName", CurrentUser.FirstName);
            attorneyLetterReport.Parameters.Add("LastName", CurrentUser.LastName);
            attorneyLetterReport.Parameters.Add("CompanyId", CurrentUser.CompanyID);
            attorneyLetterReport.Parameters.Add("AttorneyId", attorneyID);
            rvAttorneyLetter.ReportSource = attorneyLetterReport;
            rvAttorneyLetter.RefreshReport();
            rvAttorneyLetter.Visible = true;
            
        }

        #endregion

        protected void rblAttorneyLetter_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rblAttorneyLetter.SelectedValue == "1")
            {
                rcbAttorney.Visible = true;
                rfvAttorney.Enabled = true;
            }
            else
            {
                rcbAttorney.Visible = false;
                rfvAttorney.Enabled = false;
            }
        }
       
    }
}