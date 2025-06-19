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
    public partial class ProviderInfoPopUp : Classes.BasePage
    {
        #region +Properties

        #region SelectedProvider
        //get ID from query string for use
        private Provider _SelectedProvider;
        protected Provider SelectedProvider
        {
            get
            {
                if (_SelectedProvider == null && !String.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    int id;
                    if (int.TryParse(Request.QueryString["id"], out id))
                    {
                        _SelectedProvider = ProviderClass.GetProviderByID(id, true, true, false);
                    }
                }
                return _SelectedProvider;
            }
        }
        #endregion

        #region SelectedInvoiceProvider
        //get ID from query string for use
        private InvoiceProvider _SelectedInvoiceProvider;
        protected InvoiceProvider SelectedInvoiceProvider
        {
            get
            {
                if (_SelectedInvoiceProvider == null && !String.IsNullOrEmpty(Request.QueryString["ipid"]))
                {
                    int ipid;
                    if (int.TryParse(Request.QueryString["ipid"], out ipid))
                    {
                        _SelectedInvoiceProvider = ProviderClass.GetInvoiceProviderByID(ipid, true, true);
                    }
                }
                return _SelectedInvoiceProvider;
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
                if (SelectedProvider != null)
                    loadProviderInformation();
                else if (SelectedInvoiceProvider != null)
                    loadInvoiceProviderInformation();
            }
        }
        #endregion

        #region grdProviderInfo_OnNeedDataSource
        //loads and reloads the grid with the contacts
        protected void grdProviderInfo_OnNeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            if (SelectedProvider != null)
            {
                List<Contact> contacts = (from c in SelectedProvider.ContactList.Contacts
                                          orderby c.Name
                                          select c).ToList();
                grdProviderInfo.DataSource = contacts;
            }
            else if (SelectedInvoiceProvider != null)
            {
                List<InvoiceContact> contacts = (from c in SelectedInvoiceProvider.InvoiceContactList.InvoiceContacts
                                          orderby c.Name
                                          select c).ToList();
                grdProviderInfo.DataSource = contacts;
            }
        }
        #endregion

        #endregion

        #region +Helpers

        #region loadProviderInformation
        //loads the information in the upper portion of the page
        private void loadProviderInformation()
        {
            litName.Text = SelectedProvider.Name;
            litPhone.Text = SelectedProvider.Phone;
            litFacility.Text = SelectedProvider.FacilityAbbreviation;
            litFax.Text = SelectedProvider.Fax;
            litNotes.Text = SelectedProvider.Notes;
            litEmail.Text = SelectedProvider.Email;
            litDiscount.Text = String.Format("{0:#}", SelectedProvider.DiscountPercentage.HasValue ? SelectedProvider.DiscountPercentage.Value * 100 : 0) + "%";
            litPaymentDue.Text = SelectedProvider.DaysUntilPaymentDue.ToString();

            if(SelectedProvider.MRICostTypeID == (int)ProviderClass.MRICostTypeEnum.Flat_Rate && SelectedProvider.MRICostFlatRate.HasValue)
                litMRI.Text = "$" + SelectedProvider.MRICostFlatRate.ToString();
            else if (SelectedProvider.MRICostTypeID == (int)ProviderClass.MRICostTypeEnum.Percentage && SelectedProvider.MRICostPercentage.HasValue)
                litMRI.Text = String.Format("{0:#}", SelectedProvider.MRICostPercentage * 100) + "%";
            else litMRI.Text = "100%";

            string address = String.Empty;
            if (!String.IsNullOrWhiteSpace(SelectedProvider.Street2))
                address = SelectedProvider.Street1 + "<br /><span style=\"margin-left: 72px;\"></span>" + SelectedProvider.Street2 + "<br /><span style=\"margin-left: 72px;\"></span>" + SelectedProvider.City + ", " + SelectedProvider.State.Abbreviation + " " + SelectedProvider.ZipCode;
            else
                address = SelectedProvider.Street1 + "<br /><span style=\"margin-left: 72px;\"></span>" + SelectedProvider.City + ", " + SelectedProvider.State.Abbreviation + " " + SelectedProvider.ZipCode;

            litAddress.Text = address;
        }
        #endregion

        #region loadInvoiceProviderInformation
        //loads the information in the upper portion of the page
        private void loadInvoiceProviderInformation()
        {
            litName.Text = SelectedInvoiceProvider.Name;
            litPhone.Text = SelectedInvoiceProvider.Phone;
            litFacility.Text = SelectedInvoiceProvider.FacilityAbbreviation;
            litFax.Text = SelectedInvoiceProvider.Fax;
            litNotes.Text = SelectedInvoiceProvider.Notes;
            litEmail.Text = SelectedInvoiceProvider.Email;
            litDiscount.Text = String.Format("{0:#}", SelectedInvoiceProvider.DiscountPercentage.HasValue ? SelectedInvoiceProvider.DiscountPercentage.Value * 100 : 0) + "%";
            litPaymentDue.Text = SelectedInvoiceProvider.DaysUntilPaymentDue.ToString();

            if (SelectedInvoiceProvider.MRICostTypeID == (int)ProviderClass.MRICostTypeEnum.Flat_Rate && SelectedInvoiceProvider.MRICostFlatRate.HasValue)
                litMRI.Text = "$" + SelectedInvoiceProvider.MRICostFlatRate.ToString();
            else if (SelectedInvoiceProvider.MRICostTypeID == (int)ProviderClass.MRICostTypeEnum.Percentage && SelectedInvoiceProvider.MRICostPercentage.HasValue)
                litMRI.Text = String.Format("{0:#}", SelectedInvoiceProvider.MRICostPercentage * 100) + "%";
            else litMRI.Text = "100%";

            string address = String.Empty;
            if (!String.IsNullOrWhiteSpace(SelectedInvoiceProvider.Street2))
                address = SelectedInvoiceProvider.Street1 + "<br /><span style=\"margin-left: 72px;\"></span>" + SelectedInvoiceProvider.Street2 + "<br /><span style=\"margin-left: 72px;\"></span>" + SelectedInvoiceProvider.City + ", " + SelectedInvoiceProvider.State.Abbreviation + " " + SelectedInvoiceProvider.ZipCode;
            else
                address = SelectedInvoiceProvider.Street1 + "<br /><span style=\"margin-left: 72px;\"></span>" + SelectedInvoiceProvider.City + ", " + SelectedInvoiceProvider.State.Abbreviation + " " + SelectedInvoiceProvider.ZipCode;

            litAddress.Text = address;
        }
        #endregion

        #endregion
    }
}