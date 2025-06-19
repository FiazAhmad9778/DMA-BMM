using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BMM_DAL;
using BMM_BAL;
using Telerik.Web.UI;

namespace BMM
{
    public partial class AddEditSurgery : Classes.BasePage
    {
        #region + Properties

        #region Invoice

        private Classes.TemporaryInvoice _Invoice;

        public Classes.TemporaryInvoice Invoice
        {
            get
            {
                if (this._Invoice == null && Classes.TemporaryInvoice.Exists(this.Session, this.InvoiceSessionKey))
                {
                    this._Invoice = new Classes.TemporaryInvoice(this.Session, this.Company.ID, null,
                                                                 this.InvoiceSessionKey);
                }
                return this._Invoice;
            }
        }

        #endregion

        #region RequiredPermission

        public override UserClass.PermissionsEnum? RequiredPermission
        {
            get { return UserClass.PermissionsEnum.Invoice_Surgeries; }
        }

        #endregion

        #region SurgeryInvoice_SurgeryID

        private int? _SurgeryInvoice_SurgeryID;

        public int? SurgeryInvoice_SurgeryID
        {
            get
            {
                if (!this._SurgeryInvoice_SurgeryID.HasValue)
                {
                    int id;
                    if (int.TryParse(this.Request.QueryString["sisid"], out id))
                    {
                        this._SurgeryInvoice_SurgeryID = id;
                    }
                }
                return this._SurgeryInvoice_SurgeryID;
            }
        }

        #endregion

        #region Surgery

        private SurgeryInvoice_Surgery_Custom _Surgery;

        public SurgeryInvoice_Surgery_Custom Surgery
        {
            get
            {
                if (this._Surgery == null && this.Invoice != null)
                {
                    this._Surgery = this.Invoice.GetTemporarySurgery(this.SurgerySessionKey,
                                                                     this.SurgeryInvoice_SurgeryID);
                }
                return this._Surgery;
            }
        }

        #endregion

        #region ReturnURL

        protected string ReturnURL
        {
            get
            {
                string returnURL = "AddEditSurgery.aspx?isk=" + this.InvoiceSessionKey + "&ssk="
                                   + this.SurgerySessionKey;
                if (this.Surgery.ID != 0)
                {
                    returnURL += "&sisid=" + this.Surgery.ID;
                }
                if (!String.IsNullOrWhiteSpace(this.Request.QueryString["ReturnURL"]))
                {
                    returnURL += "&ReturnURL=" + this.Request.QueryString["ReturnURL"];
                }
                return returnURL;
            }
        }

        #endregion

        #region + Page Modes (View/Edit/Add)

        #region CurrentInvoiceTestsPermission

        /// <summary>
        ///     Gets the permissions for the user to see if they can add/edit/delete invoice surgeries
        /// </summary>
        private UserPermission _CurrentInvoiceSurgeriesPermission;

        public UserPermission CurrentInvoiceSurgeriesPermission
        {
            get
            {
                if (this._CurrentInvoiceSurgeriesPermission == null)
                {
                    this._CurrentInvoiceSurgeriesPermission =
                        this.GetCurrentUserPermission(UserClass.PermissionsEnum.Invoice_Surgeries);
                }
                return this._CurrentInvoiceSurgeriesPermission;
            }
        }

        #endregion

        #region IsViewMode

        /// <summary>
        ///     Gets a boolean indicating if the page is in View mode
        /// </summary>
        public bool IsViewMode
        {
            get
            {
                return this.Surgery.ID != 0 && !this.CurrentInvoiceSurgeriesPermission.AllowEdit
                       && this.CurrentInvoiceSurgeriesPermission.AllowView;
            }
        }

        #endregion

        #region IsEditMode

        /// <summary>
        ///     Gets a boolean indicating if the page is in Edit mode
        /// </summary>
        public bool IsEditMode
        {
            get { return this.Surgery.ID != 0 && this.CurrentInvoiceSurgeriesPermission.AllowEdit; }
        }

        #endregion

        #region IsAddMode

        /// <summary>
        ///     Gets a boolean indicating if the page is in Add mode
        /// </summary>
        public bool IsAddMode
        {
            get { return this.Surgery.ID == 0 && this.CurrentInvoiceSurgeriesPermission.AllowAdd; }
        }

        #endregion

        #endregion

        #endregion

        #region + Events

        #region Page_Load

        protected void Page_Load(object sender, EventArgs e)
        {
            var surgery = this.Surgery;

            if (surgery == null)
            {
                this.GoBack("/Home.aspx");
            }

            if (!this.IsPostBack)
            {
                this.rcbSurgeryID_LoadItems();
                this.rcbSurgeryID.SelectedValue = !String.IsNullOrWhiteSpace(this.Request.QueryString["sid"])
                                                      ? this.Request.QueryString["sid"]
                                                      : (surgery.SurgeryID == 0
                                                             ? String.Empty
                                                             : surgery.SurgeryID.ToString());

                if (this.GetPrimaryDate() != DateTime.MinValue)
                {
                    this.rdpDateScheduled.SelectedDate = this.GetPrimaryDate();
                }
                this.EnableAdditionalDates(this.GetAdditionalDates().Count > 0);

                this.rblIsInpatient.SelectedIndex = surgery.isInpatient ? 0 : 1;

                this.chkSurgeryCancelled.Checked = surgery.isCanceled;

                this.txtNotes.Text = String.IsNullOrWhiteSpace(surgery.Notes) ? String.Empty : surgery.Notes.Trim();

                if (this.IsViewMode)
                {
                    this.SetViewMode();
                }
            }
        }

        #endregion

        #region rcbSurgeryID_SelectedIndexChanged

        protected void rcbSurgeryID_SelectedIndexChanged(object o,
                                                         Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
        {
            if (!String.IsNullOrWhiteSpace(this.rcbSurgeryID.SelectedValue))
            {
                this.Surgery.SurgeryID = int.Parse(this.rcbSurgeryID.SelectedValue);
            }
        }

        #endregion

        #region lnkAddSurgery_Click

        protected void lnkAddSurgery_Click(object sender, EventArgs e)
        {
            this.Response.Redirect("ManageSurgeries.aspx?ReturnURL=" + this.Server.UrlEncode(this.ReturnURL));
        }

        #endregion

        #region lnkAddAnotherDate_Click

        protected void lnkAddAnotherDate_Click(object sender, EventArgs e)
        {
            this.Surgery.SurgeryDates.Add(DateTime.MinValue);
            this.lvAdditionalDates.DataSource = this.GetAdditionalDates();
                // set the new list as the datasource for the list view
            this.lvAdditionalDates.DataBind(); // databind the listview
        }

        #endregion

        #region rdpDateScheduled_SelectedDateChanged

        protected void rdpDateScheduled_SelectedDateChanged(object sender,
                                                            Telerik.Web.UI.Calendar.SelectedDateChangedEventArgs e)
        {
            this.Surgery.SurgeryDates[0] = this.rdpDateScheduled.SelectedDate.HasValue
                                               ? this.rdpDateScheduled.SelectedDate.Value
                                               : DateTime.MinValue;
        }

        #endregion

        #region cbxMultipleDates_CheckChanged

        protected void cbxMultipleDates_CheckChanged(object sender, EventArgs e)
        {
            this.EnableAdditionalDates(this.cbxMultipleDates.Checked);
        }

        #endregion

        #region lvAdditionalDates_ItemDataBound

        protected void lvAdditionalDates_ItemDataBound(object sender, ListViewItemEventArgs e)
        {
            var rdp = (Telerik.Web.UI.RadDatePicker) e.Item.FindControl("rdpAdditionalDate");
            var date = (DateTime) e.Item.DataItem;
            rdp.SelectedDate = date == DateTime.MinValue ? null : (DateTime?) date;
        }

        #endregion

        #region rdpAdditionalDate_SelectedDateChanged

        protected void rdpAdditionalDate_SelectedDateChanged(object sender,
                                                             Telerik.Web.UI.Calendar.SelectedDateChangedEventArgs e)
        {
            var rdp = (Telerik.Web.UI.RadDatePicker) sender;
            // get the index of the item index in the listview from the RDP client id
            int startIndex = rdp.ClientID.IndexOf("_ctrl") + 5;
            int listviewIndex =
                int.Parse(rdp.ClientID.Substring(startIndex, rdp.ClientID.IndexOf('_', startIndex) - startIndex));
            // set the SurgeryDate
            if (this.Surgery.SurgeryDates.Count > listviewIndex + 1)
            {
                this.Surgery.SurgeryDates[listviewIndex + 1] = e.NewDate.HasValue ? e.NewDate.Value : DateTime.MinValue;
            }
        }

        #endregion

        #region rblIsInpatient_SelectedIndexChanged

        protected void rblIsInpatient_SelectedIndexChanged(Object sender, EventArgs e)
        {
            this.Surgery.isInpatient = this.rblIsInpatient.SelectedIndex == 0;
        }

        #endregion

        #region txtNotes_TextChanged

        protected void txtNotes_TextChanged(object sender, EventArgs e)
        {
            this.Surgery.Notes = String.IsNullOrWhiteSpace(this.txtNotes.Text) ? null : this.txtNotes.Text.Trim();
        }

        #endregion

        #region btnLetterToPatient_Click

        protected void btnLetterToPatient_Click(object sender, EventArgs e)
        {
            this.Response.Redirect("Documents/SurgeryLetterToPatient.aspx?isk=" + this.InvoiceSessionKey + "&ssk="
                                   + this.SurgerySessionKey);
        }

        #endregion

        #region btnCancel_Click

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Classes.TemporaryInvoice.RemoveTemporarySurgery(this.Session, this.SurgerySessionKey);
            this.GoBack("Home.aspx");
        }

        #endregion

        #region btnSave_Click

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (this.Page.IsValid)
            {
                var surgery = this.Surgery;
                // RECONSTRUCT TEMPORARY OBJECT PROPERTIES FROM PAGE
                surgery.SurgeryID = int.Parse(this.rcbSurgeryID.SelectedValue);
                surgery.SurgeryDates.Clear();
                if (this.rdpDateScheduled.SelectedDate.HasValue)
                {
                    surgery.SurgeryDates.Add(this.rdpDateScheduled.SelectedDate.Value);
                }
                foreach (var item in this.lvAdditionalDates.Items)
                {
                    var rdpAdditionalDate = (RadDatePicker) item.FindControl("rdpAdditionalDate");
                    if (rdpAdditionalDate.SelectedDate.HasValue)
                    {
                        surgery.SurgeryDates.Add(rdpAdditionalDate.SelectedDate.Value);
                    }
                }
                surgery.SurgeryDates = surgery.SurgeryDates.Distinct().ToList();
                
                surgery.isCanceled = chkSurgeryCancelled.Checked;

                var invoiceSurgeries = this.Invoice.Surgeries;
                var target = (from s in invoiceSurgeries
                              where s.ID == surgery.ID
                              select s).FirstOrDefault();
                if (target != null)
                {
                    target.isInpatient = surgery.isInpatient;
                    target.Notes = surgery.Notes;
                    target.icdCodesList = surgery.icdCodesList;
                    target.SurgeryDates = surgery.SurgeryDates;
                    target.SurgeryID = surgery.SurgeryID;
                    target.isCanceled = surgery.isCanceled;
                }
                else
                {
                    int lowestID = (from s in invoiceSurgeries
                                    orderby s.ID ascending
                                    select s.ID).FirstOrDefault();
                    surgery.ID = lowestID > 0 ? -1 : lowestID - 1;
                    invoiceSurgeries.Add(surgery);
                }
                Classes.TemporaryInvoice.RemoveTemporarySurgery(this.Session, this.SurgerySessionKey);
                this.GoBack("Home.aspx");
            }
        }

        #endregion

        #region btnDeleteICDCode_Click
        protected void btnDeleteICDCode_Click(object sender, EventArgs e)
        {
            if (!String.IsNullOrWhiteSpace(txtICDCodeID.Text) && txtICDCodeID.Text == txtID.Text)
            {
                // reset the add/edit comment form
                ResetAddEditICDCode();
            }
            // rebinds the comments grid
            grdICDCode.Rebind();
        }
        #endregion

        #region grdICDCode_NeedDataSource
        protected void grdICDCode_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            List<SurgeryInvoice_Surgery_ICDCode> icdCodes = (from c in Surgery.icdCodesList
                                                             where c.Active
                                                             orderby GetICDCode(c) ascending
                                                             select c).ToList();
            grdICDCode.DataSource = icdCodes;
        }
        #endregion

        #region btnICDCodeAdd_Click
        protected void btnICDCodeAdd_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(rcbICDCodeID.SelectedValue))
            {
                // get the lowest current id
                int lowestID = (from c in Surgery.icdCodesList
                                orderby c.ID ascending
                                select c.ID).FirstOrDefault();
                // add the charge
                Surgery.icdCodesList.Add(new SurgeryInvoice_Surgery_ICDCode()
                {
                    Active = true,
                    SurgeryInvoice_SurgeryID = Surgery.ID,
                    ICDCodeID = int.Parse(rcbICDCodeID.SelectedValue),
                    Description = txtDescription.Text.Trim(),
                    ID = lowestID < 0 ? lowestID - 1 : -1
                });
                // reset the add/edit form
                ResetAddEditICDCode();
                // rebind the grid
                grdICDCode.Rebind();
            }
        }
        #endregion

        #region btnICDCodeCancel_Click
        protected void btnICDCodeCancel_Click(object sender, EventArgs e)
        {
            ResetAddEditICDCode();
        }
        #endregion

        #region btnICDCodeSave_Click
        protected void btnICDCodeSave_Click(object sender, EventArgs e)
        {

        }
        #endregion

        #region ResetAddEditICDCode
        /// <summary>
        /// Resets the Add/Edit CPT Charge section
        /// </summary>
        private void ResetAddEditICDCode()
        {
            // the table is visible if the page is not in view mode
            tblAddEditICDCodes.Visible = !IsViewMode;
            // set the form fields to defaults
            rcbICDCodeID.SelectedValue = String.Empty;
            rcbICDCodeID.Text = String.Empty;
            txtDescription.Text = String.Empty;
            // configure the buttons to add mode
            btnICDCodeAdd.Visible = true;
            btnICDCodeCancel.Visible = false;
            // cleat the hidden field
            txtICDCodeID.Text = String.Empty;
        }
        #endregion

        #region rcbICDCodeID_SelectedIndexChanged
        protected void rcbICDCodeID_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            int icdCodeID;
            ICDCode icdCode = null;
            if (int.TryParse(rcbICDCodeID.SelectedValue, out icdCodeID))
            {
                icdCode = (from c in ICDCodes
                           where c.ID == icdCodeID
                           select c).FirstOrDefault();
            }
            txtDescription.Text = icdCode == null ? String.Empty : icdCode.ShortDescription;
        }
        #endregion

        #region rcbICDCodeID_ItemsRequested
        protected void rcbICDCodeID_ItemsRequested(object sender, RadComboBoxItemsRequestedEventArgs e)
        {
            string text = e.Text.Trim();
            if (text.Length > 2)
            {
                foreach (var item in (from p in ICDCodes
                                      where p.Code.ToLower().Contains(text.ToLower()) &&
                                            p.Active == true
                                      select new Telerik.Web.UI.RadComboBoxItem(p.Code, p.ID.ToString())))
                {
                    rcbICDCodeID.Items.Add(item);
                }
            }
        }
        #endregion

        #region rcbICDCodeID_ValidateICDCode
        protected void rcbICDCodeID_ValidateICDCode(object source, ServerValidateEventArgs args)
        {
            if ((from c in ICDCodes
                 where c.ID.ToString() == rcbICDCodeID.SelectedValue
                 select c).Count() > 0)
            {
                args.IsValid = true;
            }
            else
                args.IsValid = false;
        }
        #endregion

        #region btnEditICDCode_Click
        protected void btnEditICDCode_Click(object sender, EventArgs e)
        {

        }
        #endregion  

        #endregion

        #region + Helpers

        #region SetViewMode

        /// <summary>
        ///     Disables controls on page when the user does not have edit permissions
        /// </summary>
        private void SetViewMode()
        {
            string toolTip = this.ToolTipTextUserDoesntHavePermission;
            this.rcbSurgeryID.Enabled = false;
            this.rcbSurgeryID.ToolTip = toolTip;
            this.lnkAddSurgery.Enabled = false;
            this.lnkAddSurgery.ToolTip = toolTip;
            this.rdpDateScheduled.Enabled = false;
            this.rdpDateScheduled.ToolTip = toolTip;
            this.cbxMultipleDates.Enabled = false;
            this.cbxMultipleDates.ToolTip = toolTip;
            this.lnkAddAnotherDate.Enabled = false;
            this.lnkAddAnotherDate.ToolTip = toolTip;
            this.rblIsInpatient.Enabled = false;
            this.rblIsInpatient.ToolTip = toolTip;
            this.splchkNotes.Enabled = false;
            this.splchkNotes.ToolTip = toolTip;
            this.txtNotes.Enabled = false;
            this.txtNotes.ToolTip = toolTip;
            this.btnSave.Enabled = false;
            this.btnSave.ToolTip = toolTip;
        }

        #endregion

        #region rcbSurgeryID_LoadItems

        protected void rcbSurgeryID_LoadItems()
        {
            this.rcbSurgeryID.Items.Clear();
            this.rcbSurgeryID.Items.Add(new Telerik.Web.UI.RadComboBoxItem("", ""));
            this.rcbSurgeryID.Items.AddRange(from s in BMM_BAL.SurgeryClass.GetSurgerysByCompanyID(this.Company.ID)
                                             orderby s.Name
                                             select new Telerik.Web.UI.RadComboBoxItem(s.Name, s.ID.ToString()));
        }

        #endregion

        #region EnableAdditionalDates

        protected void EnableAdditionalDates(bool enabled)
        {
            this.cbxMultipleDates.Checked = enabled; // check the checkbox, if enabled
            this.lvAdditionalDates.Visible = enabled; // show the listview, if enabled
            this.trAddAnotherDate.Visible = enabled; // show the "add another date" linkbutton, if enabled
            var additionalDates = this.GetAdditionalDates();
            if (enabled)
            {
                while (additionalDates.Count == 0)
                {
                    this.Surgery.SurgeryDates.Add(DateTime.MinValue);
                    additionalDates = this.GetAdditionalDates();
                }
                this.lvAdditionalDates.DataSource = additionalDates;
                    // set the new list as the datasource for the list view
                this.lvAdditionalDates.DataBind(); // databind the listview
            }
            else if (additionalDates.Count > 0)
            {
                this.Surgery.SurgeryDates.RemoveRange(1, additionalDates.Count);
            }
        }

        #endregion

        #region GetPrimaryDate

        protected DateTime GetPrimaryDate()
        {
            return this.Surgery.SurgeryDates.Count == 0 ? DateTime.MinValue : this.Surgery.SurgeryDates[0];
        }

        #endregion

        #region GetAdditionalDates

        protected List<DateTime> GetAdditionalDates()
        {
            var additionalDates = new List<DateTime>(); // create a new list
            this.Surgery.SurgeryDates.ForEach(date => additionalDates.Add(date));
                // copy each existing date to the new list
            if (additionalDates.Count > 0)
            {
                additionalDates.RemoveAt(0);
            } // remove the first (primary) date
            return additionalDates;
        }

        #endregion

        #region GetICDCode
        protected string GetICDCode(SurgeryInvoice_Surgery_ICDCode iC)
        {
            BMM_DAL.ICDCode icdCode = (from c in ICDCodes
                                       where c.ID == iC.ICDCodeID
                                       select c).FirstOrDefault();
            if (icdCode == null) { return "&nbsp;"; }
            else { return icdCode.Code; }
        }
        #endregion

        #endregion

       
    }
}
