using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BMM_DAL;
using System.Data.Linq;

namespace BMM_BAL
{
    public class CPTCodeClass
    {
        #region InsertCPTCode

        /// <summary>
        /// Inserts a new CPTCode Record into the database. 
        /// </summary>
        /// <param name="NewCPTCode">The CPTCode record to be inserted.</param>
        /// <returns>Returns the ID of the newly created CPTCode record.</returns>
        public static Int32 InsertCPTCode(CPTCode NewCPTCode)
        {
            //Set all new records to Active and the sisd added sisd to now.
            NewCPTCode.Active = true;
            NewCPTCode.DateAdded = DateTime.Now;

            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                db.CPTCodes.InsertOnSubmit(NewCPTCode);
                db.SubmitChanges();
            }

            return NewCPTCode.ID;
        }

        #endregion

        #region UpdateCPTCode

        /// <summary>
        /// Updates an CPTCode Record. Also updates the associated Contacts.
        /// </summary>
        /// <param name="CPTCodeToUpdate">The record to be updated.</param>
        public static void UpdateCPTCode(CPTCode CPTCodeToUpdate)
        {
            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                CPTCode Found = (from a in db.CPTCodes
                                   where a.ID == CPTCodeToUpdate.ID
                                   select a).FirstOrDefault();
                Found.Code = CPTCodeToUpdate.Code;
                Found.Description = CPTCodeToUpdate.Description;
                Found.Active = CPTCodeToUpdate.Active;

                db.SubmitChanges();
            }
        }

        #endregion

        #region CanInactivateCPTCode
        public static bool CanInactivateCPTCode(Int32 CPTCodeID)
        {
            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                return (from i in db.SurgeryInvoice_Provider_CPTCodes
                        where i.CPTCodeID == CPTCodeID
                           && i.Active
                        select i).FirstOrDefault() == null;
            }
        }

        #endregion

        #region GetCPTCodeByID

        /// <summary>
        /// Get a CPTCode by ID.
        /// </summary>
        /// <param name="ID">ID of the record to retrieve.</param>
        /// <returns>Returns the found record, or null if nothing was found.</returns>
        public static CPTCode GetCPTCodeByID(Int32 ID)
        {
            CPTCode Found;
            using (DataModelDataContext db = new DataModelDataContext())
            {
                Found = (from a in db.CPTCodes
                         where a.ID == ID
                         select a).FirstOrDefault();
            }

            return Found;
        }

        #endregion

        #region GetCPTCodesByCompanyID

        /// <summary>
        /// Gets a list of CPTCodes by the passed in Company ID.
        /// </summary>
        /// <param name="CompanyID"></param>
        /// <returns></returns>
        public static List<CPTCode> GetCPTCodesByCompanyID(Int32 CompanyID)
        {
            List<CPTCode> retlist;
            using (DataModelDataContext db = new DataModelDataContext())
            {
                retlist = (from a in db.CPTCodes
                           where a.CompanyID == CompanyID
                           //  && a.Active == true
                           select a).ToList();
            }
            return retlist;
        }

        #endregion

        #region DeleteCPTCode

        /// <summary>
        /// Deletes a CPTCode record from the database.
        /// DO NOT USE! FOR TESTING PURPOSES ONLY!
        /// </summary>
        /// <param name="ID"></param>
        public static void DeleteCPTCode(Int32 ID)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                CPTCode ToDelete = (from x in db.CPTCodes where x.ID == ID select x).FirstOrDefault();
                
                db.CPTCodes.DeleteOnSubmit(ToDelete);
                db.SubmitChanges();
            }
        }

        #endregion
    }
}
