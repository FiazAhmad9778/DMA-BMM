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
    public partial class LoanTerms : Classes.BasePage
    {
        #region +Properties

        #region RequiredPermission
        /// <summary>
        /// Sets the permission for the page
        /// </summary>
        public override UserClass.PermissionsEnum? RequiredPermission
        {
            get
            {
                return UserClass.PermissionsEnum.Admin_LoanTerms;
            }
        }
        #endregion

        #region CurrentUsersPermission
        /// <summary>
        /// Gets the permissions for the user to see if they can add/edit/delete Tests/procedures
        /// </summary>
        private UserPermission _CurrentUsersPermission;
        public UserPermission CurrentUsersPermission
        {
            get
            {
                if (_CurrentUsersPermission == null)
                {
                    _CurrentUsersPermission = (from p in CurrentUser.UserPermissions
                                               where p.PermissionID == (int)UserClass.PermissionsEnum.Admin_LoanTerms
                                               && p.Active
                                               select p).FirstOrDefault();
                }

                return _CurrentUsersPermission;
            }
        }
        #endregion

        #region SelectedNavigationTab
        /// <summary>
        /// sets the navigation tab
        /// </summary>
        public override NavigationTabEnum SelectedNavigationTab
        {
            get { return NavigationTabEnum.AdminConfiguration; }
        }
        #endregion

        #region SelectedSubNavigationTab
        /// <summary>
        /// Sets the sub nav tab
        /// </summary>
        public override SubNavigationTabEnum SelectedSubNavigationTab
        {
            get { return SubNavigationTabEnum.AdminLoanTerms; }
        }
        #endregion

        #endregion

        #region +Events

        #region Page_Load
        /// <summary>
        /// Sets up the page
        /// </summary>
        protected void Page_Load(object sender, EventArgs e)
        {
            Title = Company.Name + " - Manage Loan Terms";

            if (!Page.IsPostBack)
            {                
                CheckUserPermission();
                LoadLoanTerms();
            }
        }
        #endregion

        #region btnSave_Click
        /// <summary>
        /// updates the loan terms in the database and redirects to the home page
        /// </summary>
        protected void btnSave_Click(object sender, EventArgs e)
        {
            LoanTerm updatedTerms = new LoanTerm();
            string testLoanIntrest = txtTestLoanIntrest.Text.Trim();
            string surgeryLoanInterest = txtSurgeryLoanIntrest.Text.Trim();

            if (testLoanIntrest.Contains("%"))
                testLoanIntrest = testLoanIntrest.Substring(0, testLoanIntrest.Length - 1);

            if (surgeryLoanInterest.Contains("%"))
                surgeryLoanInterest = surgeryLoanInterest.Substring(0, surgeryLoanInterest.Length - 1);

            double interest_Test;
            if (double.TryParse(txtTestLoanIntrest.Text.Substring(0, testLoanIntrest.Length), out interest_Test))
                updatedTerms.Testing_YearlyInterest = Convert.ToDecimal(interest_Test / 100);

            double interest_Surgery;
            if (double.TryParse(txtSurgeryLoanIntrest.Text.Substring(0, surgeryLoanInterest.Length), out interest_Surgery))
                updatedTerms.Surgery_YearlyInterest = Convert.ToDecimal(interest_Surgery / 100);

            int term_Test;
            if (int.TryParse(txtTestLoanTerm.Text.Trim(), out term_Test))
                updatedTerms.Testing_LoanTermMonths = term_Test;

            int term_Surgery;
            if (int.TryParse(txtSurgeryLoanTerm.Text.Trim(), out term_Surgery))
                updatedTerms.Surgery_LoanTermMonths = term_Surgery;

            int feeTime_Test;
            if (int.TryParse(txtTestFeeWaivedTime.Text.Trim(), out feeTime_Test))
                updatedTerms.Testing_ServiceFeeWaivedMonths = feeTime_Test;

            int feeTime_Surgery;
            if (int.TryParse(txtSurgeryFeeWaivedTime.Text.Trim(), out feeTime_Surgery))
                updatedTerms.Surgery_ServiceFeeWaivedMonths = feeTime_Surgery;

            updatedTerms.CompanyID = CurrentUser.CompanyID;

            LoanTermsClass.InsertLoanTerms(updatedTerms);
            Response.Redirect("/Home.aspx");
        }
        #endregion

        #region btnCancel_Click
        /// <summary>
        /// cancels the edit
        /// </summary>
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("/Home.aspx");
        }
        #endregion

        #endregion

        #region +Helpers

        #region CheckUserPermission
        /// <summary>
        /// Disables the add button if the user doesn'test have permission to add/edit stuff
        /// </summary>
        private void CheckUserPermission()
        {
            if (!CurrentUsersPermission.AllowAdd || !CurrentUsersPermission.AllowEdit)
            {
                btnSave.Enabled = false;

                //if no permissions for add/edit disable textboxes
                txtSurgeryFeeWaivedTime.Enabled = false;
                txtSurgeryLoanIntrest.Enabled = false;
                txtSurgeryLoanTerm.Enabled = false;
                txtTestFeeWaivedTime.Enabled = false;
                txtTestLoanIntrest.Enabled = false;
                txtTestLoanTerm.Enabled = false;

                btnSave.ToolTip = TextUserDoesntHavePermissionText;
            }
        }
        #endregion

        #region LoadLoanTerms
        //loads the loan terms into the textboxes
        protected void LoadLoanTerms()
        {
            LoanTerm loanTerms = LoanTermsClass.GetCurrentLoanTermsByCompanyID(CurrentUser.CompanyID);

            txtTestLoanIntrest.Text = String.Format("{0:#.##}", (Convert.ToDouble(loanTerms.Testing_YearlyInterest * 100)).ToString()) + "%";
            txtTestLoanTerm.Text = loanTerms.Testing_LoanTermMonths.ToString();
            txtTestFeeWaivedTime.Text = loanTerms.Testing_ServiceFeeWaivedMonths.ToString();
            txtSurgeryLoanIntrest.Text = String.Format("{0:#.##}", (Convert.ToDouble(loanTerms.Surgery_YearlyInterest * 100)).ToString()) + "%";
            txtSurgeryLoanTerm.Text = loanTerms.Surgery_LoanTermMonths.ToString();
            txtSurgeryFeeWaivedTime.Text = loanTerms.Surgery_ServiceFeeWaivedMonths.ToString();
        }
        #endregion

        #endregion
    }
}