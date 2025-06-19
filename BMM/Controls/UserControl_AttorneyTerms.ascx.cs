using BMM_BAL;
using BMM_DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BMM.Controls
{
    public partial class UserControl_AttorneyTerms : System.Web.UI.UserControl
    {
        #region Properties

        #region MyUserPermission
        private UserClass.PermissionsEnum _MyUserPermission;
        public UserClass.PermissionsEnum MyUserPermission
        {
            get
            {
                if ((int)_MyUserPermission == 0)
                {
                    if (ViewState["MyUserPermission"] != null)
                    {
                        _MyUserPermission = (UserClass.PermissionsEnum)ViewState["MyUserPermission"];
                    }
                }
                return _MyUserPermission;
            }
            set
            {
                _MyUserPermission = value;
                ViewState["MyUserPermission"] = _MyUserPermission;
            }
        }
        #endregion

        #region SelectedAttorney
        /// <summary>
        /// The selected attorney
        /// </summary>
        private int _SelectedAttorney;
        public int SelectedAttorney
        {
            get
            {

                if (Session["SelectedAttorney"] != null)
                    _SelectedAttorney = (int)Session["SelectedAttorney"];
                else
                    _SelectedAttorney = 0;

                return _SelectedAttorney;
            }
            set
            {
                _SelectedAttorney = value;
                Session["SelectedAttorney"] = _SelectedAttorney;
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
        }
        #endregion

        #region CurrentUsersPermission
        /// <summary>
        /// Gets the permissions for the user to see if they can add/edit/delete
        /// other users
        /// </summary>
        private UserPermission _CurrentUsersPermission;
        public UserPermission CurrentUsersPermission
        {
            get
            {
                if (_CurrentUsersPermission == null)
                {
                    _CurrentUsersPermission = (from p in CurrentUser.UserPermissions
                                               where p.PermissionID == (int)MyUserPermission
                                               && p.Active
                                               select p).FirstOrDefault();
                }

                return _CurrentUsersPermission;
            }
        }
        #endregion

        #endregion

        #region Events

        #region Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                btnCancel.Visible = false;
                if(CurrentUser.CompanyID == 1)
                {
                    rdpStartDate.MinDate = DateTime.Today;
                }
            }
        }
        #endregion


        #region grdAT_ItemCommand
        /// <summary>
        /// sets the values for a contact to edit
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
        protected void grdAT_ItemCommand(object source, Telerik.Web.UI.GridCommandEventArgs e)
        {
            if (e.CommandName == "Alter")
            {
                
                using (DataModelDataContext db = new DataModelDataContext())
                {
                    AttorneyTerm myAT = (from c in db.AttorneyTerms
                                         where c.ID == Convert.ToInt32(e.CommandArgument)
                                         select c).FirstOrDefault();
                    rcbTermType.SelectedValue = myAT.TermType.ToString();
                    txtYearlyInterest.Text = myAT.YearlyInterest.ToString();
                    txtLoanTerm.Text = myAT.LoanTermsMonths.ToString();
                    txtServiceFeeWaive.Text = myAT.ServiceFeeWaivedMonths.ToString();
                    if (CurrentUser.CompanyID == 1)
                    {
                        rdpStartDate.MinDate = myAT.StartDate;
                    }

                    rdpStartDate.SelectedDate = myAT.StartDate;
                    
                    rdpEndDate.SelectedDate = myAT.EndDate;
                    btnCancel.Visible = true;
                    btnAdd.Text = "Save";
                    hdnActive.Value = myAT.Active.ToString();
                    hdnAttorneyTermId.Value = myAT.ID.ToString();
                }
            }
        }
        #endregion

        #region rgAT_NeedDataSource
        /// <summary>
        /// gets the datasource for the contacts grid
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void rgAT_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            rgAT.DataSource = AttorneyClass.GetAttorneyTermsByAttorneyID(SelectedAttorney);
        }
        #endregion

        #region btnAdd_Click
        /// <summary>
        /// Adds a contact to a contact list
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnAdd_Click(object sender, EventArgs e)
        {
            int id;
            AttorneyTerm aT;

            if (int.TryParse(hdnAttorneyTermId.Value, out id) && id > 0)
            {

                using (DataModelDataContext db = new DataModelDataContext())
                {
                    aT = (from a in db.AttorneyTerms
                          where a.ID == id
                          select a).FirstOrDefault();

                    aT.TermType = Convert.ToInt32(rcbTermType.SelectedValue);
                    aT.LoanTermsMonths = Convert.ToInt32(txtLoanTerm.Text.Trim());
                    aT.ServiceFeeWaivedMonths = Convert.ToInt32(txtServiceFeeWaive.Text.Trim());
                    aT.YearlyInterest = Convert.ToDecimal(txtYearlyInterest.Text.Trim());
                    aT.StartDate = Convert.ToDateTime(rdpStartDate.SelectedDate);
                    aT.EndDate = rdpEndDate.SelectedDate;
                    aT.Active = Convert.ToBoolean(hdnActive.Value);
                    aT.Deleted = false;
                    if (aT.StartDate > DateTime.Today)
                    {
                        aT.Status = "(Scheduled)";
                    }
                    else if (aT.StartDate <= DateTime.Today && (aT.EndDate > DateTime.Today || aT.EndDate == null))
                    {
                        aT.Status = "Current";
                    }
                    else if (aT.EndDate <= DateTime.Today)
                    {
                        aT.Status = "ENDED";
                    }

                    db.SubmitChanges();
                }
            }
            else
            {


                aT = new AttorneyTerm()
                {
                    AttorneyID = SelectedAttorney,
                     LoanTermsMonths = Convert.ToInt32(txtLoanTerm.Text.Trim()),
                    ServiceFeeWaivedMonths = Convert.ToInt32(txtServiceFeeWaive.Text.Trim()),
                    YearlyInterest = Convert.ToDecimal(txtYearlyInterest.Text.Trim()) / 100,
                    StartDate = Convert.ToDateTime(rdpStartDate.SelectedDate),
                    EndDate = rdpEndDate.SelectedDate,
                    Active = true,
                    Deleted = false,
                    DateAdded = DateTime.Now,
                    TermType = Convert.ToInt32(rcbTermType.SelectedValue)
                };

                if(aT.StartDate > DateTime.Today)
                {
                    aT.Status = "(Scheduled)";
                }
                else if (aT.StartDate <= DateTime.Today && (aT.EndDate > DateTime.Today || aT.EndDate == null))
                {
                    aT.Status = "Current";
                }
                else if (aT.EndDate <= DateTime.Today)
                {
                    aT.Status = "ENDED";
                }

                using (DataModelDataContext db = new DataModelDataContext())
                {
                    Boolean TermExists = false;
                    Boolean currentTerm = false;
                    var aTTest = (from a in db.AttorneyTerms
                                  where a.AttorneyID == SelectedAttorney
                                  && a.Status == "Current"
                                  select a).ToList();
                    foreach (var i in aTTest)
                    {
                        if (i.TermType == aT.TermType && aT.Status == "Current")
                        {
                            TermExists = true;
                            break;
                        }
                    }
                    if (TermExists)
                    {
                        if (aT.TermType == 1)
                        {
                           Response.Write("<script>alert('A Current Testing Term Already Exists');</script>");
                        }
                        else
                        {
                            
                            Response.Write("<script>alert('A Current Surgery Term Already Exists');</script>");
                        }
                       
                    }
                    else
                    {
                        foreach (var i in aTTest)
                        {
                            if (i.EndDate >= aT.StartDate && aT.Status == "(Scheduled)" && i.TermType == aT.TermType)
                            {
                                currentTerm = true;
                                break;
                            }
                        }

                        if (currentTerm)
                        {
                            if (aT.TermType == 1)
                            {
                                Response.Write("<script>alert('Please Enter A Start Date After Your Current Testing Term End Date');</script>");
                            }
                            else
                            {
                                Response.Write("<script>alert('Please Enter A Start Date After Your Current Surgery Term End Date');</script>");
                            }
                        }
                        else
                        {
                            db.AttorneyTerms.InsertOnSubmit(aT);
                            db.SubmitChanges();
                        }
                        
                        
                    }
                    
                }

            }


            rcbTermType.SelectedValue = "1";
            txtYearlyInterest.Text = "";
            txtLoanTerm.Text = "";
            txtServiceFeeWaive.Text = "";
            rdpEndDate.SelectedDate = null;
            rdpStartDate.SelectedDate = null;

            hdnAttorneyTermId.Value = "0";

            btnCancel.Visible = false;
            btnAdd.Text = "Add";

            rgAT.Rebind();
        }
        #endregion

        #region btnDelete_Click
        /// <summary>
        /// is a hidden button that remvoes a selected contact from the list
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnDelete_Click(object sender, EventArgs e)
        {
            int id;
            if (Int32.TryParse(hdnAttorneyTermId.Value, out id))
            {
                hdnAttorneyTermId.Value = "0";
                rgAT.Rebind();
            }
        }
        #endregion

        #region btnCancel_Click
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            rcbTermType.SelectedValue = "1";
            rdpEndDate.SelectedDate = null;
            rdpStartDate.SelectedDate = null;
            txtLoanTerm.Text = "";
            txtYearlyInterest.Text = "";
            txtServiceFeeWaive.Text = "";

            hdnAttorneyTermId.Value = "0";
            btnAdd.Text = "Add";
            btnCancel.Visible = false;
        }
        #endregion

        #endregion

        #region GetDelete
        /// <summary>
        /// gets if a user can delete a contact
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        protected string GetDelete(string id)
        {
            return "<a href='Javascript:DeleteAttorneyTerm(" + id + ");' ><img src='/Images/icon_delete.png' /></a>";
        }
        #endregion
    }
}