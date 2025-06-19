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
    public partial class TestStyles_BMM : Classes.BasePage
    {

        #region SelectedNavigationTab
        public override NavigationTabEnum SelectedNavigationTab
        {
            get { return NavigationTabEnum.AdminConfiguration; }
        }
        #endregion

        #region SelectedSubNavigationTab
        public override SubNavigationTabEnum SelectedSubNavigationTab
        {
            get { return SubNavigationTabEnum.AdminTests; }
        }
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                RadComboBox1.EmptyMessage = "select";
                cboTest.EmptyMessage = "select";
                FillGrid();
            }
        }

        #region btnSearch_Click
        /// <summary>
        /// Redirects the user to teh add/edit page
        /// </summary>
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            int id;

            if (int.TryParse(rcbAttorneySearch.SelectedValue, out id))
            {
                Response.Redirect("/AddEditAttorney.aspx?id=" + id);
            }
            else
                rcbAttorneySearch.ClearSelection();
        }
        #endregion

        #region rcbAttorneySearch_ItemsRequested
        //loads the combo box with the attorney names
        protected void rcbAttorneySearch_ItemsRequested(object sender, Telerik.Web.UI.RadComboBoxItemsRequestedEventArgs e)
        {
            string text = e.Text.ToLower().Trim();
            if (text.Length > 2)
            {
                foreach (var item in (from a in AttorneyClass.GetAttorneysByNameSearch(text, CurrentUser.CompanyID, true)
                                      select new Telerik.Web.UI.RadComboBoxItem(a.LastName + ", " + a.FirstName + " (" + a.Firm.Name + ")", a.ID.ToString())))
                {
                    rcbAttorneySearch.Items.Add(item);
                }
            }
        }
        #endregion

        private void FillGrid()
        {
            List<TempUser> myList = new List<TempUser>();
            for (int i = 0; i <= 5; i++)
            {
                TempUser myUser = new TempUser()
                {
                    FName = "First",
                    LName = "Last",
                    Address = "Some Street address"
                };

                myList.Add(myUser);
            }

            grdTest.DataSource = myList;
            grdTest.DataBind();
        }
    }

    public class TempUser
    {
        private String _FName;
        private String _LName;
        private String _Address;

        public String FName
        {
            get { return _FName; }
            set { _FName = value; }
        }

        public String LName
        {
            get { return _LName; }
            set { _LName = value; }
        }


        public String Address
        {
            get { return _Address; }
            set { _Address = value; }
        }
    }
}