using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BMM_DAL;
using System.Data.Linq;

namespace BMM_BAL
{
    public class AttorneyClass
    {
        #region InsertAttorney

        /// <summary>
        /// Inserts a new Attorney Record into the database. 
        /// Also takes care of inserting the ContactList and Contacts records if added.
        /// </summary>
        /// <param name="NewAttorney">The Attorney record to be inserted.</param>
        /// <returns>Returns the ID of the newly created Attorney record.</returns>
        public static Int32 InsertAttorney(Attorney NewAttorney)
        {
            //Set all new records to Active and the sisd added sisd to now.
            NewAttorney.Active = true;
            NewAttorney.DateAdded = DateTime.Now;
            if (NewAttorney.ContactList != null)
            {
                NewAttorney.ContactList.Active = true;
                NewAttorney.ContactList.DateAdded = DateTime.Now;
                if (NewAttorney.ContactList.Contacts != null)
                    NewAttorney.ContactList.Contacts.Select(c => { c.Active = true; c.DateAdded = DateTime.Now; return c; }).ToList();
            }

            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                db.Attorneys.InsertOnSubmit(NewAttorney);
                db.SubmitChanges();
            }

            return NewAttorney.ID;
        } 

        #endregion

        #region UpdateAttorney

        /// <summary>
        /// Updates an Attorney Record. Also updates the associated Contacts.
        /// </summary>
        /// <param name="AttorneyToUpdate">The record to be updated.</param>
        public static void UpdateAttorney(Attorney AttorneyToUpdate)
        {
            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                Attorney Found = (from a in db.Attorneys
                                  where a.ID == AttorneyToUpdate.ID
                                  select a).FirstOrDefault();
                Found.CompanyID = AttorneyToUpdate.CompanyID;
                Found.FirmID = AttorneyToUpdate.FirmID;
                Found.isActiveStatus = AttorneyToUpdate.isActiveStatus;
                Found.FirstName = AttorneyToUpdate.FirstName;
                Found.LastName = AttorneyToUpdate.LastName;
                Found.Street1 = AttorneyToUpdate.Street1;
                Found.Street2 = AttorneyToUpdate.Street2;
                Found.City = AttorneyToUpdate.City;
                Found.StateID = AttorneyToUpdate.StateID;
                Found.ZipCode = AttorneyToUpdate.ZipCode;
                Found.Phone = AttorneyToUpdate.Phone;
                Found.Fax = AttorneyToUpdate.Fax;
                Found.Email = AttorneyToUpdate.Email;
                Found.Notes = AttorneyToUpdate.Notes;
                Found.DiscountNotes = AttorneyToUpdate.DiscountNotes;
                Found.DepositAmountRequired = AttorneyToUpdate.DepositAmountRequired;
                Found.Active = AttorneyToUpdate.Active;
                
                db.SubmitChanges();
            }

            //Set the ContactList
            ContactClass.SetContactList(AttorneyToUpdate.ContactList);
        }

        #endregion

        #region CanInactivateAttorney
        public static bool CanInactivateAttorney(Int32 AttorneyID)
        {
            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                return (from i in db.Invoices
                        where i.InvoiceAttorney.AttorneyID == AttorneyID
                           && i.Active
                        select i).FirstOrDefault() == null;
            }
        }
        #endregion

        #region SetAttorneyActive
        public static void SetAttorneyActive(Int32 AttorneyID, bool active)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                Attorney attorney = (from a in db.Attorneys
                                     where a.ID == AttorneyID
                                     select a).FirstOrDefault();

                if (attorney != null)
                {
                    attorney.Active = active;
                    attorney.ContactList.Active = active;
                    foreach (Contact c in attorney.ContactList.Contacts)
                    {
                        c.Active = active;
                    }

                    db.SubmitChanges();
                }
            }
        }
        #endregion

        #region GetAttorneyByID

        /// <summary>
        /// Get an Attorney by ID.
        /// </summary>
        /// <param name="ID">ID of the record to retrieve.</param>
        /// <param name="LoadFirm">If true, the Firm record will be loaded along with the record.</param>
        /// <param name="LoadContacts">If true, the Contacts will be loaded along with the record.</param>
        /// <returns>Returns the found record, or null if nothing was found.</returns>
        public static Attorney GetAttorneyByID(Int32 ID, Boolean LoadFirm = false, Boolean LoadContacts = false, Boolean LoadStates = false)
        {
            Attorney Found;
            using (DataModelDataContext db = new DataModelDataContext())
            {
                DataLoadOptions options = new DataLoadOptions();
                //add the load option to load the firm if the user requested.
                if (LoadFirm)
                {
                    options.LoadWith<Attorney>(a => a.Firm);
                }

                if (LoadContacts)
                {
                    //add the options to load the contacts if the user requested.
                    options.LoadWith<Attorney>(a => a.ContactList);
                    options.LoadWith<ContactList>(cl => cl.Contacts);
                    // get only active contacts, sorted by name
                    options.AssociateWith<ContactList>(cl => cl.Contacts.Where(c => c.Active).OrderBy(c => c.Name));
                }
                if (LoadStates)
                {
                    options.LoadWith<Attorney>(a => a.State);
                }

                db.LoadOptions = options;

                Found = (from a in db.Attorneys
                         where a.ID == ID
                         select a).FirstOrDefault();
            } 

            return Found;
        }

        #endregion

        #region GetAttorneyTermsByAttorneyID
        public static List<AttorneyTerm> GetAttorneyTermsByAttorneyID(int attorneyID)
        {
            List<AttorneyTerm> Found = new List<AttorneyTerm>();
             using (DataModelDataContext db = new DataModelDataContext())
            {
                Found = (from a in db.AttorneyTerms
                         where a.AttorneyID == attorneyID && a.Deleted == false
                         orderby a.Status
                         select a).ToList();
            }
             return Found;
        }
        #endregion

        #region GetAttorneyTermByID
        public static AttorneyTerm GetAttorneyTermByID(int termID)
        {
            AttorneyTerm t = new AttorneyTerm();
            using (DataModelDataContext db = new DataModelDataContext())
            {
                t = (from a in db.AttorneyTerms
                     where a.ID == termID
                     select a).FirstOrDefault();
            }
            return t;
        }
        #endregion

        #region UpdateAttorneyTerm
        public static void UpdateAttorneyTerm(AttorneyTerm termToUpdate)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                AttorneyTerm found = (from a in db.AttorneyTerms
                                      where a.ID == termToUpdate.ID
                                      select a).FirstOrDefault();

                found.AttorneyID = termToUpdate.AttorneyID;
                found.LoanTermsMonths = termToUpdate.LoanTermsMonths;
                found.YearlyInterest = termToUpdate.YearlyInterest;
                found.ServiceFeeWaivedMonths = termToUpdate.ServiceFeeWaivedMonths;
                found.StartDate = termToUpdate.StartDate;
                found.EndDate = termToUpdate.EndDate;
                found.Active = termToUpdate.Active;
                found.TermType = termToUpdate.TermType;
                found.Deleted = termToUpdate.Deleted;
                found.Status = termToUpdate.Status;

                db.SubmitChanges();
            }
        }
        #endregion

        #region GetInvoiceAttorneyByID

        /// <summary>
        /// Get an InvoiceAttorney by ID.
        /// </summary>
        /// <param name="ID">ID of the record to retrieve.</param>
        /// <param name="LoadFirm">If true, the Firm record will be loaded along with the record.</param>
        /// <param name="LoadContacts">If true, the Contacts will be loaded along with the record.</param>
        /// <returns>Returns the found record, or null if nothing was found.</returns>
        public static InvoiceAttorney GetInvoiceAttorneyByID(Int32 ID, Boolean LoadFirm = false, Boolean LoadContacts = false, Boolean LoadStates = false)
        {
            InvoiceAttorney Found;
            using (DataModelDataContext db = new DataModelDataContext())
            {
                DataLoadOptions options = new DataLoadOptions();
                //add the load option to load the firm if the user requested.
                if (LoadFirm)
                    options.LoadWith<InvoiceAttorney>(a => a.InvoiceFirm);

                if (LoadContacts)
                {
                    //add the options to load the contacts if the user requested.
                    options.LoadWith<InvoiceAttorney>(a => a.InvoiceContactList);
                    options.LoadWith<InvoiceContactList>(c => c.InvoiceContacts);
                }
                if (LoadStates)
                {
                    options.LoadWith<InvoiceAttorney>(a => a.State);
                }

                db.LoadOptions = options;

                Found = (from a in db.InvoiceAttorneys
                         where a.ID == ID
                         select a).FirstOrDefault();
            }

            return Found;
        }

        #endregion

        #region GetAttorneysByCompanyID
        /// <summary>
        /// Gets a list of attorneys by the passed in Company ID.
        /// </summary>
        /// <param name="CompanyID"></param>
        /// <returns></returns>
        public static List<Attorney> GetAttorneysByCompanyID(Int32 CompanyID, Boolean LoadFirm, Boolean LoadState)
        {
            DataLoadOptions options = new DataLoadOptions();

            if (LoadFirm)
                options.LoadWith<Attorney>(a => a.Firm);
            if (LoadState)
                options.LoadWith<Attorney>(a => a.State);

            using (DataModelDataContext db = new DataModelDataContext() { LoadOptions = options })
            {
                return (from a in db.Attorneys
                        where a.CompanyID == CompanyID
                            && a.Active
                        select a).ToList();
            }
        }
        #endregion

        #region GetAttorneysByNameSearch
        /// <summary>
        /// Gets a list of attorneys with the search string in their name when it is formatted as "LastName, FirstName (FirmName)"
        /// </summary>
        /// <param name="search"></param>
        /// <param name="CompanyID"></param>
        /// <returns></returns>
        public static List<Attorney> GetAttorneysByNameSearch(string search, Int32 CompanyID, bool LoadFirm)
        {
            search = search.ToLower();
            using (DataModelDataContext db = new DataModelDataContext())
            {
                if (LoadFirm)
                {
                    DataLoadOptions options = new DataLoadOptions();
                    options.LoadWith<Attorney>(a => a.Firm);
                    db.LoadOptions = options;
                }
                return (from a in db.Attorneys
                        where a.CompanyID == CompanyID
                             && a.Active
                             && (a.LastName + ", " + a.FirstName + (a.Firm == null ? String.Empty : " (" + a.Firm.Name + ")")).ToLower().Contains(search)
                        orderby a.LastName, a.FirstName
                        select a).ToList();
            }
        }
        #endregion

        #region DeleteAttorney

        /// <summary>
        /// Deletes a Attorney record from the database.
        /// DO NOT USE! FOR TESTING PURPOSES ONLY!
        /// </summary>
        /// <param name="ID"></param>
        public static void DeleteAttorney(Int32 ID)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                Attorney ToDelete = (from x in db.Attorneys where x.ID == ID select x).FirstOrDefault();

                Int32 ContactListIDToDelete = ToDelete.ContactListID;

                db.Attorneys.DeleteOnSubmit(ToDelete);
                db.SubmitChanges();

                ContactClass.DeleteContacts(ToDelete.ContactListID);
            }
        }

        #endregion
    }
}
