using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BMM_DAL;
using System.Data.Linq;

namespace BMM_BAL
{
    public class UserClass
    {
        #region + Enums

        public enum PermissionsEnum
        {
            HomePage = 1,
            Invoices = 2,
            Invoice_Tests = 3,
            Invoice_PaymentInformation = 4,
            Invoice_Comments = 5,
            Invoice_Surgeries = 6,
            Invoice_Providers = 7,
            Patients = 8,
            Admin = 9,
            Admin_Firms = 10,
            Admin_Attorneys = 11,
            Admin_Providers = 12,
            Admin_Physicians = 13,
            Admin_CPTCodes = 14,
            Admin_Surgeries = 15,
            Admin_Tests = 16,
            Admin_LoanTerms = 17,
            Admin_Users = 18,
            Reports = 19,
            Users = 20,
            User_Permissions = 21,

        }

        #endregion


        #region InsertUser

        /// <summary>
        /// Inserts a new user into the database. 
        /// Also handles inserting the user permissions.
        /// </summary>
        /// <param name="NewUser"></param>
        /// <returns></returns>
        public static Int32 InsertUser(User NewUser)
        {

            NewUser.Active = true;
            NewUser.DateAdded = DateTime.Now;
            //NewUser.Password = EncryptionClass.Encrypt(NewUser.Password);
            if (NewUser.UserPermissions != null)
                NewUser.UserPermissions.Select(p => { p.Active = true; p.DateAdded = DateTime.Now; return p; }).ToList();
            
            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                db.Users.InsertOnSubmit(NewUser);
                db.SubmitChanges();
            }


            return NewUser.ID;
        }

        #endregion

        #region UpdateUser

        /// <summary>
        /// Updates a user record in the database.
        /// Also handles updating the user permissions.
        /// </summary>
        /// <param name="UserToUpdate"></param>
        public static void UpdateUser(User UserToUpdate, bool UpdatePermissions)
        {
            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                User FoundUser = (from u in db.Users
                                  where u.ID == UserToUpdate.ID
                                  select u).FirstOrDefault();

                FoundUser.CompanyID = UserToUpdate.CompanyID;
                FoundUser.FirstName = UserToUpdate.FirstName;
                FoundUser.LastName = UserToUpdate.LastName;
                FoundUser.Email = UserToUpdate.Email;
                FoundUser.Position = UserToUpdate.Position;
                FoundUser.Password = UserToUpdate.Password; // EncryptionClass.Encrypt(UserToUpdate.Password);
                FoundUser.Active = UserToUpdate.Active;

                db.SubmitChanges();
            }

            if (UpdatePermissions == true)
                SetUserPermissionsForUser(UserToUpdate.ID, UserToUpdate.UserPermissions.ToList());

        }

        #endregion

        #region GetUserByEmailAndPassword

        public static User GetUserByEmailAndPassword(string Email, string Password, int CompanyId, Boolean LoadUserPermissions)
        {
            User Found;
            //string encPassword = EncryptionClass.Encrypt(Password);
            using (DataModelDataContext db = new DataModelDataContext())
            {
                if (LoadUserPermissions)
                {
                    DataLoadOptions options = new DataLoadOptions();
                    options.LoadWith<User>(u => u.UserPermissions);
                    db.LoadOptions = options;
                }

                Found = (from u in db.Users
                        where u.Email == Email
                        && u.Password == Password //encPassword
                        && u.Active == true
                        && u.CompanyID == CompanyId
                        select u).FirstOrDefault();
            }
            //if (attorney != null)
            //    attorney.Password = EncryptionClass.Decrypt(attorney.Password);

            return Found;
        }

        #endregion

        

        #region GetUserByEmail

        public static User GetUserByEmail(string Email, int CompanyId)
        {
            User Found;
            using (DataModelDataContext db = new DataModelDataContext())
            {
                Found = (from u in db.Users
                         where u.Email == Email
                         && u.Active == true
                         && u.CompanyID == CompanyId
                         select u).FirstOrDefault();
            }
            //if (attorney != null)
            //    attorney.Password = EncryptionClass.Decrypt(attorney.Password);

            return Found;
        }

        #endregion

        #region GetUserByID

        public static User GetUserByID(Int32 ID, Boolean LoadUserPermissions)
        {
            User Found;
            using (DataModelDataContext db = new DataModelDataContext())
            {
                if (LoadUserPermissions)
                {
                    DataLoadOptions options = new DataLoadOptions();
                    options.LoadWith<User>(u => u.UserPermissions);
                    db.LoadOptions = options;
                }

                Found = (from u in db.Users
                        where u.ID == ID
                        select u).FirstOrDefault();
            }
            //if (attorney != null)
            //    attorney.Password = EncryptionClass.Decrypt(attorney.Password);

            return Found;
        }

        #endregion

        #region GetUsersByCompanyID

        public static List<User> GetUsersByCompanyID(Int32 CompanyID)
        {
            List<User> retlist = new List<User>();

            using (DataModelDataContext db = new DataModelDataContext())
            {
                retlist = (from u in db.Users
                           where u.CompanyID == CompanyID
                           && u.Active == true
                           select u).ToList();

                //retlist = retlist.Select(u => { u.Password = EncryptionClass.Decrypt(u.Password); return u; }).ToList();


            }

            return retlist;
        }

        #endregion


        #region SetUserPermissionsForUser

        /// <summary>
        /// 
        /// </summary>
        /// <param name="UserID"></param>
        /// <param name="PermissionList"></param>
        private static void SetUserPermissionsForUser(Int32 UserID, List<UserPermission> PermissionList)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                PermissionList.Select(p => { p.Active = true; p.DateAdded = DateTime.Now;  return p; }).ToList();

                //delete all existing permissions for the user
                List<UserPermission> foundList = (from up in db.UserPermissions
                                                  where up.UserID == UserID
                                                  || up.UserID == 0
                                                  select up).ToList();
                db.UserPermissions.DeleteAllOnSubmit(foundList);

                //insert all permissions in the list for the user
                //db.UserPermissions.InsertAllOnSubmit(PermissionList);
                foreach (UserPermission u in PermissionList)
                {
                    UserPermission uToAdd = new UserPermission();
                    uToAdd.Active = true;
                    uToAdd.AllowAdd = u.AllowAdd;
                    uToAdd.AllowDelete = u.AllowDelete;
                    uToAdd.AllowEdit = u.AllowEdit;
                    uToAdd.AllowView = u.AllowView;
                    uToAdd.DateAdded = DateTime.Now;
                    uToAdd.UserID = u.UserID;
                    uToAdd.PermissionID = u.PermissionID;

                    db.UserPermissions.InsertOnSubmit(uToAdd);
                }

                db.SubmitChanges();

            }
        }



        #endregion

        #region DeleteUser

        /// <summary>
        /// Deletes a User record from the database.
        /// DO NOT USE! FOR TESTING PURPOSES ONLY!
        /// </summary>
        /// <param name="ID"></param>
        public static void DeleteUser(Int32 ID)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                User ToDelete = (from x in db.Users where x.ID == ID select x).FirstOrDefault();

                db.UserPermissions.DeleteAllOnSubmit((from p in db.UserPermissions where p.UserID == ID select p).ToList());
                db.SubmitChanges();

                db.Users.DeleteOnSubmit(ToDelete);
                db.SubmitChanges();

            }
        }

        #endregion

    }
}
