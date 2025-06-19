using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BMM_DAL;
using System.Data.Linq;

namespace BMM_BAL
{
    public class ProviderClass
    {
        #region + Enums

        public enum MRICostTypeEnum
        {
            Flat_Rate = 1,
            Percentage = 2
        }

        #endregion

        #region InsertProvider

        /// <summary>
        /// Inserts a new Provider Record into the database. 
        /// Also takes care of inserting the ContactList and Contacts records if added.
        /// </summary>
        /// <param name="NewProvider">The Provider record to be inserted.</param>
        /// <returns>Returns the ID of the newly created Provider record.</returns>
        public static Int32 InsertProvider(Provider NewProvider)
        {
            //Set all new records to Active and the sisd added sisd to now.
            NewProvider.Active = true;
            NewProvider.DateAdded = DateTime.Now;
            if (NewProvider.ContactList != null)
            {
                NewProvider.ContactList.Active = true;
                NewProvider.ContactList.DateAdded = DateTime.Now;
                if (NewProvider.ContactList.Contacts != null)
                    NewProvider.ContactList.Contacts.Select(c => { c.Active = true; c.DateAdded = DateTime.Now; return c; }).ToList();
            }

            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                db.Providers.InsertOnSubmit(NewProvider);
                db.SubmitChanges();
            }

            return NewProvider.ID;
        }

        #endregion

        #region UpdateProvider

        /// <summary>
        /// Updates an Provider Record. Also updates the associated Contacts.
        /// </summary>
        /// <param name="ProviderToUpdate">The record to be updated.</param>
        public static void UpdateProvider(Provider ProviderToUpdate)
        {
            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                Provider Found = (from a in db.Providers
                                  where a.ID == ProviderToUpdate.ID
                                  select a).FirstOrDefault();
                Found.CompanyID = ProviderToUpdate.CompanyID;
                Found.isActiveStatus = ProviderToUpdate.isActiveStatus;
                Found.Name = ProviderToUpdate.Name;
                Found.Street1 = ProviderToUpdate.Street1;
                Found.Street2 = ProviderToUpdate.Street2;
                Found.City = ProviderToUpdate.City;
                Found.StateID = ProviderToUpdate.StateID;
                Found.ZipCode = ProviderToUpdate.ZipCode;
                Found.Phone = ProviderToUpdate.Phone;
                Found.Fax = ProviderToUpdate.Fax;
                Found.Email = ProviderToUpdate.Email;
                Found.Street1_Billing = ProviderToUpdate.Street1_Billing;
                Found.Street2_Billing = ProviderToUpdate.Street2_Billing;
                Found.City_Billing = ProviderToUpdate.City_Billing;
                Found.StateID_Billing = ProviderToUpdate.StateID_Billing;
                Found.ZipCode_Billing = ProviderToUpdate.ZipCode_Billing;
                Found.Phone_Billing = ProviderToUpdate.Phone_Billing;
                Found.Fax_Billing = ProviderToUpdate.Fax_Billing;
                Found.Email_Billing = ProviderToUpdate.Email_Billing;
                Found.Notes = ProviderToUpdate.Notes;
                Found.FacilityAbbreviation = ProviderToUpdate.FacilityAbbreviation;
                Found.DiscountPercentage = ProviderToUpdate.DiscountPercentage;
                Found.MRICostTypeID = ProviderToUpdate.MRICostTypeID;
                Found.MRICostFlatRate = ProviderToUpdate.MRICostFlatRate;
                Found.MRICostPercentage = ProviderToUpdate.MRICostPercentage;
                Found.DaysUntilPaymentDue = ProviderToUpdate.DaysUntilPaymentDue;
                Found.Deposits = ProviderToUpdate.Deposits;
                Found.TaxID = ProviderToUpdate.TaxID;
                Found.Active = ProviderToUpdate.Active;

                db.SubmitChanges();
            }

            //Set the ContactList
            ContactClass.SetContactList(ProviderToUpdate.ContactList);
        }

        #endregion

        #region CanInactivateProvider
        public static bool CanInactivateProvider(Int32 ProviderID)
        {
            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                return (from ip in db.InvoiceProviders
                        where ip.ProviderID == ProviderID
                           && ip.Active
                        select ip).FirstOrDefault() == null;
            }
        }
        #endregion

        #region GetProviderByID

        /// <summary>
        /// Get a Provider by ID.
        /// </summary>
        /// <param name="ID">ID of the record to retrieve.</param>
        /// <param name="LoadContacts">If true, the Contacts will be loaded along with the record.</param>
        /// <returns>Returns the found record, or null if nothing was found.</returns>
        public static Provider GetProviderByID(Int32 ID, Boolean LoadContacts = false, Boolean LoadStates = false, Boolean LoadMRICostType = false)
        {
            Provider Found;
            using (DataModelDataContext db = new DataModelDataContext())
            {

                DataLoadOptions options = new DataLoadOptions();
                if (LoadContacts)
                {
                    //add the options to load the contacts if the user requested.
                    options.LoadWith<Provider>(a => a.ContactList);
                    options.LoadWith<ContactList>(c => c.Contacts);
                }
                if (LoadStates)
                {
                    options.LoadWith<Provider>(a => a.State);
                }
                if (LoadMRICostType)
                {
                    options.LoadWith<Provider>(c => c.MRICostType);
                }
                db.LoadOptions = options;
                Found = (from a in db.Providers
                         where a.ID == ID
                         select a).FirstOrDefault();
            }

            return Found;
        }

        #endregion

        #region GetInvoiceProviderByID

        /// <summary>
        /// Get a InvoiceProvider by ID.
        /// </summary>
        /// <param name="ID">ID of the record to retrieve.</param>
        /// <param name="LoadContacts">If true, the Contacts will be loaded along with the record.</param>
        /// <returns>Returns the found record, or null if nothing was found.</returns>
        public static InvoiceProvider GetInvoiceProviderByID(Int32 ID, Boolean LoadContacts = false, Boolean LoadStates = false)
        {
            InvoiceProvider Found;
            using (DataModelDataContext db = new DataModelDataContext())
            {

                DataLoadOptions options = new DataLoadOptions();
                if (LoadContacts)
                {
                    //add the options to load the contacts if the user requested.
                    options.LoadWith<InvoiceProvider>(a => a.InvoiceContactList);
                    options.LoadWith<InvoiceContactList>(c => c.InvoiceContacts);
                }
                if (LoadStates)
                {
                    options.LoadWith<InvoiceProvider>(a => a.State);
                }
                options.LoadWith<InvoiceProvider>(c => c.MRICostType);
                db.LoadOptions = options;
                Found = (from a in db.InvoiceProviders
                         where a.ID == ID
                         select a).FirstOrDefault();
            }

            return Found;
        }

        #endregion

        #region GetProvidersByCompanyID

        /// <summary>
        /// Gets a list of Providers by the passed in Company ID.
        /// </summary>
        public static List<Provider> GetProvidersByCompanyID(Int32 CompanyID, bool LoadState = false)
        {
            List<Provider> retlist;
            using (DataModelDataContext db = new DataModelDataContext())
            {
                DataLoadOptions options = new DataLoadOptions();
                if (LoadState)
                {
                    options.LoadWith<Provider>(a => a.State);
                }

                db.LoadOptions = options;

                retlist = (from a in db.Providers
                           where a.Active == true
                           && a.CompanyID == CompanyID
                           select a).ToList();
            }

            return retlist;
        }

        #endregion

        #region GetProvidersByNameSearch
        /// <summary>
        /// Gets a list of attorneys with the search string in their name when it is formatted as "LastName, FirstName (FirmName)"
        /// </summary>
        public static List<Provider> GetProvidersByNameSearch(string search, Int32 CompanyID, bool LoadFirm)
        {
            search = search.ToLower();
            using (DataModelDataContext db = new DataModelDataContext())
            {
                if (LoadFirm)
                {
                    DataLoadOptions options = new DataLoadOptions();
                    options.LoadWith<Provider>(a => a.Name);
                    db.LoadOptions = options;
                }
                return (from a in db.Providers
                        where a.CompanyID == CompanyID
                             && a.Active
                             && a.Name.ToLower().Contains(search)
                        orderby a.Name
                        select a).ToList();
            }
        }
        #endregion

        #region DeleteProvider

        /// <summary>
        /// Deletes a Provider record from the database.
        /// DO NOT USE! FOR TESTING PURPOSES ONLY!
        /// </summary>
        /// <param name="ID"></param>
        public static void DeleteProvider(Int32 ID)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                Provider ToDelete = (from x in db.Providers where x.ID == ID select x).FirstOrDefault();

                Int32 ContactListIDToDelete = ToDelete.ContactListID;

                db.Providers.DeleteOnSubmit(ToDelete);
                db.SubmitChanges();

                ContactClass.DeleteContacts(ToDelete.ContactListID);
            }
        }

        #endregion
    }
}
