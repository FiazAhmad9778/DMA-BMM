using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BMM_DAL;
using System.Data.Linq;
using System.ComponentModel.DataAnnotations;

namespace BMM_BAL
{
    public class InvoiceClass
    {
        #region + Enums

        public enum InvoiceStatusEnum
        {
            Open = 1,
            Closed = 2,
            Overdue = 3
        }

        public enum InvoiceTypeEnum
        {
            Testing = 1,
            Surgery = 2
        }

        public enum CommentTypeEnum
        {
            PaymentComment = 1,
            InvoiceComment = 2
        }

        public enum PaymentTypeEnum
        {
            Principal = 1,
            Interest = 2,
            Deposit = 3,
            Refund = 4,
            Credit = 5
        }

        public enum InvoiceChangeLogType
        {
            LossesAmount = 1,
            ServiceFeeWaived = 2
        }

        #endregion


        #region GetInvoiceByID
        /// <summary>
        /// Gets an generic record for an Invoice.
        /// </summary>
        /// <param name="InvoiceID">ID of the invoice to retrieve from the database.</param>
        /// <param name="FullLoad">If true, all records associated with the invoice record will be loaded and pulled from the database.</param>
        /// <returns></returns>
        public static Invoice GetInvoiceByID(Int32 InvoiceID, Boolean FullLoad)
        {
            DataLoadOptions options = new DataLoadOptions();

            if (FullLoad)
            {
                options.LoadWith<Invoice>(i => i.InvoiceStatusType);
                options.LoadWith<Invoice>(i => i.InvoiceType);
                // Patient
                options.LoadWith<Invoice>(i => i.InvoicePatient);
                options.LoadWith<InvoicePatient>(ip => ip.Patient);
                options.LoadWith<InvoicePatient>(ip => ip.State);
                options.LoadWith<Patient>(p => p.State);
                // Attorney
                options.LoadWith<Invoice>(i => i.InvoiceAttorney);
                options.LoadWith<InvoiceAttorney>(ia => ia.InvoiceFirm);
                // Physician
                options.LoadWith<Invoice>(i => i.InvoicePhysician);
                // Payments
                options.AssociateWith<Invoice>(i => i.Payments.Where(p => p.Active));
                options.LoadWith<Invoice>(i => i.Payments);
                options.LoadWith<Payment>(p => p.PaymentType);
                // Comments
                options.AssociateWith<Invoice>(i => i.Comments.Where(c => c.Active));
                options.LoadWith<Invoice>(i => i.Comments);
                options.LoadWith<Comment>(c => c.User);
                // Test Invoice
                options.LoadWith<Invoice>(i => i.TestInvoice);
                options.LoadWith<TestInvoice>(ti => ti.TestType);
                options.AssociateWith<TestInvoice>(ti => ti.TestInvoice_Tests.Where(tit => tit.Active));
                options.LoadWith<TestInvoice>(ti => ti.TestInvoice_Tests);
                options.LoadWith<TestInvoice_Test>(tit => tit.Test);
                options.AssociateWith<TestInvoice_Test>(tit => tit.TestInvoice_Test_CPTCodes.Where(titc => titc.Active));
                options.LoadWith<TestInvoice_Test>(tit => tit.TestInvoice_Test_CPTCodes);
                options.LoadWith<TestInvoice_Test>(tit => tit.InvoiceProvider);
                options.LoadWith<TestInvoice_Test_CPTCode>(titc => titc.CPTCode);
                // Surgery Invoice
                options.LoadWith<Invoice>(i => i.SurgeryInvoice);
                options.LoadWith<SurgeryInvoice>(si => si.SurgeryInvoice_Surgeries);
                options.AssociateWith<SurgeryInvoice>(si => si.SurgeryInvoice_Surgeries.Where(sis => sis.Active));
                options.AssociateWith<SurgeryInvoice_Surgery>(si => si.SurgeryInvoice_SurgeryDates.Where(sisd => sisd.Active));
                options.LoadWith<SurgeryInvoice_Surgery_ICDCode>(sisicd => sisicd.ICDCode);
                options.LoadWith<SurgeryInvoice_Surgery>(sis => sis.SurgeryInvoice_SurgeryDates);
                options.LoadWith<SurgeryInvoice_Surgery>(sis => sis.SurgeryInvoice_Surgery_ICDCodes);
                options.LoadWith<SurgeryInvoice_Surgery>(sis => sis.Surgery);
                options.AssociateWith<SurgeryInvoice>(si => si.SurgeryInvoice_Providers.Where(sip => sip.Active));
                options.LoadWith<SurgeryInvoice>(si => si.SurgeryInvoice_Providers);
                options.AssociateWith<SurgeryInvoice_Provider>(sip => sip.SurgeryInvoice_Provider_CPTCodes.Where(sipc => sipc.Active));
                options.LoadWith<SurgeryInvoice_Provider>(sip => sip.SurgeryInvoice_Provider_CPTCodes);
                options.LoadWith<SurgeryInvoice_Provider>(sip => sip.InvoiceProvider);
                options.AssociateWith<SurgeryInvoice_Provider>(sip => sip.SurgeryInvoice_Provider_Services.Where(sips => sips.Active));
                options.LoadWith<SurgeryInvoice_Provider>(sip => sip.SurgeryInvoice_Provider_Services);
                options.AssociateWith<SurgeryInvoice_Provider>(sip => sip.SurgeryInvoice_Provider_Payments.Where(sipp => sipp.Active));
                options.LoadWith<SurgeryInvoice_Provider>(sip => sip.SurgeryInvoice_Provider_Payments);
                options.LoadWith<SurgeryInvoice_Provider_Payment>(sipp => sipp.PaymentType);
                options.LoadWith<SurgeryInvoice_Provider_CPTCode>(sipc => sipc.CPTCode);
                
                //options.LoadWith<SurgeryInvoice_Provider_CPTCode>(sipc => sipc.InvoiceProvider);
            }

            using (DataModelDataContext db = new DataModelDataContext() { LoadOptions = options })
            {
                return (from i in db.Invoices
                        where i.ID == InvoiceID
                        select i).FirstOrDefault();
            }
        }
        #endregion

        #region GetInvoiceByInvoiceNumberAndCompanyID
        /// <summary>
        /// Gets an generic record for an Invoice.
        /// </summary>
        /// <param name="InvoiceID">ID of the invoice to retrieve from the database.</param>
        /// <param name="FullLoad">If true, all records associated with the invoice record will be loaded and pulled from the database.</param>
        /// <returns></returns>
        public static Invoice GetInvoiceByInvoiceNumberAndCompanyID(Int32 InvoiceNumber, Int32 CompanyID, Boolean FullLoad)
        {
            DataLoadOptions options = new DataLoadOptions();

            if (FullLoad)
            {
                options.LoadWith<Invoice>(i => i.InvoiceStatusType);
                options.LoadWith<Invoice>(i => i.InvoiceType);
                // Patient
                options.LoadWith<Invoice>(i => i.InvoicePatient);
                options.LoadWith<InvoicePatient>(ip => ip.Patient);
                options.LoadWith<InvoicePatient>(ip => ip.State);
                options.LoadWith<Patient>(p => p.State);
                // Attorney
                options.LoadWith<Invoice>(i => i.InvoiceAttorney);
                options.LoadWith<InvoiceAttorney>(ia => ia.InvoiceFirm);
                // Physician
                options.LoadWith<Invoice>(i => i.InvoicePhysician);
                // Payments
                options.AssociateWith<Invoice>(i => i.Payments.Where(p => p.Active));
                options.LoadWith<Invoice>(i => i.Payments);
                options.LoadWith<Payment>(p => p.PaymentType);
                // Comments
                options.AssociateWith<Invoice>(i => i.Comments.Where(c => c.Active));
                options.LoadWith<Invoice>(i => i.Comments);
                options.LoadWith<Comment>(c => c.User);
                // Test Invoice
                options.LoadWith<Invoice>(i => i.TestInvoice);
                options.LoadWith<TestInvoice>(ti => ti.TestType);
                options.AssociateWith<TestInvoice>(ti => ti.TestInvoice_Tests.Where(tit => tit.Active));
                options.LoadWith<TestInvoice>(ti => ti.TestInvoice_Tests);
                options.LoadWith<TestInvoice_Test>(tit => tit.Test);
                options.AssociateWith<TestInvoice_Test>(tit => tit.TestInvoice_Test_CPTCodes.Where(titc => titc.Active));
                options.LoadWith<TestInvoice_Test>(tit => tit.TestInvoice_Test_CPTCodes);
                options.LoadWith<TestInvoice_Test>(tit => tit.InvoiceProvider);
                options.LoadWith<TestInvoice_Test_CPTCode>(titc => titc.CPTCode);
                // Surgery Invoice
                options.LoadWith<Invoice>(i => i.SurgeryInvoice);
                options.LoadWith<SurgeryInvoice>(si => si.SurgeryInvoice_Surgeries);
                options.AssociateWith<SurgeryInvoice>(si => si.SurgeryInvoice_Surgeries.Where(sis => sis.Active));
                options.AssociateWith<SurgeryInvoice_Surgery>(si => si.SurgeryInvoice_SurgeryDates.Where(sisd => sisd.Active));
                options.LoadWith<SurgeryInvoice_Surgery_ICDCode>(sisicd => sisicd.ICDCode);
                options.LoadWith<SurgeryInvoice_Surgery>(sis => sis.SurgeryInvoice_SurgeryDates);
                options.LoadWith<SurgeryInvoice_Surgery>(sis => sis.SurgeryInvoice_Surgery_ICDCodes);
                options.LoadWith<SurgeryInvoice_Surgery>(sis => sis.Surgery);
                options.AssociateWith<SurgeryInvoice>(si => si.SurgeryInvoice_Providers.Where(sip => sip.Active));
                options.LoadWith<SurgeryInvoice>(si => si.SurgeryInvoice_Providers);
                options.AssociateWith<SurgeryInvoice_Provider>(sip => sip.SurgeryInvoice_Provider_CPTCodes.Where(sipc => sipc.Active));
                options.LoadWith<SurgeryInvoice_Provider>(sip => sip.SurgeryInvoice_Provider_CPTCodes);
                options.LoadWith<SurgeryInvoice_Provider>(sip => sip.InvoiceProvider);
                options.AssociateWith<SurgeryInvoice_Provider>(sip => sip.SurgeryInvoice_Provider_Services.Where(sips => sips.Active));
                options.LoadWith<SurgeryInvoice_Provider>(sip => sip.SurgeryInvoice_Provider_Services);
                options.AssociateWith<SurgeryInvoice_Provider>(sip => sip.SurgeryInvoice_Provider_Payments.Where(sipp => sipp.Active));
                options.LoadWith<SurgeryInvoice_Provider>(sip => sip.SurgeryInvoice_Provider_Payments);
                options.LoadWith<SurgeryInvoice_Provider_Payment>(sipp => sipp.PaymentType);
                options.LoadWith<SurgeryInvoice_Provider_CPTCode>(sipc => sipc.CPTCode);
                //options.LoadWith<SurgeryInvoice_Provider_CPTCode>(sipc => sipc.InvoiceProvider);
            }

            using (DataModelDataContext db = new DataModelDataContext() { LoadOptions = options })
            {
                return (from i in db.Invoices
                        where i.InvoiceNumber == InvoiceNumber
                        && i.CompanyID == CompanyID
                        select i).FirstOrDefault();
            }
        }
        #endregion

        #region SetInvoiceActive
        public static void SetInvoiceActive(Int32 InvoiceID, bool active)
        {
            DataLoadOptions options = new DataLoadOptions();
            //options.LoadWith<InvoiceAttorney>(a => a.InvoiceFirm);
            //options.LoadWith<InvoiceFirm>(f => f.InvoiceContactList);
            //options.LoadWith<InvoiceContactList>(c => c.InvoiceContacts);
            //options.LoadWith
            using (DataModelDataContext db = new DataModelDataContext() { LoadOptions = options })
            {
                Invoice invoice = (from i in db.Invoices
                                   where i.ID == InvoiceID
                                   select i).FirstOrDefault();

                if (invoice != null)
                {
                    invoice.Active = active;
                    // invoice comments
                    foreach (Comment comment in invoice.Comments)
                    {
                        comment.Active = false;
                    }
                    // invoice patient
                    invoice.InvoicePatient.Active = active;
                    // invoice physician
                    if (invoice.InvoicePhysician != null)
                    {
                        invoice.InvoicePhysician.Active = active;
                    }
                    // invoice attorney
                    invoice.InvoiceAttorney.Active = active;
                    invoice.InvoiceAttorney.InvoiceContactList.Active = active;
                    foreach (InvoiceContact ic in invoice.InvoiceAttorney.InvoiceContactList.InvoiceContacts)
                    {
                        ic.Active = active;
                    }
                    // invoice firm
                    if (invoice.InvoiceAttorney.InvoiceFirm != null)
                    {
                        invoice.InvoiceAttorney.InvoiceFirm.Active = active;
                        invoice.InvoiceAttorney.InvoiceFirm.InvoiceContactList.Active = active;
                        foreach (InvoiceContact ic in invoice.InvoiceAttorney.InvoiceFirm.InvoiceContactList.InvoiceContacts)
                        {
                            ic.Active = active;
                        }
                    }
                    foreach (Payment p in invoice.Payments)
                    {
                        p.Active = active;
                    }
                    // sis invoices
                    if (invoice.SurgeryInvoice != null)
                    {
                        invoice.SurgeryInvoice.Active = active;
                        foreach (SurgeryInvoice_Surgery sis in invoice.SurgeryInvoice.SurgeryInvoice_Surgeries)
                        {
                            sis.Active = active;
                            foreach (SurgeryInvoice_SurgeryDate sisd in sis.SurgeryInvoice_SurgeryDates)
                            {
                                sisd.Active = active;
                            }
                            foreach (SurgeryInvoice_Surgery_ICDCode sisicd in sis.SurgeryInvoice_Surgery_ICDCodes)
                            {
                                sisicd.Active = active;
                            }
                        }
                        foreach (SurgeryInvoice_Provider sip in invoice.SurgeryInvoice.SurgeryInvoice_Providers)
                        {
                            sip.Active = active;
                            sip.InvoiceProvider.Active = active;
                            sip.InvoiceProvider.InvoiceContactList.Active = active;
                            foreach (InvoiceContact ic in sip.InvoiceProvider.InvoiceContactList.InvoiceContacts)
                            {
                                ic.Active = active;
                            }
                            foreach (SurgeryInvoice_Provider_Service sips in sip.SurgeryInvoice_Provider_Services)
                            {
                                sips.Active = active;
                            }
                            foreach (SurgeryInvoice_Provider_Payment sipp in sip.SurgeryInvoice_Provider_Payments)
                            {
                                sipp.Active = active;
                            }
                            foreach (SurgeryInvoice_Provider_CPTCode sipc in sip.SurgeryInvoice_Provider_CPTCodes)
                            {
                                sipc.Active = active;
                            }
                            
                        }
                    }
                    // tit_c invoices
                    if (invoice.TestInvoice != null)
                    {
                        invoice.TestInvoice.Active = active;
                        foreach (TestInvoice_Test tit in invoice.TestInvoice.TestInvoice_Tests)
                        {
                            tit.Active = active;
                            tit.InvoiceProvider.Active = active;
                            tit.InvoiceProvider.InvoiceContactList.Active = active;
                            foreach (InvoiceContact ic in tit.InvoiceProvider.InvoiceContactList.InvoiceContacts)
                            {
                                ic.Active = active;
                            }
                            foreach (TestInvoice_Test_CPTCode titc in tit.TestInvoice_Test_CPTCodes)
                            {
                                titc.Active = active;
                            }
                        }
                    }

                    db.SubmitChanges();
                }
            }
        }
        #endregion


        #region GetInvoiceAmount
        public static decimal? GetInvoiceAmount(Int32 InvoiceID)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                Invoice invoice = (from i in db.Invoices where i.ID == InvoiceID select i).First();
                if (invoice.InvoiceTypeID == (int)InvoiceTypeEnum.Testing)
                {
                    return (from t in invoice.TestInvoice.TestInvoice_Tests
                            where t.Active
                            select t.TestCost).Sum();
                }
                else
                {
                    return (from p in invoice.SurgeryInvoice.SurgeryInvoice_Providers
                            where p.Active
                            from s in p.SurgeryInvoice_Provider_Services
                            where s.Active
                            select s.Cost).Sum();
                }
            }
        }
        #endregion

        #region GetCostOfGoodsSold
        public static decimal? GetCostOfGoodsSold(Int32 InvoiceID)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                Invoice invoice = (from i in db.Invoices where i.ID == InvoiceID select i).First();
                if (invoice.InvoiceTypeID == (int)InvoiceTypeEnum.Testing)
                {
                    return (from t in invoice.TestInvoice.TestInvoice_Tests
                            where t.Active
                            select t.AmountToProvider).Sum();
                }
                else
                {
                    return (from p in invoice.SurgeryInvoice.SurgeryInvoice_Providers
                            where p.Active
                            from s in p.SurgeryInvoice_Provider_Services
                            where s.Active
                            select s.AmountDue).Sum();
                }
            }
        }
        #endregion

        #region GetPPODiscount
        public static decimal? GetPPODiscount(int InvoiceID)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                Invoice invoice = (from i in db.Invoices where i.ID == InvoiceID select i).First();
                if (invoice.InvoiceTypeID == (int)InvoiceTypeEnum.Testing)
                {
                    return (from t in invoice.TestInvoice.TestInvoice_Tests
                            where t.Active
                            select t.PPODiscount).Sum();
                }
                else
                {
                    return (from t in invoice.SurgeryInvoice.SurgeryInvoice_Providers
                            where t.Active
                            from s in t.SurgeryInvoice_Provider_Services
                            where s.Active
                            select s.PPODiscount).Sum();
                }
            }
        }
        #endregion

        #region GetCumulativeServiceFee
        public static decimal? GetCumulativeServiceFee(int InvoiceID)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                Invoice invoice = (from i in db.Invoices where i.ID == InvoiceID select i).First();

                decimal ServiceFeeReceived = (from p in invoice.Payments
                                              where p.Active && p.PaymentTypeID == (int)PaymentTypeEnum.Interest
                                              select p.Amount).Sum();

                return invoice.CalculatedCumulativeIntrest - ServiceFeeReceived - (invoice.ServiceFeeWaived ?? 0);
            }
        }
        #endregion

        #region GetInvoiceCancelled
        public static Boolean GetInvoiceCancelled(Int32 InvoiceID)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                Invoice invoice = (from i in db.Invoices where i.ID == InvoiceID select i).First();

                if (invoice.InvoiceTypeID == (int)InvoiceTypeEnum.Testing)
                {
                    var x = (from t in invoice.TestInvoice.TestInvoice_Tests
                             where t.isCanceled == true && t.Active == true
                             select t).ToList();

                    if (x.Any())
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
                else
                {
                    var y = (from t in invoice.SurgeryInvoice.SurgeryInvoice_Surgeries
                             where t.isCanceled == true && t.Active == true
                             select t).ToList();
                    if (y.Any())
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }
        }
        #endregion

        #region GetFirstServiceDate
        public static string GetFirstServiceDate(Int32 InvoiceID)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                Invoice invoice = (from i in db.Invoices where i.ID == InvoiceID select i).First();

                if (invoice.InvoiceTypeID == (int)InvoiceTypeEnum.Testing)
                {
                    var x = (from t in invoice.TestInvoice.TestInvoice_Tests
                             where t.Active == true
                             orderby t.TestDate
                             select t).FirstOrDefault();

                    if (x != null && x.TestDate != null)
                    {
                        return x.TestDate.ToShortDateString();
                    }
                    else
                    {
                        return "";
                    }
                }
                else
                {
                    var y = (from t in invoice.SurgeryInvoice.SurgeryInvoice_Surgeries
                             select t.ID).ToList();
                    if (y.Any())
                    {
                        var z = (from e in db.SurgeryInvoice_SurgeryDates
                                 where y.Contains(e.SurgeryInvoice_SurgeryID)
                                 && e.Active == true
                                 orderby e.ScheduledDate
                                 select e.ScheduledDate).FirstOrDefault();

                        if (z != null)
                            return z.ToShortDateString();
                        else
                            return "";
                    }
                    else
                    {
                        return "";
                    }
                }

            }
        }
        #endregion

        #region GetInvoiceBillAmount
        public static decimal? GetInvoiceBillAmount(Int32 InvoiceID)
        {
            decimal? amount = null;
            Invoice invoice;
            using (DataModelDataContext db = new DataModelDataContext())
            {
                invoice = (from i in db.Invoices where i.ID == InvoiceID select i).First();
            }
            if (invoice.InvoiceTypeID == (int)InvoiceClass.InvoiceTypeEnum.Testing)
            {
                amount = InvoiceClass.GetTestInvoiceSummary(invoice.ID).EndingBalance;
            }
            else if (invoice.InvoiceTypeID == (int)InvoiceClass.InvoiceTypeEnum.Surgery)
            {
                amount = InvoiceClass.GetSurgeryInvoiceSummary(invoice.ID).EndingBalance;
            }
            return amount;
        }
        #endregion


        #region CreateInvoice
        public static Int32 CreateInvoice(Int32 UserID, Int32 CompanyID, Int32 InvoiceTypeID, Int32 InvoiceStatusID,
                                            Boolean IsComplete, DateTime? DateOfAccident, Int32? TestTypeID,
                                            Int32 PatientID, Int32 AttorneyID, Int32? PhysicianID,
                                            List<TestInvoice_Test_Custom> InvoiceTests,
                                            List<SurgeryInvoice_Provider_Custom> InvoiceProviders, List<SurgeryInvoice_Surgery_Custom> InvoiceSurgeries,
                                            List<Payment> Payments, List<Comment> PaymentComments, List<Comment> GeneralComments,
                                            DateTime? InvoiceClosedDate, DateTime? DatePaid, Decimal? ServiceFeeWaived, Decimal? LossesAmount,
                                            Decimal YearlyInterest, Int32 LoanTermMonths, Int32 ServiceFeeWaivedMonths, Int32 UseAttorneyTerms)
        {
            //LoanTerm MostRecentLoanTerms = LoanTermsClass.GetCurrentLoanTermsByCompanyID(CompanyID);

            Invoice invoice = new Invoice();

            //Create the InvoiceRecords for Attorney, Patient, Physician, Provider, etc...
            invoice.InvoiceAttorneyID = CreateInvoiceRecord_Attorney(AttorneyID).ID;
            invoice.InvoicePatientID = CreateInvoiceRecord_Patient(PatientID).ID;
            if (PhysicianID.HasValue)
            {
                invoice.InvoicePhysicianID = CreateInvoiceRecord_Physician(PhysicianID.Value).ID;
            }

            //InvoiceNumber is required, but is generated in the database so pass in -1
            invoice.InvoiceNumber = -1;

            if (UseAttorneyTerms == 1)
            {
                invoice.UseAttorneyTerms = true;
            }
            else
            {
                invoice.UseAttorneyTerms = false;
            }

            //Populate the rest of the invoice record.
            invoice.CompanyID = CompanyID;
            invoice.DateOfAccident = DateOfAccident;
            invoice.InvoiceStatusTypeID = InvoiceStatusID;
            invoice.isComplete = IsComplete;
            invoice.InvoiceTypeID = InvoiceTypeID;
            invoice.InvoiceClosedDate = InvoiceClosedDate;
            invoice.DatePaid = DatePaid;
            invoice.ServiceFeeWaived = ServiceFeeWaived;
            invoice.LossesAmount = LossesAmount;

            invoice.YearlyInterest = YearlyInterest;
            invoice.ServiceFeeWaivedMonths = ServiceFeeWaivedMonths;
            invoice.LoanTermMonths = LoanTermMonths;
            if (InvoiceTypeID == (int)InvoiceTypeEnum.Surgery)
            {
                invoice.SurgeryInvoiceID = CreateSurgeryInvoice(InvoiceSurgeries, InvoiceProviders);
                //invoice.YearlyInterest = YearlyInterest.HasValue ? YearlyInterest.Value : MostRecentLoanTerms.Surgery_YearlyInterest;
                //invoice.LoanTermMonths = LoanTermMonths.HasValue ? LoanTermMonths.Value : MostRecentLoanTerms.Surgery_LoanTermMonths;
                //invoice.ServiceFeeWaivedMonths = ServiceFeeWaivedMonths.HasValue ? ServiceFeeWaivedMonths.Value : MostRecentLoanTerms.Surgery_ServiceFeeWaivedMonths;
            }
            else
            {
                invoice.TestInvoiceID = CreateTestInvoice(TestTypeID.Value, InvoiceTests);
                //invoice.YearlyInterest = YearlyInterest.HasValue ? YearlyInterest.Value : MostRecentLoanTerms.Testing_YearlyInterest;
                //invoice.LoanTermMonths = LoanTermMonths.HasValue ? LoanTermMonths.Value : MostRecentLoanTerms.Testing_LoanTermMonths;
                //invoice.ServiceFeeWaivedMonths = ServiceFeeWaivedMonths.HasValue ? ServiceFeeWaivedMonths.Value : MostRecentLoanTerms.Testing_ServiceFeeWaivedMonths;
            }

            invoice.Active = true;
            invoice.DateAdded = DateTime.Now;

            //save the invoice
            using (DataModelDataContext db = new DataModelDataContext())
            {
                db.Invoices.InsertOnSubmit(invoice);
                db.SubmitChanges();

                if (ServiceFeeWaived.HasValue)
                {
                    InvoiceChangeLog log = new InvoiceChangeLog();
                    log.InvoiceID = invoice.ID;
                    log.InvoiceChangeLogTypeID = (int)InvoiceChangeLogType.ServiceFeeWaived;
                    log.Amount = ServiceFeeWaived.Value;
                    log.UserID = UserID;
                    log.DateAdded = DateTime.Now;
                    db.InvoiceChangeLogs.InsertOnSubmit(log);
                }
                if (LossesAmount.HasValue)
                {
                    InvoiceChangeLog log = new InvoiceChangeLog();
                    log.InvoiceID = invoice.ID;
                    log.InvoiceChangeLogTypeID = (int)InvoiceChangeLogType.LossesAmount;
                    log.Amount = LossesAmount.Value;
                    log.UserID = UserID;
                    log.DateAdded = DateTime.Now;
                    db.InvoiceChangeLogs.InsertOnSubmit(log);
                }

                // general comments
                if (GeneralComments != null)
                {
                    db.Comments.InsertAllOnSubmit(from c in GeneralComments
                                                  where c.Active
                                                  select new Comment()
                                                      {
                                                          Active = true,
                                                          CommentTypeID = (int)CommentTypeEnum.InvoiceComment,
                                                          DateAdded = c.DateAdded,
                                                          InvoiceID = invoice.ID,
                                                          Text = c.Text,
                                                          UserID = c.UserID,
                                                          isIncludedOnReports = c.isIncludedOnReports
                                                      });
                }
                // sipp comments
                if (PaymentComments != null)
                {
                    db.Comments.InsertAllOnSubmit(from c in PaymentComments
                                                  where c.Active
                                                  select new Comment()
                                                      {
                                                          Active = true,
                                                          CommentTypeID = (int)CommentTypeEnum.PaymentComment,
                                                          DateAdded = c.DateAdded,
                                                          InvoiceID = invoice.ID,
                                                          Text = c.Text,
                                                          UserID = c.UserID,
                                                          isIncludedOnReports = c.isIncludedOnReports
                                                      });
                }
                // payments
                if (Payments != null)
                {
                    db.Payments.InsertAllOnSubmit(from p in Payments
                                                  where p.Active
                                                  select new Payment()
                                                      {
                                                          Active = true,
                                                          Amount = p.Amount,
                                                          CheckNumber = p.CheckNumber,
                                                          DateAdded = p.DateAdded,
                                                          DatePaid = p.DatePaid,
                                                          InvoiceID = invoice.ID,
                                                          PaymentTypeID = p.PaymentTypeID
                                                      });
                }

                db.SubmitChanges();
            }

            return invoice.ID;
        }
        #endregion

        #region UpdateInvoice
        public static void UpdateInvoice(Int32 UserID, Int32 InvoiceID, Int32 InvoiceStatusID,
                                            Boolean IsComplete, DateTime? DateOfAccident, Int32? TestTypeID,
                                            Int32 PatientID, Int32 AttorneyID, Int32? PhysicianID,
                                            List<TestInvoice_Test_Custom> InvoiceTests, List<SurgeryInvoice_Provider_Custom> InvoiceProviders, List<SurgeryInvoice_Surgery_Custom> InvoiceSurgeries,
                                            List<Payment> Payments, List<Comment> PaymentComments, List<Comment> GeneralComments,
                                            DateTime? InvoiceClosedDate, DateTime? DatePaid, Decimal? ServiceFeeWaived, Decimal? LossesAmount,
                                            Decimal YearlyInterest, Int32 LoanTermMonths, Int32 ServiceFeeWaivedMonths, Int32 UseAttorneyTerms)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                // update invoice
                Invoice invoice = (from i in db.Invoices where i.ID == InvoiceID select i).FirstOrDefault();
                invoice.DateOfAccident = DateOfAccident;
                invoice.DatePaid = DatePaid;
                invoice.InvoiceClosedDate = InvoiceClosedDate;
                invoice.InvoiceStatusTypeID = InvoiceStatusID;
                if (UseAttorneyTerms == 1)
                {
                    invoice.UseAttorneyTerms = true;
                }
                else
                {
                    invoice.UseAttorneyTerms = false;
                }
                invoice.isComplete = IsComplete;
                if (invoice.LossesAmount != LossesAmount)
                {
                    InvoiceChangeLog log = new InvoiceChangeLog();
                    log.InvoiceID = invoice.ID;
                    log.InvoiceChangeLogTypeID = (int)InvoiceChangeLogType.LossesAmount;
                    log.Amount = (LossesAmount.HasValue ? LossesAmount.Value : (decimal)0) - (invoice.LossesAmount.HasValue ? invoice.LossesAmount.Value : (decimal)0);
                    log.UserID = UserID;
                    log.Active = true;
                    log.DateAdded = DateTime.Now;
                    invoice.LossesAmount = LossesAmount;
                    db.InvoiceChangeLogs.InsertOnSubmit(log);
                }
                if (invoice.ServiceFeeWaived != ServiceFeeWaived)
                {
                    InvoiceChangeLog log = new InvoiceChangeLog();
                    log.InvoiceID = invoice.ID;
                    log.InvoiceChangeLogTypeID = (int)InvoiceChangeLogType.ServiceFeeWaived;
                    log.Amount = (ServiceFeeWaived.HasValue ? ServiceFeeWaived.Value : (decimal)0) - (invoice.ServiceFeeWaived.HasValue ? invoice.ServiceFeeWaived.Value : (decimal)0);
                    log.UserID = UserID;
                    log.Active = true;
                    log.DateAdded = DateTime.Now;
                    invoice.ServiceFeeWaived = ServiceFeeWaived;
                    db.InvoiceChangeLogs.InsertOnSubmit(log);
                }

                invoice.YearlyInterest = YearlyInterest;
                invoice.LoanTermMonths = LoanTermMonths;
                invoice.ServiceFeeWaivedMonths = ServiceFeeWaivedMonths;
                //if (YearlyInterest.HasValue) invoice.YearlyInterest = YearlyInterest.Value;
                //if (LoanTermMonths.HasValue) invoice.LoanTermMonths = LoanTermMonths.Value;
                //if (ServiceFeeWaivedMonths.HasValue) invoice.ServiceFeeWaivedMonths = ServiceFeeWaivedMonths.Value;

                // update patient
                if (invoice.InvoicePatient.PatientID != PatientID)
                {
                    invoice.InvoicePatient.Active = false;
                    invoice.InvoicePatient = CreateInvoiceRecord_Patient(db, PatientID);
                }

                // update attorney
                if (invoice.InvoiceAttorney.AttorneyID != AttorneyID)
                {
                    invoice.InvoiceAttorney.Active = false;
                    invoice.InvoiceAttorney = CreateInvoiceRecord_Attorney(db, AttorneyID);
                }

                // update physician
                if (invoice.InvoicePhysicianID.HasValue != PhysicianID.HasValue)
                {
                    if (invoice.InvoicePhysicianID.HasValue)
                    {
                        invoice.InvoicePhysician.Active = false;
                        invoice.InvoicePhysician = null;
                    }
                    else
                    {
                        invoice.InvoicePhysician = CreateInvoiceRecord_Physician(db, PhysicianID.Value);
                    }
                }
                else if (PhysicianID.HasValue && invoice.InvoicePhysician.PhysicianID != PhysicianID.Value)
                {
                    invoice.InvoicePhysician.Active = false;
                    invoice.InvoicePhysician = CreateInvoiceRecord_Physician(db, PhysicianID.Value);
                }

                // update payments
                foreach (Payment payment in Payments)
                {
                    if (payment.ID > 0)
                    {
                        // update
                        Payment existingPayment = (from p in db.Payments where p.ID == payment.ID select p).First();
                        existingPayment.Active = payment.Active;
                        existingPayment.Amount = payment.Amount;
                        existingPayment.CheckNumber = payment.CheckNumber;
                        existingPayment.DatePaid = payment.DatePaid;
                        existingPayment.PaymentTypeID = payment.PaymentTypeID;
                    }
                    else
                    {
                        // insert
                        db.Payments.InsertOnSubmit(new Payment()
                        {
                            Active = true,
                            DateAdded = DateTime.Now,
                            InvoiceID = invoice.ID,
                            Amount = payment.Amount,
                            CheckNumber = payment.CheckNumber,
                            DatePaid = payment.DatePaid,
                            PaymentTypeID = payment.PaymentTypeID
                        });
                    }
                }

                // update payment comments
                foreach (Comment comment in PaymentComments)
                {
                    if (comment.ID > 0)
                    {
                        // update
                        Comment existingComment = (from c in db.Comments where c.ID == comment.ID select c).First();
                        existingComment.Active = comment.Active;
                        existingComment.isIncludedOnReports = comment.isIncludedOnReports;
                        existingComment.Text = comment.Text;
                        existingComment.User = (from u in db.Users where u.ID == comment.User.ID select u).First();
                        existingComment.DateAdded = comment.DateAdded;
                    }
                    else
                    {
                        // insert
                        db.Comments.InsertOnSubmit(new Comment()
                        {
                            Active = true,
                            DateAdded = DateTime.Now,
                            InvoiceID = invoice.ID,
                            CommentTypeID = (int)CommentTypeEnum.PaymentComment,
                            isIncludedOnReports = comment.isIncludedOnReports,
                            Text = comment.Text,
                            UserID = comment.UserID
                        });
                    }
                }

                // update general comments
                foreach (Comment comment in GeneralComments)
                {
                    if (comment.ID > 0)
                    {
                        // update
                        Comment existingComment = (from c in db.Comments where c.ID == comment.ID select c).First();
                        existingComment.Active = comment.Active;
                        existingComment.isIncludedOnReports = comment.isIncludedOnReports;
                        existingComment.Text = comment.Text;
                        existingComment.User = (from u in db.Users where u.ID == comment.User.ID select u).First();
                        existingComment.DateAdded = comment.DateAdded;
                    }
                    else
                    {
                        // insert
                        db.Comments.InsertOnSubmit(new Comment()
                        {
                            Active = true,
                            DateAdded = DateTime.Now,
                            InvoiceID = invoice.ID,
                            CommentTypeID = (int)CommentTypeEnum.InvoiceComment,
                            isIncludedOnReports = comment.isIncludedOnReports,
                            Text = comment.Text,
                            UserID = comment.UserID
                        });
                    }
                }

                db.SubmitChanges();

                if (invoice.InvoiceTypeID == (int)InvoiceTypeEnum.Testing)
                {
                    UpdateTestInvoice(db, invoice.ID, TestTypeID.Value, InvoiceTests);
                }
                else
                {
                    UpdateSurgeryInvoice(db, invoice.ID, InvoiceSurgeries, InvoiceProviders);
                }

                // submit changes
                db.SubmitChanges();
            }
        }
        #endregion


        #region SetActiveTestInvoiceTest
        public static void SetActiveTestInvoiceTest(Int32 TestInvoiceTestID, bool active)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                TestInvoice_Test test = (from tit in db.TestInvoice_Tests
                                         where tit.ID == TestInvoiceTestID
                                         select tit).FirstOrDefault();

                if (test != null)
                {
                    test.Active = active;
                    test.InvoiceProvider.Active = active;
                    test.InvoiceProvider.InvoiceContactList.Active = active;
                    foreach (InvoiceContact ic in test.InvoiceProvider.InvoiceContactList.InvoiceContacts)
                    {
                        ic.Active = active;
                    }
                    foreach (TestInvoice_Test_CPTCode titc in test.TestInvoice_Test_CPTCodes)
                    {
                        titc.Active = active;
                    }

                    db.SubmitChanges();
                }
            }
        }
        #endregion

        #region SetActiveSurgeryInvoiceSurgery
        public static void SetActiveSurgeryInvoiceSurgery(Int32 SurgeryInvoiceSurgeryID, bool active)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                SurgeryInvoice_Surgery surgery = (from sis in db.SurgeryInvoice_Surgeries
                                                  where sis.ID == SurgeryInvoiceSurgeryID
                                                  select sis).FirstOrDefault();

                if (surgery != null)
                {
                    surgery.Active = active;
                    foreach (SurgeryInvoice_SurgeryDate sisd in surgery.SurgeryInvoice_SurgeryDates)
                    {
                        sisd.Active = active;
                    }

                    db.SubmitChanges();
                }
            }
        }
        #endregion

        #region CanInactivateSurgeryInvoiceProvider
        public static bool CanInactivateSurgeryInvoiceProvider(Int32 SurgeryInvoiceProviderID)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                return (from sipp in db.SurgeryInvoice_Provider_Payments
                        where sipp.Active && sipp.SurgeryInvoice_ProviderID == SurgeryInvoiceProviderID
                        select sipp).FirstOrDefault() == null;
            }
        }
        #endregion

        #region SetActiveSurgeryInvoiceProvider
        public static void SetActiveSurgeryInvoiceProvider(Int32 SurgeryInvoiceProviderID, bool active)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                SurgeryInvoice_Provider provider = (from sip in db.SurgeryInvoice_Providers
                                                    where sip.ID == SurgeryInvoiceProviderID
                                                    select sip).FirstOrDefault();

                if (provider != null)
                {
                    provider.Active = active;
                    provider.InvoiceProvider.Active = active;
                    provider.InvoiceProvider.InvoiceContactList.Active = active;
                    foreach (InvoiceContact ic in provider.InvoiceProvider.InvoiceContactList.InvoiceContacts)
                    {
                        ic.Active = active;
                    }
                    foreach (SurgeryInvoice_Provider_Payment sipp in provider.SurgeryInvoice_Provider_Payments)
                    {
                        sipp.Active = active;
                    }
                    foreach (SurgeryInvoice_Provider_Service sips in provider.SurgeryInvoice_Provider_Services)
                    {
                        sips.Active = active;
                    }
                    foreach (SurgeryInvoice_Provider_CPTCode sipc in provider.SurgeryInvoice_Provider_CPTCodes)
                    {
                        sipc.Active = active;
                    }

                    db.SubmitChanges();
                }
            }
        }
        #endregion


        #region SearchInvoices_ByPatientID

        public static List<Invoice> SearchInvoices_ByPatientID(Int32 PatientID, bool LoadInvoiceAttorney)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                if (LoadInvoiceAttorney)
                {
                    DataLoadOptions options = new DataLoadOptions();
                    options.LoadWith<Invoice>(i => i.InvoiceAttorney);
                    db.LoadOptions = options;
                }

                return (from i in db.Invoices
                        where i.InvoicePatient.PatientID == PatientID
                             && i.Active
                             && i.InvoicePatient.Active
                        select i).ToList();
            }
        }


        #endregion

        #region SearchInvoices_ByPatientSSN

        public static List<Invoice> SearchInvoices_ByPatientSSN(string SSN)
        {
            List<Invoice> retlist = new List<Invoice>();

            using (DataModelDataContext db = new DataModelDataContext())
            {
                //Find the patient the user searched for.
                List<InvoicePatient> FoundP = (from p in db.InvoicePatients
                                               where p.Patient.SSN == SSN
                                               select p).ToList();

                foreach (InvoicePatient p in FoundP)
                {
                    retlist.AddRange(p.Invoices);
                }


            }
            return retlist;
        }


        #endregion


        #region SearchInvoices_ByInvoiceAttorney

        public static List<Invoice> SearchInvoices_ByInvoiceAttorney(Int32 AttorneyID, bool LoadInvoicePatient)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                if (LoadInvoicePatient)
                {
                    DataLoadOptions options = new DataLoadOptions();
                    options.LoadWith<Invoice>(i => i.InvoicePatient);
                    db.LoadOptions = options;
                }

                return (from i in db.Invoices
                        where i.InvoiceAttorney.AttorneyID == AttorneyID
                             && i.Active
                        select i).OrderBy(x => x.InvoicePatient.Patient.LastName).ThenBy(x => x.InvoicePatient.Patient.FirstName).ToList();
            }
        }

        #endregion

        #region SearchInvoices_ByInvoiceID

        public static List<Invoice> SearchInvoices_ByInvoiceID(Int32 InvoiceID)
        {
            List<Invoice> retlist = new List<Invoice>();

            using (DataModelDataContext db = new DataModelDataContext())
            {
                retlist = (from i in db.Invoices
                           where i.ID == InvoiceID
                           select i).ToList();
            }

            return retlist;
        }

        #endregion

        #region SearchInvoices_ByInvoiceNumber

        public static List<Invoice> SearchInvoices_ByInvoiceNumber(Int32 InvoiceNumber, Int32 CompanyID)
        {
            List<Invoice> retlist = new List<Invoice>();

            using (DataModelDataContext db = new DataModelDataContext())
            {
                retlist = (from i in db.Invoices
                           where i.InvoiceNumber == InvoiceNumber
                           && i.CompanyID == CompanyID
                           select i).ToList();
            }

            return retlist;
        }

        #endregion

        #region GetLastInvoiceID
        /// <summary>
        /// Returns the last Surgery or Testing Invoice Number for the Homepage's General Statistics
        /// </summary>
        /// <param name="CompanyID"></param>
        /// <param name="InvoiceType"></param>
        /// <returns></returns>
        public static int GetLastInvoiceNumber(Int32 CompanyID, Int32 InvoiceType)
        {
            List<int> InvNumList = new List<int>();
            using (DataModelDataContext db = new DataModelDataContext())
            {
                InvNumList = (from i in db.Invoices
                        where i.CompanyID == CompanyID && i.InvoiceTypeID == InvoiceType && i.Active
                        select i.InvoiceNumber).ToList();
            }
            return InvNumList.Count > 0 ? InvNumList.Max() : 0;
        }
        #endregion

        #region GetInvoicePatientByID
        public static InvoicePatient GetInvoicePatientByID(Int32 InvoicePatientID, Boolean LoadPatient, Boolean LoadState)
        {
            DataLoadOptions options = new DataLoadOptions();

            if (LoadPatient)
            {
                options.LoadWith<InvoicePatient>(ip => ip.Patient);
                if (LoadState)
                {
                    options.LoadWith<Patient>(p => p.State);
                }
            }
            if (LoadState)
            {
                options.LoadWith<InvoicePatient>(ip => ip.State);
            }

            using (DataModelDataContext db = new DataModelDataContext() { LoadOptions = options })
            {
                return (from ip in db.InvoicePatients
                        where ip.ID == InvoicePatientID
                        select ip).FirstOrDefault();
            }
        }
        #endregion

        #region UpdateInvoicePatient
        public static void UpdateInvoicePatient(InvoicePatient InvoicePatientToUpdate)
        {
            using (BMM_DAL.DataModelDataContext db = new DataModelDataContext())
            {
                InvoicePatient found = (from ip in db.InvoicePatients
                                        where ip.ID == InvoicePatientToUpdate.ID
                                        select ip).FirstOrDefault();

                found.isActiveStatus = InvoicePatientToUpdate.isActiveStatus;
                found.FirstName = InvoicePatientToUpdate.FirstName;
                found.LastName = InvoicePatientToUpdate.LastName;
                found.SSN = InvoicePatientToUpdate.SSN;
                found.Street1 = InvoicePatientToUpdate.Street1;
                found.Street2 = InvoicePatientToUpdate.Street2;
                found.City = InvoicePatientToUpdate.City;
                found.StateID = InvoicePatientToUpdate.StateID;
                found.ZipCode = InvoicePatientToUpdate.ZipCode;
                found.Phone = InvoicePatientToUpdate.Phone;
                found.WorkPhone = InvoicePatientToUpdate.WorkPhone;
                found.DateOfBirth = InvoicePatientToUpdate.DateOfBirth;

                db.SubmitChanges();
            }
        }
        #endregion

        #region GetInvoiceAttorneyByID

        public static InvoiceAttorney GetInvoiceAttorneyByID(Int32 ID, Boolean LoadContactList = false, Boolean LoadInvoiceFirm = false)
        {
            DataLoadOptions options = new DataLoadOptions();
            if (LoadContactList)
            {
                options.LoadWith<InvoiceAttorney>(i => i.InvoiceContactList);
                options.LoadWith<InvoiceContactList>(icl => icl.InvoiceContacts);
            }
            if (LoadInvoiceFirm)
            {
                options.LoadWith<InvoiceAttorney>(ia => ia.InvoiceFirm);
            }

            using (DataModelDataContext db = new DataModelDataContext() { LoadOptions = options })
            {
                return (from ia in db.InvoiceAttorneys
                        where ia.ID == ID
                        select ia).FirstOrDefault();
            }
        }

        #endregion

        #region GetInvoicePhysicianByID

        public static InvoicePhysician GetInvoicePhysicianByID(Int32 ID, Boolean LoadContactList = false)
        {
            DataLoadOptions options = new DataLoadOptions();
            if (LoadContactList)
            {
                options.LoadWith<InvoicePhysician>(i => i.InvoiceContactList);
                options.LoadWith<InvoiceContactList>(icl => icl.InvoiceContacts);
            }

            using (DataModelDataContext db = new DataModelDataContext() { LoadOptions = options })
            {
                return (from ip in db.InvoicePhysicians
                        where ip.ID == ID
                        select ip).FirstOrDefault();
            }
        }

        #endregion


        #region GetTestInvoiceSummary

        public static procGetTestInvoiceSummaryResult GetTestInvoiceSummary(Int32 InvoiceID)
        {
            procGetTestInvoiceSummaryResult retval = new procGetTestInvoiceSummaryResult();

            using (DataModelDataContext db = new DataModelDataContext())
            {
                retval = db.procGetTestInvoiceSummary(InvoiceID).FirstOrDefault();
            }

            return retval;
        }

        #endregion

        #region GetSurgeryInvoiceSummary

        public static procGetSurgeryInvoiceSummaryResult GetSurgeryInvoiceSummary(Int32 InvoiceID)
        {
            procGetSurgeryInvoiceSummaryResult retval = new procGetSurgeryInvoiceSummaryResult();

            using (DataModelDataContext db = new DataModelDataContext())
            {
                retval = db.procGetSurgeryInvoiceSummary(InvoiceID).FirstOrDefault();
            }
            return retval;
        }

        #endregion


        #region GetGeneralStatistics

        public static procGetGeneralStatisticsResult GetGeneralStatistics(DateTime StartDate, DateTime EndDate, int CompanyId)
        {
            procGetGeneralStatisticsResult retval = new procGetGeneralStatisticsResult();

            using (DataModelDataContext db = new DataModelDataContext())
            {
                retval = db.procGetGeneralStatistics(StartDate, EndDate, CompanyId).FirstOrDefault();
            }

            return retval;
        }

        #endregion

        #region GetPaymentTypes
        public static List<PaymentType> GetPaymentTypes()
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                return (from pt in db.PaymentTypes select pt).ToList();
            }
        }
        #endregion


        #region + Helpers

        #region UpdateTestInvoice
        private static void UpdateTestInvoice(DataModelDataContext db, Int32 InvoiceID, Int32 TestTypeID, List<TestInvoice_Test_Custom> InvoiceTests)
        {
            // update invoice
            Invoice invoice = (from i in db.Invoices where i.ID == InvoiceID select i).First();

            // test type
            invoice.TestInvoice.TestTypeID = TestTypeID;

            // invoice tests
            foreach (TestInvoice_Test_Custom tit_c in InvoiceTests)
            {
                if (tit_c.ID > 0)
                {
                    // update existing
                    TestInvoice_Test tit = (from t in db.TestInvoice_Tests where t.ID == tit_c.ID select t).First();
                    //tit.TestInvoiceID = invoice.TestInvoiceID.Value;
                    //tit.DateAdded = DateTime.Now;
                    tit.Active = tit_c.Active;
                    tit.AmountPaidToProvider = tit_c.AmountPaidToProvider;
                    tit.AmountToProvider = tit_c.AmountToProvider;
                    tit.CalculateAmountToProvider = tit_c.CalculateAmountToProvider;
                    tit.CheckNumber = tit_c.CheckNumber;
                    tit.Date = tit_c.Date;
                    tit.DepositToProvider = tit_c.DepositToProvider;
                    tit.isCanceled = tit_c.isCancelled;
                    tit.IsPositive = tit_c.isPositive;
                    tit.MRI = tit_c.MRI;
                    tit.AccountNumber = tit_c.AccountNumber;
                    //tit.Notes = tit_c.Notes;
                    // Case 942613.  Added a check for null values.
                    tit.AccountNumber = tit_c.AccountNumber == null ? "" : tit_c.AccountNumber;
                    tit.Notes = tit_c.Notes == null ? "" : tit_c.Notes;
                    tit.NumberOfTests = tit_c.NumberOfTests;
                    tit.PPODiscount = tit_c.PPODiscount;
                    tit.ProviderDueDate = tit_c.ProviderDueDate;
                    tit.TestCost = tit_c.TestCost;
                    tit.TestDate = tit_c.TestDate;
                    tit.TestTime = tit_c.TestTime;
                    tit.TestID = tit_c.TestID;

                    // new invoice provider?
                    if (tit.InvoiceProvider.ProviderID != tit_c.ProviderID)
                    {
                        // deactivate old invoice sip
                        tit.InvoiceProvider.Active = false;
                        tit.InvoiceProvider.InvoiceContactList.Active = false;
                        foreach (InvoiceContact ic in tit.InvoiceProvider.InvoiceContactList.InvoiceContacts)
                        {
                            ic.Active = false;
                        }
                        // create new invoice sip
                        tit.InvoiceProvider = CreateInvoiceRecord_Provider(db, tit_c.ProviderID);
                    }

                    // update cpt codes
                    foreach (var titc_c in tit_c.CPTCodeList)
                    {
                        if (titc_c.ID > 0)
                        {
                            // update existing
                            TestInvoice_Test_CPTCode titc = (from c in db.TestInvoice_Test_CPTCodes where c.ID == titc_c.ID select c).First();
                            titc.Active = titc_c.Active;
                            titc.Amount = titc_c.Amount;
                            titc.CPTCodeID = titc_c.CPTCodeID;
                            titc.Description = titc_c.Description;
                        }
                        else
                        {
                            // insert new
                            TestInvoice_Test_CPTCode titc = new TestInvoice_Test_CPTCode()
                            {
                                Active = titc_c.Active,
                                Amount = titc_c.Amount,
                                CPTCodeID = titc_c.CPTCodeID,
                                DateAdded = DateTime.Now,
                                Description = titc_c.Description,
                                TestInvoice_TestID = tit.ID
                            };
                            db.TestInvoice_Test_CPTCodes.InsertOnSubmit(titc);
                        }
                    }
                }
                else
                {
                    // insert new
                    TestInvoice_Test tit = new TestInvoice_Test()
                    {
                        DateAdded = DateTime.Now,
                        Active = true,
                        InvoiceProvider = CreateInvoiceRecord_Provider(db, tit_c.ProviderID),
                        isCanceled = tit_c.isCancelled,
                        IsPositive = tit_c.isPositive,
                        MRI = tit_c.MRI,
                        Notes = tit_c.Notes,
                        NumberOfTests = tit_c.NumberOfTests,
                        PPODiscount = tit_c.PPODiscount,
                        TestCost = tit_c.TestCost,
                        TestDate = tit_c.TestDate,
                        TestTime = tit_c.TestTime,
                        TestID = tit_c.TestID,
                        TestInvoiceID = invoice.TestInvoiceID.Value,
                        AmountToProvider = tit_c.AmountToProvider,
                        CalculateAmountToProvider =  tit_c.CalculateAmountToProvider,
                        ProviderDueDate = tit_c.ProviderDueDate,
                        DepositToProvider = tit_c.DepositToProvider,
                        AmountPaidToProvider = tit_c.AmountPaidToProvider,
                        AccountNumber =  tit_c.AccountNumber,
                        Date = tit_c.Date,
                        CheckNumber = tit_c.CheckNumber
                    };
                    db.TestInvoice_Tests.InsertOnSubmit(tit);
                    db.SubmitChanges();

                    // link the CPT Codes for each tit_c
                    foreach (TestInvoice_Test_CPTCodes_Custom titc_c in tit_c.CPTCodeList)
                    {
                        TestInvoice_Test_CPTCode titc = new TestInvoice_Test_CPTCode()
                        {
                            Active = true,
                            Amount = titc_c.Amount,
                            CPTCodeID = titc_c.CPTCodeID,
                            DateAdded = DateTime.Now,
                            Description = titc_c.Description,
                            TestInvoice_TestID = tit.ID
                        };
                        db.TestInvoice_Test_CPTCodes.InsertOnSubmit(titc);
                    }
                }
            }

            // submit changes
            db.SubmitChanges();
        }
        #endregion

        #region UpdateSurgeryInvoice
        private static void UpdateSurgeryInvoice(DataModelDataContext db, Int32 InvoiceID, List<SurgeryInvoice_Surgery_Custom> InvoiceSurgeries, List<SurgeryInvoice_Provider_Custom> InvoiceProviders)
        {
            Invoice invoice = (from i in db.Invoices where i.ID == InvoiceID select i).First();

            foreach (SurgeryInvoice_Surgery_Custom sis_c in InvoiceSurgeries)
            {
                if (sis_c.ID > 0)
                {
                    #region Update Surgery
                    // update existing
                    SurgeryInvoice_Surgery sis = (from s in db.SurgeryInvoice_Surgeries where s.ID == sis_c.ID select s).First();
                    sis.Active = sis_c.Active;
                    //sis.DateAdded = DateTime.Now;
                    sis.isInpatient = sis_c.isInpatient;
                    sis.Notes = sis_c.Notes;
                    sis.SurgeryID = sis_c.SurgeryID;
                    sis.isCanceled = sis_c.isCanceled;
                    //sis.SurgeryInvoiceID = invoice.SurgeryInvoiceID;

                    // deactivate all existing dates
                    List<SurgeryInvoice_SurgeryDate> dates = (from s in db.SurgeryInvoice_SurgeryDates where s.SurgeryInvoice_SurgeryID == sis.ID select s).ToList();
                    foreach (SurgeryInvoice_SurgeryDate sisd in dates)
                    {
                        sisd.Active = false;
                    }

                    // add dates
                    for (int i = 0; i < sis_c.SurgeryDates.Count; i++)
                    {
                        if (dates.Count > i)
                        {
                            // hijack an inactive sisd
                            dates[i].Active = true;
                            dates[i].isPrimaryDate = i == 0;
                            dates[i].ScheduledDate = sis_c.SurgeryDates[i];
                        }
                        else
                        {
                            // create a new sisd
                            db.SurgeryInvoice_SurgeryDates.InsertOnSubmit(new SurgeryInvoice_SurgeryDate()
                            {
                                Active = true,
                                DateAdded = DateTime.Now,
                                isPrimaryDate = i == 0,
                                ScheduledDate = sis_c.SurgeryDates[i],
                                SurgeryInvoice_SurgeryID = sis.ID
                            });
                        }
                    }

                    // update icd codes
                    foreach (var sid in sis_c.icdCodesList)
                    {
                        if (sid.ID > 0)
                        {
                            // update existing
                            SurgeryInvoice_Surgery_ICDCode sidc = (from c in db.SurgeryInvoice_Surgery_ICDCodes where c.ID == sid.ID select c).First();
                            sidc.Active = sid.Active;
                            sidc.Amount = sid.Amount;
                            sidc.ICDCodeID = sid.ICDCodeID;
                            sidc.Description = sid.Description;
                        }
                        else
                        {
                            // insert new
                            SurgeryInvoice_Surgery_ICDCode sidc = new SurgeryInvoice_Surgery_ICDCode()
                            {
                                Active = sid.Active,
                                Amount = sid.Amount,
                                ICDCodeID = sid.ICDCodeID,
                                DateAdded = DateTime.Now,
                                Description = sid.Description,
                                SurgeryInvoice_SurgeryID = sis.ID
                            };
                            db.SurgeryInvoice_Surgery_ICDCodes.InsertOnSubmit(sidc);
                        }
                    }
                    #endregion
                }
                else
                {
                    CreateSurgeryInvoice_Surgery(invoice.SurgeryInvoiceID.Value, sis_c);
                }
            }

            foreach (SurgeryInvoice_Provider_Custom sip_c in InvoiceProviders)
            {
                if (sip_c.ID > 0)
                {
                    #region Update Provider
                    // update existing
                    SurgeryInvoice_Provider sip = (from s in db.SurgeryInvoice_Providers where s.ID == sip_c.ID select s).First();
                    sip.Active = sip_c.Active;
                    //sip.DateAdded = DateTime.Now;
                    //sip.SurgeryInvoiceID = invoice.SurgeryInvoiceID.Value;

                    // new invoice provider?
                    if (sip.InvoiceProvider.ProviderID != sip_c.ProviderID)
                    {
                        // deactivate old invoice sip
                        sip.InvoiceProvider.Active = false;
                        sip.InvoiceProvider.InvoiceContactList.Active = false;
                        foreach (InvoiceContact ic in sip.InvoiceProvider.InvoiceContactList.InvoiceContacts)
                        {
                            ic.Active = false;
                        }
                        sip.InvoiceProvider = CreateInvoiceRecord_Provider(db, sip_c.ProviderID);
                    }

                    // link cpt codes
                    foreach (SurgeryInvoice_Provider_CPTCode_Custom sipc_c in sip_c.CPTCodes)
                    {
                        if (sipc_c.ID > 0)
                        {
                            // update existing
                            SurgeryInvoice_Provider_CPTCode sipc = (from s in db.SurgeryInvoice_Provider_CPTCodes where s.ID == sipc_c.ID select s).First();
                            sipc.Active = sipc_c.Active;
                            sipc.Amount = sipc_c.Amount;
                            sipc.CPTCodeID = sipc_c.CPTCodeID;
                            sipc.Description = sipc_c.Description;
                        }
                        else
                        {
                            // insert new
                            SurgeryInvoice_Provider_CPTCode sipc = new SurgeryInvoice_Provider_CPTCode()
                            {
                                Active = sipc_c.Active,
                                Amount = sipc_c.Amount,
                                CPTCodeID = sipc_c.CPTCodeID,
                                DateAdded = DateTime.Now,
                                Description = sipc_c.Description,
                                SurgeryInvoice_ProviderID = sip.ID
                            };
                            db.SurgeryInvoice_Provider_CPTCodes.InsertOnSubmit(sipc);
                        }
                    }

                    // add sip services
                    foreach (SurgeryInvoice_Provider_Service_Custom sips_c in sip_c.ProviderServices)
                    {
                        if (sips_c.ID > 0)
                        {
                            // update existing
                            SurgeryInvoice_Provider_Service sips = (from s in db.SurgeryInvoice_Provider_Services where s.ID == sips_c.ID select s).First();
                            sips.Active = sips_c.Active;
                            sips.AccountNumber = sips_c.AccountNumber;
                            sips.AmountDue = sips_c.AmountDue;
                            sips.CalculateAmountDue = sips_c.CalculateAmountDue;
                            sips.Cost = sips_c.Cost;
                            sips.Discount = sips_c.Discount;
                            sips.DueDate = sips_c.DueDate;
                            sips.EstimatedCost = sips_c.EstimatedCost;
                            sips.PPODiscount = sips_c.PPODiscount;
                        }
                        else
                        {
                            // insert new
                            SurgeryInvoice_Provider_Service sips = new SurgeryInvoice_Provider_Service()
                            {
                                AccountNumber = sips_c.AccountNumber,
                                Active = true,
                                AmountDue = sips_c.AmountDue,
                                CalculateAmountDue = sips_c.CalculateAmountDue,
                                Cost = sips_c.Cost,
                                DateAdded = DateTime.Now,
                                Discount = sips_c.Discount,
                                DueDate = sips_c.DueDate,
                                EstimatedCost = sips_c.EstimatedCost,
                                PPODiscount = sips_c.PPODiscount,
                                SurgeryInvoice_ProviderID = sip.ID
                            };
                            db.SurgeryInvoice_Provider_Services.InsertOnSubmit(sips);
                        }
                    }

                    // add payments
                    foreach (SurgeryInvoice_Provider_Payment_Custom sipp_c in sip_c.Payments)
                    {
                        if (sipp_c.ID > 0)
                        {
                            // update existing
                            SurgeryInvoice_Provider_Payment sipp = (from s in db.SurgeryInvoice_Provider_Payments where s.ID == sipp_c.ID select s).First();
                            sipp.Active = sipp_c.Active;
                            sipp.Amount = sipp_c.Amount;
                            sipp.CheckNumber = sipp_c.CheckNumber;
                            sipp.DatePaid = sipp_c.DatePaid;
                            sipp.PaymentTypeID = sipp_c.PaymentTypeID;
                        }
                        else
                        {
                            // insert new
                            SurgeryInvoice_Provider_Payment sipp = new SurgeryInvoice_Provider_Payment()
                            {
                                Active = true,
                                Amount = sipp_c.Amount,
                                CheckNumber = sipp_c.CheckNumber,
                                DateAdded = DateTime.Now,
                                DatePaid = sipp_c.DatePaid,
                                PaymentTypeID = sipp_c.PaymentTypeID,
                                SurgeryInvoice_ProviderID = sip.ID
                            };
                            db.SurgeryInvoice_Provider_Payments.InsertOnSubmit(sipp);
                        }
                    }
                    #endregion
                }
                else
                {
                    CreateSurgeryInvoice_Provider(invoice.SurgeryInvoiceID.Value, sip_c);
                }
            }

            db.SubmitChanges();
        }
        #endregion


        #region CreateTestInvoice
        private static Int32 CreateTestInvoice(Int32 TestTypeID, List<TestInvoice_Test_Custom> InvoiceTests)
        {
            // Create the TestInvoice object and save it to the database.
            TestInvoice ti = new TestInvoice();
            ti.TestTypeID = TestTypeID;
            ti.Active = true;
            ti.DateAdded = DateTime.Now;

            using (DataModelDataContext db = new DataModelDataContext())
            {
                db.TestInvoices.InsertOnSubmit(ti);
                db.SubmitChanges();

                // create each tit_c and insert it into the database
                foreach (TestInvoice_Test_Custom tit_c in InvoiceTests)
                {
                    TestInvoice_Test tit = new TestInvoice_Test()
                    {
                        Active = true,
                        AmountPaidToProvider = tit_c.AmountPaidToProvider,
                        AmountToProvider = tit_c.AmountToProvider,
                        CalculateAmountToProvider =  tit_c.CalculateAmountToProvider,
                        CheckNumber = tit_c.CheckNumber,
                        Date = tit_c.Date,
                        DateAdded = tit_c.DateAdded,
                        DepositToProvider = tit_c.DepositToProvider,
                        InvoiceProvider = CreateInvoiceRecord_Provider(db, tit_c.ProviderID),
                        isCanceled = tit_c.isCancelled,
                        IsPositive = tit_c.isPositive,
                        MRI = tit_c.MRI,
                        Notes = tit_c.Notes,
                        NumberOfTests = tit_c.NumberOfTests,
                        PPODiscount = tit_c.PPODiscount,
                        ProviderDueDate = tit_c.ProviderDueDate,
                        TestCost = tit_c.TestCost,
                        TestDate = tit_c.TestDate,
                        TestTime = tit_c.TestTime,
                        TestID = tit_c.TestID,
                        TestInvoiceID = ti.ID,
                        AccountNumber = tit_c.AccountNumber,
                    };
                    db.TestInvoice_Tests.InsertOnSubmit(tit);
                    db.SubmitChanges();

                    // link the CPT Codes for each tit_c
                    foreach (TestInvoice_Test_CPTCodes_Custom titc_c in tit_c.CPTCodeList)
                    {
                        TestInvoice_Test_CPTCode titc = new TestInvoice_Test_CPTCode()
                        {
                            Active = true,
                            Amount = titc_c.Amount,
                            CPTCodeID = titc_c.CPTCodeID,
                            DateAdded = DateTime.Now,
                            Description = titc_c.Description,
                            TestInvoice_TestID = tit.ID
                        };
                        db.TestInvoice_Test_CPTCodes.InsertOnSubmit(titc);
                    }
                    db.SubmitChanges();
                }
            }

            return ti.ID;
        }
        #endregion


        #region CreateSurgeryInvoice
        private static Int32 CreateSurgeryInvoice(List<SurgeryInvoice_Surgery_Custom> InvoiceSurgeries, List<SurgeryInvoice_Provider_Custom> InvoiceProviders)
        {
            // Create the SurgeryInvoice object and save it to the database.
            SurgeryInvoice si = new SurgeryInvoice();
            si.Active = true;
            si.DateAdded = DateTime.Now;

            using (DataModelDataContext db = new DataModelDataContext())
            {
                db.SurgeryInvoices.InsertOnSubmit(si);
                db.SubmitChanges();
            }

            foreach (SurgeryInvoice_Surgery_Custom sis_c in InvoiceSurgeries)
            {
                CreateSurgeryInvoice_Surgery(si.ID, sis_c);
            }

            foreach (SurgeryInvoice_Provider_Custom sip_c in InvoiceProviders)
            {
                CreateSurgeryInvoice_Provider(si.ID, sip_c);
            }

            return si.ID;
        }
        #endregion


        #region CreateSurgeryInvoice_Surgery
        private static Int32 CreateSurgeryInvoice_Surgery(Int32 SurgeryInvoiceID, SurgeryInvoice_Surgery_Custom sis_c)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                // insert new
                SurgeryInvoice_Surgery sis = new SurgeryInvoice_Surgery()
                {
                    Active = true,
                    DateAdded = DateTime.Now,
                    isInpatient = sis_c.isInpatient,
                    Notes = sis_c.Notes,
                    SurgeryID = sis_c.SurgeryID,
                    SurgeryInvoiceID = SurgeryInvoiceID,
                };
                db.SurgeryInvoice_Surgeries.InsertOnSubmit(sis);
                db.SubmitChanges();

                //sis icd codes
                foreach (var sid in sis_c.icdCodesList)
                {
                    if (sid.ID > 0)
                    {
                        // update existing
                        SurgeryInvoice_Surgery_ICDCode sidc = (from c in db.SurgeryInvoice_Surgery_ICDCodes where c.ID == sid.ID select c).First();
                        sidc.Active = sid.Active;
                        sidc.Amount = sid.Amount;
                        sidc.ICDCodeID = sid.ICDCodeID;
                        sidc.Description = sid.Description;
                    }
                    else
                    {
                        // insert new
                        SurgeryInvoice_Surgery_ICDCode sidc = new SurgeryInvoice_Surgery_ICDCode()
                        {
                            Active = sid.Active,
                            Amount = sid.Amount,
                            ICDCodeID = sid.ICDCodeID,
                            DateAdded = DateTime.Now,
                            Description = sid.Description,
                            SurgeryInvoice_SurgeryID = sis.ID
                        };
                        db.SurgeryInvoice_Surgery_ICDCodes.InsertOnSubmit(sidc);
                    }
                }

                // sis dates
                for (int i = 0; i < sis_c.SurgeryDates.Count; i++)
                {
                    SurgeryInvoice_SurgeryDate sisd = new SurgeryInvoice_SurgeryDate()
                    {
                        Active = true,
                        DateAdded = DateTime.Now,
                        isPrimaryDate = i == 0,
                        ScheduledDate = sis_c.SurgeryDates[i],
                        SurgeryInvoice_SurgeryID = sis.ID
                    };
                    db.SurgeryInvoice_SurgeryDates.InsertOnSubmit(sisd);
                }

                db.SubmitChanges();

                return sis.ID;
            }
        }
        #endregion

        #region CreateSurgeryInvoice_Provider
        private static Int32 CreateSurgeryInvoice_Provider(Int32 SurgeryInvoiceID, SurgeryInvoice_Provider_Custom sip_c)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                SurgeryInvoice_Provider sip = new SurgeryInvoice_Provider()
                {
                    Active = true,
                    DateAdded = DateTime.Now,
                    InvoiceProvider = CreateInvoiceRecord_Provider(db, sip_c.ProviderID),
                    SurgeryInvoiceID = SurgeryInvoiceID
                };
                db.SurgeryInvoice_Providers.InsertOnSubmit(sip);
                db.SubmitChanges();

                // link cpt codes
                foreach (SurgeryInvoice_Provider_CPTCode_Custom sipc_c in sip_c.CPTCodes)
                {
                    SurgeryInvoice_Provider_CPTCode sipc = new SurgeryInvoice_Provider_CPTCode()
                    {
                        Active = true,
                        Amount = sipc_c.Amount,
                        CPTCodeID = sipc_c.CPTCodeID,
                        DateAdded = DateTime.Now,
                        Description = sipc_c.Description,
                        SurgeryInvoice_ProviderID = sip.ID
                    };
                    db.SurgeryInvoice_Provider_CPTCodes.InsertOnSubmit(sipc);
                }

                // add sip services
                foreach (SurgeryInvoice_Provider_Service_Custom sips_c in sip_c.ProviderServices)
                {
                    SurgeryInvoice_Provider_Service sips = new SurgeryInvoice_Provider_Service()
                    {
                        AccountNumber = sips_c.AccountNumber,
                        Active = true,
                        AmountDue = sips_c.AmountDue,
                        CalculateAmountDue = sips_c.CalculateAmountDue,
                        Cost = sips_c.Cost,
                        DateAdded = DateTime.Now,
                        Discount = sips_c.Discount,
                        DueDate = sips_c.DueDate,
                        EstimatedCost = sips_c.EstimatedCost,
                        PPODiscount = sips_c.PPODiscount,
                        SurgeryInvoice_ProviderID = sip.ID
                    };
                    db.SurgeryInvoice_Provider_Services.InsertOnSubmit(sips);
                }

                // add payments
                foreach (SurgeryInvoice_Provider_Payment_Custom sipp_c in sip_c.Payments)
                {
                    SurgeryInvoice_Provider_Payment sipp = new SurgeryInvoice_Provider_Payment()
                    {
                        Active = true,
                        Amount = sipp_c.Amount,
                        CheckNumber = sipp_c.CheckNumber,
                        DateAdded = DateTime.Now,
                        DatePaid = sipp_c.DatePaid,
                        PaymentTypeID = sipp_c.PaymentTypeID,
                        SurgeryInvoice_ProviderID = sip.ID
                    };
                    db.SurgeryInvoice_Provider_Payments.InsertOnSubmit(sipp);
                }

                db.SubmitChanges();

                return sip.ID;
            }
        }
        #endregion


        #region CreateInvoiceRecord_Attorney

        private static InvoiceAttorney CreateInvoiceRecord_Attorney(Int32 AttorneyID)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                return CreateInvoiceRecord_Attorney(db, AttorneyID);
            }
        }

        private static InvoiceAttorney CreateInvoiceRecord_Attorney(DataModelDataContext db, Int32 AttorneyID)
        {
            Attorney attorney = (from a in db.Attorneys where a.ID == AttorneyID select a).First();

            InvoiceAttorney invoiceAttorney = new InvoiceAttorney();
            invoiceAttorney.Attorney = attorney;
            invoiceAttorney.isActiveStatus = attorney.isActiveStatus;
            invoiceAttorney.FirstName = attorney.FirstName;
            invoiceAttorney.LastName = attorney.LastName;
            invoiceAttorney.Street1 = attorney.Street1;
            invoiceAttorney.Street2 = attorney.Street2;
            invoiceAttorney.City = attorney.City;
            invoiceAttorney.StateID = attorney.StateID;
            invoiceAttorney.ZipCode = attorney.ZipCode;
            invoiceAttorney.Phone = attorney.Phone;
            invoiceAttorney.Fax = attorney.Fax;
            invoiceAttorney.Email = attorney.Email;
            invoiceAttorney.Notes = attorney.Notes;
            invoiceAttorney.DiscountNotes = attorney.DiscountNotes;
            invoiceAttorney.DepositAmountRequired = attorney.DepositAmountRequired;
            invoiceAttorney.Active = attorney.Active;
            invoiceAttorney.DateAdded = attorney.DateAdded;
            invoiceAttorney.InvoiceContactListID = CreateInvoiceContactList(attorney.ContactList).ID;
            if (attorney.FirmID.HasValue)
            {
                invoiceAttorney.InvoiceFirmID = CreateInvoiceRecord_Firm((int)attorney.FirmID).ID;
            }

            db.InvoiceAttorneys.InsertOnSubmit(invoiceAttorney);
            db.SubmitChanges();

            return invoiceAttorney;
        }

        #endregion

        #region CreateInvoiceRecord_Patient

        private static InvoicePatient CreateInvoiceRecord_Patient(Int32 PatientID)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                return CreateInvoiceRecord_Patient(db, PatientID);
            }
        }

        private static InvoicePatient CreateInvoiceRecord_Patient(DataModelDataContext db, Int32 PatientID)
        {
            Patient patient = (from p in db.Patients where p.ID == PatientID select p).First();

            InvoicePatient invoicePatient = new InvoicePatient();
            invoicePatient.Patient = patient;
            invoicePatient.isActiveStatus = patient.isActiveStatus;
            invoicePatient.FirstName = patient.FirstName;
            invoicePatient.LastName = patient.LastName;
            invoicePatient.SSN = patient.SSN;
            invoicePatient.Street1 = patient.Street1;
            invoicePatient.Street2 = patient.Street2;
            invoicePatient.City = patient.City;
            invoicePatient.StateID = patient.StateID;
            invoicePatient.ZipCode = patient.ZipCode;
            invoicePatient.Phone = patient.Phone;
            invoicePatient.WorkPhone = patient.WorkPhone;
            invoicePatient.DateOfBirth = patient.DateOfBirth;
            invoicePatient.Active = patient.Active;
            invoicePatient.DateAdded = patient.DateAdded;

            db.InvoicePatients.InsertOnSubmit(invoicePatient);
            db.SubmitChanges();

            return invoicePatient;
        }

        #endregion

        #region CreateInvoiceRecord_Physician

        private static InvoicePhysician CreateInvoiceRecord_Physician(Int32 PhysicianID)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                return CreateInvoiceRecord_Physician(db, PhysicianID);
            }
        }

        private static InvoicePhysician CreateInvoiceRecord_Physician(DataModelDataContext db, Int32 PhysicianID)
        {
            Physician physician = (from p in db.Physicians where p.ID == PhysicianID select p).First();

            InvoicePhysician invoicePhysician = new InvoicePhysician()
            {
                Active = physician.Active,
                City = physician.City,
                DateAdded = DateTime.Now,
                EmailAddress = physician.EmailAddress,
                Fax = physician.Fax,
                FirstName = physician.FirstName,
                InvoiceContactList = CreateInvoiceContactList(db, physician.ContactList),
                isActiveStatus = physician.isActiveStatus,
                LastName = physician.LastName,
                Notes = physician.Notes,
                Phone = physician.Phone,
                PhysicianID = PhysicianID,
                StateID = physician.StateID,
                Street1 = physician.Street1,
                Street2 = physician.Street2,
                ZipCode = physician.ZipCode
            };

            db.InvoicePhysicians.InsertOnSubmit(invoicePhysician);
            db.SubmitChanges();

            return invoicePhysician;
        }

        #endregion

        #region CreateInvoiceRecord_Firm

        private static InvoiceFirm CreateInvoiceRecord_Firm(Int32 FirmID)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                Firm firm = (from f in db.Firms where f.ID == FirmID select f).First();

                InvoiceFirm invoiceFirm = new InvoiceFirm();
                invoiceFirm.Firm = firm;
                invoiceFirm.isActiveStatus = firm.isActiveStatus;
                invoiceFirm.Name = firm.Name;
                invoiceFirm.Street1 = firm.Street1;
                invoiceFirm.Street2 = firm.Street2;
                invoiceFirm.City = firm.City;
                invoiceFirm.StateID = firm.StateID;
                invoiceFirm.ZipCode = firm.ZipCode;
                invoiceFirm.Phone = firm.Phone;
                invoiceFirm.Fax = firm.Fax;
                invoiceFirm.Active = firm.Active;
                invoiceFirm.DateAdded = firm.DateAdded;
                invoiceFirm.InvoiceContactListID = CreateInvoiceContactList(firm.ContactList).ID;

                db.InvoiceFirms.InsertOnSubmit(invoiceFirm);
                db.SubmitChanges();

                return invoiceFirm;
            }
        }

        #endregion

        #region CreateInvoiceRecord_Provider

        private static InvoiceProvider CreateInvoiceRecord_Provider(Int32 ProviderID)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                return CreateInvoiceRecord_Provider(db, ProviderID);
            }
        }

        private static InvoiceProvider CreateInvoiceRecord_Provider(DataModelDataContext db, Int32 ProviderID)
        {
            Provider provider = (from a in db.Providers where a.ID == ProviderID select a).FirstOrDefault();

            InvoiceProvider invoiceProvider = new InvoiceProvider();
            invoiceProvider.InvoiceContactList = CreateInvoiceContactList(db, provider.ContactList);
            invoiceProvider.Provider = provider;
            invoiceProvider.isActiveStatus = provider.isActiveStatus;
            invoiceProvider.Name = provider.Name;
            invoiceProvider.Street1 = provider.Street1;
            invoiceProvider.Street2 = provider.Street2;
            invoiceProvider.City = provider.City;
            invoiceProvider.StateID = provider.StateID;
            invoiceProvider.ZipCode = provider.ZipCode;
            invoiceProvider.Phone = provider.Phone;
            invoiceProvider.Fax = provider.Fax;
            invoiceProvider.Email = provider.Email;
            invoiceProvider.Notes = provider.Notes;
            invoiceProvider.FacilityAbbreviation = provider.FacilityAbbreviation;
            invoiceProvider.DiscountPercentage = provider.DiscountPercentage;
            invoiceProvider.MRICostTypeID = provider.MRICostTypeID;
            invoiceProvider.MRICostFlatRate = provider.MRICostFlatRate;
            invoiceProvider.MRICostPercentage = provider.MRICostPercentage;
            invoiceProvider.DaysUntilPaymentDue = provider.DaysUntilPaymentDue;
            invoiceProvider.Deposits = provider.Deposits;
            invoiceProvider.Active = provider.Active;
            invoiceProvider.DateAdded = provider.DateAdded;

            db.InvoiceProviders.InsertOnSubmit(invoiceProvider);
            db.SubmitChanges();

            return invoiceProvider;
        }

        #endregion


        #region CreateInvoiceContactList

        /// <summary>
        /// Creates an InvoiceContactList and InvoiceContacts based on the ContactList passed in.
        /// </summary>
        /// <param name="oContactList"></param>
        /// <returns></returns>
        private static InvoiceContactList CreateInvoiceContactList(ContactList ContactList)
        {
            using (DataModelDataContext db = new DataModelDataContext())
            {
                return CreateInvoiceContactList(db, ContactList);
            }
        }

        private static InvoiceContactList CreateInvoiceContactList(DataModelDataContext db, ContactList ContactList)
        {
            //First, create the new contact list
            InvoiceContactList icl = new InvoiceContactList()
            {
                Active = true,
                DateAdded = DateTime.Now
            };

            db.InvoiceContactLists.InsertOnSubmit(icl);
            db.SubmitChanges();

            //Second, Create the copies of the existing contacts.
            foreach (Contact c in ContactList.Contacts)
            {
                if (c.Active)
                {
                    InvoiceContact ic = new InvoiceContact()
                    {
                        InvoiceContactListID = icl.ID,
                        Name = c.Name,
                        Position = c.Position,
                        Phone = c.Phone,
                        Email = c.Email,
                        Active = c.Active,
                        DateAdded = DateTime.Now
                    };

                    db.InvoiceContacts.InsertOnSubmit(ic);
                }
            }

            db.SubmitChanges();

            return icl;
        }

        #endregion


        #endregion
    }
}


#region + Custom Classes

#region TestInvoice_Test_Custom

public class TestInvoice_Test_Custom
{
    public Int32? ID { get; set; }
    public Int32? InvoiceProviderID { get; set; }
    public Int32 ProviderID { get; set; }
    public Int32 TestID { get; set; }
    public string Notes { get; set; }
    public DateTime TestDate { get; set; }
    public TimeSpan? TestTime { get; set; }
    public int? NumberOfTests { get; set; }
    public int MRI { get; set; }
    public Boolean? isPositive { get; set; }
    public Boolean isCancelled { get; set; }
    public decimal TestCost { get; set; }
    public decimal PPODiscount { get; set; }
    public List<TestInvoice_Test_CPTCodes_Custom> CPTCodeList { get; set; }
    public String CheckNumber { get; set; }
    public decimal? AmountPaidToProvider { get; set; }
    public decimal AmountToProvider { get; set; }
    public bool CalculateAmountToProvider { get; set; }
    public DateTime ProviderDueDate { get; set; }
    public DateTime? Date { get; set; }
    public Boolean Active { get; set; }
    public DateTime DateAdded { get; set; }
    public decimal? DepositToProvider { get; set; }
    public string AccountNumber { get; set; } 

    public void RecalculateAmountToProvider()
    {
        decimal? discountPercentage;
        int mriCostTypeID;
        decimal? mriCostFlatRate;
        decimal? mriCostPercentage;

        // get the provider
        Provider p = BMM_BAL.ProviderClass.GetProviderByID(ProviderID, false, false, true);
        // get the invoiceprovider if it exists
        InvoiceProvider ip = InvoiceProviderID.HasValue ? BMM_BAL.ProviderClass.GetInvoiceProviderByID(InvoiceProviderID.Value, false, false) : null;
        // if the invoiceprovider exists and matches the provider
        if (ip != null && ip.ProviderID == p.ID)
        {
            // use the values from the invoiceprovider
            discountPercentage = ip.DiscountPercentage;
            mriCostTypeID = ip.MRICostTypeID;
            mriCostFlatRate = ip.MRICostFlatRate;
            mriCostPercentage = ip.MRICostPercentage;
        }
        else if (p != null)
        {
            // use the values from the provider
            discountPercentage = p.DiscountPercentage;
            mriCostTypeID = p.MRICostTypeID;
            mriCostFlatRate = p.MRICostFlatRate;
            mriCostPercentage = p.MRICostPercentage;
        }
        else
        {
            AmountPaidToProvider = TestCost;
            return;
        }

        // calculate amount
        int mri = MRI;
        decimal testCost = TestCost;
        if (mri > 0 && mriCostTypeID == (int)BMM_BAL.ProviderClass.MRICostTypeEnum.Flat_Rate && mriCostFlatRate.HasValue)
        {
            AmountToProvider = mriCostFlatRate.Value * mri;
        }
        else if (testCost < 0)
        {
            AmountToProvider = -1;
        }
        else if (mri > 0 && mriCostTypeID == (int)BMM_BAL.ProviderClass.MRICostTypeEnum.Percentage && mriCostPercentage.HasValue)
        {
            AmountToProvider = testCost * mriCostPercentage.Value;
        }
        else if (mri == 0 && discountPercentage.HasValue && discountPercentage.Value != 0)
        {
            AmountToProvider = testCost * discountPercentage.Value;
        }
        else
        {
            AmountToProvider = testCost;
        }
    }

    public void RecalculateProviderDueDate()
    {
        int days;
        InvoiceProvider ip = InvoiceProviderID.HasValue ? BMM_BAL.ProviderClass.GetInvoiceProviderByID(InvoiceProviderID.Value, false, false) : null;
        bool foundIP = ip != null && ip.ProviderID == ProviderID;
        Provider p = foundIP ? null : BMM_BAL.ProviderClass.GetProviderByID(ProviderID, false, false, true);
        if (foundIP)
        {
            days = ip.DaysUntilPaymentDue.HasValue ? ip.DaysUntilPaymentDue.Value : 0;
        }
        else if (p != null)
        {
            days = p.DaysUntilPaymentDue.HasValue ? p.DaysUntilPaymentDue.Value : 0;
        }
        else
        {
            days = 0;
        }
        ProviderDueDate = DateAdded.Date.AddDays(days);
    }
}

#endregion

#region TestInvoice_Test_CPTCodes_Custom

public class TestInvoice_Test_CPTCodes_Custom
{
    public Int32 ID { get; set; }
    public Int32 CPTCodeID { get; set; }
    public decimal Amount { get; set; }
    public string Description { get; set; }
    public Boolean Active { get; set; }
}

#endregion

#region SurgeryInvoice_Surgery_Custom

public class SurgeryInvoice_Surgery_Custom
{

    public Int32 ID { get; set; }
    public Int32 SurgeryID { get; set; }
    public List<DateTime> SurgeryDates { get; set; }
    public Boolean isInpatient { get; set; }
    public string Notes { get; set; }
    public Boolean Active { get; set; }
    public Boolean isCanceled { get; set; }
    public List<SurgeryInvoice_Surgery_ICDCode> icdCodesList { get; set; }
}

#endregion

#region SurgeryInvoice_Provider_Custom

public class SurgeryInvoice_Provider_Custom
{
    public Int32? ID { get; set; }
    public Int32 ProviderID { get; set; }
    public Int32? InvoiceProviderID { get; set; }
    public List<SurgeryInvoice_Provider_Service_Custom> ProviderServices { get; set; }
    public List<SurgeryInvoice_Provider_Payment_Custom> Payments { get; set; }
    public List<SurgeryInvoice_Provider_CPTCode_Custom> CPTCodes { get; set; }
    public Boolean Active { get; set; }
}

#endregion

#region SurgeryInvoice_Provider_Service_Custom

public class SurgeryInvoice_Provider_Service_Custom
{
    public Int32 ID { get; set; }
    public decimal? EstimatedCost { get; set; }
    public decimal Cost { get; set; }
    public decimal Discount { get; set; }
    public decimal PPODiscount { get; set; }
    public DateTime DueDate { get; set; }
    public decimal AmountDue { get; set; }
    public bool CalculateAmountDue { get; set; }
    public string AccountNumber { get; set; }
    public Boolean Active { get; set; }
}

#endregion

#region SurgeryInvoice_Provider_Payment_Custom

public class SurgeryInvoice_Provider_Payment_Custom
{
    public Int32 ID { get; set; }
    public DateTime DatePaid { get; set; }
    public decimal Amount { get; set; }
    public Int32 PaymentTypeID { get; set; }
    public string CheckNumber { get; set; }
    public Boolean Active { get; set; }
}

#endregion

#region SurgeryInvoice_Provider_CPTCode_Custom

public class SurgeryInvoice_Provider_CPTCode_Custom
{
    public Int32 ID { get; set; }
    public Int32 CPTCodeID { get; set; }
    public decimal Amount { get; set; }
    public string Description { get; set; }
    public Boolean Active { get; set; }
}

#endregion


#endregion


