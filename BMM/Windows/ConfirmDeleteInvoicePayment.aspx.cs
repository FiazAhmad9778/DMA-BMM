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
    public partial class ConfirmDeleteInvoicePayment : Classes.BasePage
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

        #region btnSubmit_Click
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int id;

            if (Int32.TryParse(Request.QueryString["id"], out id) && Invoice != null)
            {
                Payment payment = (from ip in Invoice.Payments
                                   where ip.ID == id
                                   select ip).FirstOrDefault();

                if (payment != null)
                {
                    if (payment.ID > 0)
                    {
                        payment.Active = false;
                    }
                    else
                    {
                        Invoice.Payments.Remove(payment);
                    }
                }
            }

            ClientScript.RegisterClientScriptBlock(Page.GetType(), "Close", "Close(true,'" + Request.QueryString["id"] + "');", true);
        }
        #endregion

        #endregion
    }
}