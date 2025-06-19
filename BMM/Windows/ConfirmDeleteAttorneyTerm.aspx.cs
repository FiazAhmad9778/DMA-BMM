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
    public partial class ConfirmDeleteAttorneyTerm : Classes.BasePage
    {
        #region + Events

        #region Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        #endregion

        #region btnSubmit_Click
        /// <summary>
        /// sets the selected user to inactive and closes the window
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int id;

            if (Int32.TryParse(Request.QueryString["id"], out id))
            {
                BMM_DAL.AttorneyTerm myTerm = AttorneyClass.GetAttorneyTermByID(id);
                myTerm.Deleted = true;
                AttorneyClass.UpdateAttorneyTerm(myTerm);
            }

            ClientScript.RegisterClientScriptBlock(Page.GetType(), "Close", "Close();", true);
        }
        #endregion

        #endregion
    }
}