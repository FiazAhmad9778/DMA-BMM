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
    public partial class AttorneyInfoPopUp : Classes.BasePage
    {
        #region +Properties

        #region Selected Attorney
        //get ID from query string for use
        private Attorney _SelectedAttorney;
        protected Attorney SelectedAttorney
        {
            get
            {
                if (_SelectedAttorney == null && !String.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    int id;
                    if (int.TryParse(Request.QueryString["id"], out id))
                    {
                        _SelectedAttorney = AttorneyClass.GetAttorneyByID(id, true, true, true);
                    }
                }
                return _SelectedAttorney;
            }
        }
        #endregion

        #region SelectedInvoiceAttorney
        //get ID from query string for use
        private InvoiceAttorney _SelectedInvoiceAttorney;
        protected InvoiceAttorney SelectedInvoiceAttorney
        {
            get
            {
                if (_SelectedInvoiceAttorney == null && !String.IsNullOrEmpty(Request.QueryString["iaid"]))
                {
                    int iaid;
                    if (int.TryParse(Request.QueryString["iaid"], out iaid))
                    {
                        _SelectedInvoiceAttorney = AttorneyClass.GetInvoiceAttorneyByID(iaid, true, true, true);
                    }
                }
                return _SelectedInvoiceAttorney;
            }
        }
        #endregion

        #endregion

        #region +Events

        #region Page_Load
        //loads the page
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (SelectedAttorney != null)
                    loadAttorneyInformation();
                else if (SelectedInvoiceAttorney != null)
                    loadInvoiceAttorneyInformation();
            }
        }
        #endregion

        #region grdAttorneyInfo_OnNeedDataSource
        //loads and reloads the grid with the contacts
        protected void grdAttorneyInfo_OnNeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            if (SelectedAttorney != null)
            {
                List<Contact> contacts = (from c in SelectedAttorney.ContactList.Contacts
                                          orderby c.Name
                                          select c).ToList();
                grdAttorneyInfo.DataSource = contacts;
            }
            else if (SelectedInvoiceAttorney != null)
            {
                List<InvoiceContact> contacts = (from c in SelectedInvoiceAttorney.InvoiceContactList.InvoiceContacts
                                                 orderby c.Name
                                                 select c).ToList();
                grdAttorneyInfo.DataSource = contacts;
            }
        }
        #endregion

        #endregion

        #region +Helpers

        #region loadAttorneyInformation
        //loads the information in the upper portion of the page
        private void loadAttorneyInformation()
        {
            litName.Text = Server.HtmlEncode(SelectedAttorney.FirstName + " " + SelectedAttorney.LastName);
            litPhone.Text = Server.HtmlEncode(SelectedAttorney.Phone);
            litFirm.Text = SelectedAttorney.Firm == null ? String.Empty : Server.HtmlEncode(SelectedAttorney.Firm.Name);
            litFax.Text = Server.HtmlEncode(SelectedAttorney.Fax);
            litNotes.Text = Server.HtmlEncode((SelectedAttorney.Notes ?? String.Empty).Trim()).Replace("\n", "<br/>");
            litDepositAmount.Text = (SelectedAttorney.DepositAmountRequired ?? 0m).ToString("0.00%");
            litDiscountNotes.Text = Server.HtmlEncode((SelectedAttorney.DiscountNotes ?? String.Empty).Trim()).Replace("\n", "<br/>");
            litEmail.Text = Server.HtmlEncode(SelectedAttorney.Email);
            litStatus.Text = SelectedAttorney.isActiveStatus ? "Active" : "<span class='inactiveRedText'>Inactive</span>";

            string address = String.Empty;
            if(!String.IsNullOrWhiteSpace(SelectedAttorney.Street2))
                address = SelectedAttorney.Street1 + "<br /><span style=\"margin-left: 72px;\"></span>" + SelectedAttorney.Street2 + "<br /><span style=\"margin-left: 72px;\"></span>" + SelectedAttorney.City + ", " + SelectedAttorney.State.Abbreviation + " " + SelectedAttorney.ZipCode;
            else
                address = SelectedAttorney.Street1 + "<br /><span style=\"margin-left: 72px;\"></span>" + SelectedAttorney.City + ", " + SelectedAttorney.State.Abbreviation + " " + SelectedAttorney.ZipCode;

            litAddress.Text = address;
        }
        #endregion

        #region loadInvoiceAttorneyInformation
        //loads the information in the upper portion of the page
        private void loadInvoiceAttorneyInformation()
        {
            litName.Text = Server.HtmlEncode(SelectedInvoiceAttorney.FirstName + " " + SelectedInvoiceAttorney.LastName);
            litPhone.Text = Server.HtmlEncode(SelectedInvoiceAttorney.Phone);
            litFirm.Text = SelectedInvoiceAttorney.InvoiceFirm == null ? String.Empty : Server.HtmlEncode(SelectedInvoiceAttorney.InvoiceFirm.Name);
            litFax.Text = Server.HtmlEncode(SelectedInvoiceAttorney.Fax);
            litNotes.Text = Server.HtmlEncode((SelectedInvoiceAttorney.Notes ?? String.Empty).Trim()).Replace("\n", "<br/>");
            litDepositAmount.Text = (SelectedInvoiceAttorney.DepositAmountRequired ?? 0m).ToString("0.00%");
            litDiscountNotes.Text = Server.HtmlEncode((SelectedInvoiceAttorney.DiscountNotes ?? String.Empty).Trim()).Replace("\n", "<br/>");
            litEmail.Text = Server.HtmlEncode(SelectedInvoiceAttorney.Email);
            litStatus.Text = AttorneyClass.GetAttorneyByID(SelectedInvoiceAttorney.AttorneyID, false,  false, false).isActiveStatus ? "Active" : "<span class='inactiveRedText'>Inactive</span>";


            string address = String.Empty;
            if (!String.IsNullOrWhiteSpace(SelectedInvoiceAttorney.Street2))
                address = SelectedInvoiceAttorney.Street1 + "<br /><span style=\"margin-left: 72px;\"></span>" + SelectedInvoiceAttorney.Street2 + "<br /><span style=\"margin-left: 72px;\"></span>" + SelectedInvoiceAttorney.City + ", " + SelectedInvoiceAttorney.State.Abbreviation + " " + SelectedInvoiceAttorney.ZipCode;
            else
                address = SelectedInvoiceAttorney.Street1 + "<br /><span style=\"margin-left: 72px;\"></span>" + SelectedInvoiceAttorney.City + ", " + SelectedInvoiceAttorney.State.Abbreviation + " " + SelectedInvoiceAttorney.ZipCode;

            litAddress.Text = address;
        }
        #endregion

        #endregion
    }
}
