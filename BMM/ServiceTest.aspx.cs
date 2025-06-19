using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BMM_BAL;
using BMM_DAL;

namespace BMM
{
    public partial class ServiceTest : Classes.BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //TestAttorneyClass();
            //TestInvoiceClass();
            //TestPatientClass();
            //TestUserClass();
            GetPatientB();
        }

        private Patient GetPatientA()
        {
            Patient patient = PatientClass.GetPatientBySSN("000000001", 1);
            if (patient == null)
            {
                patient = PatientClass.GetPatientByID(PatientClass.InsertPatient(
                    new Patient()
                    {
                        CompanyID = 1,
                        SSN = "000000001",
                        FirstName = "Andrew",
                        LastName = "Bursavich",
                        DateOfBirth = new DateTime(1986, 10, 20),
                        isActiveStatus = true,
                        Phone = "2258922939",
                        WorkPhone = "5555555555",
                        Street1 = "1443 Beckenham Dr",
                        City = "Baton Rouge",
                        StateID = 19,
                        ZipCode = "70808"
                    }),
                    false,
                    false);
            }
            return patient;
        }

        private Patient GetPatientB()
        {
            Patient patient = PatientClass.GetPatientBySSN("000000002", 1);
            if (patient == null)
            {
                patient = PatientClass.GetPatientByID(PatientClass.InsertPatient(
                    new Patient()
                    {
                        CompanyID = 1,
                        SSN = "000000002",
                        FirstName = "Nicholas",
                        LastName = "Bursavich",
                        DateOfBirth = new DateTime(1980, 12, 15),
                        isActiveStatus = true,
                        Phone = "2258920014",
                        WorkPhone = "5555555555",
                        Street1 = "356 Maxine Dr",
                        City = "Baton Rouge",
                        StateID = 19,
                        ZipCode = "70808"
                    }),
                    false,
                    false);
            }
            return patient;
        }

        private void TestAttorneyClass()
        {
            Attorney A = new Attorney();
            A.CompanyID = 1;
            A.FirmID = 2;
            A.isActiveStatus = true;
            A.FirstName = "bJohn";
            A.LastName = "Attorney";
            A.Street1 = "548 Highland Creek Pkwy";
            A.City = "Baton Rouge";
            A.StateID = 19;
            A.ZipCode = "70808";
            A.Phone = "225-889-9989";


            Contact c1 = new Contact();
            c1.Name = "bJohn Contacto";
            c1.Position = "Contactor";
            c1.Phone = "123-654-9898";
            c1.Email = "john@infiniedge.com";
            c1.DateAdded = DateTime.Now;

            Contact c2 = new Contact();
            c2.Name = "bJohn Contacto";
            c2.Position = "Contactor";
            c2.Phone = "123-654-9898";
            c2.Email = "john@infiniedge.com";
            c2.DateAdded = DateTime.Now;

            A.ContactList = new ContactList();
            A.ContactList.DateAdded = DateTime.Now;
            A.ContactList.Contacts.Add(c1);
            A.ContactList.Contacts.Add(c2);

            //INSERT THE NEW ATTORNEY RECORD
            Int32 NewAttorneyID = AttorneyClass.InsertAttorney(A);

            //GET THE ATTORNEY BY THE ID RETURNED FROM THE INSERT
            Attorney X = AttorneyClass.GetAttorneyByID(NewAttorneyID, true, true, true);

            Contact c3 = new Contact();
            c3.Name = "zJohn Contacto";
            c3.Position = "Contactor";
            c3.Phone = "123-654-9898";
            c3.Email = "john@infiniedge.com";
            c3.DateAdded = DateTime.Now;

            X.ContactList.Contacts.Clear();
            X.ContactList.Contacts.Add(c3);

            AttorneyClass.UpdateAttorney(X);

            AttorneyClass.DeleteAttorney(X.ID);
        }

        private void TestInvoiceClass()
        {
            #region sis CreateNewTestInvoice

            Comment C1 = new Comment();
            C1.CommentTypeID = 1;
            C1.UserID = 37;
            C1.Text = "Payment Comment 1";
            C1.isIncludedOnReports = false;

            Comment C2 = new Comment();
            C2.CommentTypeID = 1;
            C2.UserID = 37;
            C2.Text = "Payment Comment 2";
            C2.isIncludedOnReports = true;

            Comment C3 = new Comment();
            C3.CommentTypeID = 2;
            C3.UserID = 37;
            C3.Text = "Invoice Comment 1";
            C3.isIncludedOnReports = false;

            List<Comment> pList1 = new List<Comment>();
            pList1.Add(C1);
            pList1.Add(C2);

            List<Comment> iList1 = new List<Comment>();
            iList1.Add(C3);


            List<Payment> pList = new List<Payment>();

            Payment pay1 = new Payment();
            pay1.Amount = 100;
            pay1.CheckNumber = "asdf";
            pay1.DatePaid = DateTime.Now;
            pay1.PaymentTypeID = 1;
            pList.Add(pay1);


            #endregion


            TestSurgeryInvoice(pList, iList1, pList1);


        }

        private void TestPatientClass()
        {
            Patient NewPatient = new Patient();
            NewPatient.CompanyID = 1;
            NewPatient.isActiveStatus = true;
            NewPatient.FirstName = "First";
            NewPatient.LastName = "Last";
            NewPatient.SSN = "123-65-9898";
            NewPatient.Street1 = "123 sis";
            NewPatient.Street2 = "apt A12";
            NewPatient.City = "baton rouge";
            NewPatient.StateID = 19;
            NewPatient.ZipCode = "70808";
            NewPatient.Phone = "123-9898";
            NewPatient.WorkPhone = "654-9898";
            NewPatient.DateOfBirth = new DateTime(2012, 1, 1);
            NewPatient.Active = true;
            NewPatient.DateAdded = DateTime.Now;

            Int32 newPatientID = PatientClass.InsertPatient(NewPatient);

            Patient FoundPatient = PatientClass.GetPatientByID(newPatientID, true, false);
            FoundPatient.CompanyID = 2;
            FoundPatient.isActiveStatus = false;
            FoundPatient.FirstName = "FName";
            FoundPatient.LastName = "LName";
            FoundPatient.SSN = "444-44-4444";
            FoundPatient.Street1 = "123 Street1";
            FoundPatient.Street2 = "apt 2";
            FoundPatient.City = "Different City";
            FoundPatient.StateID = 18;
            FoundPatient.ZipCode = "45678";
            FoundPatient.Phone = "888-8888";
            FoundPatient.WorkPhone = "777-7777";
            FoundPatient.DateOfBirth = new DateTime(1934, 1, 2);
            FoundPatient.Active = false;

            PatientClass.UpdatePatient(FoundPatient, 2);

            PatientClass.DeletePatient(newPatientID);
        }

        private void TestUserClass()
        {
            User NewUser = new BMM_DAL.User();
            NewUser.CompanyID = 1;
            NewUser.FirstName = "John2";
            NewUser.LastName = "D'Antonio2";
            NewUser.Email = "john@infiniedge.com";
            NewUser.Position = "test2";
            NewUser.Password = "Password1aaa23!";

            UserPermission up1 = new UserPermission();
            up1.AllowAdd = false;
            up1.AllowDelete = false;
            up1.AllowEdit = false;
            up1.AllowView = true;
            up1.UserID = NewUser.ID;
            up1.PermissionID = 7;

            UserPermission up2 = new UserPermission();
            up2.AllowAdd = true;
            up2.AllowDelete = true;
            up2.AllowEdit = false;
            up2.AllowView = false;
            up2.UserID = NewUser.ID;
            up2.PermissionID = 4;

            NewUser.UserPermissions = new System.Data.Linq.EntitySet<UserPermission>();
            NewUser.UserPermissions.Add(up1);
            NewUser.UserPermissions.Add(up2);

            NewUser.ID = UserClass.InsertUser(NewUser);

            //List<UserPermission> upList = new List<UserPermission>();
            //upList.Add(up1);
            //upList.Add(up2);
            //UserClass.SetUserPermissionsForUser(NewUser.ID, upList);

            User found = UserClass.GetUserByID(NewUser.ID, true);

            UserPermission up3 = new UserPermission();
            up3.AllowAdd = false;
            up3.AllowDelete = false;
            up3.AllowEdit = false;
            up3.AllowView = false;
            up3.UserID = NewUser.ID;
            up3.PermissionID = 11;

            found.UserPermissions.Add(up3);

            found.CompanyID = 2;
            found.FirstName = "FNAME";
            found.LastName = "LNAME";
            found.Email = "jjjj";
            found.Position = "Hkjkjkj";
            found.Password = "whatever";

            UserClass.UpdateUser(found, true);

            User u1 = UserClass.GetUserByEmail(found.Email, Company.ID);
            User u2 = UserClass.GetUserByEmail("kjkjkjkjk", Company.ID);
            User u3 = UserClass.GetUserByEmailAndPassword(found.Email, found.Password, Company.ID, true);
            User u4 = UserClass.GetUserByEmailAndPassword("kjkjk", "jjkjkj", Company.ID, true);

            List<User> aList = UserClass.GetUsersByCompanyID(1);
            List<User> bList = UserClass.GetUsersByCompanyID(2);
            List<User> cList = UserClass.GetUsersByCompanyID(3);

            UserClass.DeleteUser(NewUser.ID);
        }


        #region TestSurgeryInvoice

        private void TestSurgeryInvoice(List<Payment> PaymentList, List<Comment> GeneralComments, List<Comment> PaymentComments)
        {
            List<SurgeryInvoice_Provider_CPTCode_Custom> CPTList = new List<SurgeryInvoice_Provider_CPTCode_Custom>();
            SurgeryInvoice_Provider_CPTCode_Custom c1 = new SurgeryInvoice_Provider_CPTCode_Custom();
            c1.Active = true;
            c1.CPTCodeID = 1;
            c1.Description = "remedy";
            c1.Amount = 456;
            CPTList.Add(c1);

            List<SurgeryInvoice_Provider_Payment_Custom> SIPP_List = new List<SurgeryInvoice_Provider_Payment_Custom>();
            SurgeryInvoice_Provider_Payment_Custom S1 = new SurgeryInvoice_Provider_Payment_Custom();
            S1.Amount = 99;
            S1.CheckNumber = "p01";
            S1.DatePaid = DateTime.Now;
            S1.PaymentTypeID = 1;
            SIPP_List.Add(S1);

            List<SurgeryInvoice_Provider_Service_Custom> SIPS_List = new List<SurgeryInvoice_Provider_Service_Custom>();
            SurgeryInvoice_Provider_Service_Custom service1 = new SurgeryInvoice_Provider_Service_Custom();
            service1.AccountNumber = "12345";
            service1.AmountDue = 98;
            service1.Cost = 194;
            service1.Discount = 9;
            service1.DueDate = DateTime.Now.AddDays(99);
            service1.EstimatedCost = 99;
            service1.PPODiscount = 11;
            SIPS_List.Add(service1);

            List<SurgeryInvoice_Provider_Custom> SIPC_List = new List<SurgeryInvoice_Provider_Custom>();
            SurgeryInvoice_Provider_Custom SIPC1 = new SurgeryInvoice_Provider_Custom();
            SIPC1.ProviderID = 1;
            SIPC1.Active = true;
            SIPC1.CPTCodes = CPTList;
            SIPC1.ProviderServices = SIPS_List;
            SIPC1.Payments = SIPP_List;
            SIPC_List.Add(SIPC1);

            List<DateTime> dateslist = new List<DateTime>();
            dateslist.Add(new DateTime(1900, 7, 11));
            dateslist.Add(new DateTime(1909, 7, 11));

            List<SurgeryInvoice_Surgery_Custom> sList = new List<SurgeryInvoice_Surgery_Custom>();
            SurgeryInvoice_Surgery_Custom sc1 = new SurgeryInvoice_Surgery_Custom();
            sc1.Active = true;
            sc1.isInpatient = false;
            sc1.Notes = "Test Notes";
            sc1.SurgeryDates = dateslist;
            sc1.SurgeryID = 1;
            sList.Add(sc1);

            //Int32 sInvID = InvoiceClass.CreateNewSurgeryInvoice(1, DateTime.Now, 1, false, 11, 4, 1, SIPC_List, sList, PaymentList, PaymentComments, GeneralComments, DateTime.Now, DateTime.Now, 0, 1);

            //Invoice i = BMM_BAL.InvoiceClass.GetSurgeryInvoice(sInvID, true);

            //InvoiceClass.UpdateSurgeryInvoice(sInvID, i.DateOfAccident, i.InvoiceStatusTypeID, i.isComplete, 12, 23, 2, null, null, PaymentList, PaymentComments, GeneralComments, DateTime.Now, i.DatePaid.Value, 10, 0);
        }

        #endregion

        #region TestTestInvoice

        private void TestTestInvoice(List<Payment> PaymentList, List<Comment> GeneralComments, List<Comment> PaymentComments)
        {
            TestInvoice_Test_CPTCodes_Custom code1 = new TestInvoice_Test_CPTCodes_Custom();
            code1.Amount = 123;
            code1.CPTCodeID = 1;
            code1.Description = "TEST";
            TestInvoice_Test_CPTCodes_Custom code2 = new TestInvoice_Test_CPTCodes_Custom();
            code2.Amount = 999;
            code2.CPTCodeID = 1;
            code2.Description = "TOO TEST";

            TestInvoice_Test_Custom TIT = new TestInvoice_Test_Custom();
            TIT.CPTCodeList = new List<TestInvoice_Test_CPTCodes_Custom>();
            TIT.CPTCodeList.Add(code1);
            TIT.ProviderID = 1;
            TIT.TestID = 1;
            TestInvoice_Test_Custom TIT2 = new TestInvoice_Test_Custom();
            TIT2.CPTCodeList = new List<TestInvoice_Test_CPTCodes_Custom>();
            TIT2.CPTCodeList.Add(code2);
            TIT2.ProviderID = 1;
            TIT2.TestID = 1;

            List<TestInvoice_Test_Custom> TITList = new List<TestInvoice_Test_Custom>();
            TITList.Add(TIT);

            //Int32 invID = InvoiceClass.CreateNewTestInvoice(1, DateTime.Now, 1, true, 1, 11, 4, 1, TITList, pList, pList1, iList1, DateTime.Now, DateTime.Now, 0, 0);

            //Invoice invoice = BMM_BAL.InvoiceClass.GetTestInvoice(invID, true);

            //TITList[0].CPTCodeList[0].Amount = 7;
            //TITList[0].CPTCodeList.Add(code2);
            //TITList.Add(TIT2);

            //InvoiceClass.UpdateTestInvoice(invID, invoice.InvoiceDateOfAccident, invoice.InvoiceStatusTypeID, invoice.isComplete, invoice.TestInvoice.InvoiceTestTypeID, 12, 23, 2, TITList, pList, pList1, iList1, DateTime.Now, invoice.DatePaid.Value, 10, 0); 
        }

        #endregion
    }
}
