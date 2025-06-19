using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BMM_DAL;
using System.Data.Linq;

namespace BMM_BAL
{
    public class LoanTermsClass
    {
        #region InsertLoanTerms

        /// <summary>
        /// Inserts a new LoanTerms Record into the database. 
        /// </summary>
        /// <param name="NewLoanTerms">The LoanTerms record to be inserted.</param>
        /// <returns>Returns the ID of the newly created LoanTerms record.</returns>
        public static Int32 InsertLoanTerms(LoanTerm NewLoanTerms)
        {
            //Set all new records to Active and the sisd added sisd to now.
            NewLoanTerms.Active = true;
            NewLoanTerms.DateAdded = DateTime.Now;

            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                db.LoanTerms.InsertOnSubmit(NewLoanTerms);
                db.SubmitChanges();
            }

            return NewLoanTerms.ID;
        }

        #endregion

        #region GetLoanTermsByID

        /// <summary>
        /// Get a LoanTerm by ID.
        /// </summary>
        /// <param name="ID">ID of the record to retrieve.</param>
        /// <returns>Returns the found record, or null if nothing was found.</returns>
        public static LoanTerm GetLoanTermsByID(Int32 ID)
        {
            LoanTerm Found;
            using (DataModelDataContext db = new DataModelDataContext())
            {
                Found = (from a in db.LoanTerms
                         where a.ID == ID
                         select a).FirstOrDefault();
            }

            return Found;
        }

        #endregion

        #region GetCurrentLoanTermsByCompanyID

        /// <summary>
        /// Gets a list of LoanTermss by the passed in Company ID.
        /// </summary>
        /// <param name="CompanyID"></param>
        /// <returns></returns>
        public static LoanTerm GetCurrentLoanTermsByCompanyID(Int32 CompanyID)
        {
            LoanTerm retval = new LoanTerm();
            using (DataModelDataContext db = new DataModelDataContext())
            {
                retval = (from a in db.LoanTerms
                           where a.Active == true
                           && a.CompanyID == CompanyID
                           orderby a.DateAdded descending
                           select a).FirstOrDefault();
            }
            return retval;
        }

        #endregion

        #region DeleteLoanTerms

        /// <summary>
        /// Deletes a LoanTerms record from the database.
        /// DO NOT USE! FOR TESTING PURPOSES ONLY!
        /// </summary>
        /// <param name="ID"></param>
        public static void DeleteLoanTerms(Int32 ID)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                LoanTerm ToDelete = (from x in db.LoanTerms where x.ID == ID select x).FirstOrDefault();

                db.LoanTerms.DeleteOnSubmit(ToDelete);
                db.SubmitChanges();
            }
        }

        #endregion
    }
}
