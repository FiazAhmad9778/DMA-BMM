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
    public partial class ConfirmDeleteSurgeryInvoiceSurgery : Classes.BasePage
    {
        #region + Properties

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

        #endregion

        #region + Events

        #region btnSubmit_Click
        /// <summary>
        /// sets the selected SurgeryInvoice_Surgery to inactive and closes the window
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int id;

            if (Int32.TryParse(Request.QueryString["id"], out id) && Invoice != null)
            {
                var invoiceSurgery = (from s in Invoice.Surgeries
                                      where s.ID == id
                                      select s).FirstOrDefault();
                if (invoiceSurgery != null)
                {
                    if (invoiceSurgery.ID > 0)
                    {
                        invoiceSurgery.Active = false;
                        invoiceSurgery.SurgeryDates.Clear();
                    }
                    else
                    {
                        Invoice.Surgeries.Remove(invoiceSurgery);
                    }
                }
            }

            ClientScript.RegisterClientScriptBlock(Page.GetType(), "Close", "Close(true);", true);
        }
        #endregion

        #endregion
    }
}