using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BMM_DAL;
using BMM_BAL;

namespace BMM
{
    public partial class ForgotPassword : Classes.BasePage
    {
        #region + Properties

        #region User
        /// <summary>
        /// Sets the user when the page is validated
        /// </summary>
        public BMM_DAL.User User { get; set; }
        #endregion

        #region SelectedNavigationTab
        public override NavigationTabEnum SelectedNavigationTab
        {
            get { return NavigationTabEnum.None; }
        }
        #endregion

        #endregion

        #region + Events

        #region Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                Title = Company.Name + " - Forgot Password";
        }
        #endregion

        #region btnCancel_Click
        /// <summary>
        /// Redirects the user back to the login page
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("/Login.aspx");
        }
        #endregion

        #region cvValidUsername_Validate
        /// <summary>
        /// Validates the user'p name
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void cvValidUsername_Validate(object sender, ServerValidateEventArgs e)
        {
            User = UserClass.GetUserByEmail(txtUsername.Text.Trim(), Company.ID);

            if (User == null)
            {
                e.IsValid = false;
            }
            else
            {
                e.IsValid = true;
            }
        }
        #endregion

        #region btnSubmit_Click
        /// <summary>
        /// Validates the page, if the page is valid we update the user'p info and send the email.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            // Forces the page to validate
            Page.Validate();

            // if the page is valid we continue on
            if (Page.IsValid)
            {
                // gets the new user to be updated and the compnay they belong to
                BMM_DAL.User myUser = User;
                Company myCompany = CompanyClass.GetCompanyByID(myUser.CompanyID);

                // sets the user'p password
                myUser.Password = Classes.Utility.GenerateRandomPassword();

                // gets the email text
                string body = myUser.FirstName
                    + "<br /><br />Below is your newly generated password for the " +
                    myCompany.LongName +
                    " system.  To have your password updated to one of your choosing, please contact your system administrator.<br /><br />Password: " +
                    myUser.Password
                    + "<br /><br />Thank you,<br />Site Admin";

                string subject = "Your Password to the " + myCompany.LongName + " System";
                
                // updates the user and sends the email
                UserClass.UpdateUser(myUser, false);
                SendEmail(myUser.Email, myCompany.FromEmailAddress, subject, body);

                // Redirects the user to the login screen.
                Response.Redirect("Login.aspx");
            }
        }
        #endregion

        #endregion
    }
}