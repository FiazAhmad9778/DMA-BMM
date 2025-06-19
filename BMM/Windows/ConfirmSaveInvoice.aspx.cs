using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace BMM.Windows
{
    public partial class ConfirmSaveInvoice : Classes.BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        #region btnSubmit_Click
        /// <summary>
        ///  Close the window and save
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            ClientScript.RegisterClientScriptBlock(Page.GetType(), "Close", "Close(true);", true);
        }
        #endregion
    }
}