using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BMM_DAL;
using System.Data.Linq;

namespace BMM_BAL
{
    public class FirmClass
    {
        #region InsertFirm

        /// <summary>
        /// Inserts a new Firm Record into the database. 
        /// Also takes care of inserting the ContactList and Contacts records if added.
        /// </summary>
        /// <param name="NewFirm">The Firm record to be inserted.</param>
        /// <returns>Returns the ID of the newly created Firm record.</returns>
        public static Int32 InsertFirm(Firm NewFirm)
        {
            //Set all new records to Active and the sisd added sisd to now.
            NewFirm.Active = true;
            NewFirm.DateAdded = DateTime.Now;
            if (NewFirm.ContactList != null)
            {
                NewFirm.ContactList.Active = true;
                NewFirm.ContactList.DateAdded = DateTime.Now;
                if (NewFirm.ContactList.Contacts != null)
                    NewFirm.ContactList.Contacts.Select(c => { c.Active = true; c.DateAdded = DateTime.Now; return c; }).ToList();
            }

            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                db.Firms.InsertOnSubmit(NewFirm);
                db.SubmitChanges();
            }

            return NewFirm.ID;
        }

        #endregion

        #region UpdateFirm

        /// <summary>
        /// Updates an Firm Record. Also updates the associated Contacts.
        /// </summary>
        /// <param name="FirmToUpdate">The record to be updated.</param>
        public static void UpdateFirm(Firm FirmToUpdate)
        {
            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                Firm Found = (from f in db.Firms
                              where f.ID == FirmToUpdate.ID
                              select f).FirstOrDefault();
                Found.isActiveStatus = FirmToUpdate.isActiveStatus;
                Found.CompanyID = FirmToUpdate.CompanyID;
                Found.Name = FirmToUpdate.Name;
                Found.Street1 = FirmToUpdate.Street1;
                Found.Street2 = FirmToUpdate.Street2;
                Found.City = FirmToUpdate.City;
                Found.StateID = FirmToUpdate.StateID;
                Found.ZipCode = FirmToUpdate.ZipCode;
                Found.Phone = FirmToUpdate.Phone;
                Found.Fax = FirmToUpdate.Fax;
                Found.Active = FirmToUpdate.Active;

                db.SubmitChanges();
            }

            //Set the ContactList
            ContactClass.SetContactList(FirmToUpdate.ContactList);
        }

        #endregion

        #region CanInactivateFirm
        public static bool CanInactivateFirm(Int32 FirmID)
        {
            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                return (from i in db.Invoices
                        where i.InvoiceAttorney.InvoiceFirm.FirmID == FirmID
                           && i.Active
                        select i).FirstOrDefault() == null;
            }
        }

        #endregion

        #region GetFirmByID

        /// <summary>
        /// Get an Firm by ID.
        /// </summary>
        /// <param name="ID">ID of the record to retrieve.</param>
        /// <param name="LoadAttorneys">If true, the Attorney will be loaded along with the record.</param>
        /// <param name="LoadContacts">If true, the Contacts will be loaded along with the record.</param>
        /// <returns>Returns the found record, or null if nothing was found.</returns>
        public static Firm GetFirmByID(Int32 ID, bool LoadAttorneys, bool LoadContacts, bool LoadState = true)
        {
            DataLoadOptions options = new DataLoadOptions();

            //add the load option to load the firm if the user requested.
            if (LoadAttorneys)
                options.LoadWith<Firm>(f => f.Attorneys);

            if (LoadContacts)
            {
                //add the options to load the contacts if the user requested.
                options.LoadWith<Firm>(f => f.ContactList);
                options.LoadWith<ContactList>(c => c.Contacts);
            }

            if (LoadState)
                options.LoadWith<Firm>(f => f.State);

            using (DataModelDataContext db = new DataModelDataContext() { LoadOptions = options })
            {
                return (from f in db.Firms
                        where f.ID == ID
                        select f).FirstOrDefault();
            }
        }

        #endregion

        #region GetFirmsByCompanyID

        /// <summary>
        /// Gets a list of firms by the passed in Company ID.
        /// </summary>
        /// <param name="CompanyID"></param>
        /// <returns></returns>
        public static List<Firm> GetFirmsByCompanyID(Int32 CompanyID, Boolean LoadState)
        {
            List<Firm> retlist;
            using (DataModelDataContext db = new DataModelDataContext())
            {
                DataLoadOptions options = new DataLoadOptions();
                //add the load option to load the firm if the user requested.
                if (LoadState)
                {
                    options.LoadWith<Firm>(a => a.State);
                }

                db.LoadOptions = options;

                retlist = (from f in db.Firms
                           where f.Active == true
                           && f.CompanyID == CompanyID
                           select f).ToList();
            }
            return retlist;
        }

        #endregion

        #region GetFirmsByNameSearch
        /// <summary>
        /// Gets a list of firms with the search string in the firm name
        /// </summary>
        /// <param name="search"></param>
        /// <param name="CompanyID"></param>
        /// <returns></returns>
        public static List<Firm> GetFirmsByNameSearch(string search, Int32 CompanyID)
        {
            List<Firm> retlist;
            search = search.ToLower();
            using (DataModelDataContext db = new DataModelDataContext())
            {
                retlist = (from a in db.Firms
                           where a.CompanyID == CompanyID
                                && a.Active
                                && (a.Name.ToLower()).Contains(search)
                           orderby a.Name
                           select a).ToList();
            }
            return retlist;
        }
        #endregion

        #region DeleteFirm

        /// <summary>
        /// Deletes a firm record from the database.
        /// DO NOT USE! FOR TESTING PURPOSES ONLY!
        /// </summary>
        /// <param name="ID"></param>
        public static void DeleteFirm(Int32 ID)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                db.Firms.DeleteOnSubmit((from x in db.Firms where x.ID == ID select x).FirstOrDefault());
                db.SubmitChanges();
            }
        }

        #endregion
    }
}
