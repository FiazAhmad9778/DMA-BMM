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
    public partial class FirmInfoPopUp : Classes.BasePage
    {
        #region +Properties

        #region SelectedFirm
        //get ID from query string for use
        private Firm _SelectedFirm;
        protected Firm SelectedFirm
        {
            get
            {
                if (_SelectedFirm == null && !String.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    int id;
                    if (int.TryParse(Request.QueryString["id"], out id))
                    {
                        _SelectedFirm = FirmClass.GetFirmByID(id, true, true, true);
                    }
                }
                return _SelectedFirm;
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
                if (SelectedFirm != null)
                {
                    litName.Text = SelectedFirm.Name;
                    litAddress.Text = SelectedFirm.Street1 +
                        (String.IsNullOrEmpty(SelectedFirm.Street2) ? String.Empty : "<br/><span style='margin-left:72px'>" + SelectedFirm.Street2 + "</span>") +
                        "<br/><span style='margin-left:72px'>" + SelectedFirm.City + ", " + SelectedFirm.State.Abbreviation + " " + SelectedFirm.ZipCode + "</span>";
                    litPhone.Text = SelectedFirm.Phone;
                    litFax.Text = String.IsNullOrEmpty(SelectedFirm.Fax) ? "N/A" : SelectedFirm.Fax;
                }
            }
        }
        #endregion

        #region grdContacts_OnNeedDataSource
        //loads and reloads the grid with the contacts
        protected void grdContacts_OnNeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            if (SelectedFirm != null)
            {
                grdContacts.DataSource = (from c in SelectedFirm.ContactList.Contacts
                                              orderby c.Name
                                              select c).ToList();
            }
        }
        #endregion

        #region grdAttorneys_NeedDataSource
        //loads and reloads the grid with the attorneys
        protected void grdAttorneys_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            if (SelectedFirm != null)
            {
                grdAttorneys.DataSource = (from a in SelectedFirm.Attorneys
                                          orderby a.LastName ascending, a.FirstName ascending
                                          select a).ToList();
            }
        }
        #endregion


        #endregion

    }
}