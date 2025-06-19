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
    public partial class EditInvoiceLoanTerms : Classes.BasePage
    {
        #region + Properties

        #region RequiredPermission
        public override UserClass.PermissionsEnum? RequiredPermission
        {
            get
            {
                return UserClass.PermissionsEnum.Invoices;
            }
        }
        #endregion

        #region CurrentInvoicesPermission
        /// <summary>
        /// Gets the permissions for the user to see if they can add/edit/delete invoice tests
        /// </summary>
        private UserPermission _CurrentInvoicesTestsPermission;
        public UserPermission CurrentInvoicesTestsPermission
        {
            get
            {
                if (_CurrentInvoicesTestsPermission == null)
                {
                    _CurrentInvoicesTestsPermission = (from p in CurrentUser.UserPermissions
                                                       where p.PermissionID == (int)UserClass.PermissionsEnum.Invoices
                                                       && p.Active
                                                       select p).FirstOrDefault();
                    // if there was no permission found, spoof a UserPermission object with all permission set to false
                    if (_CurrentInvoicesTestsPermission == null)
                    {
                        _CurrentInvoicesTestsPermission = new UserPermission()
                        {
                            ID = -1,
                            UserID = CurrentUser.ID,
                            PermissionID = (int)UserClass.PermissionsEnum.Invoice_Tests,
                            AllowView = false,
                            AllowEdit = false,
                            AllowAdd = false,
                            AllowDelete = false,
                            DateAdded = DateTime.Now,
                            Active = true
                        };
                    }
                }

                return _CurrentInvoicesTestsPermission;
            }
        }
        #endregion

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

        #region Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Invoice != null)
            {
                if (Invoice.ID.HasValue)
                {
                    litTitle.Text = "Loan Terms for " + (Invoice.TypeIsTesting ? "Testing" : "Surgery") + " Invoice #" + Invoice.InvoiceNumber.Value;
                }
                else
                {
                    litTitle.Text = "Loan Terms for New " + (Invoice.TypeIsTesting ? "Testing" : "Surgery") + " Invoice";
                }

                decimal? yearlyInterest = Invoice.YearlyInterest;
                int? loanTermMonths = Invoice.LoanTermMonths;
                int? serviceFeeWaivedMonths = Invoice.ServiceFeeWaivedMonths;

                if (!yearlyInterest.HasValue || !loanTermMonths.HasValue || !serviceFeeWaivedMonths.HasValue)
                {
                    LoanTerm terms = LoanTermsClass.GetCurrentLoanTermsByCompanyID(Company.ID);
                    if (Invoice.TypeIsTesting)
                    {
                        yearlyInterest = terms.Testing_YearlyInterest;
                        loanTermMonths = terms.Testing_LoanTermMonths;
                        serviceFeeWaivedMonths = terms.Testing_ServiceFeeWaivedMonths;
                    }
                    else
                    {
                        yearlyInterest = terms.Surgery_YearlyInterest;
                        loanTermMonths = terms.Surgery_LoanTermMonths;
                        serviceFeeWaivedMonths = terms.Surgery_ServiceFeeWaivedMonths;
                    }
                }

                txtLoanTermMonths.Value = loanTermMonths;
                txtServiceFeeWaivedMonths.Value = serviceFeeWaivedMonths;
                txtYearlyInterest.Value = yearlyInterest.HasValue ? (double?)(yearlyInterest.Value * 100m) : (double?)null;
            }
        }
        #endregion

        #region btnYes_Click
        protected void btnYes_Click(object sender, EventArgs e)
        {
            Page.Validate();
            if (Page.IsValid && Invoice != null)
            {
                if (txtYearlyInterest.Value.HasValue) Invoice.YearlyInterest = (decimal)(txtYearlyInterest.Value.Value * 0.01d);
                if (txtLoanTermMonths.Value.HasValue) Invoice.LoanTermMonths = (int)txtLoanTermMonths.Value.Value;
                if (txtServiceFeeWaivedMonths.Value.HasValue) Invoice.ServiceFeeWaivedMonths = (int)txtServiceFeeWaivedMonths.Value.Value;
                Invoice.UseAttorneyTerms = 0;
                Invoice.CustomTerms = true;
                ClientScript.RegisterClientScriptBlock(Page.GetType(), "Close", "Close(true);", true);
            }
        }
        #endregion

        #endregion
    }
}