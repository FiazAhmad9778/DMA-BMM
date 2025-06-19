using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BMM
{
    public partial class Master : System.Web.UI.MasterPage
    {
        #region + Properties

        /// <summary>
        /// The BasePage
        /// </summary>
        public BMM.Classes.BasePage BasePage { get; set; }

        protected string ThemeName
        {
            get
            {
                if (BasePage == null) return String.Empty;
                else return BasePage.Theme;
            }
        }

        #endregion

        #region + Events

        #region Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ConfigureFavicon();
                ConfigureHeader();
            }
        }
        #endregion

        #region btnLogout_Click
        /// <summary>
        /// Logout button click event handler. Logs any current user out.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            if (BasePage != null)
            {
                BasePage.Logout();
            }
        }
        #endregion

        #endregion

        #region + Helpers

        #region ConfigureFavicon
        protected void ConfigureFavicon()
        {
            if (BasePage != null && !String.IsNullOrEmpty(BasePage.Theme))
            {
                litFavicon.Text = "<link rel=\"shortcut icon\" href=\"Images/" + BasePage.Theme + "/favicon.ico\" />";
            }
        }
        #endregion

        #region ConfigureHeader
        /// <summary>
        /// Configures the header: navigation and logout button.
        /// </summary>
        protected void ConfigureHeader()
        {
            // If there is no BasePage or CurrentUser
            if (BasePage == null || BasePage.CurrentUser == null)
            {
                // hide the logout button
                btnLogout.Visible = false;
                aHome.Visible = false;
                // hide the navigation
                ulNavigation.Visible = false;
            }
            else
            {
                // if the page has not disable navigation
                if (BasePage.ShowNavigation)
                {
                    // activate the page'p selected tab, if any
                    switch (BasePage.SelectedNavigationTab)
                    {
                        case Classes.BasePage.NavigationTabEnum.None:
                            break;
                        case Classes.BasePage.NavigationTabEnum.Home:
                            liHome.Attributes.Add("class", "Home Selected Active");
                            break;
                        case Classes.BasePage.NavigationTabEnum.Invoices:
                            liInvoices.Attributes.Add("class", "Invoices Selected Active");
                            break;
                        case Classes.BasePage.NavigationTabEnum.Patients:
                            liPatients.Attributes.Add("class", "Patients Selected Active");
                            break;
                        case Classes.BasePage.NavigationTabEnum.AdminConfiguration:
                            liAdminConfig.Attributes.Add("class", "AdminConfig Selected Active");
                            ulAdminConfig.Attributes.Add("class", "SubNavigation AdminConfig Active");
                            break;
                        case Classes.BasePage.NavigationTabEnum.Reports:
                            liReports.Attributes.Add("class", "Reports Selected Active");
                            break;
                    }
                    // activate the page'p selected subnavigation tab, if any
                    switch (BasePage.SelectedSubNavigationTab)
                    {
                        case Classes.BasePage.SubNavigationTabEnum.None:
                            break;
                        case Classes.BasePage.SubNavigationTabEnum.AdminFirms:
                            liAdminFirms.Attributes.Add("class", "Selected Active");
                            break;
                        case Classes.BasePage.SubNavigationTabEnum.AdminAttorneys:
                            liAdminAttorneys.Attributes.Add("class", "Selected Active");
                            break;
                        case Classes.BasePage.SubNavigationTabEnum.AdminProviders:
                            liAdminProviders.Attributes.Add("class", "Selected Active");
                            break;
                        case Classes.BasePage.SubNavigationTabEnum.AdminPhysicians:
                            liAdminPhysicians.Attributes.Add("class", "Selected Active");
                            break;
                        case Classes.BasePage.SubNavigationTabEnum.AdminCPTCodes:
                            liAdminCPTCodes.Attributes.Add("class", "Selected Active");
                            break;
                        case Classes.BasePage.SubNavigationTabEnum.AdminICDCodes:
                            liAdminICDCodes.Attributes.Add("class", "Selected Active");
                            break;
                        case Classes.BasePage.SubNavigationTabEnum.AdminProcedures:
                            liAdminProcedures.Attributes.Add("class", "Selected Active");
                            break;
                        case Classes.BasePage.SubNavigationTabEnum.AdminTests:
                            liAdminTests.Attributes.Add("class", "Selected Active");
                            break;
                        case Classes.BasePage.SubNavigationTabEnum.AdminLoanTerms:
                            liAdminLoanTerms.Attributes.Add("class", "Selected Active");
                            break;
                        case Classes.BasePage.SubNavigationTabEnum.AdminUsers:
                            liAdminUsers.Attributes.Add("class", "Selected Active");
                            break;
                    }
                    // show the Invoices navigation and subnavigation if the user is allowed to view it
                    liInvoices.Visible = (from up in BasePage.CurrentUser.UserPermissions
                                          where up.PermissionID == (int)BMM_BAL.UserClass.PermissionsEnum.Invoices
                                             && up.AllowView
                                             && up.Active
                                          select up).FirstOrDefault() != null;
                    // show the Patients navigation and subnavigation if the user is allowed to view it
                    liPatients.Visible = (from up in BasePage.CurrentUser.UserPermissions
                                          where up.PermissionID == (int)BMM_BAL.UserClass.PermissionsEnum.Patients
                                             && up.AllowView
                                             && up.Active
                                          select up).FirstOrDefault() != null;
                    // show the Admin navigation and subnavigation if the user is allowed to view it
                    liAdminConfig.Visible = ulAdminConfig.Visible = (from up in BasePage.CurrentUser.UserPermissions
                                                                     where up.PermissionID == (int)BMM_BAL.UserClass.PermissionsEnum.Admin
                                                                        && up.AllowView
                                                                        && up.Active
                                                                     select up).FirstOrDefault() != null;
                    // add the Admin subnavigation items as either links or plain text, depending on the user'p permissions
                    AddSubNavigationItem(liAdminFirms, BMM_BAL.UserClass.PermissionsEnum.Admin_Firms, "Firms", "/ManageFirms.aspx");
                    AddSubNavigationItem(liAdminAttorneys, BMM_BAL.UserClass.PermissionsEnum.Admin_Attorneys, "Attorneys", "/ManageAttorneys.aspx");
                    AddSubNavigationItem(liAdminProviders, BMM_BAL.UserClass.PermissionsEnum.Admin_Providers, "Providers", "/ManageProviders.aspx");
                    AddSubNavigationItem(liAdminPhysicians, BMM_BAL.UserClass.PermissionsEnum.Admin_Physicians, "Physicians", "/ManagePhysicians.aspx");
                    AddSubNavigationItem(liAdminCPTCodes, BMM_BAL.UserClass.PermissionsEnum.Admin_CPTCodes, "CPT Codes", "/ManageCPTCodes.aspx");
                    AddSubNavigationItem(liAdminICDCodes, BMM_BAL.UserClass.PermissionsEnum.Admin_CPTCodes, "ICD Codes", "/ManageICDCodes.aspx");
                    AddSubNavigationItem(liAdminProcedures, BMM_BAL.UserClass.PermissionsEnum.Admin_Surgeries, "Procedures", "/ManageSurgeries.aspx");
                    AddSubNavigationItem(liAdminTests, BMM_BAL.UserClass.PermissionsEnum.Admin_Tests, "Tests", "/ManageTests.aspx");
                    AddSubNavigationItem(liAdminLoanTerms, BMM_BAL.UserClass.PermissionsEnum.Admin_LoanTerms, "Loan Terms", "/LoanTerms.aspx");
                    AddSubNavigationItem(liAdminUsers, BMM_BAL.UserClass.PermissionsEnum.Admin_Users, "Users", "/ManageUsers.aspx");
                    // show the Invoices navigation if the user is allowed to view it
                    liReports.Visible = (from up in BasePage.CurrentUser.UserPermissions
                                         where up.PermissionID == (int)BMM_BAL.UserClass.PermissionsEnum.Reports
                                            && up.AllowView
                                            && up.Active
                                         select up).FirstOrDefault() != null;
                }
                else
                {
                    // hide the navigation
                    ulNavigation.Visible = ulAdminConfig.Visible = false;
                }
            }
        }
        #endregion

        #region AddSubNavigationItem
        /// <summary>
        /// Adds a subnavigation item as either a link or text, depending on the user'p permissions
        /// </summary>
        /// <param name="listItem">The list item in which to add the subnavigation option</param>
        /// <param name="permission">The permission required for the subnavigation option</param>
        /// <param name="name">The name of the subnavigation option</param>
        /// <param name="url">The location of the subnavigation option</param>
        private void AddSubNavigationItem(System.Web.UI.HtmlControls.HtmlGenericControl listItem,  BMM_BAL.UserClass.PermissionsEnum permission, String name, String url)
        {
            // if the user has the required (view) permission
            if ((from up in BasePage.CurrentUser.UserPermissions
                 where up.PermissionID == (int)permission
                    && up.AllowView
                    && up.Active
                 select up).FirstOrDefault() != null)
            {
                // add a link to the list item
                listItem.InnerHtml = "<a href=\"" + url + "\">" + name + "</a>";
            }
            else
            {
                // add a class and the text to the list item
                listItem.Attributes.Add("class", String.IsNullOrWhiteSpace(listItem.Attributes["class"]) ? "Disabled" : listItem.Attributes["class"] + " Disabled");
                listItem.InnerHtml = name;
            }
        }
        #endregion

        #endregion
    }
}