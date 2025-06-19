using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BMM_BAL;
using BMM_DAL;

namespace BMM.Windows
{
    public partial class ConfirmDeleteSurgeryInvoiceProvider : Classes.BasePage
    {
        #region Invoice
        private Classes.TemporaryInvoice _Invoice;
        public Classes.TemporaryInvoice Invoice
        {
            get
            {
                if (_Invoice == null && Classes.TemporaryInvoice.Exists(Session, InvoiceSessionKey))
                {
                    _Invoice = new Classes.TemporaryInvoice(Session, Company.ID, null, InvoiceSessionKey);
                }
                return _Invoice;
            }
        }
        #endregion

        #region + Events

        #region Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {
            int id;

            if (Int32.TryParse(Request.QueryString["id"], out id) && CanInactivateProvider(id))
            {
                litTitle.Text = "Confirm Provider Deletion";
                litContent.Text = "Are you sure you want to delete this record?";
            }
            else
            {
                litTitle.Text = "Cannot Delete Provider";
                litContent.Text = "Can not delete selected Provider because payments have been logged to the Provider.";
                btnCancel.Text = "OK";
                btnSubmit.Visible = false;
            }
        }
        #endregion

        #region btnSubmit_Click
        /// <summary>
        /// sets the selected SurgeryInvoice_Provider to inactive and closes the window
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int id;

            if (Int32.TryParse(Request.QueryString["id"], out id) && Invoice != null && CanInactivateProvider(id))
            {
                SurgeryInvoice_Provider_Custom provider = (from it in Invoice.Providers
                                                           where it.ID == id
                                                           select it).FirstOrDefault();
                if (provider != null)
                {
                    // inactive invoice provider
                    provider.Active = false;
                    // remove all new codes
                    provider.CPTCodes.RemoveAll(c => c.ID < 0);
                    // inactivate existing codes
                    provider.CPTCodes.ForEach(c => c.Active = false);
                    // remove all new attorneyPayments
                    provider.Payments.RemoveAll(c => c.ID < 0);
                    // inactivate existing attorneyPayments
                    provider.Payments.ForEach(c => c.Active = false);
                    // remove all new services
                    provider.ProviderServices.RemoveAll(c => c.ID < 0);
                    // inactivate existing services
                    provider.ProviderServices.ForEach(c => c.Active = false);
                }
            }

            ClientScript.RegisterClientScriptBlock(Page.GetType(), "Close", "Close(true);", true);
        }
        #endregion

        #endregion

        #region + Helpers

        private bool CanInactivateProvider(int id)
        {
            if (Invoice != null)
            {
                // get the provider
                SurgeryInvoice_Provider_Custom provider = (from p in Invoice.Providers
                                                           where p.Active && p.ID == id
                                                           select p).FirstOrDefault();
                if (provider != null)
                {
                    // get any active payments
                    // if not found, allow deletion
                    return (from payment in provider.Payments
                            where payment.Active
                            select payment).FirstOrDefault() == null;
                }
            }
            return false;
        }

        #endregion
    }
}