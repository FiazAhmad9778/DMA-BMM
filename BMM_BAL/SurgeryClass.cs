using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BMM_DAL;
using System.Data.Linq;

namespace BMM_BAL
{
    public class SurgeryClass
    {
        #region InsertSurgery

        /// <summary>
        /// Inserts a new Surgery Record into the database. 
        /// </summary>
        /// <param name="NewSurgery">The Surgery record to be inserted.</param>
        /// <returns>Returns the ID of the newly created Surgery record.</returns>
        public static Int32 InsertSurgery(Surgery NewSurgery)
        {
            //Set all new records to Active and the sisd added sisd to now.
            NewSurgery.Active = true;
            NewSurgery.DateAdded = DateTime.Now;

            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                db.Surgeries.InsertOnSubmit(NewSurgery);
                db.SubmitChanges();
            }

            return NewSurgery.ID;
        }

        #endregion

        #region UpdateSurgery

        /// <summary>
        /// Updates an Surgery Record. 
        /// </summary>
        /// <param name="SurgeryToUpdate">The record to be updated.</param>
        public static void UpdateSurgery(Surgery SurgeryToUpdate)
        {
            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                Surgery Found = (from a in db.Surgeries
                              where a.ID == SurgeryToUpdate.ID
                              select a).FirstOrDefault();
                Found.CompanyID = SurgeryToUpdate.CompanyID;
                Found.Name = SurgeryToUpdate.Name;
                Found.Active = SurgeryToUpdate.Active;

                db.SubmitChanges();
            }

        }

        #endregion

        #region CanInactivateSurgery
        public static bool CanInactivateSurgery(Int32 SurgeryID)
        {
            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                return (from i in db.SurgeryInvoice_Surgeries
                        where i.SurgeryID == SurgeryID
                           && i.Active
                        select i).FirstOrDefault() == null;
            }
        }

        #endregion

        #region GetSurgeryByID

        /// <summary>
        /// Get a Surgery by ID.
        /// </summary>
        /// <param name="ID">ID of the record to retrieve.</param>
        /// <returns>Returns the found record, or null if nothing was found.</returns>
        public static Surgery GetSurgeryByID(Int32 ID)
        {
            Surgery Found;
            using (DataModelDataContext db = new DataModelDataContext())
            {
                Found = (from a in db.Surgeries
                         where a.ID == ID
                         select a).FirstOrDefault();
            }

            return Found;
        }

        #endregion

        #region GetSurgerysByCompanyID

        /// <summary>
        /// Gets a list of Surgerys by the passed in Company ID.
        /// </summary>
        /// <param name="CompanyID"></param>
        /// <returns></returns>
        public static List<Surgery> GetSurgerysByCompanyID(Int32 CompanyID)
        {
            List<Surgery> retlist;
            using (DataModelDataContext db = new DataModelDataContext())
            {
                retlist = (from a in db.Surgeries
                           where a.CompanyID == CompanyID
                              && a.Active
                           select a).ToList();
            }
            return retlist;
        }

        #endregion

        #region DeleteSurgery

        /// <summary>
        /// Deletes a Surgery record from the database.
        /// DO NOT USE! FOR TESTING PURPOSES ONLY!
        /// </summary>
        /// <param name="ID"></param>
        public static void DeleteSurgery(Int32 ID)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                Surgery ToDelete = (from x in db.Surgeries where x.ID == ID select x).FirstOrDefault();

                db.Surgeries.DeleteOnSubmit(ToDelete);
                db.SubmitChanges();
            }
        }

        #endregion
    }
}
