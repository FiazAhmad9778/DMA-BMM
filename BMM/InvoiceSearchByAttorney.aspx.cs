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
    public partial class InvoiceSearchByAttorney : Classes.BasePage
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

        #region SelectedNavigationTab
        public override NavigationTabEnum SelectedNavigationTab
        {
            get { return NavigationTabEnum.Invoices; }
        }
        #endregion

        #region CurrentInvoicesPermission
        /// <summary>
        /// Gets the permissions for the user to see if they can add/edit/delete invoices
        /// </summary>
        private UserPermission _CurrentInvoicesPermission;
        public UserPermission CurrentInvoicesPermission
        {
            get
            {
                if (_CurrentInvoicesPermission == null)
                {
                    _CurrentInvoicesPermission = (from p in CurrentUser.UserPermissions
                                                  where p.PermissionID == (int)UserClass.PermissionsEnum.Invoices
                                                  && p.Active
                                                  select p).FirstOrDefault();
                    // if there was no permission found, spoof a UserPermission object with all permission set to false
                    if (_CurrentInvoicesPermission == null)
                    {
                        _CurrentInvoicesPermission = new UserPermission()
                        {
                            ID = -1,
                            UserID = CurrentUser.ID,
                            PermissionID = (int)UserClass.PermissionsEnum.Invoices,
                            AllowView = false,
                            AllowEdit = false,
                            AllowAdd = false,
                            AllowDelete = false,
                            DateAdded = DateTime.Now,
                            Active = true
                        };
                    }
                }

                return _CurrentInvoicesPermission;
            }
        }
        #endregion

        #region SelectedAttorneyID
        private int _SelectedAttorneyID = -2;
        protected int SelectedAttorneyID
        {
            get
            {
                if (_SelectedAttorneyID == -2)
                {
                    if (ViewState["SelectedAttorneyID"] == null)
                    {
                        _SelectedAttorneyID = -1;
                    }
                    else
                    {
                        _SelectedAttorneyID = (int)ViewState["SelectedAttorneyID"];
                    }
                }
                return _SelectedAttorneyID;
            }
        }
        #endregion

        #region SelectedAttorney
        private Attorney _SelectedAttorney;
        protected Attorney SelectedAttorney
        {
            get
            {
                if (_SelectedAttorney == null && SelectedAttorneyID > -1)
                {
                    _SelectedAttorney = AttorneyClass.GetAttorneyByID(SelectedAttorneyID, true, true, true);
                    _SelectedAttorneyID = _SelectedAttorney == null ? -1 : _SelectedAttorney.ID;
                    ViewState["SelectedAttorneyID"] = _SelectedAttorneyID;
                }
                return _SelectedAttorney;
            }
            set
            {
                _SelectedAttorney = value;
                _SelectedAttorneyID = value == null ? -1 : value.ID;
                ViewState["SelectedAttorneyID"] = _SelectedAttorneyID;
            }
        }
        #endregion

        #endregion

        #region + Events

        #region Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {
            Title = Company.Name + " - Invoice Search By Attorney";
        }
        #endregion

        #region rcbAttorneyName_ItemsRequested
        protected void rcbAttorneyName_ItemsRequested(object sender, Telerik.Web.UI.RadComboBoxItemsRequestedEventArgs e)
        {
            string text = e.Text.ToLower().Trim();
            if (text.Length > 2)
            {
                foreach (var item in (from a in AttorneyClass.GetAttorneysByNameSearch(text, CurrentUser.CompanyID, true)
                                      select new Telerik.Web.UI.RadComboBoxItem(a.LastName + ", " + a.FirstName + (a.Firm == null ? String.Empty : " (" + a.Firm.Name + ")"), a.ID.ToString())))
                {
                    rcbAttorneyName.Items.Add(item);
                }
            }
        }
        #endregion

        #region btnSearch_Click
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            ClearResults();
            if (!String.IsNullOrWhiteSpace(rcbAttorneyName.Text))
            {
                SelectedAttorney = String.IsNullOrWhiteSpace(rcbAttorneyName.SelectedValue) ? null : AttorneyClass.GetAttorneyByID(int.Parse(rcbAttorneyName.SelectedValue), true, true, true);
                if (SelectedAttorney == null)
                {
                    litError.Text = "Attorney name entered does not exist. Please try search again.";
                }
                ShowSelectedAttorney();
            }
        }
        #endregion

        #region grdInvoices_OnNeedDataSource
        protected void grdInvoices_OnNeedDataSource(object source, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            grdInvoices.DataSource = InvoiceClass.SearchInvoices_ByInvoiceAttorney(SelectedAttorneyID, true);
        }
        #endregion

        #endregion

        #region + Helpers

        #region ClearResults
        private void ClearResults()
        {
            litError.Text = "";
            divResults.Visible = false;
        }
        #endregion

        #region ShowSelectedAttorney
        private void ShowSelectedAttorney()
        {
            Attorney attorney = SelectedAttorney;
            if (attorney == null)
            {
                divResults.Visible = false;
            }
            else
            {
                divResults.Visible = true;

                litAttorneyName.Text = attorney.FirstName + " " + attorney.LastName;
                litFirmName.Text = attorney.Firm == null ? "N/A" : attorney.Firm.Name + " <a href='javascript:ViewFirmInfo(" + attorney.FirmID + ")'>See More Info</a>";
                litAddress.Text = attorney.Street1 + "<br/>" +
                    (String.IsNullOrWhiteSpace(attorney.Street2) ? String.Empty : attorney.Street2 + "<br/>") + 
                    attorney.City + ", " + attorney.State.Abbreviation + " " + attorney.ZipCode;
                litPhone.Text = String.IsNullOrWhiteSpace(attorney.Phone) ? "N/A" : attorney.Phone;
                litFax.Text = String.IsNullOrWhiteSpace(attorney.Fax) ? "N/A" : attorney.Fax;
                litEmail.Text = String.IsNullOrWhiteSpace(attorney.Email) ? "N/A" : "<a href=\"mailto:" + attorney.Email + "\">" + attorney.Email + "</a>";

                grdContacts.DataSource = (from c in attorney.ContactList.Contacts where c.Active orderby c.Name ascending select c);
                grdContacts.DataBind();

                grdInvoices.DataBind();
                grdInvoices.CurrentPageIndex = 0;
                grdInvoices.Rebind();
            }
        }
        #endregion

        #region GetAttorneyName
        public string GetAttorneyName()
        {
            return SelectedAttorney.FirstName + " " + SelectedAttorney.LastName;
        }
        #endregion

        #region GetInvoiceType
        public string GetInvoiceType(Invoice invoice)
        {
            int[] values = (int[])Enum.GetValues(typeof(InvoiceClass.InvoiceTypeEnum));
            string[] names = Enum.GetNames(typeof(InvoiceClass.InvoiceTypeEnum));
            for (int i = 0; i < values.Length; i++)
            {
                if (values[i] == invoice.InvoiceTypeID)
                {
                    return names[i];
                }
            }
            return "N/A";
        }
        #endregion

        #region GetAvailableActions
        /// <summary>
        /// Gets the actions that the user is allowed to do
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public String GetAvailableActions(Invoice invoice)
        {
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            UserPermission permission = CurrentInvoicesPermission;
            // view
            sb.Append("<a href='/AddEditInvoice.aspx?id=" + invoice.ID + "'>View</a>&nbsp;");
            // edit
            if (permission.AllowEdit)
            {
                sb.Append("&nbsp;<a href='/AddEditInvoice.aspx?id=" + invoice.ID + "'>Edit</a>");
            }
            else
            {
                sb.Append("&nbsp;<span title='" + ToolTipTextCannotEditInvoice + "'>Edit</span>");
            }
            // delete
            if (permission.AllowDelete)
            {
                sb.Append("&nbsp;<a href=\"Javascript:ConfirmDelete('" + invoice.ID + "')\">Delete</a>");
            }
            else
            {
                sb.Append("&nbsp;<span title='" + ToolTipTextCannotDeleteInvoice + "'>Delete</span>");
            }

            return sb.ToString();
        }
        #endregion

        protected void btnPrint_Click(object sender, EventArgs e)
        {
            grdInvoices.MasterTableView.GetColumn("Actions").Visible = false;
            grdInvoices.MasterTableView.ExportToPdf();
            //grdInvoices.MasterTableView.GetColumn("Actions").Visible = true;
        }


        #endregion
    }
}