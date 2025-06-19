using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BMM_BAL;
using BMM_DAL;

namespace BMM
{
    public partial class Home : Classes.BasePage
    {
        #region + Properties

        #region SelectedNavigationTab
        public override NavigationTabEnum SelectedNavigationTab
        {
            get { return NavigationTabEnum.Home; }
        }
        #endregion

        #endregion

        #region + Events

        #region Page_Load
        /// <summary>
        /// Sets the inital dates to today and 12 months back
        /// also fills the information according to these months
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                Title = Company.Name + " - Home";
                rdpStartDate.SelectedDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                rdpEndDate.SelectedDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).AddMonths(1).AddDays(-1);
                FillGeneralStats();
            }
        }
        #endregion

        #region btnUpdateStatistiscs_Click
        /// <summary>
        /// Calls the fill statistics function
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnUpdateStatistiscs_Click(object sender, EventArgs e)
        {
            FillGeneralStats();
        }
        #endregion

        #endregion

        #region + Helpers

        #region FillGeneralStats
        /// <summary>
        /// Fills the literals with some General statistics
        /// </summary>
        private void FillGeneralStats()
        {
            procGetGeneralStatisticsResult myResults = InvoiceClass.GetGeneralStatistics((DateTime)rdpStartDate.SelectedDate, (DateTime)rdpEndDate.SelectedDate, Company.ID);

            litTotalTest.Text = (myResults.TotalTests ?? 0).ToString();            
            litTotalSurgeries.Text = (myResults.TotalSurgeries ?? 0).ToString();
            litTotalAmount.Text = (myResults.TotalAmountCollected ?? 0).ToString("c");
            litPaymentsMade.Text = (myResults.TotalPaymentsMade ?? 0).ToString("c");

            litLastSurgeryInvoiceID.Text = InvoiceClass.GetLastInvoiceNumber(Company.ID, Convert.ToInt32(InvoiceClass.InvoiceTypeEnum.Surgery)).ToString();
            litLastTestInvoiceID.Text = InvoiceClass.GetLastInvoiceNumber(Company.ID, Convert.ToInt16(InvoiceClass.InvoiceTypeEnum.Testing)).ToString();
        }
        #endregion

        #endregion
    }
}