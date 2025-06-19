using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using BMM_BAL;
using BMM_DAL;

namespace BMM
{
    public partial class Login : Classes.BasePage
    {
        #region + Properties
        #region SelectedNavigationTab
        public override NavigationTabEnum SelectedNavigationTab
        {
            get { return NavigationTabEnum.None; }
        }
        #endregion
        #endregion

        #region + Events

        #region Page_Load
        /// <summary>
        /// Does nothing ATM
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
                Title = Company.Name + " - Login";
        }
        #endregion

        #region btnLogin_Click
        /// <summary>
        /// Checks the user'p username and password and logs them in 
        /// if there is a match.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            litPasswordError.Visible = false;
            BMM_DAL.User myUser = UserClass.GetUserByEmailAndPassword(txtUsername.Text.Trim(), txtPassword.Text.Trim(), Company.ID, true);

            if (myUser == null || myUser.CompanyID != Company.ID || !string.Equals(myUser.Password, txtPassword.Text.Trim()))
            {
                litPasswordError.Visible = true;
            }
            else
            {
                CurrentUser = myUser;
                FormsAuthentication.RedirectFromLoginPage(CurrentUser.Email, false);
            }
        }
        #endregion

        #endregion
    }
}
