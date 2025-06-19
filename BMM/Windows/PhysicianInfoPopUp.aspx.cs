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
    public partial class PhysicianInfoPopUp : Classes.BasePage
    {
        #region +Properties

        #region SelectedPhysician
        //get ID from query string for use
        private Physician _SelectedPhysician;
        protected Physician SelectedPhysician
        {
            get
            {
                if (_SelectedPhysician == null && !String.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    int id;
                    if (int.TryParse(Request.QueryString["id"], out id))
                    {
                        _SelectedPhysician = PhysicianClass.GetPhysicianByID(id, true, true);
                    }
                }
                return _SelectedPhysician;
            }
        }
        #endregion

        #region SelectedInvoicePhysician
        //get ID from query string for use
        private InvoicePhysician _SelectedInvoicePhysician;
        protected InvoicePhysician SelectedInvoicePhysician
        {
            get
            {
                if (_SelectedInvoicePhysician == null && !String.IsNullOrEmpty(Request.QueryString["ipid"]))
                {
                    int ipid;
                    if (int.TryParse(Request.QueryString["ipid"], out ipid))
                    {
                        _SelectedInvoicePhysician = PhysicianClass.GetInvoicePhysicianByID(ipid, true, true);
                    }
                }
                return _SelectedInvoicePhysician;
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
                if (SelectedPhysician != null)
                    loadPhysicianInformation();
                else if (SelectedInvoicePhysician != null)
                    loadInvoicePhysicianInformation();
            }
        }
        #endregion

        #region grdPhysicianInfo_OnNeedDataSource
        //loads and reloads the grid with the contacts
        protected void grdPhysicianInfo_OnNeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            if (SelectedPhysician != null)
            {
                List<Contact> contacts = (from c in SelectedPhysician.ContactList.Contacts
                                          orderby c.Name
                                          select c).ToList();
                grdPhysicianInfo.DataSource = contacts;
            }
            else if (SelectedInvoicePhysician != null)
            {
                List<InvoiceContact> contacts = (from c in SelectedInvoicePhysician.InvoiceContactList.InvoiceContacts
                                                 orderby c.Name
                                                 select c).ToList();
                grdPhysicianInfo.DataSource = contacts;
            }
        }
        #endregion

        #endregion

        #region +Helpers

        #region loadPhysicianInformation
        //loads the information in the upper portion of the page
        private void loadPhysicianInformation()
        {
            litName.Text = Server.HtmlEncode(SelectedPhysician.FirstName + " " + SelectedPhysician.LastName);
            litPhone.Text = Server.HtmlEncode(SelectedPhysician.Phone);
            litFax.Text = Server.HtmlEncode(SelectedPhysician.Fax);
            litNotes.Text = Server.HtmlEncode((SelectedPhysician.Notes ?? String.Empty).Trim()).Replace("\n", "<br/>");
            litEmail.Text = Server.HtmlEncode(SelectedPhysician.EmailAddress);

            if (!String.IsNullOrWhiteSpace(SelectedPhysician.Street2))
                litAddress.Text = SelectedPhysician.Street1 + "<br /><span style=\"margin-left: 72px;\"></span>" + SelectedPhysician.Street2 + "<br /><span style=\"margin-left: 72px;\"></span>" + SelectedPhysician.City + ", " + SelectedPhysician.State.Abbreviation + " " + SelectedPhysician.ZipCode;
            else
                litAddress.Text = SelectedPhysician.Street1 + "<br /><span style=\"margin-left: 72px;\"></span>" + SelectedPhysician.City + ", " + SelectedPhysician.State.Abbreviation + " " + SelectedPhysician.ZipCode;
        }
        #endregion

        #region loadInvoicePhysicianInformation
        //loads the information in the upper portion of the page
        private void loadInvoicePhysicianInformation()
        {
            litName.Text = Server.HtmlEncode(SelectedInvoicePhysician.FirstName + " " + SelectedInvoicePhysician.LastName);
            litPhone.Text = Server.HtmlEncode(SelectedInvoicePhysician.Phone);
            litFax.Text = Server.HtmlEncode(SelectedInvoicePhysician.Fax);
            litNotes.Text = Server.HtmlEncode((SelectedInvoicePhysician.Notes ?? String.Empty).Trim()).Replace("\n", "<br/>");
            litEmail.Text = Server.HtmlEncode(SelectedInvoicePhysician.EmailAddress);

            if (!String.IsNullOrWhiteSpace(SelectedInvoicePhysician.Street2))
                litAddress.Text = SelectedInvoicePhysician.Street1 + "<br /><span style=\"margin-left: 72px;\"></span>" + SelectedInvoicePhysician.Street2 + "<br /><span style=\"margin-left: 72px;\"></span>" + SelectedInvoicePhysician.City + ", " + SelectedInvoicePhysician.State.Abbreviation + " " + SelectedInvoicePhysician.ZipCode;
            else
                litAddress.Text = SelectedInvoicePhysician.Street1 + "<br /><span style=\"margin-left: 72px;\"></span>" + SelectedInvoicePhysician.City + ", " + SelectedInvoicePhysician.State.Abbreviation + " " + SelectedInvoicePhysician.ZipCode;
        }
        #endregion

        #endregion
    }
}