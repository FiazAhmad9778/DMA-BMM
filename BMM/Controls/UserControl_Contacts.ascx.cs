using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BMM_BAL;
using BMM_DAL;

namespace BMM.Controls
{
    public partial class UserControl_Contacts : System.Web.UI.UserControl
    {
        #region isAddPage
        public bool isAddPage
        {
            get
            {
                return (bool)ViewState["IsAnAddPage"];
            }
            set
            {
                ViewState["IsAnAddPage"] = value;
            }
        }
        #endregion

        #region ListOfContactsKey
        private String _ListOfContactsKey;
        public String ListOfContactsKey
        {
            get
            {
                if (_ListOfContactsKey == null)
                {
                    if (ViewState["ListOfContactsKey"] == null)
                    {
                        _ListOfContactsKey = DateTime.Now.Ticks.ToString();
                        ViewState["ListOfContactsKey"] = _ListOfContactsKey;
                    }
                    else _ListOfContactsKey = ViewState["ListOfContactsKey"].ToString();
                }

                return _ListOfContactsKey;
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

        #region ListOfContacts
        /// <summary>
        /// has the list of contacts for the selected firm
        /// </summary>
        private List<Contact> _ListOfContacts;
        public List<Contact> ListOfContacts
        {
            get
            {
                if (_ListOfContacts == null)
                {
                    if (Session["ListOfContacts" + ListOfContactsKey] != null)
                        _ListOfContacts = (List<Contact>)Session["ListOfContacts" + ListOfContactsKey];
                    else
                        _ListOfContacts = new List<Contact>();
                }

                return _ListOfContacts;
            }
            set
            {
                _ListOfContacts = value;
                Session["ListOfContacts" + ListOfContactsKey] = _ListOfContacts;
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

        #region Page_Load
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                btnContactCancel.Visible = false;
            }
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
            Contact myContact;
            List<Contact> myList = ListOfContacts;

            if (int.TryParse(hdnContactId.Value, out id) && id > 0)
            {
                int index = myList.FindIndex(p => p.ID == id);

                myContact = (from l in ListOfContacts
                             where l.ID == id
                             select l).FirstOrDefault();

                myContact.Name = txtContactName.Text.Trim();
                myContact.Phone = txtContactPhone.Text.Trim();
                myContact.Position = txtContactPosistion.Text.Trim();
                myContact.Email = txtContactEmail.Text.Trim();

                myList[index] = myContact;
                ListOfContacts = myList;
            }
            else
            {
                myContact = new Contact()
                {
                    Name = txtContactName.Text.Trim(),
                    Position = txtContactPosistion.Text.Trim(),
                    Phone = txtContactPhone.Text.Trim(),
                    Email = txtContactEmail.Text.Trim(),
                    ID = GetNextID()
                };

                if ((from l in ListOfContacts
                     where l.Name == txtContactName.Text.Trim() &&
                          l.Position == txtContactPosistion.Text.Trim() &&
                          l.Phone == txtContactPhone.Text.Trim() &&
                          l.Email == txtContactEmail.Text.Trim()
                     select l).ToList().Count == 0)
                {
                    myList.Add(myContact);
                    ListOfContacts = myList;
                }

            }


            txtContactEmail.Text = "";
            txtContactName.Text = "";
            txtContactPhone.Text = "";
            txtContactPosistion.Text = "";

            hdnContactId.Value = "0";

            btnContactCancel.Visible = false;
            btnAdd.Text = "Add";

            rgContacts.Rebind();
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
            if (Int32.TryParse(hdnContactId.Value, out id))
            {
                List<Contact> myList = ListOfContacts;
                myList.RemoveAll(x => x.ID == id);
                ListOfContacts = myList;

                hdnContactId.Value = "0";
                rgContacts.Rebind();
            }
        }
        #endregion

        #region btnContactCancel_Click
        protected void btnContactCancel_Click(object sender, EventArgs e)
        {
            txtContactEmail.Text = "";
            txtContactName.Text = "";
            txtContactPhone.Text = "";
            txtContactPosistion.Text = "";

            hdnContactId.Value = "0";
            btnAdd.Text = "Add";
            btnContactCancel.Visible = false;
        }
        #endregion

        #region grdContacts_ItemCommand
        /// <summary>
        /// sets the values for a contact to edit
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
        protected void grdContacts_ItemCommand(object source, Telerik.Web.UI.GridCommandEventArgs e)
        {
            if (e.CommandName == "Alter")
            {
                Contact myContact = (from c in ListOfContacts
                                     where c.ID == Convert.ToInt32(e.CommandArgument)
                                     select c).FirstOrDefault();
                txtContactEmail.Text = myContact.Email;
                txtContactName.Text = myContact.Name;
                txtContactPhone.Text = myContact.Phone;
                txtContactPosistion.Text = myContact.Position;

                btnContactCancel.Visible = true;
                btnAdd.Text = "Save";

                hdnContactId.Value = myContact.ID.ToString();
            }
        }
        #endregion

        #region rgContacts_NeedDataSource
        /// <summary>
        /// gets the datasource for the contacts grid
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void rgContacts_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            rgContacts.DataSource = from l in ListOfContacts
                                    orderby l.Name
                                    select l;
        }
        #endregion

        #region GetNextID
        /// <summary>
        /// gets the next id for the contacts grid
        /// </summary>
        /// <returns></returns>
        private int GetNextID()
        {
            return (from c in ListOfContacts
                    orderby c.ID descending
                    select c.ID).FirstOrDefault() + 1;
        }
        #endregion

        #region GetDelete
        /// <summary>
        /// gets if a user can delete a contact
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        protected string GetDelete(string id)
        {
            const string textUserDoesntHavePermissionText = "You do not have the required user permissions to perform this action.";
            if (isAddPage)
                return CurrentUsersPermission.AllowAdd ? "<a href='Javascript:DeleteUser(" + id + ");' ><img src='/Images/icon_delete.png' /></a>" : "<img src='Images/icon_delete_inactive.png' title='" + textUserDoesntHavePermissionText + "' />";
            else
                return CurrentUsersPermission.AllowEdit ? "<a href='Javascript:DeleteUser(" + id + ");' ><img src='/Images/icon_delete.png' /></a>" : "<img src='Images/icon_delete_inactive.png' title='" + textUserDoesntHavePermissionText + "' />";
        }
        #endregion

        #region GetListOfContacts
        public List<Contact> GetListOfContacts()
        {
            return ListOfContacts;
        }
        #endregion

        #region isButtonVisable
        protected bool isButtonVisable()
        {
            if (isAddPage)
                return CurrentUsersPermission.AllowAdd;
            else
                return CurrentUsersPermission.AllowEdit;
        }
        #endregion

        #region DiableControls
        public void DisableControls()
        {
            txtContactEmail.Enabled = false;
            txtContactName.Enabled = false;
            txtContactPhone.Enabled = false;
            txtContactPosistion.Enabled = false;
            btnAdd.Enabled = false;
        }
        #endregion

        #region RemoveList
        /// <summary>
        /// Clears the list from memory
        /// </summary>
        public void RemoveList()
        {
            Session.Remove("ListOfContacts" + ListOfContactsKey.ToString());
        }
        #endregion
    }
}