using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BMM.Reports;
using BMM_BAL;
using BMM_DAL;
using Telerik.Reporting;

namespace BMM.Windows
{
    public partial class ClientPayoffQuotationPopUp : Classes.BasePage
    {
        #region +Properties

        #region Selected Patient
        //get ID from query string for use
        private BMM_DAL.Patient _selectedPatient;
        protected BMM_DAL.Patient SelectedPatient
        {
            get
            {
                if (_selectedPatient == null && !String.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    int id;
                    if (int.TryParse(Request.QueryString["id"], out id))
                    {
                        _selectedPatient = PatientClass.GetPatientByID(id, true, true);
                    }
                }
                return _selectedPatient;
            }
        }
        #endregion

        #endregion

        #region Page_Load
        //loads the page
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                rptClientPayoffQuotation.Visible = false;

                FillComboBoxes();

                var item = new Telerik.Web.UI.RadComboBoxItem(SelectedPatient.LastName + ", " + SelectedPatient.FirstName + (String.IsNullOrEmpty(SelectedPatient.SSN) ? String.Empty : " - " + SelectedPatient.SSN.Substring(SelectedPatient.SSN.Length - 4)), SelectedPatient.ID.ToString());
                rcbName.Items.Add(item);
                rcbName.SelectedIndex = 0;
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
