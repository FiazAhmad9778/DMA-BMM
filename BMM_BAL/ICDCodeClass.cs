using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BMM_DAL;
using System.Data.Linq;

namespace BMM_BAL
{
    public class ICDCodeClass
    {
        #region InsertICDCode

        /// <summary>
        /// Inserts a new ICDCode Record into the database. 
        /// </summary>
        /// <param name="NewICDCode">The ICDCode record to be inserted.</param>
        /// <returns>Returns the ID of the newly created ICDCode record.</returns>
        public static Int32 InsertICDCode(ICDCode NewICDCode)
        {
            //Set all new records to Active and the sisd added sisd to now.
            NewICDCode.Active = true;

            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                db.ICDCodes.InsertOnSubmit(NewICDCode);
                db.SubmitChanges();
            }

            return NewICDCode.ID;
        }

        #endregion

        #region CheckICDCodeByCode
        public static Boolean CheckICDCodeByCode(string code, int CompanyID)
        {
            Boolean Found = false;
            List<ICDCode> test = new List<ICDCode>();
            using (DataModelDataContext db = new DataModelDataContext())
            {
                test = (from a in db.ICDCodes
                         where a.Code == code && a.CompanyID == CompanyID
                         select a).ToList();
            }

            if (test.Any())
            {
                Found = true;
            }
            else
            {
                Found = false;
            }
            return Found;
        }
        #endregion

        #region UpdateICDCode

        /// <summary>
        /// Updates an ICDCode Record. Also updates the associated Contacts.
        /// </summary>
        /// <param name="ICDCodeToUpdate">The record to be updated.</param>
        public static void UpdateICDCode(ICDCode ICDCodeToUpdate)
        {
            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                ICDCode Found = (from a in db.ICDCodes
                                 where a.ID == ICDCodeToUpdate.ID
                                 select a).FirstOrDefault();
                Found.Code = ICDCodeToUpdate.Code;
                Found.ShortDescription = ICDCodeToUpdate.ShortDescription;
                Found.LongDescription = ICDCodeToUpdate.LongDescription;
                Found.Active = ICDCodeToUpdate.Active;

                db.SubmitChanges();
            }
        }

        #endregion

        #region CanInactivateICDCode
        public static bool CanInactivateICDCode(Int32 ICDCodeID)
        {
            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                return (from i in db.SurgeryInvoice_Surgery_ICDCodes
                        where i.ICDCodeID == ICDCodeID
                           && i.Active
                        select i).FirstOrDefault() == null;
            }
        }

        #endregion

        #region GetICDCodeByID

        /// <summary>
        /// Get a ICDCode by ID.
        /// </summary>
        /// <param name="ID">ID of the record to retrieve.</param>
        /// <returns>Returns the found record, or null if nothing was found.</returns>
        public static ICDCode GetICDCodeByID(Int32 ID)
        {
            ICDCode Found;
            using (DataModelDataContext db = new DataModelDataContext())
            {
                Found = (from a in db.ICDCodes
                         where a.ID == ID
                         select a).FirstOrDefault();
            }

            return Found;
        }

        #endregion

        #region GetICDCodesByCompanyID

        /// <summary>
        /// Gets a list of ICDCodes by the passed in Company ID.
        /// </summary>
        /// <param name="CompanyID"></param>
        /// <returns></returns>
        public static List<ICDCode> GetICDCodesByCompanyID(Int32 CompanyID)
        {
            List<ICDCode> retlist;
            using (DataModelDataContext db = new DataModelDataContext())
            {
                retlist = (from a in db.ICDCodes
                           where a.CompanyID == CompanyID
                           //  && a.Active == true
                           select a).ToList();
            }
            return retlist;
        }

        #endregion

        #region DeleteICDCode

        /// <summary>
        /// Deletes a ICDCode record from the database.
        /// DO NOT USE! FOR TESTING PURPOSES ONLY!
        /// </summary>
        /// <param name="ID"></param>
        public static void DeleteICDCode(Int32 ID)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                ICDCode ToDelete = (from x in db.ICDCodes where x.ID == ID select x).FirstOrDefault();

                db.ICDCodes.DeleteOnSubmit(ToDelete);
                db.SubmitChanges();
            }
        }

        #endregion
    }
}
