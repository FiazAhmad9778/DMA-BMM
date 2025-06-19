using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BMM_DAL;
using System.Data.Linq;

namespace BMM_BAL
{
    public class PhysicianClass
    {
        #region InsertPhysician

        /// <summary>
        /// Inserts a new Physician Record into the database. 
        /// Also takes care of inserting the ContactList and Contacts records if added.
        /// </summary>
        /// <param name="NewPhysician">The Physician record to be inserted.</param>
        /// <returns>Returns the ID of the newly created Physician record.</returns>
        public static Int32 InsertPhysician(Physician NewPhysician)
        {
            //Set all new records to Active and the sisd added sisd to now.
            NewPhysician.Active = true;
            NewPhysician.DateAdded = DateTime.Now;
            if (NewPhysician.ContactList != null)
            {
                NewPhysician.ContactList.Active = true;
                NewPhysician.ContactList.DateAdded = DateTime.Now;
                if (NewPhysician.ContactList.Contacts != null)
                    NewPhysician.ContactList.Contacts.Select(c => { c.Active = true; c.DateAdded = DateTime.Now; return c; }).ToList();
            }

            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                db.Physicians.InsertOnSubmit(NewPhysician);
                db.SubmitChanges();
            }

            return NewPhysician.ID;
        }

        #endregion

        #region UpdatePhysician

        /// <summary>
        /// Updates an Physician Record. Also updates the associated Contacts.
        /// </summary>
        /// <param name="PhysicianToUpdate">The record to be updated.</param>
        public static void UpdatePhysician(Physician PhysicianToUpdate)
        {
            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                Physician Found = (from a in db.Physicians
                                  where a.ID == PhysicianToUpdate.ID
                                  select a).FirstOrDefault();
                Found.CompanyID = PhysicianToUpdate.CompanyID;
                Found.isActiveStatus = PhysicianToUpdate.isActiveStatus;
                Found.FirstName = PhysicianToUpdate.FirstName;
                Found.LastName = PhysicianToUpdate.LastName;
                Found.Street1 = PhysicianToUpdate.Street1;
                Found.Street2 = PhysicianToUpdate.Street2;
                Found.City = PhysicianToUpdate.City;
                Found.StateID = PhysicianToUpdate.StateID;
                Found.ZipCode = PhysicianToUpdate.ZipCode;
                Found.Phone = PhysicianToUpdate.Phone;
                Found.Fax = PhysicianToUpdate.Fax;
                Found.EmailAddress = PhysicianToUpdate.EmailAddress;
                Found.Notes = PhysicianToUpdate.Notes;
                Found.Active = PhysicianToUpdate.Active;

                db.SubmitChanges();
            }

            //Set the ContactList
            ContactClass.SetContactList(PhysicianToUpdate.ContactList);
        }

        #endregion

        #region CanInactivatePhysician
        public static bool CanInactivatePhysician(Int32 PhysicianID)
        {
            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                return (from i in db.Invoices
                        where i.InvoicePhysician.PhysicianID == PhysicianID
                           && i.Active
                        select i).FirstOrDefault() == null;
            }
        }
        #endregion

        #region GetPhysicianByID

        /// <summary>
        /// Get a Physician by ID.
        /// </summary>
        /// <param name="ID">ID of the record to retrieve.</param>
        /// <param name="LoadContacts">If true, the Contacts will be loaded along with the record.</param>
        /// <returns>Returns the found record, or null if nothing was found.</returns>
        public static Physician GetPhysicianByID(Int32 ID, Boolean LoadContacts = false, Boolean LoadStates = false)
        {
            Physician Found;
            using (DataModelDataContext db = new DataModelDataContext())
            {

                DataLoadOptions options = new DataLoadOptions();
                if (LoadContacts)
                {
                    //add the options to load the contacts if the user requested.
                    options.LoadWith<Physician>(a => a.ContactList);
                    options.LoadWith<ContactList>(c => c.Contacts);
                }
                if (LoadStates)
                {
                    options.LoadWith<Physician>(a => a.State);
                }
                db.LoadOptions = options;
                Found = (from a in db.Physicians
                         where a.ID == ID
                         select a).FirstOrDefault();
            }

            return Found;
        }

        #endregion

        #region GetInvoicePhysicianByID

        /// <summary>
        /// Get a InvoicePhysician by ID.
        /// </summary>
        /// <param name="ID">ID of the record to retrieve.</param>
        /// <param name="LoadContacts">If true, the Contacts will be loaded along with the record.</param>
        /// <returns>Returns the found record, or null if nothing was found.</returns>
        public static InvoicePhysician GetInvoicePhysicianByID(Int32 ID, Boolean LoadContacts = false, Boolean LoadStates = false)
        {
            InvoicePhysician Found;
            DataLoadOptions options = new DataLoadOptions();
            using (DataModelDataContext db = new DataModelDataContext())
            {

                if (LoadContacts)
                {
                    //add the options to load the contacts if the user requested.
                    options.LoadWith<InvoicePhysician>(a => a.InvoiceContactList);
                    options.LoadWith<InvoiceContactList>(c => c.InvoiceContacts);
                }
                if (LoadStates)
                {
                    options.LoadWith<InvoicePhysician>(a => a.State);
                }
                db.LoadOptions = options;
                Found = (from a in db.InvoicePhysicians
                         where a.ID == ID
                         select a).FirstOrDefault();
            }

            return Found;
        }

        #endregion

        #region GetPhysiciansByCompanyID

        /// <summary>
        /// Gets a list of Physicians by the passed in Company ID.
        /// </summary>
        /// <param name="CompanyID"></param>
        /// <returns></returns>
        public static List<Physician> GetPhysiciansByCompanyID(Int32 CompanyID, bool LoadStates)
        {
            List<Physician> retlist;
            using (DataModelDataContext db = new DataModelDataContext())
            {
                DataLoadOptions options = new DataLoadOptions();
                if (LoadStates)
                {
                    options.LoadWith<Physician>(a => a.State);
                }
                db.LoadOptions = options;
                retlist = (from a in db.Physicians
                           where a.Active == true
                           && a.CompanyID == CompanyID
                           select a).ToList();                
            }
            return retlist;
        }

        #endregion

        #region GetPhysiciansByNameSearch
        /// <summary>
        /// Gets a list of physicians with the search string in their name when it is formatted as "LastName, FirstName (FirmName)"
        /// </summary>
        /// <param name="search"></param>
        /// <param name="CompanyID"></param>
        /// <returns></returns>
        public static List<Physician> GetPhysiciansByNameSearch(string search, Int32 CompanyID)
        {
            search = search.ToLower();
            using (DataModelDataContext db = new DataModelDataContext())
            {
                return (from a in db.Physicians
                        where a.CompanyID == CompanyID
                             && a.Active
                             && (a.LastName + ", " + a.FirstName).ToLower().Contains(search)
                        orderby a.LastName, a.FirstName
                        select a).ToList();
            }
        }
        #endregion

        #region DeletePhysician

        /// <summary>
        /// Deletes a Physician record from the database.
        /// DO NOT USE! FOR TESTING PURPOSES ONLY!
        /// </summary>
        /// <param name="ID"></param>
        public static void DeletePhysician(Int32 ID)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                Physician ToDelete = (from x in db.Physicians where x.ID == ID select x).FirstOrDefault();

                Int32 ContactListIDToDelete = ToDelete.ContactListID;

                db.Physicians.DeleteOnSubmit(ToDelete);
                db.SubmitChanges();

                ContactClass.DeleteContacts(ToDelete.ContactListID);
            }
        }

        #endregion

    }
}
