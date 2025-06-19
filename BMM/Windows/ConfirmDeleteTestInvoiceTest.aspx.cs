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
    public partial class ConfirmDeleteTestInvoiceTest : Classes.BasePage
    {
        #region + Events

        #region btnSubmit_Click
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int id;

            if (Int32.TryParse(Request.QueryString["id"], out id))
            {
                Classes.TemporaryInvoice invoice = new Classes.TemporaryInvoice(Session, Company.ID, null, InvoiceSessionKey);
                TestInvoice_Test_Custom tit_c = (from t in invoice.Tests
                                                 where t.ID == id
                                                 select t).FirstOrDefault();
                if (tit_c != null)
                {
                    tit_c.Active = false;
                    // remove added codes
                    foreach (TestInvoice_Test_CPTCodes_Custom titc_c in (from s in tit_c.CPTCodeList where s.ID < 1 select s))
                    {
                        tit_c.CPTCodeList.Remove(titc_c);
                    }
                    // inactivate old codes
                    foreach (TestInvoice_Test_CPTCodes_Custom titc_c in tit_c.CPTCodeList)
                    {
                        titc_c.Active = false;
                    }
                }
            }

            ClientScript.RegisterClientScriptBlock(Page.GetType(), "Close", "Close(true);", true);
        }
        #endregion

        #endregion
    }
}