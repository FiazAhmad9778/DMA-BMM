using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BMM_DAL;
using System.Data.Linq;

namespace BMM_BAL
{
    public class PatientClass
    {
        #region InsertPatient

        /// <summary>
        /// Inserts a new Patient Record into the database. 
        /// </summary>
        /// <param name="NewPatient">The Patient record to be inserted.</param>
        /// <returns>Returns the ID of the newly created Patient record.</returns>
        public static Int32 InsertPatient(Patient NewPatient)
        {
            //Set all new records to Active and the sisd added sisd to now.
            NewPatient.Active = true;
            NewPatient.DateAdded = DateTime.Now;

            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                db.Patients.InsertOnSubmit(NewPatient);
                db.SubmitChanges();
            }

            return NewPatient.ID;
        }

        #endregion

        #region UpdatePatient

        /// <summary>
        /// Updates an Patient Record. 
        /// Also inserts a new record in the PatientChangeLog for any changes.
        /// </summary>
        /// <param name="PatientToUpdate">The record to be updated.</param>
        /// <param name="UserID">ID of the user making the changes.</param>
        public static void UpdatePatient(Patient PatientToUpdate, Int32 UserID)
        {
            string LogString = string.Empty;
            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                Patient Found = (from a in db.Patients
                                   where a.ID == PatientToUpdate.ID
                                   select a).FirstOrDefault();
                if (Found.CompanyID != PatientToUpdate.CompanyID)
                {
                    LogString = AddChangeToChangeLogString(LogString, "CompanyID", Found.CompanyID.ToString());
                    Found.Company = db.Companies.Single(c => c.ID == PatientToUpdate.CompanyID);
                }
                if (Found.isActiveStatus != PatientToUpdate.isActiveStatus)
                {
                    LogString = AddChangeToChangeLogString(LogString, "Status", Found.isActiveStatus ? "Active" : "Inactive" );
                    Found.isActiveStatus = PatientToUpdate.isActiveStatus;
                }
                if (Found.FirstName != PatientToUpdate.FirstName)
                {
                    LogString = AddChangeToChangeLogString(LogString, "First Name", Found.FirstName);
                    Found.FirstName = PatientToUpdate.FirstName;
                }
                if (Found.LastName != PatientToUpdate.LastName)
                {
                    LogString = AddChangeToChangeLogString(LogString, "Last Name", Found.LastName);
                    Found.LastName = PatientToUpdate.LastName;
                }
                if (Found.SSN != PatientToUpdate.SSN)
                {
                    LogString = AddChangeToChangeLogString(LogString, "SSN", Found.SSN);
                    Found.SSN = PatientToUpdate.SSN;
                }
                if (Found.Street1 != PatientToUpdate.Street1)
                {
                    LogString = AddChangeToChangeLogString(LogString, "Street Address", Found.Street1);
                    Found.Street1 = PatientToUpdate.Street1;
                }
                if (Found.Street2 != PatientToUpdate.Street2)
                {
                    LogString = AddChangeToChangeLogString(LogString, "Apt or Suite", Found.Street2);
                    Found.Street2 = PatientToUpdate.Street2;
                }
                if (Found.City != PatientToUpdate.City)
                {
                    LogString = AddChangeToChangeLogString(LogString, "City", Found.City);
                    Found.City = PatientToUpdate.City;
                }
                if (Found.StateID != PatientToUpdate.StateID)
                {
                    LogString = AddChangeToChangeLogString(LogString, "State", Found.State.Name);
                    Found.State = db.States.Single(s => s.ID == PatientToUpdate.StateID);
                }
                if (Found.ZipCode != PatientToUpdate.ZipCode)
                {
                    LogString = AddChangeToChangeLogString(LogString, "Zip Code", Found.ZipCode);
                    Found.ZipCode = PatientToUpdate.ZipCode;
                }
                if (Found.Phone != PatientToUpdate.Phone)
                {
                    LogString = AddChangeToChangeLogString(LogString, "Phone", Found.Phone);
                    Found.Phone = PatientToUpdate.Phone;
                }
                if (Found.WorkPhone != PatientToUpdate.WorkPhone)
                {
                    LogString = AddChangeToChangeLogString(LogString, "Work Phone", Found.WorkPhone);
                    Found.WorkPhone = PatientToUpdate.WorkPhone;
                }
                if (Found.DateOfBirth != PatientToUpdate.DateOfBirth)
                {
                    LogString = AddChangeToChangeLogString(LogString, "Date Of Birth", Found.DateOfBirth.ToShortDateString());
                    Found.DateOfBirth = PatientToUpdate.DateOfBirth;
                }
                if (Found.Active != PatientToUpdate.Active)
                {
                    LogString = AddChangeToChangeLogString(LogString, "Active", Found.Active.ToString());
                    Found.Active = PatientToUpdate.Active;
                }

                db.SubmitChanges();
            }
            if (LogString.Length > 0)
                InsertPatientChangeLog(LogString, UserID, PatientToUpdate.ID);

        }

        #endregion

        #region CanInactivatePatient
        public static bool CanInactivatePatient(Int32 PatientID)
        {
            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                return (from i in db.Invoices
                        where i.InvoicePatient.PatientID == PatientID
                           && i.Active
                        select i).FirstOrDefault() == null;
            }
        }

        #endregion

        #region GetPatientByID
        /// <summary>
        /// Get a Patient by ID.
        /// </summary>
        /// <param name="ID">ID of the record to retrieve.</param>
        /// <returns>Returns the found record, or null if nothing was found.</returns>
        public static Patient GetPatientByID(Int32 ID, Boolean LoadHistory = false, Boolean LoadState = false)
        {
            DataLoadOptions options = new DataLoadOptions();

            if (LoadHistory)
            {
                options.LoadWith<Patient>(p => p.PatientChangeLogs);
                options.LoadWith<PatientChangeLog>(p => p.User);
            }
            if (LoadState)
            {
                options.LoadWith<Patient>(p => p.State);
            }

            using (DataModelDataContext db = new DataModelDataContext() { LoadOptions = options })
            {
                return (from a in db.Patients
                        where a.ID == ID
                        select a).FirstOrDefault();
            }
        }

        #endregion

        #region GetPatientBySSN
        public static Patient GetPatientBySSN(string SSN, Int32 CompanyID)
        {
            Patient retval;
            using (DataModelDataContext db = new DataModelDataContext())
            {
                retval = (from p in db.Patients
                          where p.SSN == SSN
                                && p.CompanyID == CompanyID
                                && p.Active
                          select p).FirstOrDefault();
            }
            return retval;
        }
        #endregion

        #region GetPatientByInvoiceID
        public static Patient GetPatientByInvoiceID(Int32 InvoiceID, Int32 CompanyID, Boolean LoadState = false)
        {
            Patient retval;

            DataLoadOptions options = new DataLoadOptions();
            if (LoadState) options.LoadWith<Patient>(p => p.State);

            using (DataModelDataContext db = new DataModelDataContext() { LoadOptions = options })
            {
                retval = (from i in db.Invoices
                          where i.ID == InvoiceID
                            && i.CompanyID == CompanyID
                            && i.Active
                            && i.InvoicePatient.Active
                            && i.InvoicePatient.Patient.Active
                          select i.InvoicePatient.Patient).FirstOrDefault();
            }
            return retval;
        }
        #endregion

        #region GetPatientByInvoiceNumber
        public static Patient GetPatientByInvoiceNumber(Int32 InvoiceNumber, Int32 CompanyID, Boolean LoadState = false)
        {
            Patient retval;

            DataLoadOptions options = new DataLoadOptions();
            if (LoadState) options.LoadWith<Patient>(p => p.State);

            using (DataModelDataContext db = new DataModelDataContext() { LoadOptions = options })
            {
                retval = (from i in db.Invoices
                          where i.InvoiceNumber == InvoiceNumber
                            && i.CompanyID == CompanyID
                            && i.Active
                            && i.InvoicePatient.Active
                            && i.InvoicePatient.Patient.Active
                          select i.InvoicePatient.Patient).FirstOrDefault();
            }
            return retval;
        }
        #endregion

        #region GetPatientsByCompanyID
        /// <summary>
        /// Gets a list of Patients by the passed in Company ID.
        /// </summary>
        /// <param name="CompanyID"></param>
        /// <returns></returns>
        public static List<Patient> GetPatientsByCompanyID(Int32 CompanyID, Boolean LoadState)
        {
            List<Patient> retlist;
            using (DataModelDataContext db = new DataModelDataContext())
            {
                DataLoadOptions options = new DataLoadOptions();
                //add the load option to load the firm if the user requested.
                if (LoadState)
                {
                    options.LoadWith<Patient>(a => a.State);
                }

                db.LoadOptions = options;

                retlist = (from p in db.Patients
                           where p.CompanyID == CompanyID
                                && p.Active
                           select p).ToList();
            }
            return retlist;
        }
        #endregion

        #region GetPatientsByNameSearch
        /// <summary>
        /// Gets a list of patients with the search string in their name when it is formatted as "LastName, FirstName"
        /// </summary>
        /// <param name="search"></param>
        /// <param name="CompanyID"></param>
        /// <returns></returns>
        public static List<Patient> GetPatientsByNameSearch(string search, Int32 CompanyID)
        {
            search = search.ToLower();
            using (DataModelDataContext db = new DataModelDataContext())
            {
                return (from p in db.Patients
                        where p.CompanyID == CompanyID
                             && p.Active
                             && (p.LastName.ToLower() + ", " + p.FirstName.ToLower()).Contains(search)
                        orderby p.LastName, p.FirstName, p.SSN
                        select p).ToList();
            }
        }
        #endregion

        #region GetPatientsBySSNSearch
        /// <summary>
        /// Gets a list of patients with the search string in their name when it is formatted as "LastName, FirstName"
        /// </summary>
        /// <param name="search"></param>
        /// <param name="CompanyID"></param>
        /// <returns></returns>
        public static List<Patient> GetPatientsBySSNSearch(string search, Int32 CompanyID)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {

                return (from p in db.Patients
                        where p.CompanyID == CompanyID
                             && p.Active
                             && !(p.SSN == String.Empty)
                             && ((search.Contains("-") && (p.SSN.Substring(0, 3) + "-" + p.SSN.Substring(3, 2) + "-" + p.SSN.Substring(5, 4)).Contains(search))
                                || (!search.Contains("-") && p.SSN.Contains(search)))
                        orderby p.LastName, p.FirstName, p.SSN
                        select p).ToList();
            }
        }
        #endregion

        #region GetPatientsByInvoiceDateOfAccident
        public static List<Patient> GetPatientsByInvoiceDateOfAccident(DateTime DateOfAccident, Int32 CompanyID, Boolean LoadState = false)
        {
            List<Patient> retval;

            DataLoadOptions options = new DataLoadOptions();
            if (LoadState) options.LoadWith<Patient>(p => p.State);

            using (DataModelDataContext db = new DataModelDataContext() { LoadOptions = options })
            {
                retval = (from i in db.Invoices
                          //join p in db.InvoicePatients on invoice.InvoicePatientID equals p.ID
                          where i.DateOfAccident.HasValue
                                && i.DateOfAccident.Value.Date == DateOfAccident.Date
                                && i.CompanyID == CompanyID
                                && i.Active
                                && i.InvoicePatient.Active
                                && i.InvoicePatient.Patient.Active
                          select i.InvoicePatient.Patient).Distinct().ToList();

            }
            return retval;
        }
        #endregion

        #region GetPatientsByDateOfBirth
        public static List<Patient> GetPatientsByDateOfBirth(DateTime DateOfBirth, Int32 CompanyID, Boolean LoadState = false)
        {
            List<Patient> retval;
            DataLoadOptions options = new DataLoadOptions();
            if (LoadState) options.LoadWith<Patient>(p => p.State);

            using (DataModelDataContext db = new DataModelDataContext() { LoadOptions = options })
            {
                retval = (from i in db.Patients
                          where i.DateOfBirth == DateOfBirth
                          select i).Distinct().ToList();
            }
            return retval;
        }
        #endregion

        #region GetPatientsByFirstServiceDate
        public static List<Patient> GetPatientsByFirstServiceDate(DateTime FirstServiceDate, Int32 CompanyID, Boolean LoadState = false)
        {

            List<Patient> retval;

            DataLoadOptions options = new DataLoadOptions();
            if (LoadState) options.LoadWith<Patient>(p => p.State);

            using (DataModelDataContext db = new DataModelDataContext() { LoadOptions = options })
            {
                List<procSearchInvoice_GetByFirstServiceDateResult> result = db.procSearchInvoice_GetByFirstServiceDate(FirstServiceDate).ToList();
                retval = (from r in result
                          join p in db.Patients on r.ID equals p.ID
                          where p.CompanyID == CompanyID
                          select p).Distinct().ToList();
            }
            return retval;
        }
        #endregion

        #region DeletePatient
        /// <summary>
        /// Deletes a Patient record from the database.
        /// DO NOT USE! FOR TESTING PURPOSES ONLY!
        /// </summary>
        /// <param name="ID"></param>
        public static void DeletePatient(Int32 ID)
        {
            DeletePatientChangeLogsForPatient(ID);

            using (DataModelDataContext db = new DataModelDataContext())
            {
                Patient ToDelete = (from x in db.Patients where x.ID == ID select x).FirstOrDefault();

                db.Patients.DeleteOnSubmit(ToDelete);
                db.SubmitChanges();
            }
            DeletePatientChangeLogsForPatient(ID);
        }
        #endregion


        #region InsertPatientChangeLog

        private static void InsertPatientChangeLog(string ChangeLogString, Int32 UserID, Int32 PatientID)
        {
            PatientChangeLog pcl = new PatientChangeLog();
            pcl.Active = true;
            pcl.DateAdded = DateTime.Now;
            pcl.InformationUpdated = ChangeLogString;
            pcl.PatientID = PatientID;
            pcl.UserID = UserID;
            using (DataModelDataContext db = new DataModelDataContext())
            {
                db.PatientChangeLogs.InsertOnSubmit(pcl);
                db.SubmitChanges();
            }
        }

        #endregion


        #region + Helpers

        #region AddChangeToChangeLogString

        /// <summary>
        /// 
        /// </summary>
        /// <param name="CurrentLogString"></param>
        /// <param name="FieldName"></param>
        /// <param name="OldValue"></param>
        /// <returns></returns>
        private static string AddChangeToChangeLogString(string CurrentLogString, string FieldName, string OldValue)
        {
            if (CurrentLogString.Trim().Length > 0)
                CurrentLogString += "<br>";
            CurrentLogString += FieldName.ToString() + ": " + (OldValue == null ? null : OldValue.ToString());
            return CurrentLogString;
        }

        #endregion

        #region DeletePatientChangeLogsForPatient

        /// <summary>
        /// Deletes a PatientChangeLog record from the database.
        /// DO NOT USE! FOR TESTING PURPOSES ONLY!
        /// </summary>
        /// <param name="PatientID"></param>
        private static void DeletePatientChangeLogsForPatient(Int32 PatientID)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                db.PatientChangeLogs.DeleteAllOnSubmit((from c in db.PatientChangeLogs where c.PatientID == PatientID select c).ToList());
                db.SubmitChanges();
            }
        }

        #endregion

        #endregion
    }
}
