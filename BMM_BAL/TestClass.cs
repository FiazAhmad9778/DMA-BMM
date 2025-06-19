using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BMM_DAL;
using System.Data.Linq;

namespace BMM_BAL
{
    public class TestClass
    {
        #region + Enums

        public enum TestTypeEnum
        {
            Pain_Management = 1,
            MRI = 2,
            Other_Diagnostic = 3
        }

        #endregion

        #region InsertTest

        /// <summary>
        /// Inserts a new Test Record into the database. 
        /// </summary>
        /// <param name="NewTest">The Test record to be inserted.</param>
        /// <returns>Returns the ID of the newly created Test record.</returns>
        public static Int32 InsertTest(Test NewTest)
        {
            //Set all new records to Active and the sisd added sisd to now.
            NewTest.Active = true;
            NewTest.DateAdded = DateTime.Now;

            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                db.Tests.InsertOnSubmit(NewTest);
                db.SubmitChanges();
            }

            return NewTest.ID;
        }

        #endregion

        #region UpdateTest

        /// <summary>
        /// Updates an Test Record. 
        /// </summary>
        /// <param name="TestToUpdate">The record to be updated.</param>
        public static void UpdateTest(Test TestToUpdate)
        {
            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                Test Found = (from a in db.Tests
                                   where a.ID == TestToUpdate.ID
                                   select a).FirstOrDefault();
                Found.CompanyID = TestToUpdate.CompanyID;
                Found.Name = TestToUpdate.Name;
                Found.Active = TestToUpdate.Active;

                db.SubmitChanges();
            }

        }

        #endregion

        #region CanInactivateTest
        public static bool CanInactivateTest(Int32 TestID)
        {
            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                return (from i in db.TestInvoice_Tests
                        where i.TestID == TestID
                           && i.Active
                        select i).FirstOrDefault() == null;
            }
        }

        #endregion

        #region GetTestByID

        /// <summary>
        /// Get a Test by ID.
        /// </summary>
        /// <param name="ID">ID of the record to retrieve.</param>
        /// <returns>Returns the found record, or null if nothing was found.</returns>
        public static Test GetTestByID(Int32 ID)
        {
            Test Found;
            using (DataModelDataContext db = new DataModelDataContext())
            {
                Found = (from a in db.Tests
                         where a.ID == ID
                         select a).FirstOrDefault();
            }

            return Found;
        }

        #endregion

        #region GetTestsByCompanyID

        /// <summary>
        /// Gets a list of Tests by the passed in Company ID.
        /// </summary>
        /// <param name="CompanyID"></param>
        /// <returns></returns>
        public static List<Test> GetTestsByCompanyID(Int32 CompanyID)
        {
            List<Test> retlist;
            using (DataModelDataContext db = new DataModelDataContext())
            {
                retlist = (from a in db.Tests
                           where a.Active == true
                           && a.CompanyID == CompanyID
                           select a).ToList();
            }
            return retlist;
        }

        #endregion

        #region DeleteTest

        /// <summary>
        /// Deletes a Test record from the database.
        /// DO NOT USE! FOR TESTING PURPOSES ONLY!
        /// </summary>
        /// <param name="ID"></param>
        public static void DeleteTest(Int32 ID)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                Test ToDelete = (from x in db.Tests where x.ID == ID select x).FirstOrDefault();
                
                db.Tests.DeleteOnSubmit(ToDelete);
                db.SubmitChanges();
            }
        }

        #endregion
    }
}
