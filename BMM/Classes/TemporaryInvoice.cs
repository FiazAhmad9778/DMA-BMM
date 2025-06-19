using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using BMM_BAL;
using BMM_DAL;

namespace BMM.Classes
{
    public class TemporaryInvoice
    {
        #region + Members
        private HttpSessionState _Session;
        private string _Key;
        #endregion

        #region + Properties

        #region SessionData
        private InvoiceSession SessionData
        {
            get { return (InvoiceSession)_Session["Invoice_" + _Key]; }
            set { _Session["Invoice_" + _Key] = value; }
        }
        #endregion

        #region Key
        public string Key
        {
            get { return _Key; }
        }
        #endregion

        #region ID
        public int? ID
        {
            get { return SessionData.ID; }
        }
        #endregion

        #region InvoiceNumber
        public int? InvoiceNumber
        {
            get { return SessionData.InvoiceNumber; }
        }
        #endregion

        #region CompanyID
        public int? CompanyID
        {
            get { return SessionData.CompanyID; }
        }
        #endregion

        #region + Type

        #region TypeID
        public int TypeID
        {
            get { return SessionData.TypeID; }
            set
            {
                if (ID.HasValue && SessionData.TypeID != value) throw new Exception("Cannot change the type of an existing invoice.");
                SessionData.TypeID = value;
            }
        }
        #endregion

        #region Type
        public InvoiceClass.InvoiceTypeEnum Type
        {
            get { return (InvoiceClass.InvoiceTypeEnum)Enum.ToObject(typeof(InvoiceClass.InvoiceTypeEnum), TypeID); }
            set { TypeID = (int)value; }
        }
        #endregion

        #region TypeName
        public string TypeName
        {
            get { return Enum.GetName(typeof(InvoiceClass.InvoiceTypeEnum), TypeID); }
        }
        #endregion

        #region TypeIsTesting
        public bool TypeIsTesting
        {
            get { return SessionData.TypeID == (int)InvoiceClass.InvoiceTypeEnum.Testing; }
        }
        #endregion

        #region TypeIsSurgery
        public bool TypeIsSurgery
        {
            get { return SessionData.TypeID == (int)InvoiceClass.InvoiceTypeEnum.Surgery; }
        }
        #endregion

        #endregion

        #region DateOfAccident
        public DateTime? DateOfAccident
        {
            get { return SessionData.DateOfAccident; }
            set { SessionData.DateOfAccident = value; }
        }
        #endregion

        #region + Status

        #region StatusID
        public int StatusID
        {
            get { return SessionData.StatusID; }
            set { SessionData.StatusID = value; }
        }
        #endregion

        #region Status
        public InvoiceClass.InvoiceStatusEnum Status
        {
            get { return (InvoiceClass.InvoiceStatusEnum)Enum.ToObject(typeof(InvoiceClass.InvoiceStatusEnum), StatusID); }
            set { StatusID = (int)value; }
        }
        #endregion

        #region StatusName
        public string StatusName
        {
            get { return Enum.GetName(typeof(InvoiceClass.InvoiceStatusEnum), StatusID); }
        }
        #endregion

        #region IsComplete
        public bool IsComplete
        {
            get { return SessionData.IsComplete; }
            set { SessionData.IsComplete = value; }
        }
        #endregion

        #endregion

        #region + Patient

        #region PatientID
        public int? PatientID
        {
            get { return SessionData.PatientID; }
            set { SessionData.PatientID = value; }
        }
        #endregion

        #region Patient
        private Patient _Patient;
        public Patient Patient
        {
            get
            {
                int? patientID = PatientID;
                if (patientID.HasValue)
                {
                    if (_Patient == null || _Patient.ID != patientID.Value)
                    {
                        _Patient = PatientClass.GetPatientByID(patientID.Value, false, true);
                    }
                    return _Patient;
                }
                return null;
            }
        }
        #endregion

        #region InvoicePatientID
        public int? InvoicePatientID
        {
            get { return SessionData.InvoicePatientID; }
        }
        #endregion

        #region InvoicePatient
        private InvoicePatient _InvoicePatient;
        public InvoicePatient InvoicePatient
        {
            get
            {
                if (_InvoicePatient == null && InvoicePatientID.HasValue)
                {
                    _InvoicePatient = InvoiceClass.GetInvoicePatientByID(InvoicePatientID.Value, false, true);
                }
                return _InvoicePatient;
            }
        }
        #endregion

        #endregion

        #region + Attorney

        #region AttorneyID
        public int? AttorneyID
        {
            get { return SessionData.AttorneyID; }
            set { SessionData.AttorneyID = value; }
        }
        #endregion

        #region Attorney
        private Attorney _Attorney;
        public Attorney Attorney
        {
            get
            {
                int? attorneyID = AttorneyID;
                if (attorneyID.HasValue)
                {
                    if (_Attorney == null || _Attorney.ID != attorneyID.Value)
                    {
                        _Attorney = AttorneyClass.GetAttorneyByID(attorneyID.Value);
                    }
                    return _Attorney;
                }
                return null;
            }
        }
        #endregion

        #region InvoiceAttorneyID
        public int? InvoiceAttorneyID
        {
            get { return SessionData.InvoiceAttorneyID; }
        }
        #endregion

        #region InvoiceAttorney
        private InvoiceAttorney _InvoiceAttorney;
        public InvoiceAttorney InvoiceAttorney
        {
            get
            {
                if (_InvoiceAttorney == null && InvoiceAttorneyID.HasValue)
                {
                    _InvoiceAttorney = InvoiceClass.GetInvoiceAttorneyByID(InvoiceAttorneyID.Value, false, true);
                }
                return _InvoiceAttorney;
            }
        }
        #endregion

        #endregion

        #region + Physician

        #region PhysicianID
        public int? PhysicianID
        {
            get { return SessionData.PhysicianID; }
            set { SessionData.PhysicianID = value; }
        }
        #endregion

        #region Physician
        private Physician _Physician;
        public Physician Physician
        {
            get
            {
                if (PhysicianID.HasValue)
                {
                    if (_Physician == null || _Physician.ID != PhysicianID.Value)
                    {
                        _Physician = PhysicianClass.GetPhysicianByID(PhysicianID.Value);
                    }
                    return _Physician;
                }
                return null;
            }
        }
        #endregion

        #region InvoicePhysicianID
        public int? InvoicePhysicianID
        {
            get { return SessionData.InvoicePhysicianID; }
        }
        #endregion

        #region InvoicePhysician
        private InvoicePhysician _InvoicePhysician;
        public InvoicePhysician InvoicePhysician
        {
            get
            {
                if (_InvoicePhysician == null && InvoicePhysicianID.HasValue)
                {
                    _InvoicePhysician = InvoiceClass.GetInvoicePhysicianByID(InvoicePhysicianID.Value);
                }
                return _InvoicePhysician;
            }
        }
        #endregion

        #endregion

        #region + TestType

        #region TestTypeID
        public int TestTypeID
        {
            get { return SessionData.TestTypeID; }
            set { SessionData.TestTypeID = value; }
        }
        #endregion

        #region TestType
        public TestClass.TestTypeEnum TestType
        {
            get { return (TestClass.TestTypeEnum)Enum.ToObject(typeof(TestClass.TestTypeEnum), TestTypeID); }
            set { TestTypeID = (int)value; }
        }
        #endregion

        #endregion

        #region UseAttorneyTerms
        public int UseAttorneyTerms
        {
            get { return SessionData.UseAttorneyTerms; }
            set { SessionData.UseAttorneyTerms = value; }
        }
        #endregion

        #region CustomTerms
        public Boolean CustomTerms
        {
            get { return SessionData.CustomTerms; }
            set { SessionData.CustomTerms = value; }
        }
        #endregion

        #region Tests
        public List<TestInvoice_Test_Custom> Tests
        {
            get { return SessionData.Tests; }
        }
        #endregion

        #region Surgeries
        public List<SurgeryInvoice_Surgery_Custom> Surgeries
        {
            get { return SessionData.Surgeries; }
        }
        #endregion

        #region Providers
        public List<SurgeryInvoice_Provider_Custom> Providers
        {
            get { return SessionData.Providers; }
        }
        #endregion

        #region Payments
        public List<Payment> Payments
        {
            get { return SessionData.Payments; }
        }
        #endregion

        #region PaymentComments
        public List<Comment> PaymentComments
        {
            get { return SessionData.PaymentComments; }
        }
        #endregion

        #region ClosedDate
        public DateTime? ClosedDate
        {
            get { return SessionData.ClosedDate; }
            set { SessionData.ClosedDate = value; }
        }
        #endregion

        #region DatePaid
        public DateTime? DatePaid
        {
            get { return SessionData.DatePaid; }
            set { SessionData.DatePaid = value; }
        }
        #endregion

        #region ServiceFeeWaived
        public Decimal? ServiceFeeWaived
        {
            get { return SessionData.ServiceFeeWaived; }
            set { SessionData.ServiceFeeWaived = value; }
        }
        #endregion

        #region LossesAmount
        public Decimal? LossesAmount
        {
            get { return SessionData.LossesAmount; }
            set { SessionData.LossesAmount = value; }
        }
        #endregion

        #region GeneralComments
        public List<Comment> GeneralComments
        {
            get { return SessionData.GeneralComments; }
        }
        #endregion

        #region CalculatedCumulativeInterest
        public decimal CalculatedCumulativeInterest
        {
            get { return SessionData.CalculatedCumulativeInterest; }
        }
        #endregion

        #region YearlyInterest
        public decimal YearlyInterest
        {
            get { return SessionData.YearlyInterest ?? (TypeIsTesting ? SessionData.TestingYearlyInterest : SessionData.SurgeryYearlyInterest); }
            set { SessionData.YearlyInterest = value; }
        }
        #endregion

        #region LoanTermMonths
        public int LoanTermMonths
        {
            get { return SessionData.LoanTermMonths ?? (TypeIsTesting ? SessionData.TestingLoanTermMonths : SessionData.SurgeryLoanTermMonths); }
            set { SessionData.LoanTermMonths = value; }
        }
        #endregion

        #region ServiceFeeWaivedMonths
        public int ServiceFeeWaivedMonths
        {
            get { return SessionData.ServiceFeeWaivedMonths ?? (TypeIsTesting ? SessionData.TestingServiceFeeWaivedMonths : SessionData.SurgeryServiceFeeWaivedMonths); }
            set { SessionData.ServiceFeeWaivedMonths = value; }
        }
        #endregion


        #region AmortizationDate
        public DateTime? AmortizationDate
        {
            get
            {
                if (TypeIsTesting)
                {
                    return (from test in Tests
                            where test.Active
                            orderby test.TestDate ascending
                            select (DateTime?)test.TestDate).FirstOrDefault();
                }
                else
                {
                    return (from surgery in Surgeries
                            where surgery.Active && surgery.SurgeryDates.Count > 0
                            orderby surgery.SurgeryDates[0] ascending
                            select (DateTime?)surgery.SurgeryDates[0]).FirstOrDefault();
                }
            }
        }
        #endregion

        #region DateServiceFeeBegins
        public DateTime? DateServiceFeeBegins
        {
            get
            {
                DateTime? amortizationDate = AmortizationDate;
                if (amortizationDate.HasValue)
                {
                    DateTime monthServiceFeeBegins = amortizationDate.Value.AddMonths(ServiceFeeWaivedMonths + 1);
                    return new DateTime(monthServiceFeeBegins.Year, monthServiceFeeBegins.Month, 1);
                }
                return null;
            }
        }
        #endregion

        #region MaturityDate
        public DateTime? MaturityDate
        {
            get
            {
                DateTime? dateServiceFeeBegins = DateServiceFeeBegins;
                return dateServiceFeeBegins.HasValue ? dateServiceFeeBegins.Value.AddMonths(LoanTermMonths) : (DateTime?)null;
            }
        }
        #endregion


        #region TotalCost
        public decimal TotalCost
        {
            get
            {

                if (TypeIsTesting)
                {
                    return (from t in Tests
                            where t.Active
                            select t.TestCost).Sum();
                }
                else // TypeIsSurgery
                {
                    return (from p in Providers
                            where p.Active
                            from s in p.ProviderServices
                            where s.Active
                            select s.Cost).Sum();
                }
            }
        }
        #endregion

        #region TotalPPODiscount
        public decimal TotalPPODiscount
        {
            get
            {
                if (TypeIsTesting)
                {
                    return (from t in Tests
                            where t.Active
                            select t.PPODiscount).Sum();
                }
                else // TypeIsSurgery
                {
                    return (from p in Providers
                            where p.Active
                            from s in p.ProviderServices
                            where s.Active
                            select s.PPODiscount).Sum();
                }
            }
        }
        #endregion

        #region DepositPaid
        public decimal DepositPaid
        {
            get
            {
                return (from p in Payments
                        where p.Active && p.PaymentTypeID == (int)InvoiceClass.PaymentTypeEnum.Deposit
                        select p.Amount).Sum();
            }
        }
        #endregion

        #region PrincipalPaid
        public decimal PrincipalPaid
        {
            get
            {
                return (from p in Payments
                        where p.Active && p.PaymentTypeID == (int)InvoiceClass.PaymentTypeEnum.Principal
                        select p.Amount).Sum();
            }
        }
        #endregion

        #region PrincipalAndDepositPaid
        public decimal PrincipalAndDepositPaid
        {
            get { return DepositPaid + PrincipalPaid; }
        }
        #endregion

        #region AdditionalDeductions
        public decimal AdditionalDeductions
        {
            get
            {
                return (from p in Payments
                        where p.Active && (p.PaymentTypeID == (int)InvoiceClass.PaymentTypeEnum.Credit || p.PaymentTypeID == (int)InvoiceClass.PaymentTypeEnum.Refund)
                        select p.Amount).Sum() + (LossesAmount ?? 0);
            }
        }
        #endregion

        #region InterestWaived
        public decimal? InterestWaived
        {
            get { return ServiceFeeWaived; }
        }
        #endregion

        #region BalanceDue
        public decimal BalanceDue
        {
            get { return TotalCost - TotalPPODiscount - PrincipalAndDepositPaid - AdditionalDeductions; }
        }
        #endregion

        #region ServiceFeeReceived
        public decimal ServiceFeeReceived
        {
            get
            {
                return (from p in Payments
                        where p.Active && p.PaymentTypeID == (int)InvoiceClass.PaymentTypeEnum.Interest
                        select p.Amount).Sum();
            }
        }
        #endregion

        #region CumulativeServiceFeeDue
        public decimal CumulativeServiceFeeDue
        {
            get { return CalculatedCumulativeInterest - ServiceFeeReceived - (ServiceFeeWaived ?? 0m); }
        }
        #endregion

        #region InterestDue
        public decimal InterestDue
        {
            get { return CalculatedCumulativeInterest - ServiceFeeReceived - (InterestWaived ?? 0m); }
        }
        #endregion

        #region EndingBalance
        public decimal EndingBalance
        {
            //get { return BalanceDue + CumulativeServiceFeeDue - (LossesAmount ?? 0m); }
            get { return BalanceDue + CumulativeServiceFeeDue; }
        }
        #endregion

        #region CostOfGoodsSold
        public decimal CostOfGoodsSold
        {
            get
            {
                if (TypeIsTesting)
                {
                    return (from t in Tests
                            where t.Active
                            select t.AmountToProvider).Sum();
                }
                else // TypeIsSurgery
                {
                    return (from p in Providers
                            where p.Active
                            from s in p.ProviderServices
                            where s.Active
                            select s.AmountDue).Sum();
                }
            }
        }
        #endregion

        #region TotalRevenue
        public decimal TotalRevenue
        {
            get { return TotalCost - CostOfGoodsSold - TotalPPODiscount; }
        }
        #endregion

        #region TotalCPTs
        public decimal TotalCPTs
        {
            get
            {
                if (TypeIsTesting)
                {
                    return (from t in Tests
                            where t.Active
                            from c in t.CPTCodeList
                            where c.Active
                            select c.Amount).Sum();
                }
                else // TypeIsSurgery
                {
                    return (from p in Providers
                            where p.Active
                            from c in p.CPTCodes
                            where c.Active
                            select c.Amount).Sum();
                }
            }
        }
        #endregion

        #endregion

        #region Constructor
        public TemporaryInvoice(HttpSessionState session, int companyID, int? id = null, string key = null)
        {
            _Session = session;
            _Key = String.IsNullOrEmpty(key) ? DateTime.Now.ToString("X") : key;
            CreateSessionData(id, companyID);
        }
        #endregion

        #region + Methods

        #region CreateSessionData
        private void CreateSessionData(int? id, int companyID)
        {
            if (SessionData == null)
            {
                SessionData = new InvoiceSession();
                Invoice invoice = !id.HasValue ? null : InvoiceClass.GetInvoiceByID(id.Value, true);
                if (invoice == null)
                {
                    SessionData.ID = null;
                    SessionData.InvoiceNumber = null;
                    SessionData.CompanyID = null;
                    SessionData.TypeID = (int)InvoiceClass.InvoiceTypeEnum.Testing;
                    SessionData.DateOfAccident = null;
                    SessionData.StatusID = (int)InvoiceClass.InvoiceStatusEnum.Open;
                    SessionData.IsComplete = false;
                    SessionData.PatientID = null;
                    SessionData.InvoicePatientID = null;
                    SessionData.AttorneyID = null;
                    SessionData.InvoiceAttorneyID = null;
                    SessionData.PhysicianID = null;
                    SessionData.InvoicePhysicianID = null;
                    SessionData.TestTypeID = (int)TestClass.TestTypeEnum.Pain_Management;
                    SessionData.Tests = new List<TestInvoice_Test_Custom>();
                    SessionData.Surgeries = new List<SurgeryInvoice_Surgery_Custom>();
                    SessionData.Providers = new List<SurgeryInvoice_Provider_Custom>();
                    SessionData.Payments = new List<Payment>();
                    SessionData.PaymentComments = new List<Comment>();
                    SessionData.ClosedDate = null;
                    SessionData.DatePaid = null;
                    SessionData.ServiceFeeWaived = null;
                    SessionData.LossesAmount = null;
                    SessionData.GeneralComments = new List<Comment>();
                    SessionData.CalculatedCumulativeInterest = 0;
                    SessionData.UseAttorneyTerms = 0;
                    SessionData.CustomTerms = false;
                    SessionData.LoanTermMonths = null;
                    SessionData.ServiceFeeWaivedMonths = null;
                    SessionData.YearlyInterest = null;
                    LoanTerm loanTerms = LoanTermsClass.GetCurrentLoanTermsByCompanyID(companyID);
                    if (loanTerms != null)
                    {
                        SessionData.TestingLoanTermMonths = loanTerms.Testing_LoanTermMonths;
                        SessionData.TestingServiceFeeWaivedMonths = loanTerms.Testing_ServiceFeeWaivedMonths;
                        SessionData.TestingYearlyInterest = loanTerms.Testing_YearlyInterest;
                        SessionData.SurgeryLoanTermMonths = loanTerms.Surgery_LoanTermMonths;
                        SessionData.SurgeryServiceFeeWaivedMonths = loanTerms.Surgery_ServiceFeeWaivedMonths;
                        SessionData.SurgeryYearlyInterest = loanTerms.Surgery_YearlyInterest;
                    }
                }
                else
                {
                    SessionData.ID = invoice.ID;
                    SessionData.InvoiceNumber = invoice.InvoiceNumber;
                    SessionData.CompanyID = invoice.CompanyID;
                    SessionData.TypeID = invoice.InvoiceTypeID;
                    SessionData.DateOfAccident = invoice.DateOfAccident;
                    SessionData.StatusID = invoice.InvoiceStatusTypeID;
                    if (invoice.UseAttorneyTerms != null)
                    {
                        if (invoice.UseAttorneyTerms == true)
                        {
                            SessionData.UseAttorneyTerms = 1;
                        }
                        else
                        {
                            SessionData.UseAttorneyTerms = 0;
                        }

                    }
                    else
                    {
                        SessionData.UseAttorneyTerms = 0;
                    }
                    SessionData.IsComplete = invoice.isComplete;
                    SessionData.PatientID = invoice.InvoicePatient == null ? null : (int?)invoice.InvoicePatient.PatientID;
                    SessionData.InvoicePatientID = invoice.InvoicePatientID;
                    SessionData.AttorneyID = invoice.InvoiceAttorney == null ? null : (int?)invoice.InvoiceAttorney.AttorneyID;
                    SessionData.InvoiceAttorneyID = invoice.InvoiceAttorneyID;
                    SessionData.PhysicianID = invoice.InvoicePhysician == null ? null : (int?)invoice.InvoicePhysician.PhysicianID;
                    SessionData.InvoicePhysicianID = invoice.InvoicePhysicianID;
                    // Test Invoice
                    if (invoice.InvoiceTypeID == (int)InvoiceClass.InvoiceTypeEnum.Testing)
                    {
                        SessionData.TestTypeID = invoice.TestInvoice.TestTypeID;
                        SessionData.Tests = (from test in invoice.TestInvoice.TestInvoice_Tests
                                             where test.Active
                                             select new TestInvoice_Test_Custom()
                                             {
                                                 Active = test.Active,
                                                 CPTCodeList = (from code in test.TestInvoice_Test_CPTCodes
                                                                where code.Active
                                                                select new TestInvoice_Test_CPTCodes_Custom()
                                                                {
                                                                    Active = code.Active,
                                                                    Amount = code.Amount,
                                                                    CPTCodeID = code.CPTCodeID,
                                                                    Description = code.Description,
                                                                    ID = code.ID
                                                                }).ToList(),
                                                 ID = test.ID,
                                                 InvoiceProviderID = test.InvoiceProviderID,
                                                 isCancelled = test.isCanceled,
                                                 isPositive = test.IsPositive,
                                                 MRI = test.MRI,
                                                 Notes = test.Notes,
                                                 NumberOfTests = test.NumberOfTests,
                                                 PPODiscount = test.PPODiscount,
                                                 ProviderID = test.InvoiceProvider.ProviderID,
                                                 TestCost = test.TestCost,
                                                 TestDate = test.TestDate,
                                                 TestTime = test.TestTime,
                                                 TestID = test.TestID,
                                                 AmountPaidToProvider = test.AmountPaidToProvider,
                                                 AmountToProvider = test.AmountToProvider,
                                                 CalculateAmountToProvider =  test.CalculateAmountToProvider,
                                                 CheckNumber = test.CheckNumber,
                                                 Date = test.Date,
                                                 DateAdded = test.DateAdded,
                                                 DepositToProvider = test.DepositToProvider,
                                                 ProviderDueDate = test.ProviderDueDate,
                                                 AccountNumber =  test.AccountNumber,
                                             }).ToList();
                        SessionData.Surgeries = null;
                        SessionData.Providers = null;
                    }
                    // SurgeryInvoice
                    else
                    {
                        SessionData.TestTypeID = (int)TestClass.TestTypeEnum.Pain_Management;
                        SessionData.Tests = null;
                        SessionData.Surgeries = (from surgery in invoice.SurgeryInvoice.SurgeryInvoice_Surgeries
                                                 where surgery.Active
                                                 select new SurgeryInvoice_Surgery_Custom()
                                                 {
                                                     Active = surgery.Active,
                                                     ID = surgery.ID,
                                                     isInpatient = surgery.isInpatient,
                                                     icdCodesList = (from iccode in surgery.SurgeryInvoice_Surgery_ICDCodes
                                                                     where iccode.Active
                                                                     select iccode).ToList(),
                                                     Notes = surgery.Notes,
                                                     SurgeryDates = (from scheduledDate in surgery.SurgeryInvoice_SurgeryDates
                                                                     where scheduledDate.Active
                                                                     orderby scheduledDate.isPrimaryDate descending, scheduledDate.ScheduledDate ascending
                                                                     select scheduledDate.ScheduledDate).ToList(),
                                                     SurgeryID = surgery.SurgeryID,
                                                     isCanceled =  surgery.isCanceled
                                                 }).ToList();
                        SessionData.Providers = (from provider in invoice.SurgeryInvoice.SurgeryInvoice_Providers
                                                 where provider.Active
                                                 select new SurgeryInvoice_Provider_Custom()
                                                 {
                                                     Active = provider.Active,
                                                     CPTCodes = (from code in provider.SurgeryInvoice_Provider_CPTCodes
                                                                 where code.Active
                                                                 select new SurgeryInvoice_Provider_CPTCode_Custom()
                                                                 {
                                                                     Active = code.Active,
                                                                     Amount = code.Amount,
                                                                     CPTCodeID = code.CPTCodeID,
                                                                     Description = code.Description,
                                                                     ID = code.ID
                                                                 }).ToList(),
                                                     ID = provider.ID,
                                                     InvoiceProviderID = provider.InvoiceProviderID,
                                                     ProviderID = provider.InvoiceProvider.ProviderID,
                                                     Payments = (from payment in provider.SurgeryInvoice_Provider_Payments
                                                                 where payment.Active
                                                                 select new SurgeryInvoice_Provider_Payment_Custom()
                                                                 {
                                                                     Active = payment.Active,
                                                                     Amount = payment.Amount,
                                                                     CheckNumber = payment.CheckNumber,
                                                                     DatePaid = payment.DatePaid,
                                                                     ID = payment.ID,
                                                                     PaymentTypeID = payment.PaymentTypeID
                                                                 }).ToList(),
                                                     ProviderServices = (from service in provider.SurgeryInvoice_Provider_Services
                                                                         where service.Active
                                                                         select new SurgeryInvoice_Provider_Service_Custom()
                                                                         {
                                                                             AccountNumber = service.AccountNumber,
                                                                             Active = service.Active,
                                                                             AmountDue = service.AmountDue,
                                                                             CalculateAmountDue = service.CalculateAmountDue,
                                                                             Cost = service.Cost,
                                                                             Discount = service.Discount,
                                                                             DueDate = service.DueDate,
                                                                             EstimatedCost = service.EstimatedCost,
                                                                             ID = service.ID,
                                                                             PPODiscount = service.PPODiscount
                                                                         }).ToList()
                                                 }).ToList();
                    }
                    SessionData.Payments = (from payment in invoice.Payments
                                            where payment.Active
                                            select payment).ToList();
                    SessionData.PaymentComments = (from comment in invoice.Comments
                                                   where comment.Active
                                                      && comment.CommentTypeID == (int)InvoiceClass.CommentTypeEnum.PaymentComment
                                                   select comment).ToList();
                    SessionData.ClosedDate = invoice.InvoiceClosedDate;
                    SessionData.DatePaid = invoice.DatePaid;
                    SessionData.ServiceFeeWaived = invoice.ServiceFeeWaived;
                    SessionData.LossesAmount = invoice.LossesAmount;
                    SessionData.GeneralComments = (from comment in invoice.Comments
                                                   where comment.Active
                                                      && comment.CommentTypeID == (int)InvoiceClass.CommentTypeEnum.InvoiceComment
                                                   select comment).ToList();
                    SessionData.YearlyInterest = invoice.YearlyInterest;
                    SessionData.LoanTermMonths = invoice.LoanTermMonths;
                    SessionData.ServiceFeeWaivedMonths = invoice.ServiceFeeWaivedMonths;
                    SessionData.CalculatedCumulativeInterest = invoice.CalculatedCumulativeIntrest;
                }
            }
        }
        #endregion

        #region Exists
        public static bool Exists(HttpSessionState session, string key)
        {
            return session["Invoice_" + key] != null;
        }
        #endregion

        #region Remove
        public void Remove()
        {
            _Session.Remove("Invoice_" + _Key);
        }
        #endregion

        #region + Patient

        public bool InvoicePatientOverridesPatient()
        {
            return PatientID.HasValue && InvoicePatient != null && InvoicePatient.PatientID == PatientID.Value;
        }

        public string GetPatientFirstName()
        {
            if (InvoicePatientOverridesPatient())
                return InvoicePatient.FirstName; ;
            if (Patient != null)
                return Patient.FirstName;
            return String.Empty;
        }

        public string GetPatientLastName()
        {
            if (InvoicePatientOverridesPatient())
                return InvoicePatient.LastName; ;
            if (Patient != null)
                return Patient.LastName;
            return String.Empty;
        }

        public string GetPatientFullName()
        {
            if (InvoicePatientOverridesPatient())
                return InvoicePatient.FirstName + " " + InvoicePatient.LastName;
            if (Patient != null)
                return Patient.FirstName + " " + Patient.LastName;
            return String.Empty;
        }

        public string GetPatientSSN(bool formatted = false)
        {
            if (InvoicePatientOverridesPatient())
                return formatted ? Classes.Utility.FormatSSN(InvoicePatient.SSN) : InvoicePatient.SSN;
            if (Patient != null)
                return formatted ? Classes.Utility.FormatSSN(Patient.SSN) : Patient.SSN;
            return String.Empty;
        }

        public string GetPatientDateOfBirth(string format = "MM/dd/yyyy")
        {
            if (InvoicePatientOverridesPatient())
                return InvoicePatient.DateOfBirth.ToString(format);
            if (Patient != null)
                return Patient.DateOfBirth.ToString(format);
            return String.Empty;
        }

        public string GetPatientStreet1()
        {
            if (InvoicePatientOverridesPatient())
                return InvoicePatient.Street1;
            if (Patient != null)
                return Patient.Street1;
            return String.Empty;
        }

        public string GetPatientStreet2()
        {
            if (InvoicePatientOverridesPatient())
                return InvoicePatient.Street2;
            if (Patient != null)
                return Patient.Street2;
            return String.Empty;
        }

        public string GetPatientPhone()
        {
            if (InvoicePatientOverridesPatient())
                return InvoicePatient.Phone;
            if (Patient != null)
                return Patient.Phone;
            return String.Empty;
        }

        public string GetPatientWorkPhone()
        {
            if (InvoicePatientOverridesPatient())
                return InvoicePatient.WorkPhone;
            if (Patient != null)
                return Patient.WorkPhone;
            return String.Empty;
        }

        public string GetPatientCity()
        {
            if (InvoicePatientOverridesPatient())
                return InvoicePatient.City;
            if (Patient != null)
                return Patient.City;
            return String.Empty;
        }

        public string GetPatientState()
        {
            if (InvoicePatientOverridesPatient())
                return InvoicePatient.State.Abbreviation;
            if (Patient != null)
                return Patient.State.Abbreviation;
            return String.Empty;
        }

        public string GetPatientZipCode()
        {
            if (InvoicePatientOverridesPatient())
                return InvoicePatient.ZipCode;
            if (Patient != null)
                return Patient.ZipCode;
            return String.Empty;
        }

        #endregion

        #region GetTemporaryProvider
        public SurgeryInvoice_Provider_Custom GetTemporaryProvider(string key, int? id = null)
        {
            SurgeryInvoice_Provider_Custom provider = null;

            string sessionKeyName = "Provider_" + key;
            // if the provider is in session
            if (_Session[sessionKeyName] != null)
            {
                // use it
                provider = (SurgeryInvoice_Provider_Custom)_Session[sessionKeyName];
            }
            // otherwise, if there is an id for the surgery
            else if (id.HasValue)
            {
                // search for it in the temporary invoice
                SurgeryInvoice_Provider_Custom p = (from ip in Providers
                                                    where ip.ID == id.Value
                                                    select ip).FirstOrDefault();
                // if it was found
                if (p != null)
                {
                    // create a temporary copy of it
                    provider = new SurgeryInvoice_Provider_Custom()
                    {
                        Active = p.Active,
                        ID = p.ID,
                        CPTCodes = new List<SurgeryInvoice_Provider_CPTCode_Custom>(),
                        InvoiceProviderID = p.InvoiceProviderID,
                        Payments = new List<SurgeryInvoice_Provider_Payment_Custom>(),
                        ProviderID = p.ProviderID,
                        ProviderServices = new List<SurgeryInvoice_Provider_Service_Custom>()
                    };
                    p.CPTCodes.ForEach(cptcode => provider.CPTCodes.Add(new SurgeryInvoice_Provider_CPTCode_Custom()
                    {
                        Active = cptcode.Active,
                        Amount = cptcode.Amount,
                        CPTCodeID = cptcode.CPTCodeID,
                        Description = cptcode.Description,
                        ID = cptcode.ID
                    }));
                    p.Payments.ForEach(payment => provider.Payments.Add(new SurgeryInvoice_Provider_Payment_Custom()
                    {
                        Active = payment.Active,
                        Amount = payment.Amount,
                        CheckNumber = payment.CheckNumber,
                        DatePaid = payment.DatePaid,
                        ID = payment.ID,
                        PaymentTypeID = payment.PaymentTypeID
                    }));
                    p.ProviderServices.ForEach(service => provider.ProviderServices.Add(new SurgeryInvoice_Provider_Service_Custom()
                    {
                        AccountNumber = service.AccountNumber,
                        Active = service.Active,
                        AmountDue = service.AmountDue,
                        CalculateAmountDue = service.CalculateAmountDue,
                        Cost = service.Cost,
                        Discount = service.Discount,
                        DueDate = service.DueDate,
                        EstimatedCost = service.EstimatedCost,
                        ID = service.ID,
                        PPODiscount = service.PPODiscount
                    }));
                    // save the temporary copy to session
                    _Session[sessionKeyName] = provider;
                }
            }
            // otherwise, create a new surgery
            if (provider == null)
            {
                provider = new SurgeryInvoice_Provider_Custom()
                {
                    Active = true,
                    ID = null,
                    ProviderID = 0,
                    InvoiceProviderID = null,
                    CPTCodes = new List<SurgeryInvoice_Provider_CPTCode_Custom>(),
                    Payments = new List<SurgeryInvoice_Provider_Payment_Custom>(),
                    ProviderServices = new List<SurgeryInvoice_Provider_Service_Custom>()
                };
                // save the temporary copy to session
                _Session[sessionKeyName] = provider;
            }

            return provider;
        }
        #endregion

        #region RemoveTemporaryProvider
        public static void RemoveTemporaryProvider(HttpSessionState session, string key)
        {
            session.Remove("Provider_" + key);
        }
        #endregion

        #region GetTemporaryTest
        public TestInvoice_Test_Custom GetTemporaryTest(string key, int? id = null)
        {
            TestInvoice_Test_Custom test = null;

            string testSesssionKey = "Test_" + key;
            // if the t1 is in session
            if (_Session[testSesssionKey] != null)
            {
                // use it
                test = (TestInvoice_Test_Custom)_Session[testSesssionKey];
            }
            // otherwise, if there is an id for the surgery
            else if (id.HasValue)
            {
                // search for it in the temporary invoice
                TestInvoice_Test_Custom t = (from tit in Tests
                                             where tit.ID == id.Value
                                             select tit).FirstOrDefault();
                // if it was found
                if (t != null)
                {
                    // create a temporary copy of it
                    test = new TestInvoice_Test_Custom()
                    {
                        Active = t.Active,
                        CPTCodeList = new List<TestInvoice_Test_CPTCodes_Custom>(),
                        ID = t.ID,
                        InvoiceProviderID = t.InvoiceProviderID,
                        isCancelled = t.isCancelled,
                        isPositive = t.isPositive,
                        MRI = t.MRI,
                        AccountNumber = t.AccountNumber,
                        Notes = t.Notes,
                        NumberOfTests = t.NumberOfTests,
                        PPODiscount = t.PPODiscount,
                        ProviderID = t.ProviderID,
                        TestCost = t.TestCost,
                        TestDate = t.TestDate,
                        TestTime = t.TestTime,
                        TestID = t.TestID,
                        AmountPaidToProvider = t.AmountPaidToProvider,
                        AmountToProvider = t.AmountToProvider,
                        CalculateAmountToProvider =  t.CalculateAmountToProvider,
                        CheckNumber = t.CheckNumber,
                        Date = t.Date,
                        DateAdded = t.DateAdded,
                        DepositToProvider = t.DepositToProvider,
                        ProviderDueDate = t.ProviderDueDate
                    };
                    t.CPTCodeList.ForEach(cptCode => test.CPTCodeList.Add(new TestInvoice_Test_CPTCodes_Custom()
                    {
                        Active = cptCode.Active,
                        Amount = cptCode.Amount,
                        CPTCodeID = cptCode.CPTCodeID,
                        Description = cptCode.Description,
                        ID = cptCode.ID
                    }));
                    // save the temporary copy to session
                    _Session[testSesssionKey] = test;
                }
            }
            // otherwise, create a new surgery
            if (test == null)
            {
                test = new TestInvoice_Test_Custom()
                {
                    Active = true,
                    CPTCodeList = new List<TestInvoice_Test_CPTCodes_Custom>(),
                    ID = null,
                    InvoiceProviderID = null,
                    isCancelled = false,
                    isPositive = null,
                    MRI = 0,
                    AccountNumber = String.Empty,
                    Notes = String.Empty,
                    NumberOfTests = null,
                    PPODiscount = 0,
                    ProviderID = -1,
                    TestCost = 0,
                    TestDate = DateTime.MinValue,
                    TestTime = null,
                    TestID = -1,
                    AmountPaidToProvider = null,
                    AmountToProvider = -1,
                    CalculateAmountToProvider =  true,
                    CheckNumber = null,
                    Date = null,
                    DateAdded = DateTime.Now,
                    DepositToProvider = null,
                    ProviderDueDate = DateTime.Now.Date
                };
                // save the temporary copy to session
                _Session[testSesssionKey] = test;
            }

            return test;
        }
        #endregion

        #region RemoveTemporaryTest
        public static void RemoveTemporaryTest(HttpSessionState session, string key)
        {
            session.Remove("Test_" + key);
        }
        #endregion

        #region GetTemporarySurgery
        public SurgeryInvoice_Surgery_Custom GetTemporarySurgery(string key, int? id = null)
        {
            SurgeryInvoice_Surgery_Custom surgery = null;

            string sessionKeyName = "Surgery_" + key;
            // if the surgery is in session
            if (_Session[sessionKeyName] != null)
            {
                // use it
                surgery = (SurgeryInvoice_Surgery_Custom)_Session[sessionKeyName];
            }
            // otherwise, if there is an id for the surgery
            else if (id.HasValue)
            {
                // search for it in the temporary invoice
                SurgeryInvoice_Surgery_Custom s = (from sis in Surgeries
                                                   where sis.ID == id.Value
                                                   select sis).FirstOrDefault();
                // if it was found
                if (s != null)
                {
                    // create a temporary copy of it
                    surgery = new SurgeryInvoice_Surgery_Custom()
                    {
                        Active = s.Active,
                        ID = s.ID,
                        icdCodesList = new List<SurgeryInvoice_Surgery_ICDCode>(),
                        isInpatient = s.isInpatient,
                        Notes = s.Notes,
                        SurgeryDates = new List<DateTime>(),
                        SurgeryID = s.SurgeryID,
                        isCanceled = s.isCanceled
                    };
                    s.SurgeryDates.ForEach(date => surgery.SurgeryDates.Add(date));
                    if (surgery.SurgeryDates.Count == 0) surgery.SurgeryDates.Add(DateTime.MinValue);
                    // save the temporary copy to session
                    _Session[sessionKeyName] = surgery;
                }
                 s.icdCodesList.ForEach(icdCode => surgery.icdCodesList.Add(new SurgeryInvoice_Surgery_ICDCode()
                    {
                        Active = icdCode.Active,
                        Amount = icdCode.Amount,
                        ICDCodeID = icdCode.ICDCodeID,
                        Description = icdCode.Description,
                        ID = icdCode.ID
                    }));
            }
            // otherwise, create a new surgery
            if (surgery == null)
            {
                surgery = new SurgeryInvoice_Surgery_Custom()
                {
                    Active = true,
                    ID = 0,
                    icdCodesList = new List<SurgeryInvoice_Surgery_ICDCode>(),
                    isInpatient = true,
                    Notes = String.Empty,
                    SurgeryDates = new List<DateTime>(),
                    SurgeryID = 0
                };
                surgery.SurgeryDates.Add(DateTime.MinValue);
                // save the temporary copy to session
                _Session[sessionKeyName] = surgery;
            }

            return surgery;
        }
        #endregion

        #region RemoveTemporarySurgery
        public static void RemoveTemporarySurgery(HttpSessionState session, string key)
        {
            session.Remove("Surgery_" + key);
        }
        #endregion

        #endregion

        #region + Classes

        #region InvoiceSession
        private class InvoiceSession
        {
            public int? ID;
            public int? InvoiceNumber;
            public int? CompanyID;
            public int TypeID;
            public DateTime? DateOfAccident;
            public int StatusID;
            public int UseAttorneyTerms;
            public Boolean CustomTerms;
            public bool IsComplete;
            public int? PatientID;
            public int? InvoicePatientID;
            public int? AttorneyID;
            public int? InvoiceAttorneyID;
            public int? PhysicianID;
            public int? InvoicePhysicianID;
            public int TestTypeID;
            public List<TestInvoice_Test_Custom> Tests;
            public List<SurgeryInvoice_Surgery_Custom> Surgeries;
            public List<SurgeryInvoice_Provider_Custom> Providers;
            public List<Payment> Payments;
            public List<Comment> PaymentComments;
            public DateTime? ClosedDate;
            public DateTime? DatePaid;
            public Decimal? ServiceFeeWaived;
            public Decimal? LossesAmount;
            public List<Comment> GeneralComments;
            public decimal CalculatedCumulativeInterest;
            public decimal? YearlyInterest;
            public int? LoanTermMonths;
            public int? ServiceFeeWaivedMonths;
            public decimal TestingYearlyInterest;
            public int TestingLoanTermMonths;
            public int TestingServiceFeeWaivedMonths;
            public decimal SurgeryYearlyInterest;
            public int SurgeryLoanTermMonths;
            public int SurgeryServiceFeeWaivedMonths;
        }
        #endregion

        #endregion
    }
}