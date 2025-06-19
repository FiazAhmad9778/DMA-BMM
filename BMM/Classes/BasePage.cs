using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net.Mail;
using System.Configuration;
using BMM_BAL;
using BMM_DAL;

namespace BMM.Classes
{
    public class BasePage : System.Web.UI.Page
    {
        #region + Constants

        protected const string TextUserDoesntHavePermissionText = "You do not have the required user permissions to perform this action.";

        #endregion

        #region + Properties

        #region Companies
        private List<Company> Companies
        {
            get
            {
                List<Company> companies;

                // if the companies list has not been cached at the application level
                // or was cached over 15 minutes ago
                if (Application["Companies"] == null || (DateTime.Now.Subtract((DateTime)Application["CompaniesDateCached"])).TotalMinutes > 30)
                {
                    // get the list of companies
                    companies = CompanyClass.GetCompanies();
                    // cache the list at the application level
                    Application["Companies"] = companies;
                    // store the time that the list was cached
                    Application["CompaniesDateCached"] = DateTime.Now;
                }
                else
                {
                    // get the list from the application cache
                    companies = (List<Company>)Application["Companies"];
                }

                return companies;
            }
        }
        #endregion

        #region Company
        private Company _Company;
        public Company Company
        {
            get
            {
                // if the backing member is null
                if (_Company == null)
                {
                    // if the company has not been cached in the user'p session
                    if (Session["Company"] == null)
                    {
                        // store a local copy of the companies list
                        List<Company> companies = Companies;
                        // get the current url/host
                        string siteURL = Context.Request.Url.Host.ToLower();
                        // get the theme for this url
                        _Company = (from c in companies
                                    where siteURL.Contains(c.SiteURL)
                                    //where c.SiteURL == "dma"
                                    select c).FirstOrDefault();
                        // if no company was matched but at least one exists, use the first one
                        if (_Company == null && companies.Count > 0)
                        {
                            _Company = companies[0];
                        }
                        // set the company to the user'p session
                        Session["Company"] = _Company;
                    }
                    else
                    {
                        // get the company from the user'p session
                        _Company = (Company)Session["Company"];
                    }
                }

                // return the backing member
                return _Company;
            }
        }
        #endregion

        #region Theme
        public override string Theme
        {
            get
            {
                return Company.ThemeName;
            }
        }
        #endregion

        #region CurrentUser
        private User _CurrentUser;
        public User CurrentUser
        {
            get
            {
                // if the backing member is null, but the value is cached in session
                if (_CurrentUser == null && Session["CurrentUserID"] != null)
                {
                    // get the value from the session
                    _CurrentUser = UserClass.GetUserByID((int)Session["CurrentUserID"], true);
                }

                // return the backing member
                return _CurrentUser;
            }
            set
            {
                _CurrentUser = value;
                if (value == null)
                {
                    Session["CurrentUserID"] = null;
                }
                else
                {
                    Session["CurrentUserID"] = value.ID;
                }
            }
        }
        #endregion

        #region RequiredPermission
        public virtual UserClass.PermissionsEnum? RequiredPermission
        {
            get { return null; }
        }
        #endregion 

        #region ShowNavigation
        public virtual bool ShowNavigation
        {
            get { return true; }
        }
        #endregion

        #region SMTPServer

        private string SMTPServer
        {
            get
            {
                string retval = ConfigurationManager.AppSettings["SMTPServer"];
                if (retval == null)
                {
                    throw new Exception("Missing SMTPServer key from web.config.");
                }
                return retval;
            }
        }

        #endregion

        #region SelectedNavigationTab
        public virtual NavigationTabEnum SelectedNavigationTab
        {
            get { return NavigationTabEnum.None; }
        }
        #endregion

        #region SelectedSubNavigationTab
        public virtual SubNavigationTabEnum SelectedSubNavigationTab
        {
            get { return SubNavigationTabEnum.None; }
        }
        #endregion

        #region + Tooltip Text

        #region ToolTipTextUserDoesntHavePermission
        private string _ToolTipTextUserDoesntHavePermission;
        public string ToolTipTextUserDoesntHavePermission
        {
            get
            {
                if (String.IsNullOrEmpty(_ToolTipTextUserDoesntHavePermission))
                {
                    _ToolTipTextUserDoesntHavePermission = TextUserDoesntHavePermissionText;
                }
                return _ToolTipTextUserDoesntHavePermission;
            }
        }
        #endregion

        #region + Invoice

        #region ToolTipTextCannotAddInvoice
        private string _ToolTipTextCannotAddInvoice;
        public string ToolTipTextCannotAddInvoice
        {
            get
            {
                if (String.IsNullOrEmpty(_ToolTipTextCannotAddInvoice))
                {
                    _ToolTipTextCannotAddInvoice = "You are unable to add any Invoices because you do not have the user permissions to do so.";
                }
                return _ToolTipTextCannotAddInvoice;
            }
        }
        #endregion

        #region ToolTipTextCannotEditInvoice
        private string _ToolTipTextCannotEditInvoice;
        public string ToolTipTextCannotEditInvoice
        {
            get
            {
                if (String.IsNullOrEmpty(_ToolTipTextCannotEditInvoice))
                {
                    _ToolTipTextCannotEditInvoice = TextUserDoesntHavePermissionText;
                }
                return _ToolTipTextCannotEditInvoice;
            }
        }
        #endregion

        #region ToolTipTextCannotDeleteInvoice
        private string _ToolTipTextCannotDeleteInvoice;
        public string ToolTipTextCannotDeleteInvoice
        {
            get
            {
                if (String.IsNullOrEmpty(_ToolTipTextCannotDeleteInvoice))
                {
                    _ToolTipTextCannotDeleteInvoice = "You are unable to delete any Invoices because you do not have the user permissions to do so.";
                }
                return _ToolTipTextCannotDeleteInvoice;
            }
        }
        #endregion

        #endregion

        #region + Test

        #region ToolTipTextCannotAddTest
        private string _ToolTipTextCannotAddTest;
        public string ToolTipTextCannotAddTest
        {
            get
            {
                if (String.IsNullOrEmpty(_ToolTipTextCannotAddTest))
                {
                    _ToolTipTextCannotAddTest = "You are unable to add any Tests because you do not have the user permissions to do so.";
                }
                return _ToolTipTextCannotAddTest;
            }
        }
        #endregion

        #region ToolTipTextCannotEditTest
        private string _ToolTipTextCannotEditTest;
        public string ToolTipTextCannotEditTest
        {
            get
            {
                if (String.IsNullOrEmpty(_ToolTipTextCannotEditTest))
                {
                    _ToolTipTextCannotEditTest = "You are unable to edit any Tests because you do not have the user permissions to do so.";
                }
                return _ToolTipTextCannotEditTest;
            }
        }
        #endregion

        #region ToolTipTextCannotDeleteTest
        private string _ToolTipTextCannotDeleteTest;
        public string ToolTipTextCannotDeleteTest
        {
            get
            {
                if (String.IsNullOrEmpty(_ToolTipTextCannotDeleteTest))
                {
                    _ToolTipTextCannotDeleteTest = "You are unable to delete any Tests because you do not have the user permissions to do so.";
                }
                return _ToolTipTextCannotDeleteTest;
            }
        }
        #endregion

        #endregion

        #region + Provider

        #region ToolTipTextCannotAddSurgery
        private string _ToolTipTextCannotAddSurgery;
        public string ToolTipTextCannotAddSurgery
        {
            get
            {
                if (String.IsNullOrEmpty(_ToolTipTextCannotAddSurgery))
                {
                    _ToolTipTextCannotAddSurgery = "You are unable to add any Surgery because you do not have the user permissions to do so.";
                }
                return _ToolTipTextCannotAddSurgery;
            }
        }
        #endregion

        #region ToolTipTextCannotEditSurgery
        private string _ToolTipTextCannotEditSurgery;
        public string ToolTipTextCannotEditSurgery
        {
            get
            {
                if (String.IsNullOrEmpty(_ToolTipTextCannotEditSurgery))
                {
                    _ToolTipTextCannotEditSurgery = TextUserDoesntHavePermissionText;
                }
                return _ToolTipTextCannotEditSurgery;
            }
        }
        #endregion

        #region ToolTipTextCannotDeleteSurgery
        private string _ToolTipTextCannotDeleteSurgery;
        public string ToolTipTextCannotDeleteSurgery
        {
            get
            {
                if (String.IsNullOrEmpty(_ToolTipTextCannotDeleteSurgery))
                {
                    _ToolTipTextCannotDeleteSurgery = "You are unable to delete any Surgeries because you do not have the user permissions to do so.";
                }
                return _ToolTipTextCannotDeleteSurgery;
            }
        }
        #endregion

        #endregion

        #region + Provider

        #region ToolTipTextCannotAddProvider
        private string _ToolTipTextCannotAddProvider;
        public string ToolTipTextCannotAddProvider
        {
            get
            {
                if (String.IsNullOrEmpty(_ToolTipTextCannotAddProvider))
                {
                    _ToolTipTextCannotAddProvider = "You are unable to add any Provider because you do not have the user permissions to do so";
                }
                return _ToolTipTextCannotAddProvider;
            }
        }
        #endregion

        #region ToolTipTextCannotEditProvider
        private string _ToolTipTextCannotEditProvider;
        public string ToolTipTextCannotEditProvider
        {
            get
            {
                if (String.IsNullOrEmpty(_ToolTipTextCannotEditProvider))
                {
                    _ToolTipTextCannotEditProvider = "You are unable to edit any Providers because you do not have the user permissions to do so.";
                }
                return _ToolTipTextCannotEditProvider;
            }
        }
        #endregion

        #region ToolTipTextCannotDeleteProvider
        private string _ToolTipTextCannotDeleteProvider;
        public string ToolTipTextCannotDeleteProvider
        {
            get
            {
                if (String.IsNullOrEmpty(_ToolTipTextCannotDeleteProvider))
                {
                    _ToolTipTextCannotDeleteProvider = "You are unable to delete any Providers because you do not have the user permissions to do so.";
                }
                return _ToolTipTextCannotDeleteProvider;
            }
        }
        #endregion

        #endregion

        #region + Payment

        #region ToolTipTextCannotAddPayment
        private string _ToolTipTextCannotAddPayment;
        public string ToolTipTextCannotAddPayment
        {
            get
            {
                if (String.IsNullOrEmpty(_ToolTipTextCannotAddPayment))
                {
                    _ToolTipTextCannotAddPayment = "You are unable to add any Payment because you do not have the user permissions to do so.";
                }
                return _ToolTipTextCannotAddPayment;
            }
        }
        #endregion

        #region ToolTipTextCannotEditPayment
        private string _ToolTipTextCannotEditPayment;
        public string ToolTipTextCannotEditPayment
        {
            get
            {
                if (String.IsNullOrEmpty(_ToolTipTextCannotEditPayment))
                {
                    _ToolTipTextCannotEditPayment = "You are unable to edit any Payments because you do not have the user permissions to do so.";
                }
                return _ToolTipTextCannotEditPayment;
            }
        }
        #endregion

        #region ToolTipTextCannotDeletePayment
        private string _ToolTipTextCannotDeletePayment;
        public string ToolTipTextCannotDeletePayment
        {
            get
            {
                if (String.IsNullOrEmpty(_ToolTipTextCannotDeletePayment))
                {
                    _ToolTipTextCannotDeletePayment = "You are unable to delete any Payments because you do not have the user permissions to do so.";
                }
                return _ToolTipTextCannotDeletePayment;
            }
        }
        #endregion

        #endregion

        #region + Comment

        #region ToolTipTextCannotAddComment
        private string _ToolTipTextCannotAddComment;
        public string ToolTipTextCannotAddComment
        {
            get
            {
                if (String.IsNullOrEmpty(_ToolTipTextCannotAddComment))
                {
                    _ToolTipTextCannotAddComment = "You are unable to add any Comment because you do not have the user permissions to do so.";
                }
                return _ToolTipTextCannotAddComment;
            }
        }
        #endregion

        #region ToolTipTextCannotEditComment
        private string _ToolTipTextCannotEditComment;
        public string ToolTipTextCannotEditComment
        {
            get
            {
                if (String.IsNullOrEmpty(_ToolTipTextCannotEditComment))
                {
                    _ToolTipTextCannotEditComment = "You are unable to edit any Comments because you do not have the user permissions to do so.";
                }
                return _ToolTipTextCannotEditComment;
            }
        }
        #endregion

        #region ToolTipTextCannotDeleteComment
        private string _ToolTipTextCannotDeleteComment;
        public string ToolTipTextCannotDeleteComment
        {
            get
            {
                if (String.IsNullOrEmpty(_ToolTipTextCannotDeleteComment))
                {
                    _ToolTipTextCannotDeleteComment = "You are unable to delete any Comments because you do not have the user permissions to do so.";
                }
                return _ToolTipTextCannotDeleteComment;
            }
        }
        #endregion

        #endregion

        #endregion

        #region InvoiceSessionKey
        private string _InvoiceSessionKey;
        public string InvoiceSessionKey
        {
            get
            {
                if (_InvoiceSessionKey == null)
                {
                    if (ViewState["InvoiceSessionKey"] != null)
                    {
                        _InvoiceSessionKey = ViewState["InvoiceSessionKey"].ToString();
                    }
                    else
                    {
                        if (!String.IsNullOrWhiteSpace(Request.QueryString["isk"]))
                        {
                            _InvoiceSessionKey = Request.QueryString["isk"];
                        }
                        else
                        {
                            _InvoiceSessionKey = DateTime.Now.Ticks.ToString("X");
                        }
                        ViewState["InvoiceSessionKey"] = _InvoiceSessionKey;
                    }
                }
                return _InvoiceSessionKey;
            }
        }
        #endregion

        #region TestSessionKey
        private string _TestSessionKey;
        public string TestSessionKey
        {
            get
            {
                if (_TestSessionKey == null)
                {
                    if (ViewState["TestSessionKey"] != null)
                    {
                        _TestSessionKey = ViewState["TestSessionKey"].ToString();
                    }
                    else
                    {
                        if (!String.IsNullOrWhiteSpace(Request.QueryString["tsk"]))
                        {
                            _TestSessionKey = Request.QueryString["tsk"];
                        }
                        else
                        {
                            _TestSessionKey = DateTime.Now.Ticks.ToString("X");
                        }
                        ViewState["TestSessionKey"] = _TestSessionKey;
                    }
                }
                return _TestSessionKey;
            }
        }
        #endregion

        #region SurgerySessionKey
        private string _SurgerySessionKey;
        public string SurgerySessionKey
        {
            get
            {
                if (_SurgerySessionKey == null)
                {
                    if (ViewState["SurgerySessionKey"] != null)
                    {
                        _SurgerySessionKey = ViewState["SurgerySessionKey"].ToString();
                    }
                    else
                    {
                        if (!String.IsNullOrWhiteSpace(Request.QueryString["ssk"]))
                        {
                            _SurgerySessionKey = Request.QueryString["ssk"];
                        }
                        else
                        {
                            _SurgerySessionKey = DateTime.Now.Ticks.ToString("X");
                        }
                        ViewState["SurgerySessionKey"] = _SurgerySessionKey;
                    }
                }
                return _SurgerySessionKey;
            }
        }
        #endregion

        #region ProviderSessionKey
        private string _ProviderSessionKey;
        public string ProviderSessionKey
        {
            get
            {
                if (_ProviderSessionKey == null)
                {
                    if (ViewState["ProviderSessionKey"] != null)
                    {
                        _ProviderSessionKey = ViewState["ProviderSessionKey"].ToString();
                    }
                    else
                    {
                        if (!String.IsNullOrWhiteSpace(Request.QueryString["psk"]))
                        {
                            _ProviderSessionKey = Request.QueryString["psk"];
                        }
                        else
                        {
                            _ProviderSessionKey = DateTime.Now.Ticks.ToString("X");
                        }
                        ViewState["ProviderSessionKey"] = _ProviderSessionKey;
                    }
                }
                return _ProviderSessionKey;
            }
        }
        #endregion

        #region CPTCodes
        public List<CPTCode> CPTCodes 
        { 
            get 
            {
                if (HttpContext.Current.Cache[CurrentCPTCodeCacheName] == null)
                {
                    HttpContext.Current.Cache.Add(CurrentCPTCodeCacheName, BMM_BAL.CPTCodeClass.GetCPTCodesByCompanyID(Company.ID), null, System.Web.Caching.Cache.NoAbsoluteExpiration, new TimeSpan(1, 0, 0, 0), System.Web.Caching.CacheItemPriority.High, null);
                }

                return (List<CPTCode>)HttpContext.Current.Cache[CurrentCPTCodeCacheName];
            } 
        }
        #endregion

        #region ICDCodes
        public List<ICDCode> ICDCodes
        {
            get
            {
                if (HttpContext.Current.Cache[CurrentICDCodeCacheName] == null)
                {
                    HttpContext.Current.Cache.Add(CurrentICDCodeCacheName, BMM_BAL.ICDCodeClass.GetICDCodesByCompanyID(Company.ID), null, System.Web.Caching.Cache.NoAbsoluteExpiration, new TimeSpan(1, 0, 0, 0), System.Web.Caching.CacheItemPriority.High, null);
                }

                return (List<ICDCode>)HttpContext.Current.Cache[CurrentICDCodeCacheName];
            }
        }
        #endregion

        public string CurrentCPTCodeCacheName
        {
            get
            {
                return "CPTCodeCache" + Company.ThemeName;
            }
        }

        public string CurrentICDCodeCacheName
        {
            get
            {
                return "ICDCodeCache" + Company.ThemeName;
            }
        }

        #endregion

        #region + Enums

        #region NavigationTabEnum
        public enum NavigationTabEnum
        {
            None,
            Home,
            Invoices,
            Patients,
            AdminConfiguration,
            Reports
        }
        #endregion

        #region SubNavigationTabEnum
        public enum SubNavigationTabEnum
        {
            None,
            AdminFirms,
            AdminAttorneys,
            AdminProviders,
            AdminPhysicians,
            AdminCPTCodes,
            AdminICDCodes,
            AdminProcedures,
            AdminTests,
            AdminLoanTerms,
            AdminUsers
        }
        #endregion

        #endregion

        #region + Events

        #region OnInit
        protected override void OnInit(EventArgs e)
        {
            RedirectUnauthorizedUsers();
            RegisterWithMasterPage();

            base.OnInit(e);
        }
        #endregion

        #endregion

        #region + Helpers

        #region RedirectUnauthorizedUsers
        private void RedirectUnauthorizedUsers()
        {
            if (Request.Url.LocalPath != "/Login.aspx" &&
                Request.Url.LocalPath != "/ForgotPassword.aspx" &&
                Request.Url.LocalPath != "/Error.aspx")
            {
                if (CurrentUser == null && !Page.IsCallback)
                {
                    System.Web.HttpContext.Current.Response.Redirect("/Login.aspx");
                }
                else if (Page.IsCallback && CurrentUser == null)
                {
                    Response.RedirectLocation = "/Login.aspx";
                    Response.End();
                    
                }
                else if (RequiredPermission.HasValue &&
                        (from up in CurrentUser.UserPermissions
                         where up.PermissionID == (int)RequiredPermission
                                && up.AllowView
                                && up.Active
                         select up).FirstOrDefault() == null)
                {
                    System.Web.HttpContext.Current.Response.Redirect("/Home.aspx");
                }
            }
        }
        #endregion

        #region RegisterWithMasterPage
        /// <summary>
        /// Registers the basepage with the master page
        /// </summary>
        private void RegisterWithMasterPage()
        {
            if (Master != null && Master is BMM.Master)
            {
                ((Master)Master).BasePage = this;
            }
        }
        #endregion

        #region Logout
        public void Logout()
        {
            System.Web.Security.FormsAuthentication.SignOut();
            Response.Clear();
            CurrentUser = null;
            Session.Abandon();
            Session.Clear();
            Response.Redirect("/Login.aspx");
        }
        #endregion
        
        #region GetCurrentUserPermission
        public UserPermission GetCurrentUserPermission(UserClass.PermissionsEnum permission)
        {
            UserPermission userPermission = (from p in CurrentUser.UserPermissions
                                             where p.PermissionID == (int)permission
                                             && p.Active
                                             select p).FirstOrDefault();

            // if there was no permission found, spoof a UserPermission object with all permission set to false
            if (userPermission == null)
            {
                userPermission = new UserPermission()
                {
                    ID = -1,
                    UserID = CurrentUser.ID,
                    PermissionID = (int)permission,
                    AllowView = false,
                    AllowEdit = false,
                    AllowAdd = false,
                    AllowDelete = false,
                    DateAdded = DateTime.Now,
                    Active = true
                };
            }

            return userPermission;
        }
        #endregion

        #region SendEmail
        public void SendEmail(string ToAddr, string FromAddr, string Subject, string Body)
        {
            MailMessage msg = new MailMessage();
            msg.From = new MailAddress(FromAddr);
            msg.To.Add(ToAddr);
            msg.Subject = Subject;
            msg.Body = Body;
            msg.IsBodyHtml = true;

            SmtpClient client = new SmtpClient(SMTPServer);
            client.Send(msg);
        }
        #endregion

        #region LoadComboBoxItems
        public void LoadComboBoxItems(Telerik.Web.UI.RadComboBox radComboBox, Type enumType)
        {
            int[] values = (int[])Enum.GetValues(enumType);
            string[] names = Enum.GetNames(enumType);
            radComboBox.Items.Clear();
            for (int i = 0; i < values.Length; i++)
            {
                radComboBox.Items.Add(new Telerik.Web.UI.RadComboBoxItem(names[i].Replace("_", " "), values[i].ToString()));
            }
        }
        #endregion

        #region GoBack
        public void GoBack(string url)
        {
            if (String.IsNullOrWhiteSpace(Request.QueryString["ReturnURL"]))
            {
                Response.Redirect(url);
            }
            else
            {
                Response.Redirect(Request.QueryString["ReturnURL"]);
            }
        }
        #endregion

        #region ClearCompanyCPTCodeCache
        /// <summary>
        /// 
        /// </summary>
        public void ClearCompanyCPTCodeCache()
        {
            HttpContext.Current.Cache.Remove(CurrentCPTCodeCacheName);
        }
        #endregion

        #region ClearCompanyICDCodeCache
        /// <summary>
        /// 
        /// </summary>
        public void ClearCompanyICDCodeCache()
        {
            HttpContext.Current.Cache.Remove(CurrentICDCodeCacheName);
        }
        #endregion

        #endregion
    }
}
