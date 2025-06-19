using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BMM_DAL;
using System.Data.Linq;

namespace BMM_BAL
{
    public class ContactClass
    {
        #region SetContactList

        public static Int32 SetContactList(ContactList CList)
        {
            if (CList.ID <= 0)
            {
                CList.ID = InsertContactList(CList);
            }
            SetContacts(CList.Contacts.ToList(), CList.ID);
            return CList.ID;
        }

        #endregion

        #region DeleteContacts

        /// <summary>
        /// Deletes a contactlist record and all associated contacts from the database.
        /// DO NOT USE! FOR TESTING PURPOSES ONLY!
        /// </summary>
        /// <param name="ID"></param>
        public static void DeleteContacts(Int32 ContactListID)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                //Delete the contacts
                db.Contacts.DeleteAllOnSubmit((from c in db.Contacts where c.ContactListID == ContactListID select c).ToList());

                //Delete the contact list
                db.ContactLists.DeleteOnSubmit((from l in db.ContactLists where l.ID == ContactListID select l).FirstOrDefault());

                db.SubmitChanges();
            }
        }

        #endregion

        #region + Helpers (private)

        #region InsertContactList (private)

        private static Int32 InsertContactList(ContactList NewContactList)
        {
            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                NewContactList.Active = true;
                NewContactList.DateAdded = DateTime.Now;

            }
            return NewContactList.ID;
        }

        #endregion

        #region SetContacts (private)

        private static void SetContacts(List<Contact> toSet, Int32 ContactListID)
        {
            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                //First delete all existing contacts for the given contact list id
                List<Contact> toDelete = (from c in db.Contacts
                                          where c.ContactListID == ContactListID
                                          select c).ToList();
                db.Contacts.DeleteAllOnSubmit(toDelete);

                //loop through the contact list passed in, create new contacts and add them to the list to be inserted.
                foreach(Contact c in toSet)
                {
                    Contact toAdd = new Contact();
                    toAdd.Active = true;
                    toAdd.ContactListID = ContactListID;
                    toAdd.Name = c.Name;
                    toAdd.Position = c.Position;
                    toAdd.Phone = c.Phone;
                    toAdd.Email = c.Email;
                    toAdd.DateAdded = DateTime.Now;
                    db.Contacts.InsertOnSubmit(toAdd);
                }

                //Submit the deletes and the inserts.
                db.SubmitChanges();
            }
        }

        #endregion

        #endregion

    }
}
