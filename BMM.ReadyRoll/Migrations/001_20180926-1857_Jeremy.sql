-- <Migration ID="60eb22ec-b750-46cf-9e43-d554f4e23994" />
GO

PRINT N'Creating [dbo].[Company]'
GO
CREATE TABLE [dbo].[Company]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) NOT NULL,
[LongName] [varchar] (500) NOT NULL,
[SiteURL] [varchar] (100) NOT NULL,
[ThemeName] [varchar] (100) NOT NULL,
[ContactFirstName] [varchar] (50) NOT NULL,
[ContactLastName] [varchar] (50) NOT NULL,
[ContactTitle] [varchar] (50) NOT NULL,
[Phone] [varchar] (50) NOT NULL,
[Fax] [varchar] (50) NOT NULL,
[Address] [varchar] (500) NOT NULL,
[CityStateZip] [varchar] (500) NOT NULL,
[FederalID] [varchar] (50) NOT NULL,
[FromEmailAddress] [varchar] (50) NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Company_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_Company_DateAdded] DEFAULT (getdate())
)
GO
PRINT N'Creating primary key [PK_Company] on [dbo].[Company]'
GO
ALTER TABLE [dbo].[Company] ADD CONSTRAINT [PK_Company] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[Attorney]'
GO
CREATE TABLE [dbo].[Attorney]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CompanyID] [int] NOT NULL,
[ContactListID] [int] NOT NULL,
[FirmID] [int] NULL,
[isActiveStatus] [bit] NOT NULL CONSTRAINT [DF_Attorney_isActiveStatus] DEFAULT ((1)),
[FirstName] [varchar] (100) NOT NULL,
[LastName] [varchar] (100) NOT NULL,
[Street1] [varchar] (100) NOT NULL,
[Street2] [varchar] (100) NULL,
[City] [varchar] (100) NOT NULL,
[StateID] [int] NOT NULL,
[ZipCode] [varchar] (50) NOT NULL,
[Phone] [varchar] (50) NOT NULL,
[Fax] [varchar] (50) NULL,
[Email] [varchar] (100) NULL,
[Notes] [text] NULL,
[DiscountNotes] [text] NULL,
[DepositAmountRequired] [decimal] (18, 4) NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Attorney_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_Attorney_DateAdded] DEFAULT (getdate()),
[Temp_AttorneyID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_Attorney] on [dbo].[Attorney]'
GO
ALTER TABLE [dbo].[Attorney] ADD CONSTRAINT [PK_Attorney] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[Firm]'
GO
CREATE TABLE [dbo].[Firm]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CompanyID] [int] NOT NULL,
[ContactListID] [int] NOT NULL,
[isActiveStatus] [bit] NOT NULL CONSTRAINT [DF_Firm_isActiveStatus] DEFAULT ((1)),
[Name] [varchar] (100) NOT NULL,
[Street1] [varchar] (100) NOT NULL,
[Street2] [varchar] (100) NULL,
[City] [varchar] (100) NOT NULL,
[StateID] [int] NOT NULL,
[ZipCode] [varchar] (50) NOT NULL,
[Phone] [varchar] (50) NOT NULL,
[Fax] [varchar] (50) NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Firm_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_Firm_DateAdded] DEFAULT (getdate())
)
GO
PRINT N'Creating primary key [PK_Firm] on [dbo].[Firm]'
GO
ALTER TABLE [dbo].[Firm] ADD CONSTRAINT [PK_Firm] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[ContactList]'
GO
CREATE TABLE [dbo].[ContactList]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Active] [bit] NOT NULL CONSTRAINT [DF_CommentType_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_CommentType_DateAdded] DEFAULT (getdate()),
[Temp_AttorneyID] [int] NULL,
[Temp_ProviderID] [int] NULL,
[Temp_PhysicianID] [int] NULL,
[Temp_FacilityID] [int] NULL,
[Temp_CompanyID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_ContactList] on [dbo].[ContactList]'
GO
ALTER TABLE [dbo].[ContactList] ADD CONSTRAINT [PK_ContactList] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[States]'
GO
CREATE TABLE [dbo].[States]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) NOT NULL,
[Abbreviation] [varchar] (2) NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_States_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_States_DateAdded] DEFAULT (getdate())
)
GO
PRINT N'Creating primary key [PK_States] on [dbo].[States]'
GO
ALTER TABLE [dbo].[States] ADD CONSTRAINT [PK_States] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[CommentType]'
GO
CREATE TABLE [dbo].[CommentType]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_ContactType_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_ContactType_DateAdded] DEFAULT (getdate())
)
GO
PRINT N'Creating primary key [PK_ContactType] on [dbo].[CommentType]'
GO
ALTER TABLE [dbo].[CommentType] ADD CONSTRAINT [PK_ContactType] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[Comments]'
GO
CREATE TABLE [dbo].[Comments]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[InvoiceID] [int] NOT NULL,
[UserID] [int] NOT NULL,
[CommentTypeID] [int] NOT NULL,
[Text] [text] NOT NULL,
[isIncludedOnReports] [bit] NOT NULL CONSTRAINT [DF_Comments_isIncludedOnReports] DEFAULT ((1)),
[Active] [bit] NOT NULL CONSTRAINT [DF_Comment_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_Comment_DateAdded] DEFAULT (getdate()),
[Temp_CompanyID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_Comment] on [dbo].[Comments]'
GO
ALTER TABLE [dbo].[Comments] ADD CONSTRAINT [PK_Comment] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating index [IX_Comments] on [dbo].[Comments]'
GO
CREATE NONCLUSTERED INDEX [IX_Comments] ON [dbo].[Comments] ([ID], [InvoiceID], [CommentTypeID], [isIncludedOnReports], [Active])
GO
PRINT N'Creating index [IX_InvoiceID] on [dbo].[Comments]'
GO
CREATE NONCLUSTERED INDEX [IX_InvoiceID] ON [dbo].[Comments] ([InvoiceID])
GO
PRINT N'Creating [dbo].[Invoice]'
GO
CREATE TABLE [dbo].[Invoice]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[InvoiceNumber] [int] NOT NULL,
[CompanyID] [int] NOT NULL,
[DateOfAccident] [datetime] NULL,
[InvoiceStatusTypeID] [int] NOT NULL,
[isComplete] [bit] NOT NULL CONSTRAINT [DF_Invoice_isComplete] DEFAULT ((0)),
[InvoicePhysicianID] [int] NULL,
[InvoiceAttorneyID] [int] NOT NULL,
[InvoicePatientID] [int] NOT NULL,
[InvoiceTypeID] [int] NOT NULL,
[TestInvoiceID] [int] NULL,
[SurgeryInvoiceID] [int] NULL,
[InvoiceClosedDate] [datetime] NULL,
[DatePaid] [datetime] NULL,
[ServiceFeeWaived] [decimal] (18, 2) NULL,
[LossesAmount] [decimal] (18, 2) NULL,
[YearlyInterest] [decimal] (18, 4) NOT NULL,
[LoanTermMonths] [int] NOT NULL,
[ServiceFeeWaivedMonths] [int] NOT NULL,
[CalculatedCumulativeIntrest] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_Invoice_CalculatedCumulativeIntrest] DEFAULT ((0)),
[Active] [bit] NOT NULL CONSTRAINT [DF_Invoice_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_Invoice_DateAdded] DEFAULT (getdate()),
[UseAttorneyTerms] [bit] NULL,
[CustomTerms] [bit] NULL
)
GO
PRINT N'Creating primary key [PK_Invoice] on [dbo].[Invoice]'
GO
ALTER TABLE [dbo].[Invoice] ADD CONSTRAINT [PK_Invoice] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating index [IX_Invoice_missing_3] on [dbo].[Invoice]'
GO
CREATE NONCLUSTERED INDEX [IX_Invoice_missing_3] ON [dbo].[Invoice] ([CompanyID], [InvoiceTypeID], [Active]) INCLUDE ([ID], [InvoiceAttorneyID], [InvoiceNumber], [InvoicePatientID], [InvoiceStatusTypeID], [SurgeryInvoiceID])
GO
PRINT N'Creating index [IX_Invoice] on [dbo].[Invoice]'
GO
CREATE NONCLUSTERED INDEX [IX_Invoice] ON [dbo].[Invoice] ([ID], [InvoiceAttorneyID], [InvoiceTypeID], [InvoicePatientID], [LossesAmount], [InvoiceStatusTypeID], [SurgeryInvoiceID], [TestInvoiceID], [LoanTermMonths], [ServiceFeeWaived], [ServiceFeeWaivedMonths], [Active])
GO
PRINT N'Creating [dbo].[Users]'
GO
CREATE TABLE [dbo].[Users]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CompanyID] [int] NOT NULL,
[FirstName] [varchar] (100) NOT NULL,
[LastName] [varchar] (100) NOT NULL,
[Email] [varchar] (100) NOT NULL,
[Position] [varchar] (100) NULL,
[Password] [varchar] (500) NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Users_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_Users_DateAdded] DEFAULT (getdate())
)
GO
PRINT N'Creating primary key [PK_Users] on [dbo].[Users]'
GO
ALTER TABLE [dbo].[Users] ADD CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[Contacts]'
GO
CREATE TABLE [dbo].[Contacts]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ContactListID] [int] NOT NULL,
[Name] [varchar] (100) NOT NULL,
[Position] [varchar] (50) NOT NULL,
[Phone] [varchar] (50) NULL,
[Email] [varchar] (50) NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Contacts_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_Contacts_DateAdded] DEFAULT (getdate()),
[Temp_CompanyID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_Contacts] on [dbo].[Contacts]'
GO
ALTER TABLE [dbo].[Contacts] ADD CONSTRAINT [PK_Contacts] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[CPTCodes_BAD]'
GO
CREATE TABLE [dbo].[CPTCodes_BAD]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CompanyID] [int] NOT NULL,
[Code] [varchar] (50) NOT NULL,
[Description] [text] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_CPTCodes_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_CPTCodes_DateAdded] DEFAULT (getdate())
)
GO
PRINT N'Creating primary key [PK_CPTCodes] on [dbo].[CPTCodes_BAD]'
GO
ALTER TABLE [dbo].[CPTCodes_BAD] ADD CONSTRAINT [PK_CPTCodes] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[InvoiceAttorney]'
GO
CREATE TABLE [dbo].[InvoiceAttorney]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AttorneyID] [int] NOT NULL,
[InvoiceContactListID] [int] NOT NULL,
[InvoiceFirmID] [int] NULL,
[isActiveStatus] [bit] NOT NULL CONSTRAINT [DF_InvoiceAttorneyLog_isActiveStatus] DEFAULT ((1)),
[FirstName] [varchar] (100) NOT NULL,
[LastName] [varchar] (100) NOT NULL,
[Street1] [varchar] (500) NOT NULL,
[Street2] [varchar] (500) NULL,
[City] [varchar] (500) NOT NULL,
[StateID] [int] NOT NULL,
[ZipCode] [varchar] (500) NOT NULL,
[Phone] [varchar] (50) NOT NULL,
[Fax] [varchar] (50) NULL,
[Email] [varchar] (100) NULL,
[Notes] [text] NULL,
[DiscountNotes] [text] NULL,
[DepositAmountRequired] [decimal] (18, 2) NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_InvoiceAttorneyLog_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_InvoiceAttorneyLog_DateAdded] DEFAULT (getdate()),
[Temp_InvoiceNumber] [int] NULL,
[Temp_AttorneyID] [int] NULL,
[Temp_CompanyID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_InvoiceAttorneyLog] on [dbo].[InvoiceAttorney]'
GO
ALTER TABLE [dbo].[InvoiceAttorney] ADD CONSTRAINT [PK_InvoiceAttorneyLog] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating index [IX_InvoiceAttorney_missing_43] on [dbo].[InvoiceAttorney]'
GO
CREATE NONCLUSTERED INDEX [IX_InvoiceAttorney_missing_43] ON [dbo].[InvoiceAttorney] ([Active]) INCLUDE ([AttorneyID], [ID], [InvoiceFirmID])
GO
PRINT N'Creating [dbo].[InvoiceStatusType]'
GO
CREATE TABLE [dbo].[InvoiceStatusType]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_InvoiceStatusType_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_InvoiceStatusType_DateAdded] DEFAULT (getdate())
)
GO
PRINT N'Creating primary key [PK_InvoiceStatusType] on [dbo].[InvoiceStatusType]'
GO
ALTER TABLE [dbo].[InvoiceStatusType] ADD CONSTRAINT [PK_InvoiceStatusType] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[InvoiceType]'
GO
CREATE TABLE [dbo].[InvoiceType]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_InvoiceType_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_InvoiceType_DateAdded] DEFAULT (getdate())
)
GO
PRINT N'Creating primary key [PK_InvoiceType] on [dbo].[InvoiceType]'
GO
ALTER TABLE [dbo].[InvoiceType] ADD CONSTRAINT [PK_InvoiceType] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[InvoicePatient]'
GO
CREATE TABLE [dbo].[InvoicePatient]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[PatientID] [int] NOT NULL,
[isActiveStatus] [bit] NOT NULL CONSTRAINT [DF_InvoicePatient_isActiveStatus] DEFAULT ((1)),
[FirstName] [varchar] (500) NOT NULL,
[LastName] [varchar] (500) NOT NULL,
[SSN] [varchar] (500) NOT NULL,
[Street1] [varchar] (500) NOT NULL,
[Street2] [varchar] (500) NULL,
[City] [varchar] (500) NOT NULL,
[StateID] [int] NOT NULL,
[ZipCode] [varchar] (500) NOT NULL,
[Phone] [varchar] (500) NOT NULL,
[WorkPhone] [varchar] (500) NULL,
[DateOfBirth] [date] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_InvoicePatient_Active] DEFAULT ((1)),
[DateAdded] [datetime] NULL CONSTRAINT [DF_InvoicePatient_DateAdded] DEFAULT (getdate()),
[Temp_CompanyID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_InvoicePatient] on [dbo].[InvoicePatient]'
GO
ALTER TABLE [dbo].[InvoicePatient] ADD CONSTRAINT [PK_InvoicePatient] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating index [IX_InvoicePatient_missing_15] on [dbo].[InvoicePatient]'
GO
CREATE NONCLUSTERED INDEX [IX_InvoicePatient_missing_15] ON [dbo].[InvoicePatient] ([PatientID], [Active])
GO
PRINT N'Creating [dbo].[InvoicePhysician]'
GO
CREATE TABLE [dbo].[InvoicePhysician]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[InvoiceContactListID] [int] NOT NULL,
[PhysicianID] [int] NOT NULL,
[isActiveStatus] [bit] NOT NULL CONSTRAINT [DF_InvoicePhysician_isActiveStatus] DEFAULT ((1)),
[FirstName] [varchar] (50) NOT NULL,
[LastName] [varchar] (50) NOT NULL,
[Street1] [varchar] (500) NOT NULL,
[Street2] [varchar] (500) NULL,
[City] [varchar] (500) NOT NULL,
[StateID] [int] NOT NULL,
[ZipCode] [varchar] (500) NOT NULL,
[Phone] [varchar] (50) NOT NULL,
[Fax] [varchar] (50) NULL,
[EmailAddress] [varchar] (100) NULL,
[Notes] [text] NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_InvoicePhysician_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_InvoicePhysician_DateAdded] DEFAULT (getdate()),
[Temp_InvoiceNumber] [int] NULL,
[Temp_PhysicianID] [int] NULL,
[Temp_CompanyID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_InvoicePhysician] on [dbo].[InvoicePhysician]'
GO
ALTER TABLE [dbo].[InvoicePhysician] ADD CONSTRAINT [PK_InvoicePhysician] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[SurgeryInvoice]'
GO
CREATE TABLE [dbo].[SurgeryInvoice]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Active] [bit] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_SurgeryInvoice_DateAdded] DEFAULT (getdate()),
[Temp_InvoiceID] [int] NULL,
[Temp_CompanyID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_SurgeryInvoice] on [dbo].[SurgeryInvoice]'
GO
ALTER TABLE [dbo].[SurgeryInvoice] ADD CONSTRAINT [PK_SurgeryInvoice] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[TestInvoice]'
GO
CREATE TABLE [dbo].[TestInvoice]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[TestTypeID] [int] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_TestInvoice_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_TestInvoice_DateAdded] DEFAULT (getdate()),
[Temp_TestNo] [int] NULL,
[Temp_InvoiceID] [int] NULL,
[Temp_CompanyID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_TestInvoice] on [dbo].[TestInvoice]'
GO
ALTER TABLE [dbo].[TestInvoice] ADD CONSTRAINT [PK_TestInvoice] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[InvoiceContactList]'
GO
CREATE TABLE [dbo].[InvoiceContactList]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Active] [bit] NOT NULL CONSTRAINT [DF_ContactListLog_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_ContactListLog_DateAdded] DEFAULT (getdate()),
[Temp_AttorneyID] [int] NULL,
[Temp_PhysicianID] [int] NULL,
[Temp_ProviderID] [int] NULL,
[Temp_Invoice] [int] NULL,
[Temp_FacilityID] [int] NULL,
[Temp_CompanyID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_ContactListLog] on [dbo].[InvoiceContactList]'
GO
ALTER TABLE [dbo].[InvoiceContactList] ADD CONSTRAINT [PK_ContactListLog] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[InvoiceFirm]'
GO
CREATE TABLE [dbo].[InvoiceFirm]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[FirmID] [int] NOT NULL,
[InvoiceContactListID] [int] NOT NULL,
[isActiveStatus] [bit] NOT NULL CONSTRAINT [DF_InvoiceFirm_isActiveStatus] DEFAULT ((1)),
[Name] [varchar] (100) NOT NULL,
[Street1] [varchar] (500) NOT NULL,
[Street2] [varchar] (500) NULL,
[City] [varchar] (500) NOT NULL,
[StateID] [int] NOT NULL,
[ZipCode] [varchar] (500) NOT NULL,
[Phone] [varchar] (50) NOT NULL,
[Fax] [varchar] (50) NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_InvoiceFirm_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_InvoiceFirm_DateAdded] DEFAULT (getdate()),
[Temp_CompanyID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_InvoiceFirm] on [dbo].[InvoiceFirm]'
GO
ALTER TABLE [dbo].[InvoiceFirm] ADD CONSTRAINT [PK_InvoiceFirm] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[InvoiceChangeLog]'
GO
CREATE TABLE [dbo].[InvoiceChangeLog]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[InvoiceID] [int] NOT NULL,
[InvoiceChangeLogTypeID] [int] NOT NULL,
[Amount] [decimal] (18, 2) NOT NULL,
[UserID] [int] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_InvoiceChangeLog_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_InvoiceChangeLog_DateAdded] DEFAULT (getdate()),
[Temp_CompanyID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_InvoiceChangeLog] on [dbo].[InvoiceChangeLog]'
GO
ALTER TABLE [dbo].[InvoiceChangeLog] ADD CONSTRAINT [PK_InvoiceChangeLog] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[InvoiceChangeLogType]'
GO
CREATE TABLE [dbo].[InvoiceChangeLogType]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_InvoiceChangeLogType_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_InvoiceChangeLogType_DateAdded] DEFAULT (getdate())
)
GO
PRINT N'Creating primary key [PK_InvoiceChangeLogType] on [dbo].[InvoiceChangeLogType]'
GO
ALTER TABLE [dbo].[InvoiceChangeLogType] ADD CONSTRAINT [PK_InvoiceChangeLogType] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[InvoiceContacts]'
GO
CREATE TABLE [dbo].[InvoiceContacts]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[InvoiceContactListID] [int] NOT NULL,
[Name] [varchar] (100) NOT NULL,
[Position] [varchar] (50) NOT NULL,
[Phone] [varchar] (50) NULL,
[Email] [varchar] (50) NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_InvoiceContacts_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_InvoiceContacts_DateAdded] DEFAULT (getdate()),
[Temp_CompanyID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_InvoiceContacts] on [dbo].[InvoiceContacts]'
GO
ALTER TABLE [dbo].[InvoiceContacts] ADD CONSTRAINT [PK_InvoiceContacts] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[InvoiceInterestCalculationLog]'
GO
CREATE TABLE [dbo].[InvoiceInterestCalculationLog]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[InvoiceID] [int] NOT NULL,
[YearlyInterest] [decimal] (18, 4) NOT NULL,
[ServiceFeeWaivedMonths] [int] NOT NULL,
[AmortizationDate] [date] NULL,
[DateInterestBegins] [date] NULL,
[TotalCost] [decimal] (18, 2) NOT NULL,
[TotalPPODiscount] [decimal] (18, 2) NOT NULL,
[TotalAppliedPayments] [decimal] (18, 2) NOT NULL,
[BalanceDue] [decimal] (18, 2) NOT NULL,
[CalculatedInterest] [decimal] (18, 2) NOT NULL,
[PreviousCumulativeInterest] [decimal] (18, 2) NOT NULL,
[NewCumulativeInterest] [decimal] (18, 2) NOT NULL,
[DateAdded] [datetime] NOT NULL
)
GO
PRINT N'Creating primary key [PK_InvoiceInterestCalculationLog] on [dbo].[InvoiceInterestCalculationLog]'
GO
ALTER TABLE [dbo].[InvoiceInterestCalculationLog] ADD CONSTRAINT [PK_InvoiceInterestCalculationLog] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating index [IX_InvoiceInterestCalculationLog_missing_5] on [dbo].[InvoiceInterestCalculationLog]'
GO
CREATE NONCLUSTERED INDEX [IX_InvoiceInterestCalculationLog_missing_5] ON [dbo].[InvoiceInterestCalculationLog] ([DateAdded]) INCLUDE ([InvoiceID])
GO
PRINT N'Creating index [IX_InvoiceInterestCalculationLog] on [dbo].[InvoiceInterestCalculationLog]'
GO
CREATE NONCLUSTERED INDEX [IX_InvoiceInterestCalculationLog] ON [dbo].[InvoiceInterestCalculationLog] ([InvoiceID])
GO
PRINT N'Creating [dbo].[Patient]'
GO
CREATE TABLE [dbo].[Patient]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CompanyID] [int] NOT NULL,
[isActiveStatus] [bit] NOT NULL CONSTRAINT [DF_Patient_isActiveStatus] DEFAULT ((1)),
[FirstName] [varchar] (500) NOT NULL,
[LastName] [varchar] (500) NOT NULL,
[SSN] [varchar] (500) NOT NULL,
[Street1] [varchar] (500) NOT NULL,
[Street2] [varchar] (500) NULL,
[City] [varchar] (500) NOT NULL,
[StateID] [int] NOT NULL,
[ZipCode] [varchar] (500) NOT NULL,
[Phone] [varchar] (500) NOT NULL,
[WorkPhone] [varchar] (500) NULL,
[DateOfBirth] [date] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Patient_Active] DEFAULT ((1)),
[DateAdded] [datetime] NULL CONSTRAINT [DF_Patient_DateAdded] DEFAULT (getdate()),
[Temp_InvoiceID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_Patient] on [dbo].[Patient]'
GO
ALTER TABLE [dbo].[Patient] ADD CONSTRAINT [PK_Patient] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating index [IX_Patient] on [dbo].[Patient]'
GO
CREATE NONCLUSTERED INDEX [IX_Patient] ON [dbo].[Patient] ([ID], [Active])
GO
PRINT N'Creating [dbo].[Physician]'
GO
CREATE TABLE [dbo].[Physician]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CompanyID] [int] NOT NULL,
[ContactListID] [int] NOT NULL,
[isActiveStatus] [bit] NOT NULL CONSTRAINT [DF_Physician_isActiveStatus] DEFAULT ((1)),
[FirstName] [varchar] (50) NOT NULL,
[LastName] [varchar] (50) NOT NULL,
[Street1] [varchar] (500) NOT NULL,
[Street2] [varchar] (500) NULL,
[City] [varchar] (500) NOT NULL,
[StateID] [int] NOT NULL,
[ZipCode] [varchar] (500) NOT NULL,
[Phone] [varchar] (50) NOT NULL,
[Fax] [varchar] (50) NULL,
[EmailAddress] [varchar] (100) NULL,
[Notes] [text] NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Physicians_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_Physicians_DateAdded] DEFAULT (getdate()),
[Temp_PhysicianID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_Physicians] on [dbo].[Physician]'
GO
ALTER TABLE [dbo].[Physician] ADD CONSTRAINT [PK_Physicians] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[InvoiceProvider]'
GO
CREATE TABLE [dbo].[InvoiceProvider]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[InvoiceContactListID] [int] NOT NULL,
[ProviderID] [int] NOT NULL,
[isActiveStatus] [bit] NOT NULL CONSTRAINT [DF_InvoiceProvider_isActiveStatus] DEFAULT ((1)),
[Name] [varchar] (500) NOT NULL,
[Street1] [varchar] (500) NOT NULL,
[Street2] [varchar] (500) NULL,
[City] [varchar] (500) NOT NULL,
[StateID] [int] NOT NULL,
[ZipCode] [varchar] (500) NOT NULL,
[Phone] [varchar] (50) NOT NULL,
[Fax] [varchar] (50) NULL,
[Email] [varchar] (100) NULL,
[Notes] [text] NULL,
[FacilityAbbreviation] [varchar] (50) NULL,
[DiscountPercentage] [decimal] (18, 4) NULL,
[MRICostTypeID] [int] NOT NULL,
[MRICostFlatRate] [decimal] (18, 2) NULL,
[MRICostPercentage] [decimal] (18, 4) NULL,
[DaysUntilPaymentDue] [int] NULL,
[Deposits] [decimal] (18, 2) NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_InvoiceProvider_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_InvoiceProvider_DateAdded] DEFAULT (getdate()),
[Temp_ProviderID] [int] NULL,
[Temp_InvoiceID] [int] NULL,
[Temp_CompanyID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_InvoiceProvider] on [dbo].[InvoiceProvider]'
GO
ALTER TABLE [dbo].[InvoiceProvider] ADD CONSTRAINT [PK_InvoiceProvider] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating index [IX_InvoiceProvider] on [dbo].[InvoiceProvider]'
GO
CREATE NONCLUSTERED INDEX [IX_InvoiceProvider] ON [dbo].[InvoiceProvider] ([ID], [MRICostFlatRate], [MRICostPercentage], [MRICostTypeID], [ProviderID], [Deposits], [Active])
GO
PRINT N'Creating [dbo].[MRICostType]'
GO
CREATE TABLE [dbo].[MRICostType]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_MRICostType_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_MRICostType_DateAdded] DEFAULT (getdate())
)
GO
PRINT N'Creating primary key [PK_MRICostType] on [dbo].[MRICostType]'
GO
ALTER TABLE [dbo].[MRICostType] ADD CONSTRAINT [PK_MRICostType] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[Provider]'
GO
CREATE TABLE [dbo].[Provider]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CompanyID] [int] NOT NULL,
[ContactListID] [int] NOT NULL,
[isActiveStatus] [bit] NOT NULL CONSTRAINT [DF_Providers_isActiveStatus] DEFAULT ((1)),
[Name] [varchar] (500) NOT NULL,
[Street1] [varchar] (500) NOT NULL,
[Street2] [varchar] (500) NULL,
[City] [varchar] (500) NOT NULL,
[StateID] [int] NOT NULL,
[ZipCode] [varchar] (500) NOT NULL,
[Phone] [varchar] (50) NOT NULL,
[Fax] [varchar] (50) NULL,
[Email] [varchar] (100) NULL,
[Street1_Billing] [varchar] (500) NULL,
[Street2_Billing] [varchar] (500) NULL,
[City_Billing] [varchar] (500) NULL,
[StateID_Billing] [int] NULL,
[ZipCode_Billing] [varchar] (500) NULL,
[Phone_Billing] [varchar] (50) NULL,
[Fax_Billing] [varchar] (50) NULL,
[Email_Billing] [varchar] (100) NULL,
[Notes] [text] NULL,
[FacilityAbbreviation] [varchar] (50) NULL,
[DiscountPercentage] [decimal] (18, 4) NULL,
[MRICostTypeID] [int] NOT NULL,
[MRICostFlatRate] [decimal] (18, 2) NULL,
[MRICostPercentage] [decimal] (18, 4) NULL,
[DaysUntilPaymentDue] [int] NULL,
[Deposits] [decimal] (18, 2) NULL,
[TaxID] [varchar] (50) NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Providers_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_Providers_DateAdded] DEFAULT (getdate()),
[Temp_ProviderID] [int] NULL,
[Temp_Type] [nchar] (10) NULL
)
GO
PRINT N'Creating primary key [PK_Providers] on [dbo].[Provider]'
GO
ALTER TABLE [dbo].[Provider] ADD CONSTRAINT [PK_Providers] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating index [IX_Provider] on [dbo].[Provider]'
GO
CREATE NONCLUSTERED INDEX [IX_Provider] ON [dbo].[Provider] ([ID], [DiscountPercentage], [MRICostFlatRate], [MRICostTypeID], [MRICostPercentage], [Active])
GO
PRINT N'Creating [dbo].[LoanTerms]'
GO
CREATE TABLE [dbo].[LoanTerms]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CompanyID] [int] NOT NULL,
[Testing_YearlyInterest] [decimal] (18, 4) NOT NULL,
[Testing_LoanTermMonths] [int] NOT NULL,
[Testing_ServiceFeeWaivedMonths] [int] NOT NULL,
[Surgery_YearlyInterest] [decimal] (18, 4) NOT NULL,
[Surgery_LoanTermMonths] [int] NOT NULL,
[Surgery_ServiceFeeWaivedMonths] [int] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_LoanTerms_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_LoanTerms_DateAdded] DEFAULT (getdate())
)
GO
PRINT N'Creating primary key [PK_LoanTerms] on [dbo].[LoanTerms]'
GO
ALTER TABLE [dbo].[LoanTerms] ADD CONSTRAINT [PK_LoanTerms] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[PatientChangeLog]'
GO
CREATE TABLE [dbo].[PatientChangeLog]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[PatientID] [int] NOT NULL,
[UserID] [int] NOT NULL,
[InformationUpdated] [text] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_PatientChangeLog_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_PatientChangeLog_DateAdded] DEFAULT (getdate()),
[Temp_CompanyID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_PatientChangeLog] on [dbo].[PatientChangeLog]'
GO
ALTER TABLE [dbo].[PatientChangeLog] ADD CONSTRAINT [PK_PatientChangeLog] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[Payments]'
GO
CREATE TABLE [dbo].[Payments]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[InvoiceID] [int] NOT NULL,
[PaymentTypeID] [int] NOT NULL,
[DatePaid] [datetime] NOT NULL,
[Amount] [decimal] (18, 2) NOT NULL,
[CheckNumber] [varchar] (50) NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Payments_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_Payments_DateAdded] DEFAULT (getdate()),
[Temp_CompanyID] [int] NULL,
[Temp_InvoiceID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_Payments] on [dbo].[Payments]'
GO
ALTER TABLE [dbo].[Payments] ADD CONSTRAINT [PK_Payments] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating index [IX_Payments_missing_305] on [dbo].[Payments]'
GO
CREATE NONCLUSTERED INDEX [IX_Payments_missing_305] ON [dbo].[Payments] ([Active], [DatePaid]) INCLUDE ([Amount], [InvoiceID])
GO
PRINT N'Creating index [IX_Payments] on [dbo].[Payments]'
GO
CREATE NONCLUSTERED INDEX [IX_Payments] ON [dbo].[Payments] ([ID], [Amount], [DatePaid], [InvoiceID], [CheckNumber], [PaymentTypeID], [Active])
GO
PRINT N'Creating index [IX_InvoiceID] on [dbo].[Payments]'
GO
CREATE NONCLUSTERED INDEX [IX_InvoiceID] ON [dbo].[Payments] ([InvoiceID])
GO
PRINT N'Creating index [IX_Payments_missing_50] on [dbo].[Payments]'
GO
CREATE NONCLUSTERED INDEX [IX_Payments_missing_50] ON [dbo].[Payments] ([PaymentTypeID], [DatePaid]) INCLUDE ([InvoiceID])
GO
PRINT N'Creating [dbo].[PaymentType]'
GO
CREATE TABLE [dbo].[PaymentType]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_PaymentType_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_PaymentType_DateAdded] DEFAULT (getdate())
)
GO
PRINT N'Creating primary key [PK_PaymentType] on [dbo].[PaymentType]'
GO
ALTER TABLE [dbo].[PaymentType] ADD CONSTRAINT [PK_PaymentType] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[SurgeryInvoice_Provider_CPTCodes]'
GO
CREATE TABLE [dbo].[SurgeryInvoice_Provider_CPTCodes]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SurgeryInvoice_ProviderID] [int] NOT NULL,
[CPTCodeID] [int] NOT NULL,
[Amount] [decimal] (18, 2) NOT NULL,
[Description] [text] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Invoice_CPTCodes_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_Invoice_CPTCodes_DateAdded] DEFAULT (getdate()),
[Temp_CompanyID] [int] NULL,
[Temp_InvoiceID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_Provider_CPTCodes] on [dbo].[SurgeryInvoice_Provider_CPTCodes]'
GO
ALTER TABLE [dbo].[SurgeryInvoice_Provider_CPTCodes] ADD CONSTRAINT [PK_Provider_CPTCodes] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating index [IX_SurgeryInvoice_Provider_CPTCodes_missing_27] on [dbo].[SurgeryInvoice_Provider_CPTCodes]'
GO
CREATE NONCLUSTERED INDEX [IX_SurgeryInvoice_Provider_CPTCodes_missing_27] ON [dbo].[SurgeryInvoice_Provider_CPTCodes] ([SurgeryInvoice_ProviderID], [Active]) INCLUDE ([Amount])
GO
PRINT N'Creating [dbo].[Surgery]'
GO
CREATE TABLE [dbo].[Surgery]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CompanyID] [int] NOT NULL,
[Name] [varchar] (100) NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Surgery_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_Surgery_DateAdded] DEFAULT (getdate())
)
GO
PRINT N'Creating primary key [PK_Surgery] on [dbo].[Surgery]'
GO
ALTER TABLE [dbo].[Surgery] ADD CONSTRAINT [PK_Surgery] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating index [IX_Surgery] on [dbo].[Surgery]'
GO
CREATE NONCLUSTERED INDEX [IX_Surgery] ON [dbo].[Surgery] ([ID], [Active])
GO
PRINT N'Creating [dbo].[SurgeryInvoice_Surgery]'
GO
CREATE TABLE [dbo].[SurgeryInvoice_Surgery]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SurgeryInvoiceID] [int] NOT NULL,
[SurgeryID] [int] NOT NULL,
[isInpatient] [bit] NOT NULL,
[Notes] [text] NULL,
[isCanceled] [bit] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Surgery_isCanceled] DEFAULT ((0)),
[Active] [bit] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Surgery_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Surgery_DateAdded] DEFAULT (getdate()),
[Temp_InvoiceID] [int] NULL,
[Temp_CompanyID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_SurgeryInvoice_Surgery] on [dbo].[SurgeryInvoice_Surgery]'
GO
ALTER TABLE [dbo].[SurgeryInvoice_Surgery] ADD CONSTRAINT [PK_SurgeryInvoice_Surgery] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating index [IX_SurgeryInvoice_Surgery] on [dbo].[SurgeryInvoice_Surgery]'
GO
CREATE NONCLUSTERED INDEX [IX_SurgeryInvoice_Surgery] ON [dbo].[SurgeryInvoice_Surgery] ([ID], [SurgeryInvoiceID], [SurgeryID], [Active])
GO
PRINT N'Creating index [IX_SurgeryInvoice_Surgery_ID] on [dbo].[SurgeryInvoice_Surgery]'
GO
CREATE NONCLUSTERED INDEX [IX_SurgeryInvoice_Surgery_ID] ON [dbo].[SurgeryInvoice_Surgery] ([SurgeryInvoiceID], [SurgeryID])
GO
PRINT N'Creating [dbo].[SurgeryInvoice_SurgeryDates]'
GO
CREATE TABLE [dbo].[SurgeryInvoice_SurgeryDates]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SurgeryInvoice_SurgeryID] [int] NOT NULL,
[ScheduledDate] [datetime] NOT NULL,
[isPrimaryDate] [bit] NOT NULL CONSTRAINT [DF_SurgeryInvoice_SurgeryDates_isPrimaryDate] DEFAULT ((0)),
[Active] [bit] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Dates_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Dates_DateAdded] DEFAULT (getdate()),
[Temp_CompanyID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_SurgeryInvoice_Dates] on [dbo].[SurgeryInvoice_SurgeryDates]'
GO
ALTER TABLE [dbo].[SurgeryInvoice_SurgeryDates] ADD CONSTRAINT [PK_SurgeryInvoice_Dates] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating index [IX_SurgeryInvoice_SurgeryDates] on [dbo].[SurgeryInvoice_SurgeryDates]'
GO
CREATE NONCLUSTERED INDEX [IX_SurgeryInvoice_SurgeryDates] ON [dbo].[SurgeryInvoice_SurgeryDates] ([ID], [ScheduledDate], [SurgeryInvoice_SurgeryID], [isPrimaryDate], [Active])
GO
PRINT N'Creating [dbo].[SurgeryInvoice_Providers]'
GO
CREATE TABLE [dbo].[SurgeryInvoice_Providers]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SurgeryInvoiceID] [int] NOT NULL,
[InvoiceProviderID] [int] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Providers_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Providers_DateAdded] DEFAULT (getdate()),
[Temp_InvoiceID] [int] NULL,
[Temp_ProviderID] [int] NULL,
[Temp_ServiceID] [int] NULL,
[Temp_CompanyID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_SurgeryInvoice_Providers] on [dbo].[SurgeryInvoice_Providers]'
GO
ALTER TABLE [dbo].[SurgeryInvoice_Providers] ADD CONSTRAINT [PK_SurgeryInvoice_Providers] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating index [IX_SurgeryInvoice_Providers] on [dbo].[SurgeryInvoice_Providers]'
GO
CREATE NONCLUSTERED INDEX [IX_SurgeryInvoice_Providers] ON [dbo].[SurgeryInvoice_Providers] ([ID], [InvoiceProviderID], [SurgeryInvoiceID], [Active])
GO
PRINT N'Creating index [IS_SurgeryInvoiceID] on [dbo].[SurgeryInvoice_Providers]'
GO
CREATE NONCLUSTERED INDEX [IS_SurgeryInvoiceID] ON [dbo].[SurgeryInvoice_Providers] ([SurgeryInvoiceID])
GO
PRINT N'Creating [dbo].[SurgeryInvoice_Provider_Payments]'
GO
CREATE TABLE [dbo].[SurgeryInvoice_Provider_Payments]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SurgeryInvoice_ProviderID] [int] NOT NULL,
[PaymentTypeID] [int] NOT NULL,
[DatePaid] [datetime] NOT NULL,
[Amount] [decimal] (18, 2) NOT NULL,
[CheckNumber] [varchar] (50) NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Provider_Payments_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Provider_Payments_DateAdded] DEFAULT (getdate()),
[Temp_CompanyID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_SurgeryInvoice_Provider_Payments] on [dbo].[SurgeryInvoice_Provider_Payments]'
GO
ALTER TABLE [dbo].[SurgeryInvoice_Provider_Payments] ADD CONSTRAINT [PK_SurgeryInvoice_Provider_Payments] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating index [IX_SurgeryInvoice_Provider_Payments] on [dbo].[SurgeryInvoice_Provider_Payments]'
GO
CREATE NONCLUSTERED INDEX [IX_SurgeryInvoice_Provider_Payments] ON [dbo].[SurgeryInvoice_Provider_Payments] ([ID], [Amount], [DatePaid], [PaymentTypeID], [SurgeryInvoice_ProviderID], [Active])
GO
PRINT N'Creating index [IX_SurgeryInvoice_Provider_Payments_missing_88] on [dbo].[SurgeryInvoice_Provider_Payments]'
GO
CREATE NONCLUSTERED INDEX [IX_SurgeryInvoice_Provider_Payments_missing_88] ON [dbo].[SurgeryInvoice_Provider_Payments] ([SurgeryInvoice_ProviderID], [Active])
GO
PRINT N'Creating [dbo].[SurgeryInvoice_Provider_Services]'
GO
CREATE TABLE [dbo].[SurgeryInvoice_Provider_Services]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SurgeryInvoice_ProviderID] [int] NOT NULL,
[EstimatedCost] [decimal] (18, 2) NULL,
[Cost] [decimal] (18, 2) NOT NULL,
[Discount] [decimal] (18, 2) NOT NULL,
[PPODiscount] [decimal] (18, 2) NOT NULL,
[DueDate] [datetime] NOT NULL,
[AmountDue] [decimal] (18, 2) NOT NULL,
[CalculateAmountDue] [bit] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Provider_Services_CalculateAmountDue] DEFAULT ((1)),
[AccountNumber] [varchar] (100) NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Provider_Services_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Provider_Services_DateAdded] DEFAULT (getdate()),
[Temp_ServiceID] [int] NULL,
[Temp_CompanyID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_SurgeryInvoice_Provider_Services] on [dbo].[SurgeryInvoice_Provider_Services]'
GO
ALTER TABLE [dbo].[SurgeryInvoice_Provider_Services] ADD CONSTRAINT [PK_SurgeryInvoice_Provider_Services] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating index [IX_SurgeryInvoice_Provider_Services_missing_21] on [dbo].[SurgeryInvoice_Provider_Services]'
GO
CREATE NONCLUSTERED INDEX [IX_SurgeryInvoice_Provider_Services_missing_21] ON [dbo].[SurgeryInvoice_Provider_Services] ([Active]) INCLUDE ([Cost], [PPODiscount], [SurgeryInvoice_ProviderID])
GO
PRINT N'Creating index [IX_SurgeryInvoice_Provider_Services] on [dbo].[SurgeryInvoice_Provider_Services]'
GO
CREATE NONCLUSTERED INDEX [IX_SurgeryInvoice_Provider_Services] ON [dbo].[SurgeryInvoice_Provider_Services] ([ID], [AmountDue], [Cost], [PPODiscount], [EstimatedCost], [DueDate], [SurgeryInvoice_ProviderID], [Active])
GO
PRINT N'Creating index [IX_SurgeryInvoice_Provider_Services_missing_7] on [dbo].[SurgeryInvoice_Provider_Services]'
GO
CREATE NONCLUSTERED INDEX [IX_SurgeryInvoice_Provider_Services_missing_7] ON [dbo].[SurgeryInvoice_Provider_Services] ([SurgeryInvoice_ProviderID]) INCLUDE ([Cost])
GO
PRINT N'Creating index [IX_SurgeryInvoice_Provider_Services_missing_9] on [dbo].[SurgeryInvoice_Provider_Services]'
GO
CREATE NONCLUSTERED INDEX [IX_SurgeryInvoice_Provider_Services_missing_9] ON [dbo].[SurgeryInvoice_Provider_Services] ([SurgeryInvoice_ProviderID]) INCLUDE ([PPODiscount])
GO
PRINT N'Creating index [IX_SurgeryInvoice_Provider_Services_missing_19] on [dbo].[SurgeryInvoice_Provider_Services]'
GO
CREATE NONCLUSTERED INDEX [IX_SurgeryInvoice_Provider_Services_missing_19] ON [dbo].[SurgeryInvoice_Provider_Services] ([SurgeryInvoice_ProviderID], [Active]) INCLUDE ([Cost], [PPODiscount])
GO
PRINT N'Creating [dbo].[ICDCodes]'
GO
CREATE TABLE [dbo].[ICDCodes]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ShortDescription] [nvarchar] (255) NOT NULL,
[LongDescription] [nvarchar] (500) NOT NULL,
[ICDVersion] [nvarchar] (20) NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_ICDCodes_Active] DEFAULT ((1)),
[CompanyID] [int] NOT NULL,
[Code] [nvarchar] (50) NOT NULL
)
GO
PRINT N'Creating primary key [PK_ICDCodes] on [dbo].[ICDCodes]'
GO
ALTER TABLE [dbo].[ICDCodes] ADD CONSTRAINT [PK_ICDCodes] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[SurgeryInvoice_Surgery_ICDCodes]'
GO
CREATE TABLE [dbo].[SurgeryInvoice_Surgery_ICDCodes]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SurgeryInvoice_SurgeryID] [int] NOT NULL,
[ICDCodeID] [int] NOT NULL,
[Amount] [decimal] (18, 2) NULL,
[Description] [text] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Provider_ICDCodes_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL,
[Temp_CompanyID] [int] NOT NULL
)
GO
PRINT N'Creating primary key [PK_SurgeryInvoice_Provider_ICDCodes] on [dbo].[SurgeryInvoice_Surgery_ICDCodes]'
GO
ALTER TABLE [dbo].[SurgeryInvoice_Surgery_ICDCodes] ADD CONSTRAINT [PK_SurgeryInvoice_Provider_ICDCodes] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[Test]'
GO
CREATE TABLE [dbo].[Test]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CompanyID] [int] NOT NULL,
[Name] [varchar] (100) NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Test_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_Test_DateAdded] DEFAULT (getdate()),
[Temp_TestTypeID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_Test] on [dbo].[Test]'
GO
ALTER TABLE [dbo].[Test] ADD CONSTRAINT [PK_Test] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[TestInvoice_Test]'
GO
CREATE TABLE [dbo].[TestInvoice_Test]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[TestInvoiceID] [int] NOT NULL,
[TestID] [int] NOT NULL,
[InvoiceProviderID] [int] NOT NULL,
[Notes] [varchar] (500) NOT NULL,
[TestDate] [datetime] NOT NULL,
[TestTime] [time] (0) NULL,
[NumberOfTests] [int] NULL,
[MRI] [int] NOT NULL,
[IsPositive] [bit] NULL,
[isCanceled] [bit] NOT NULL,
[TestCost] [decimal] (18, 2) NOT NULL,
[PPODiscount] [decimal] (18, 2) NOT NULL,
[AmountToProvider] [decimal] (18, 2) NOT NULL,
[CalculateAmountToProvider] [bit] NOT NULL CONSTRAINT [DF_TestInvoice_Test_CalculateAmountToProvider] DEFAULT ((1)),
[ProviderDueDate] [datetime] NOT NULL,
[DepositToProvider] [decimal] (18, 2) NULL,
[AmountPaidToProvider] [decimal] (18, 2) NULL,
[Date] [datetime] NULL,
[CheckNumber] [varchar] (50) NULL,
[AccountNumber] [varchar] (100) NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_TestInvoice_Test_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_TestInvoice_Test_DateAdded] DEFAULT (getdate()),
[Temp_InvoiceID] [int] NULL,
[Temp_CompanyID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_TestInvoice_Test] on [dbo].[TestInvoice_Test]'
GO
ALTER TABLE [dbo].[TestInvoice_Test] ADD CONSTRAINT [PK_TestInvoice_Test] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating index [IX_TestInvoice_Test_missing_303] on [dbo].[TestInvoice_Test]'
GO
CREATE NONCLUSTERED INDEX [IX_TestInvoice_Test_missing_303] ON [dbo].[TestInvoice_Test] ([Active], [Date]) INCLUDE ([AmountPaidToProvider], [DepositToProvider], [TestID])
GO
PRINT N'Creating index [IX_TestInvoice_Test_missing_55] on [dbo].[TestInvoice_Test]'
GO
CREATE NONCLUSTERED INDEX [IX_TestInvoice_Test_missing_55] ON [dbo].[TestInvoice_Test] ([Active], [Date]) INCLUDE ([TestInvoiceID])
GO
PRINT N'Creating index [IX_TestInvoice_Test] on [dbo].[TestInvoice_Test]'
GO
CREATE NONCLUSTERED INDEX [IX_TestInvoice_Test] ON [dbo].[TestInvoice_Test] ([ID], [AmountPaidToProvider], [DepositToProvider], [PPODiscount], [ProviderDueDate], [TestCost], [TestDate], [CheckNumber], [Active])
GO
PRINT N'Creating index [IX_TestInvoice_Test_missing_37] on [dbo].[TestInvoice_Test]'
GO
CREATE NONCLUSTERED INDEX [IX_TestInvoice_Test_missing_37] ON [dbo].[TestInvoice_Test] ([InvoiceProviderID], [Active])
GO
PRINT N'Creating index [IX_TestInvoice_Test_missing_35] on [dbo].[TestInvoice_Test]'
GO
CREATE NONCLUSTERED INDEX [IX_TestInvoice_Test_missing_35] ON [dbo].[TestInvoice_Test] ([InvoiceProviderID], [Active]) INCLUDE ([TestCost])
GO
PRINT N'Creating index [IX_TestInvoice_Test_missing_301] on [dbo].[TestInvoice_Test]'
GO
CREATE NONCLUSTERED INDEX [IX_TestInvoice_Test_missing_301] ON [dbo].[TestInvoice_Test] ([isCanceled], [Active], [TestDate]) INCLUDE ([NumberOfTests], [TestID])
GO
PRINT N'Creating index [IX_TestInvoice_Test_ID] on [dbo].[TestInvoice_Test]'
GO
CREATE NONCLUSTERED INDEX [IX_TestInvoice_Test_ID] ON [dbo].[TestInvoice_Test] ([TestInvoiceID], [TestID])
GO
PRINT N'Creating [dbo].[TestInvoice_Test_CPTCodes]'
GO
CREATE TABLE [dbo].[TestInvoice_Test_CPTCodes]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[TestInvoice_TestID] [int] NOT NULL,
[CPTCodeID] [int] NOT NULL,
[Amount] [decimal] (18, 2) NOT NULL,
[Description] [text] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_TestInvoice_Test_CPTCodes_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_TestInvoice_Test_CPTCodes_DateAdded] DEFAULT (getdate()),
[Temp_CompanyID] [int] NULL
)
GO
PRINT N'Creating primary key [PK_TestInvoice_Test_CPTCodes] on [dbo].[TestInvoice_Test_CPTCodes]'
GO
ALTER TABLE [dbo].[TestInvoice_Test_CPTCodes] ADD CONSTRAINT [PK_TestInvoice_Test_CPTCodes] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating index [IX_TestInvoice_Test_CPTCodes_missing_31] on [dbo].[TestInvoice_Test_CPTCodes]'
GO
CREATE NONCLUSTERED INDEX [IX_TestInvoice_Test_CPTCodes_missing_31] ON [dbo].[TestInvoice_Test_CPTCodes] ([TestInvoice_TestID], [Active]) INCLUDE ([Amount])
GO
PRINT N'Creating [dbo].[TestType]'
GO
CREATE TABLE [dbo].[TestType]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_TestType_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_TestType_DateAdded] DEFAULT (getdate())
)
GO
PRINT N'Creating primary key [PK_TestType] on [dbo].[TestType]'
GO
ALTER TABLE [dbo].[TestType] ADD CONSTRAINT [PK_TestType] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[Permissions]'
GO
CREATE TABLE [dbo].[Permissions]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Permissions_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_Permissions_DateAdded] DEFAULT (getdate())
)
GO
PRINT N'Creating primary key [PK_Permissions] on [dbo].[Permissions]'
GO
ALTER TABLE [dbo].[Permissions] ADD CONSTRAINT [PK_Permissions] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[UserPermissions]'
GO
CREATE TABLE [dbo].[UserPermissions]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[UserID] [int] NOT NULL,
[PermissionID] [int] NOT NULL,
[AllowView] [bit] NOT NULL,
[AllowAdd] [bit] NOT NULL,
[AllowEdit] [bit] NOT NULL,
[AllowDelete] [bit] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_UserPermissions_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_UserPermissions_DateAdded] DEFAULT (getdate())
)
GO
PRINT N'Creating primary key [PK_UserPermissions] on [dbo].[UserPermissions]'
GO
ALTER TABLE [dbo].[UserPermissions] ADD CONSTRAINT [PK_UserPermissions] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating trigger [dbo].[t_Invoice_Insert_InvoiceNumber] on [dbo].[Invoice]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[t_Invoice_Insert_InvoiceNumber]
   ON  [dbo].[Invoice]
   AFTER Insert
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @CompanyID int = (select top 1 CompanyID from inserted )
	declare @ID int = (select top 1 ID from inserted )
	

    -- Insert statements for trigger here
    declare @NewInvoiceNumber int = (select top 1 InvoiceNumber + 1
									from Invoice as I
									where CompanyID = @CompanyID
									order by InvoiceNumber desc)
									
	update invoice 
	set InvoiceNumber = @NewInvoiceNumber
	where ID = @ID

END
GO
PRINT N'Creating [dbo].[procTotalRevenueReport]'
GO
-- =============================================
-- Author:		Brad Conley
-- Create date: 4/2/14
-- Description:	Return information for the Total Revenue Report
-- Modified date: 07/27/2015 by Cherie Walker to only show active surgery and test dates
-- Modified columns: 08/17/2015 by Cherie Walker based on user's feedback
-- =============================================
CREATE PROCEDURE [dbo].[procTotalRevenueReport] 
	@StartYear Date = '1/1/1901', 
	@EndYear Date = GETDATE,
	@CompanyId int = -1
AS
BEGIN
	
	SET NOCOUNT ON;
(
   select
    A.ID as AttorneyID,
    A.FirstName as AttorneyFirstName,
    A.LastName as AttorneyLastName,
    YEAR(SISD.ScheduledDate) as YearPaid,
    SIS.isCanceled as Canceled,
    SIPS.ID as ID,
    SIPS.Cost as TotalCostBeforePPODiscount,
    SIPS.PPODiscount as PPODiscount,
    SIPS.Cost - SIPS.PPODiscount as TotalCostLessPPODiscount,
    SIPS.AmountDue as LessCostOfGoodsSold,
    (SIPS.Cost - SIPS.PPODiscount) - SIPS.AmountDue as TotalRevenue,
    C.LongName as CompanyName
  
    from Invoice I
    JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
	JOIN Attorney A on IA.AttorneyID = A.ID
	JOIN SurgeryInvoice SI on SI.ID = I.SurgeryInvoiceID
	JOIN SurgeryInvoice_Surgery SIS on SI.ID = SIS.SurgeryInvoiceID
	JOIN SurgeryInvoice_SurgeryDates SISD on SIS.ID = SISD.SurgeryInvoice_SurgeryID
	JOIN SurgeryInvoice_Providers SIP on SIP.SurgeryInvoiceID = SI.ID
	JOIN SurgeryInvoice_Provider_Services SIPS on SIPS.SurgeryInvoice_ProviderID = SIP.ID
	JOIN Company C on C.ID = I.CompanyID
	
    WHERE I.Active = 1 
    AND SIS.isCanceled = 0 
    AND I.CompanyID = @CompanyId
    and SISD.ScheduledDate BETWEEN @StartYear AND @EndYear
)
UNION
(
	select
	A.ID as AttorneyID,
    A.FirstName as AttorneyFirstName,
    A.LastName as AttorneyLastName,
    YEAR(TIT.TestDate) as YearPaid,
    TIT.isCanceled as Canceled,
    TIT.ID as ID,
    TIT.TestCost as TotalCostBeforePPODiscount,
    TIT.PPODiscount as PPODiscount,
    TIT.TestCost - TIT.PPODiscount AS TotalCostLessPPODiscount,
    TIT.AmountToProvider as LessCostOfGoodsSold,
    (TIT.TestCost - TIT.PPODiscount) - TIT.AmountToProvider as TotalRevenue,
    C.LongName as CompanyName
	
	from Invoice I
	JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
	JOIN Attorney A on IA.AttorneyID = A.ID
	JOIN TestInvoice TI on TI.ID = I.TestInvoiceID
	JOIN TestInvoice_Test TIT on TIT.TestInvoiceID = TI.ID
	JOIN Company C on C.ID = I.CompanyID
	
	where I.Active = 1 
	AND TIT.isCanceled = 0 
	AND I.CompanyID = @CompanyId
    and TIT.TestDate BETWEEN @StartYear AND @EndYear
)
END
GO
PRINT N'Creating [dbo].[f_GetTestProvidersAbbrByInvoiceAndDate]'
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Gets multiple providers, and abbreviations for a test invoice as string
-- =============================================
create FUNCTION [dbo].[f_GetTestProvidersAbbrByInvoiceAndDate] 
(
	-- Add the parameters for the function here
	@InvoiceID int,
	@Date datetime
)
RETURNS varchar(1000)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(1000)

	-- Add the T-SQL statements to compute the return value here
	SELECT distinct @Result = COALESCE(@Result + ', ', '') + IP.FacilityAbbreviation
	FROM Invoice I
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
		JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1
		JOIN InvoiceProvider IP ON IP.ID=TIT.InvoiceProviderID AND IP.Active=1
	WHERE I.ID = @InvoiceID AND IP.FacilityAbbreviation IS NOT NULL
	and Convert(date, tit.TestDate) = Convert(date, @Date)

	-- Return the result of the function
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[f_GetTestProcedure]'
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Gets all test procedure names associated with an invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetTestProcedure] 
(
	@InvoiceID int,
	@Date datetime
)
RETURNS varchar(1000)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(1000)

	-- Add the T-SQL statements to compute the return value here
	SELECT distinct @Result = COALESCE(@Result + ', ', '') + CONVERT(varchar, T.Name, 1)
	FROM Invoice I 
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
			LEFT JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1
			LEFT JOIN Test T ON T.ID=TIT.TestID AND T.Active=1
	WHERE I.ID = @InvoiceID and Convert(date, tit.TestDate) = Convert(date, @Date)

	-- Return the result of the function
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[f_GetTestPPODiscountTotal]'
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Gets the sum of the cost of tests for an invoice
-- UPDATED 2012.04.12 by BURSAVICH, ANDY
-- =============================================
CREATE FUNCTION [dbo].[f_GetTestPPODiscountTotal] 
(
	-- Add the parameters for the function here
	@InvoiceID int
)
RETURNS decimal(18,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result decimal(18,2)

	-- Add the T-SQL statements to compute the return value here
	--SELECT @Result = COALESCE(@Result,0) + Sum(TIT.PPODiscount)
	--FROM Invoice I 
	--	JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
	--	LEFT JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1
	--WHERE I.ID = @InvoiceID
	SELECT @Result = ISNULL(SUM(TIT.PPODiscount), 0)
		FROM Invoice I 
			JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
				JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1
		WHERE I.ID = @InvoiceID
	
	-- Return the result of the function
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[f_GetFirstTestDate]'
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Gets all test dates as string for an invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetFirstTestDate] 
(
	-- Add the parameters for the function here
	@InvoiceID int	
)
RETURNS datetime
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result datetime

	-- Add the T-SQL statements to compute the return value here
	SELECT TOP 1 @Result = TIT.TestDate
	FROM Invoice I
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
		LEFT JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1		
	WHERE I.ID = @InvoiceID
	ORDER BY TIT.TestDate Asc

	-- Return the result of the function
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[f_GetTestInvoiceSummaryTableMinified]'
GO

/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/19/2012
-- Description:	Testing Invoice Summary Data
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    03/19/2012   Aaron     Created proc
** 2	12/20/2012	 Czarina   Made modifications to populate endingbalance (was showing as 0 for everyone)		  
*******************************/

CREATE FUNCTION [dbo].[f_GetTestInvoiceSummaryTableMinified] 
(
	@InvoiceID int,
	@StatementDate datetime
)
RETURNS  
@InvoiceSummary TABLE (InvoiceID int, MaturityDate date, BalanceDue decimal(18,2), CumulativeServiceFeeDue decimal(18,2), EndingBalance decimal(18,2), FirstTestDate datetime, InvoicePaymentTotal decimal(18,2))
AS
BEGIN
	
-------------------------Intial Load
----- Insert into Invoice Summary initially with basic table data
INSERT INTO @InvoiceSummary
	SELECT @InvoiceID, null, 0, 0, 0, null, 0

-------------------------Amortization Date
----- Update the Invoice Summary table with the amortization date
----- The Amortization Date will be the date of the earliest test. //From Spec
DECLARE @AmortizationDate datetime = dbo.f_GetFirstTestDate(@InvoiceID)

UPDATE @InvoiceSummary
SET FirstTestDate = @AmortizationDate

DECLARE @ServiceFeeWaivedMonths int
DECLARE @ServiceFeeWaived decimal(18,2)
DECLARE @LoanTermMonths int

SELECT @ServiceFeeWaivedMonths = ServiceFeeWaivedMonths, 
		@ServiceFeeWaived = ServiceFeeWaived, 
		@LoanTermMonths = LoanTermMonths 
		FROM Invoice WHERE ID = @InvoiceID
----- Update the invoice summary with the date service fee begins and the maturity date calculated from the amortization date
----- The Date Service Fee Begins will be determined by the Service Fee Waived Time Period after the Amortization Date. //From Spec
----- The Maturity Date will be determined by the time period entered in the Loan Term (in months) after the Date Service Fee Begins. //From Spec
UPDATE @InvoiceSummary
SET MaturityDate = DATEADD(M,@ServiceFeeWaivedMonths + @LoanTermMonths, @AmortizationDate)

-------------------------Principal_Deposits_Paid, ServiceFeeReceived and AdditionalDeductions
----- Update invoice summary with different payment type totals

DECLARE @Principal_Deposits_Paid decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND (@StatementDate is null OR P.DatePaid <= @StatementDate)
								AND P.PaymentTypeID in (1,3))
DECLARE @ServiceFeeReceived decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND (@StatementDate is null OR P.DatePaid <= @StatementDate)
								AND P.PaymentTypeID = 2)
DECLARE @AdditionalDeductions decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND (@StatementDate is null OR P.DatePaid <= @StatementDate)
								AND P.PaymentTypeID in (4,5))
DECLARE @TotalPrincipal decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND (@StatementDate is null OR P.DatePaid <= @StatementDate)
								AND P.PaymentTypeID = 1)
DECLARE @TotalDeposits decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND (@StatementDate is null OR P.DatePaid <= @StatementDate)
								AND P.PaymentTypeID = 3)

DECLARE @TotalTestCost_Minus_PPODiscount decimal(18,2) =  (SELECT (SUM(TestCost) - SUM(TIT.PPODiscount))	
														FROM Invoice AS I
														INNER JOIN TestInvoice AS TI ON I.TestInvoiceID = TI.ID AND TI.Active = 1
														INNER JOIN TestInvoice_Test AS TIT ON TI.ID = TIT.TestInvoiceID AND TIT.Active = 1
														WHERE I.ID = @InvoiceID)

-------------------------Balance Due and Cumulative Service Fee Due
----- Update the invoice summary
----- Balance Due equals The total test cost minus the ppo discount minus the principal deposits made and minus any additional deductions 
UPDATE @InvoiceSummary
SET BalanceDue = ISNULL(@TotalTestCost_Minus_PPODiscount, 0) - ISNULL(@Principal_Deposits_Paid, 0) - ISNULL(@AdditionalDeductions, 0),
	CumulativeServiceFeeDue = (SELECT I.CalculatedCumulativeIntrest FROM Invoice AS I WHERE ID = @InvoiceID),
	InvoicePaymentTotal = ISNULL(@Principal_Deposits_Paid, 0) + ISNULL(@ServiceFeeReceived, 0) + ISNULL(@AdditionalDeductions, 0)

UPDATE @InvoiceSummary
SET CumulativeServiceFeeDue = (ISNULL(CumulativeServiceFeeDue,0) - ISNULL(@ServiceFeeReceived,0) - (ISNULL(@ServiceFeeWaived,0))),
-- CCW:  12/20/2012:  ADDED LINE BELOW to provide EndingBalance (the sum of BalanceDue + CumulativeServiceFeeDue)
	EndingBalance = (ISNULL(@TotalTestCost_Minus_PPODiscount, 0) - ISNULL(@Principal_Deposits_Paid, 0) - ISNULL(@AdditionalDeductions, 0)) + (ISNULL(CumulativeServiceFeeDue,0) - ISNULL(@ServiceFeeReceived,0) - (ISNULL(@ServiceFeeWaived,0)))

	RETURN 
END
GO
PRINT N'Creating [dbo].[f_GetTestCostTotal]'
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Gets the sum of the cost of tests for an invoice
-- UPDATED 2012.04.12 by BURSAVICH, ANDY
-- =============================================
CREATE FUNCTION [dbo].[f_GetTestCostTotal] 
(
	-- Add the parameters for the function here
	@InvoiceID int
)
RETURNS decimal(18,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result decimal(18,2)

	-- Add the T-SQL statements to compute the return value here
	--SELECT @Result = COALESCE(@Result,0) + Sum(TIT.TestCost)
	--FROM Invoice I 
	--	JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
	--	LEFT JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1
	--WHERE I.ID = @InvoiceID
	SELECT @Result = ISNULL(SUM(TIT.TestCost), 0)
	FROM Invoice I 
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
		JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1 AND TIT.isCanceled = 0
	WHERE I.ID = @InvoiceID
	
	-- Return the result of the function
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[f_GetSurgeryProvidersAbbrByInvoice]'
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Gets multiple providers for a surgery invoice as string
-- =============================================
CREATE FUNCTION [dbo].[f_GetSurgeryProvidersAbbrByInvoice] 
(
	-- Add the parameters for the function here
	@InvoiceID int
)
RETURNS varchar(1000)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(1000)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = COALESCE(@Result + ', ', '') + IP.FacilityAbbreviation
	FROM Invoice I
		JOIN SurgeryInvoice SI ON SI.ID=I.SurgeryInvoiceID AND SI.Active=1
		JOIN SurgeryInvoice_Providers SIP ON SIP.SurgeryInvoiceID=SI.ID AND SIP.Active=1
		JOIN InvoiceProvider IP ON IP.ID=SIP.InvoiceProviderID AND IP.Active=1
	WHERE I.ID = @InvoiceID AND IP.FacilityAbbreviation IS NOT NULL

	-- Return the result of the function
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[f_GetSurgeryProcedures]'
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Gets all surgery procedure names associated with an invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetSurgeryProcedures] 
(
	-- Add the parameters for the function here
	@InvoiceID int
)
RETURNS varchar(1000)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(1000)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = COALESCE(@Result + ', ', '') + CONVERT(varchar, S.Name, 1)
	FROM Invoice I 
		JOIN SurgeryInvoice SI ON SI.ID=I.SurgeryInvoiceID AND SI.Active=1
		LEFT JOIN SurgeryInvoice_Surgery SIS ON SIS.SurgeryInvoiceID=SI.ID AND SIS.Active=1
		LEFT JOIN Surgery S ON S.ID=SIS.SurgeryID AND S.Active=1
	WHERE I.ID = @InvoiceID

	-- Return the result of the function
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[f_GetSurgeryPPODiscountTotal]'
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Gets the sum of the ppo cost of surgeries for an invoice
-- UPDATED 2012.04.12 by BURSAVICH, ANDY
-- =============================================
CREATE FUNCTION [dbo].[f_GetSurgeryPPODiscountTotal] 
(
	-- Add the parameters for the function here
	@InvoiceID int
)
RETURNS decimal(18,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result decimal(18,2)

	-- Add the T-SQL statements to compute the return value here
	--SELECT @Result = COALESCE(@Result,0) + Sum(SIPS.PPODiscount)
	--FROM Invoice I 
	--	JOIN SurgeryInvoice SI ON SI.ID=I.SurgeryInvoiceID AND SI.Active=1
	--		LEFT JOIN SurgeryInvoice_Providers SIP ON SIP.SurgeryInvoiceID=SI.ID AND SIP.Active=1
	--		LEFT JOIN SurgeryInvoice_Provider_Services SIPS ON SIPS.SurgeryInvoice_ProviderID=SIP.ID
	--WHERE I.ID = @InvoiceID
	SELECT @Result = ISNULL(SUM(SIPS.PPODiscount), 0)
		FROM Invoice I 
			JOIN SurgeryInvoice SI ON SI.ID=I.SurgeryInvoiceID AND SI.Active=1
				JOIN SurgeryInvoice_Providers SIP ON SIP.SurgeryInvoiceID=SI.ID AND SIP.Active=1
					JOIN SurgeryInvoice_Provider_Services SIPS ON SIPS.SurgeryInvoice_ProviderID=SIP.ID
		WHERE I.ID = @InvoiceID
	
	-- Return the result of the function
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[f_GetFirstSurgeryDate]'
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Returns first instance of a surgery date
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    03/23/2012   Aaron     Created function
** 2    03/30/2012   Andy      Restricted to primary dates only
*******************************/
CREATE FUNCTION [dbo].[f_GetFirstSurgeryDate] 
(
	-- Add the parameters for the function here
	@InvoiceID int
)
RETURNS datetime
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result datetime

	-- Add the T-SQL statements to compute the return value here
	SELECT TOP 1 @Result = SISD.ScheduledDate
	FROM Invoice I
		JOIN SurgeryInvoice SI ON SI.ID=I.SurgeryInvoiceID AND SI.Active=1
		LEFT JOIN SurgeryInvoice_Surgery SIS ON SIS.SurgeryInvoiceID=SI.ID AND SIS.Active=1
			LEFT JOIN Surgery S ON S.ID=SIS.SurgeryID AND S.Active=1
			LEFT JOIN SurgeryInvoice_SurgeryDates SISD ON SISD.SurgeryInvoice_SurgeryID = SIS.ID AND SISD.Active=1
	WHERE I.ID = @InvoiceID AND SISD.isPrimaryDate = 1
	ORDER BY SISD.ScheduledDate Asc 
	
	-- Return the result of the function
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[f_GetSurgeryInvoiceSummaryTableMinified]'
GO

CREATE FUNCTION [dbo].[f_GetSurgeryInvoiceSummaryTableMinified] 
(
	@InvoiceID int,
	@StatementDate datetime
)
RETURNS 
@InvoiceSummary TABLE (InvoiceID int, MaturityDate date, BalanceDue decimal(18,2), CumulativeServiceFeeDue decimal(18,2), EndingBalance decimal(18,2), FirstSurgeryDate datetime, InvoicePaymentTotal decimal(18,2))
AS
BEGIN

-------------------------Intial Load
----- Insert into Invoice Summary initially with basic table data	
INSERT INTO @InvoiceSummary
	SELECT @InvoiceID, null, 0, 0, 0, null, 0
	
-------------------------Amortization Date
----- Update the Invoice Summary table with the amortization date
----- The Amortization Date will be the earliest date scheduled. //From Spec
DECLARE @AmortizationDate datetime = dbo.f_GetFirstSurgeryDate(@InvoiceID)

UPDATE @InvoiceSummary
SET FirstSurgeryDate = @AmortizationDate
						
-------------------------Date Service Fee Begins and Maturity Date
----- Get the months the service fee is waived for
DECLARE @ServiceFeeWaivedMonths int
DECLARE @ServiceFeeWaived decimal(18,2)
DECLARE @LoanTermMonths int

SELECT @ServiceFeeWaivedMonths = ServiceFeeWaivedMonths, 
		@ServiceFeeWaived = ServiceFeeWaived, 
		@LoanTermMonths = LoanTermMonths 
		FROM Invoice WHERE ID = @InvoiceID

----- Update the invoice summary with the date service fee begins and the maturity date calculated from the amortization date
----- The Date Service Fee Begins will be determined by the Service Fee Waived Time Period after the Amortization Date. //From Spec
----- The Maturity Date will be determined by the time period entered in the Loan Term (in months) after the Date Service Fee Begins. //From Spec
UPDATE @InvoiceSummary
SET MaturityDate = DATEADD(M,@ServiceFeeWaivedMonths + @LoanTermMonths, @AmortizationDate)

-------------------------Principal_Deposits_Paid, ServiceFeeReceived and AdditionalDeductions
----- Update invoice summary with different payment type totals
DECLARE @Principal_Deposits_Paid decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active = 1
								AND P.InvoiceID = @InvoiceID
								AND (@StatementDate is null OR P.DatePaid <= @StatementDate)
								AND P.PaymentTypeID in (1,3))
DECLARE @ServiceFeeReceived decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active = 1
								AND P.InvoiceID = @InvoiceID
								AND (@StatementDate is null OR P.DatePaid <= @StatementDate)
								AND P.PaymentTypeID = 2)
DECLARE @AdditionalDeductions decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active = 1
								AND P.InvoiceID = @InvoiceID
								AND (@StatementDate is null OR P.DatePaid <= @StatementDate)
								AND P.PaymentTypeID in (4,5))
DECLARE @TotalPrincipal decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active = 1
								AND P.InvoiceID = @InvoiceID
								AND (@StatementDate is null OR P.DatePaid <= @StatementDate)
								AND P.PaymentTypeID = 1)
DECLARE @TotalDeposits decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active = 1
								AND P.InvoiceID = @InvoiceID
								AND (@StatementDate is null OR P.DatePaid <= @StatementDate)
								AND P.PaymentTypeID = 3)

DECLARE @TotalCost_Minus_PPODiscount decimal(18,2) = (SELECT (SUM(SIPS.Cost) - SUM(SIPS.PPODiscount))
														FROM Invoice AS I
														INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
														INNER JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
														INNER JOIN SurgeryInvoice_Provider_Services AS SIPS ON SIP.ID = SIPS.SurgeryInvoice_ProviderID AND SIPS.Active = 1
														WHERE I.ID = @InvoiceID)

-------------------------Balance Due and Cumulative Service Fee Due
----- Update the invoice summary
----- Balance Due equals The total test cost minus the ppo discount minus the principal deposits made and minus any additional deductions 
UPDATE @InvoiceSummary
SET BalanceDue = ISNULL(@TotalCost_Minus_PPODiscount, 0) - ISNULL(@Principal_Deposits_Paid, 0) - ISNULL(@AdditionalDeductions, 0),
	CumulativeServiceFeeDue = (SELECT I.CalculatedCumulativeIntrest FROM Invoice AS I WHERE ID = @InvoiceID),
	InvoicePaymentTotal = ISNULL(@Principal_Deposits_Paid, 0) + ISNULL(@ServiceFeeReceived, 0) + ISNULL(@AdditionalDeductions, 0)

UPDATE @InvoiceSummary
SET CumulativeServiceFeeDue = (ISNULL(CumulativeServiceFeeDue,0) - ISNULL(@ServiceFeeReceived,0) - (ISNULL(@ServiceFeeWaived,0)))

-------------------------Ending Balance
----- Update the invoice summary setting the ending balance
----- Ending Balance equals the balance due plus the cumulative service fee due, minus losses amount
UPDATE @InvoiceSummary
SET EndingBalance = (BalanceDue + CumulativeServiceFeeDue) - (SELECT ISNULL(LossesAmount, 0) FROM Invoice WHERE ID=@InvoiceID)
	
	RETURN 
END
GO
PRINT N'Creating [dbo].[f_GetSurgeryCostTotal]'
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Gets the sum of the cost of surgeries for an invoice
-- UPDATED 2012.04.12 by BURSAVICH, ANDY
-- =============================================
CREATE FUNCTION [dbo].[f_GetSurgeryCostTotal] 
(
	-- Add the parameters for the function here
	@InvoiceID int
)
RETURNS decimal(18,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result decimal(18,2)

	-- Add the T-SQL statements to compute the return value here
	--SELECT @Result = COALESCE(@Result,0) + Sum(SIPS.Cost)
	--FROM Invoice I 
	--	JOIN SurgeryInvoice SI ON SI.ID=I.SurgeryInvoiceID AND SI.Active=1
	--		LEFT JOIN SurgeryInvoice_Providers SIP ON SIP.SurgeryInvoiceID=SI.ID AND SIP.Active=1
	--		LEFT JOIN SurgeryInvoice_Provider_Services SIPS ON SIPS.SurgeryInvoice_ProviderID=SIP.ID
	--WHERE I.ID = @InvoiceID
	SELECT @Result = ISNULL(SUM(SIPS.Cost), 0)
		FROM Invoice I 
			JOIN SurgeryInvoice SI ON SI.ID=I.SurgeryInvoiceID AND SI.Active=1
				JOIN SurgeryInvoice_Providers SIP ON SIP.SurgeryInvoiceID=SI.ID AND SIP.Active=1
					JOIN SurgeryInvoice_Provider_Services SIPS ON SIPS.SurgeryInvoice_ProviderID=SIP.ID 
					AND SIPS.Active = 1
		WHERE I.ID = @InvoiceID 
	
	-- Return the result of the function
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[f_GetLastCommentFromInvoice]'
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Return Last Comment on an Invoice with the date as string
-- Modified:  Czarina Walker:  1/15/2013:  Customer is trying to use the payment comments for this report and isIncludedOnReports is not a property of the PaymentComments
-- =============================================
CREATE FUNCTION [dbo].[f_GetLastCommentFromInvoice] 
(
	-- Add the parameters for the function here
	@InvoiceID int
)
RETURNS varchar(2000)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(2000)
	DECLARE @LastCommentID int
	
	SELECT @LastCommentID = MAX(c.ID)
	FROM Comments c 
	WHERE c.InvoiceID = @InvoiceID AND c.Active = 1 --AND c.isIncludedOnReports = 1

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = CONVERT(varchar(30), c.DateAdded, 1) + '  ' + CONVERT(varchar(2000),c.[Text], 1)
	FROM Comments c 
	WHERE c.ID = @LastCommentID

	-- Return the result of the function
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[procAccountsReceivablesPastDueReport]'
GO
-- =============================================
-- Author:		Brad Conley
-- Create date: 4/30/2014
-- Description:	Data Set for Acounts Receivables Past Due Report
--				4/3/2017 - JA -- Added IsPastDue column
-- =============================================
CREATE PROCEDURE [dbo].[procAccountsReceivablesPastDueReport]
	@StartDate datetime = null, 
	@EndDate datetime = '1/1/1900',
	@CompanyId int = null,
	@AttorneyId int = null,
	@StatementDate datetime = null
AS
BEGIN
	SET NOCOUNT ON;
	
DECLARE @ClosedStatusTypeID INT = 2
DECLARE @PrinciplePaymentTypeID INT = 1
DECLARE @DepositPaymentTypeID INT = 3
DECLARE @CreditPaymentTypeID INT = 5
DECLARE @RefundPaymentTypeID INT = 4
DECLARE @TestTypeID INT = 1
DECLARE @SurgeryTypeID INT = 2
(
	SELECT
		'Test' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		CONVERT(varchar, dbo.f_GetFirstTestDate(I.ID), 1) AS [ServiceDate],
		(dbo.f_GetFirstTestDate(I.ID) + I.ServiceFeeWaivedMonths) AS DateServiceFeeBegins,
		dbo.f_GetTestProvidersAbbrByInvoiceAndDate(I.ID, dbo.f_GetFirstTestDate(I.ID)) AS Provider,
		dbo.f_GetTestProcedure(I.ID, dbo.f_GetFirstTestDate(I.ID)) as ServiceName,
		A.FirstName AS AttorneyFirstName,
		A.LastName AS AttorneyLastName,
		A.LastName + ', ' + A.FirstName AS AttorneyDisplayName,
		InvF.Name AS FirmName,
		InvP.FirstName AS PatientFirstName,
		InvP.LastName AS PatientLastName,
		InvP.LastName + ', ' + InvP.FirstName AS PatientDisplayName,
		dbo.f_GetTestCostTotal(I.ID) AS TotalCost,
		tis.InvoicePaymentTotal AS PaymentAmount,
	    dbo.f_GetTestPPODiscountTotal(I.ID) AS PPODiscount,
		tis.BalanceDue as BalanceDue,
		tis.CumulativeServiceFeeDue as ServiceFeeDue,
		tis.EndingBalance as EndingBalance,
		tis.BalanceDue + tis.CumulativeServiceFeeDue AS TotalDue,
		dbo.f_GetLastCommentFromInvoice(I.ID) As Comment,
		I.isComplete AS InvoiceCompleted,
		-- Change the DueDate(Maturity Date) to the first of the following month.
		-- This is done to match the maturity date of the invoice on the EditInvoice.aspx
	 	DateAdd(Month, 1, DateAdd(Month, DateDiff(Month, 0, tis.MaturityDate), 0)) As DueDate,
		co.LongName as CompanyName,
		tis.FirstTestDate as SortServiceDate,
		I.InvoiceStatusTypeID as StatusType,
		IsPastDue = case when DateAdd(Month, I.LoanTermMonths, dbo.f_GetFirstTestDate(I.ID)) <= Cast(@EndDate as date) then 1 else 0 end
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		join Attorney A on IA.AttorneyID = A.ID 
		LEFT JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		JOIN InvoicePatient InvP ON InvP.ID=I.InvoicePatientID AND InvP.Active=1
		outer apply dbo.f_GetTestInvoiceSummaryTableMinified(I.ID, @StatementDate) tis
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE I.InvoiceStatusTypeID != @ClosedStatusTypeID 
		--AND I.isComplete = 1
		AND tis.BalanceDue > 0 -- CCW:  12/20/2012  Customer does not mark testing invoices as complete, instead placeholder value of $1.00 is updated to signify that this invoice needs to appear on receivables report
		AND I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @TestTypeID
		AND (@AttorneyId = -1 or A.ID = @AttorneyId)
		--AND @StartDate <= tis.MaturityDate AND tis.MaturityDate <= @EndDate
)
UNION
(
	SELECT
		'Procedure' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		CONVERT(varchar, dbo.f_GetFirstSurgeryDate(I.ID), 1) AS [ServiceDate],
		(dbo.f_GetFirstSurgeryDate(I.ID) + I.ServiceFeeWaivedMonths) As DateServiceFeeBegins,
		dbo.f_GetSurgeryProvidersAbbrByInvoice(I.ID) AS Provider,
		dbo.f_GetSurgeryProcedures(I.ID) as ServiceName,
		A.FirstName AS AttorneyFirstName,
		A.LastName AS AttorneyLastName,
		A.LastName + ', ' + A.FirstName AS AttorneyName,
		InvF.Name AS FirmName,
		InvP.FirstName AS PatientFirstName,
		InvP.LastName AS PatientLastName,
		InvP.LastName + ', ' + InvP.FirstName As PatientName,
		dbo.f_GetSurgeryCostTotal(I.ID) AS TotalCost,
		sisum.InvoicePaymentTotal AS PaymentAmount,
		dbo.f_GetSurgeryPPODiscountTotal(I.ID) AS PPODiscount,
		sisum.BalanceDue as BalanceDue,
		sisum.CumulativeServiceFeeDue as ServiceFeeDue,
		sisum.BalanceDue + sisum.CumulativeServiceFeeDue as TotalDue,
		sisum.EndingBalance as EndingBalance,
		dbo.f_GetLastCommentFromInvoice(I.ID) As Comment,
		I.isComplete AS InvoiceCompleted,
		--sisum.MaturityDate As DueDate,
		-- Change the DueDate(Maturity Date) to the first of the following month.
		-- This is done to match the maturity date of the invoice on the EditInvoice.aspx
	 	DateAdd(Month, 1, DateAdd(Month, DateDiff(Month, 0, sisum.MaturityDate), 0)) As DueDate,
		co.LongName as CompanyName,
		sisum.FirstSurgeryDate as SortServiceDate,
		I.InvoiceStatusTypeID as StatusType,
		
		IsPastDue = case when DateAdd(Month, I.LoanTermMonths, dbo.f_GetFirstSurgeryDate(I.ID)) <= Cast(@EndDate as date) then 1 else 0 end
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		join Attorney A on IA.AttorneyID = A.ID 
		LEFT JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		JOIN InvoicePatient InvP ON InvP.ID=I.InvoicePatientID AND InvP.Active=1
		outer apply dbo.f_GetSurgeryInvoiceSummaryTableMinified(I.ID, @StatementDate) sisum
		LEFT JOIN Comments c ON I.ID = c.InvoiceID AND c.Active=1 AND c.isIncludedOnReports = 1
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE I.InvoiceStatusTypeID != @ClosedStatusTypeID AND I.isComplete = 1
		AND I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @SurgeryTypeID
		AND (@AttorneyId = -1 or A.ID = @AttorneyId)
		--AND @StartDate <= sisum.MaturityDate AND sisum.MaturityDate <= @EndDate
)
order by AttorneyDisplayName, InvoiceNumber

END
GO
PRINT N'Creating [dbo].[procProviderInvoiceReport]'
GO
-- =============================================
-- Author:		Brad Conley
-- Create date: 11/14/2014
-- Description:	Return data for Provider Invoice Report
-- =============================================
CREATE PROCEDURE [dbo].[procProviderInvoiceReport] 
	-- Add the parameters for the stored procedure here
	@StartDate datetime = null,
	@EndDate datetime = null,
	@CompanyId int = -1,
	@ProviderId int = -1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	select *
	from (
(
	select P.ID, 
	REPLACE(P.Name,'&','&amp;') as Name, 
	SUM(SIPP.Amount) as CostofGoods, 
	C.LongName as CompanyName,
	'Surgery' as InvoiceType,
	I.InvoiceNumber as InvoiceNumber,
	--dbo.f_ServiceFeeBegins(dbo.f_GetFirstSurgeryDate(I.ID), I.ServiceFeeWaivedMonths) as DateServiceFeeBegins,
	dbo.f_GetFirstSurgeryDate(I.ID) as DateServiceFeeBegins,
	(select inP.FirstName + ' ' + inP.LastName
	 from InvoicePatient inP
	 where inP.ID = I.InvoicePatientID) as Patient,
	 
	 (select inA.LastName + ', ' + inA.FirstName
	 from InvoiceAttorney inA
	 where inA.ID = I.InvoiceAttorneyID) as Attorney,
	 	 	
	 (select SUM(SIPS.Cost)
	 from SurgeryInvoice_Provider_Services SIPS
	 where SIPS.SurgeryInvoice_ProviderID = SIP.ID) as TotalInvoiceAmount
	
	from Provider as P
	inner join InvoiceProvider as IP on P.ID = IP.ProviderID
	inner join SurgeryInvoice_Providers as SIP on IP.ID = SIP.InvoiceProviderID
	inner join SurgeryInvoice_Provider_Payments as SIPP on SIP.ID = SIPP.SurgeryInvoice_ProviderID
	inner join SurgeryInvoice SI on SI.ID = SIP.SurgeryInvoiceID
	inner join SurgeryInvoice_Provider_Services SIPS on SIPS.SurgeryInvoice_ProviderID = SIP.ID
	inner join Invoice I on I.SurgeryInvoiceID = SI.ID
	inner join Company as C on P.CompanyID = C.ID
	where
	--dbo.f_ServiceFeeBegins(dbo.f_GetFirstSurgeryDate(I.ID), I.ServiceFeeWaivedMonths) >= @StartDate 
	--and dbo.f_ServiceFeeBegins(dbo.f_GetFirstSurgeryDate(I.ID), I.ServiceFeeWaivedMonths) <= @EndDate	
	dbo.f_GetFirstSurgeryDate(I.ID) >= @StartDate 
	and dbo.f_GetFirstSurgeryDate(I.ID) <= @EndDate	
	and P.CompanyID = @CompanyId
	and (@ProviderId = -1 or P.ID = @ProviderId)
	group by P.ID, P.Name, C.LongName, I.InvoiceNumber, I.ID, I.ServiceFeeWaivedMonths, I.InvoicePatientID, I.InvoiceAttorneyID, SIP.ID	
)
union
(
	select P.ID, 
	REPLACE(P.Name,'&','&amp;') as Name, 
	SUM(isnull(TIT.AmountToProvider,0)) as CostofGoods, 
	C.LongName as CompanyName,
	'Test' as InvoiceType,
	I.InvoiceNumber as InvoiceNumber,
	
	--dbo.f_ServiceFeeBegins(dbo.f_GetFirstTestDate(I.ID), I.ServiceFeeWaivedMonths) as DateServiceFeeBegins,	
	dbo.f_GetFirstTestDate(I.ID) as DateServiceFeeBegins,
	(select inP.FirstName + ' ' + inP.LastName
	 from InvoicePatient inP
	 where inP.ID = I.InvoicePatientID) as Patient,
	 
	 (select inA.LastName + ', ' + inA.FirstName
	 from InvoiceAttorney inA
	 where inA.ID = I.InvoiceAttorneyID) as Attorney,
	 
	 SUM(TIT.TestCost) as  TotalInvoiceAmount
	 
	
	from Provider as P
	inner join InvoiceProvider as IP on P.ID = IP.ProviderID
	inner join TestInvoice_Test as TIT on IP.ID = TIT.InvoiceProviderID
	inner join TestInvoice TI on TI.ID = TIT.TestInvoiceID
	inner join Invoice I on I.TestInvoiceID = TI.ID
	inner join Company as C on P.CompanyID = C.ID
	where
	--dbo.f_ServiceFeeBegins(dbo.f_GetFirstTestDate(I.ID), I.ServiceFeeWaivedMonths) >= @StartDate 
	--and dbo.f_ServiceFeeBegins(dbo.f_GetFirstTestDate(I.ID), I.ServiceFeeWaivedMonths) <= @EndDate
	dbo.f_GetFirstTestDate(I.ID)>= @StartDate
	and dbo.f_GetFirstTestDate(I.ID) <= @EndDate
	and TIT.Active = 1
	and P.CompanyID = @CompanyId
	and (@ProviderId = -1 or P.ID = @ProviderId)
	group by P.ID, P.Name, C.LongName, I.InvoiceNumber, I.ID, I.ServiceFeeWaivedMonths, I.InvoicePatientID, I.InvoiceAttorneyID
)) as res

order by res.Name
   
END
GO
PRINT N'Creating [dbo].[proc_dev_AddEnableUserPermissions]'
GO
-- =============================================
-- Author:		Bursavich, Andrew
-- Create date: 2012.01.09
-- Description:	Adds or enables all permissions for a user
-- =============================================
CREATE PROCEDURE [dbo].[proc_dev_AddEnableUserPermissions]
	@UserID int
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE UserPermissions
	SET AllowView=1, AllowAdd=1, AllowEdit=1, AllowDelete=1, Active=1
	WHERE UserID=@UserID

	INSERT INTO UserPermissions (UserID, PermissionID, AllowView, AllowAdd, AllowEdit, AllowDelete, Active)
	SELECT @UserID, P.ID, 1, 1, 1, 1, 1
	FROM [Permissions] P
	LEFT JOIN UserPermissions UP ON UP.PermissionID=P.ID AND UP.UserID=@UserID
	WHERE P.Active=1 AND UP.ID IS NULL

END
GO
PRINT N'Creating [dbo].[procReportTesting]'
GO
-- =============================================
-- Author:		Bursavich, Andrew
-- Create date: 2011.01.04
-- Description:	For Testing SSRS
-- =============================================
CREATE PROCEDURE [dbo].[procReportTesting]
AS
BEGIN

	SET NOCOUNT ON;


DECLARE @OpenStatusTypeID INT = 1
DECLARE @PrinciplePaymentTypeID INT = 1
DECLARE @DepositPaymentTypeID INT = 3
DECLARE @CreditPaymentTypeID INT = 5
DECLARE @RefundPaymentTypeID INT = 4
(
	SELECT
		--I.ID As [InvoiceID], TI.ID AS [TestInvoiceID],
		--TIT.ID AS [TestInvoice_TestID], T.ID AS [TestID], IP.ID AS [InvoiceProviderID],
		------------------------------
		IA.AttorneyID AS AttorneyID,
		I.ID AS InvoiceID,
		TIT.ID AS ServiceID,
		TIT.ID AS DateID,
		TIT.ID AS CostID,
		P.ID AS PaymentID,
		------------------------------
		'Test' AS [Type],
		I.ID AS InvoiceNumber,
		TIT.TestDate AS [ServiceDate],
		CASE WHEN TIT.TestDate IS NULL THEN 0 ELSE 1 END AS isPrimaryDate,
		T.Name as ServiceName,
		IA.LastName + ', ' + IA.FirstName AS AttorneyName,
		InvF.Name AS FirmName,
		InvP.LastName + ', ' + InvP.FirstName As PatientName,
		IP.Name AS Provider,
		TIT.TestCost AS ServiceCost,
		CASE WHEN P.Amount IS NULL THEN 0 ELSE P.Amount END AS PaymentAmount,
		TIT.PPODiscount AS PPODiscount
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		JOIN InvoicePatient InvP ON InvP.ID=I.InvoicePatientID AND InvP.Active=1
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
			LEFT JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1
				LEFT JOIN InvoiceProvider IP ON IP.ID=TIT.InvoiceProviderID AND IP.Active=1
				LEFT JOIN Test T ON T.ID=TIT.TestID AND T.Active=1
		LEFT JOIN Payments P ON P.InvoiceID=I.ID AND (P.PaymentTypeID=@PrinciplePaymentTypeID OR P.PaymentTypeID=@DepositPaymentTypeID OR P.PaymentTypeID=@CreditPaymentTypeID OR P.PaymentTypeID=@RefundPaymentTypeID) AND P.Active=1
	WHERE I.InvoiceStatusTypeID=@OpenStatusTypeID
		AND I.Active = 1
)
UNION
(
	SELECT
		------------------------------
		IA.AttorneyID AS AttorneyID,
		I.ID AS InvoiceID,
		SIS.ID AS ServiceID,
		SISD.ID AS DateID,
		SIPS.ID AS CostID,
		P.ID AS PaymentID,
		------------------------------
		'Procedure' AS [Type],
		I.ID AS InvoiceNumber,
		SISD.ScheduledDate AS [ServiceDate],
		SISD.isPrimaryDate,
		S.Name as ServiceName,
		IA.LastName + ', ' + IA.FirstName AS AttorneyName,
		InvF.Name AS FirmName,
		InvP.LastName + ', ' + InvP.FirstName As PatientName,
		IP.Name AS Provider,
		SIPS.Cost AS ServiceCost,
		CASE WHEN P.Amount IS NULL THEN 0 ELSE P.Amount END AS PaymentAmount,
		SIPS.PPODiscount AS PPODiscount
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		JOIN InvoicePatient InvP ON InvP.ID=I.InvoicePatientID AND InvP.Active=1
		JOIN SurgeryInvoice SI ON SI.ID=I.SurgeryInvoiceID AND SI.Active=1
			LEFT JOIN SurgeryInvoice_Surgery SIS ON SIS.SurgeryInvoiceID=SI.ID AND SIS.Active=1
				LEFT JOIN Surgery S ON S.ID=SIS.SurgeryID AND S.Active=1
				LEFT JOIN SurgeryInvoice_SurgeryDates SISD ON SISD.SurgeryInvoice_SurgeryID=SIS.ID AND SISD.Active=1
			LEFT JOIN SurgeryInvoice_Providers SIP ON SIP.SurgeryInvoiceID=SI.ID AND SIP.Active=1
				LEFT JOIN InvoiceProvider IP ON IP.ID=SIP.InvoiceProviderID AND IP.Active=1
				LEFT JOIN SurgeryInvoice_Provider_Services SIPS ON SIPS.SurgeryInvoice_ProviderID=SIP.ID
		LEFT JOIN Payments P ON P.InvoiceID=I.ID AND (P.PaymentTypeID=@PrinciplePaymentTypeID OR P.PaymentTypeID=@DepositPaymentTypeID OR P.PaymentTypeID=@CreditPaymentTypeID OR P.PaymentTypeID=@RefundPaymentTypeID) AND P.Active=1
	WHERE I.InvoiceStatusTypeID=@OpenStatusTypeID
		AND I.Active = 1
)
ORDER BY AttorneyName ASC, InvoiceNumber ASC, isPrimaryDate DESC


END
GO
PRINT N'Creating [dbo].[f_GetTestInvoicesForCashReport]'
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 2/14/2013
-- Description:	Returns Test Invoice ID For Cash Report
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    02/14/2013   Aaron     Created function from stored proc
*******************************/
CREATE FUNCTION [dbo].[f_GetTestInvoicesForCashReport] 
(
	@CompanyId int,
	@StartDate datetime,
	@EndDate datetime
)
RETURNS 
@InvoiceCashReport TABLE (InvoiceID int)
AS
BEGIN

DECLARE @ClosedStatusTypeID INT = 2
DECLARE @PrinciplePaymentTypeID INT = 1
DECLARE @DepositPaymentTypeID INT = 3
DECLARE @InterestPaymentTypeID INT = 2
DECLARE @RefundPaymentTypeID INT = 4

-- Insert Account and Provider
INSERT INTO @InvoiceCashReport (InvoiceID)
	Select InvoiceID from (	
	(Select Distinct InvoiceID as InvoiceID 
	from Payments P
	Inner join Company c on c.ID = @CompanyId AND c.Active = 1
	Where (P.DatePaid IS NULL OR P.DatePaid BETWEEN @StartDate AND @EndDate)
			AND (P.PaymentTypeID IS NULL OR P.PaymentTypeID in (@PrinciplePaymentTypeID,@DepositPaymentTypeID,@InterestPaymentTypeID))
	)
	Union
	(
	Select Distinct I.ID AS InvoiceID
	FROM Invoice I 
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
		JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1
	WHERE TIT.[Date] BETWEEN @StartDate AND @EndDate)) as tmp

	RETURN 
END
GO
PRINT N'Creating [dbo].[f_GetSurgeryInvoicesForCashReport]'
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 2/14/2013
-- Description:	Returns Surgery Invoice ID For Cash Report
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    02/14/2013   Aaron     Created function from stored proc
*******************************/
CREATE FUNCTION [dbo].[f_GetSurgeryInvoicesForCashReport] 
(
	@CompanyId int,
	@StartDate datetime,
	@EndDate datetime
)
RETURNS 
@InvoiceCashReport TABLE (InvoiceID int)
AS
BEGIN

DECLARE @ClosedStatusTypeID INT = 2
DECLARE @PrinciplePaymentTypeID INT = 1
DECLARE @DepositPaymentTypeID INT = 3
DECLARE @InterestPaymentTypeID INT = 2
DECLARE @RefundPaymentTypeID INT = 4

-- Insert Account and Provider
INSERT INTO @InvoiceCashReport (InvoiceID)
	Select InvoiceID from (	
	(Select Distinct InvoiceID as InvoiceID 
	from Payments P
	Inner join Company c on c.ID = @CompanyId AND c.Active = 1
	Where (P.DatePaid IS NULL OR P.DatePaid BETWEEN @StartDate AND @EndDate)
			AND (P.PaymentTypeID IS NULL OR P.PaymentTypeID in (@PrinciplePaymentTypeID,@DepositPaymentTypeID,@InterestPaymentTypeID))
	)
	Union
	(
	Select Distinct I.ID AS InvoiceID
	FROM Invoice I 
		JOIN SurgeryInvoice SI ON SI.ID=I.SurgeryInvoiceID AND SI.Active=1
			JOIN SurgeryInvoice_Providers SIP ON SIP.SurgeryInvoiceID=SI.ID AND SIP.Active=1
				JOIN SurgeryInvoice_Provider_Payments SIPP ON SIPP.SurgeryInvoice_ProviderID=SIP.ID
	WHERE SIPP.DatePaid BETWEEN @StartDate AND @EndDate)) as tmp

	RETURN 
END
GO
PRINT N'Creating [dbo].[AttorneyTerms]'
GO
CREATE TABLE [dbo].[AttorneyTerms]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AttorneyID] [int] NOT NULL,
[LoanTermsMonths] [int] NOT NULL,
[YearlyInterest] [decimal] (18, 4) NOT NULL,
[ServiceFeeWaivedMonths] [int] NOT NULL,
[StartDate] [date] NOT NULL,
[EndDate] [date] NULL,
[DateAdded] [datetime] NULL,
[Active] [bit] NULL CONSTRAINT [DF_AttorneyTerms_Active] DEFAULT ((1)),
[Deleted] [bit] NULL CONSTRAINT [DF_AttorneyTerms_Deleted] DEFAULT ((0)),
[TermType] [int] NULL,
[Status] [nvarchar] (15) NULL
)
GO
PRINT N'Creating primary key [PK_AttorneyTerms] on [dbo].[AttorneyTerms]'
GO
ALTER TABLE [dbo].[AttorneyTerms] ADD CONSTRAINT [PK_AttorneyTerms] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[svcUpdateAttorneyTerms]'
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[svcUpdateAttorneyTerms] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ATQueueIDs TABLE (ID int, Processed int)
	DECLARE @ATIDs TABLE (ID int)
	DECLARE @Process int = 0
	DECLARE @Processed int = 1
	DECLARE @AtID int	

    -- Insert statements for procedure here
	--INSERT INTO @ATQueueIDs
	--(ID, Processed)
	--select ID, @Process
	--from AttorneyTerms
	--where Active = 1

	 --while (select COUNT(*) from @ATQueueIDs where Processed = 0) > 0
    --BEGIN
		--select top 1 @AtID = ID from @ATQueueIDs where Processed = 0
		update AttorneyTerms set Active = 0, Status = 'ENDED'
		where EndDate < GETDATE()
		
		update AttorneyTerms set Status = 'Current'
		where StartDate <= GETDATE() AND Status = '(Scheduled)' AND (EndDate > GETDATE() or EndDate is null)

		--update @AtQueueIDs set Processed = 1 where ID = @AtID
	--END
END

GO
PRINT N'Creating [dbo].[Temp_TestTimeValConversionTEXTToTIME]'
GO
CREATE TABLE [dbo].[Temp_TestTimeValConversionTEXTToTIME]
(
[TestTimeTEXT] [nvarchar] (10) NOT NULL,
[TestTimeTIME] [time] NULL
)
GO
PRINT N'Creating primary key [PK_Temp_TestTimeValConversionTEXTToTIME] on [dbo].[Temp_TestTimeValConversionTEXTToTIME]'
GO
ALTER TABLE [dbo].[Temp_TestTimeValConversionTEXTToTIME] ADD CONSTRAINT [PK_Temp_TestTimeValConversionTEXTToTIME] PRIMARY KEY CLUSTERED  ([TestTimeTEXT])
GO
PRINT N'Creating [dbo].[Temp_PatientRecordConsolidation]'
GO
CREATE TABLE [dbo].[Temp_PatientRecordConsolidation]
(
[Original_PatientID] [int] NOT NULL,
[Temp_InvoiceID] [int] NULL,
[New_PatientID] [int] NULL,
[FirstName] [nvarchar] (50) NULL,
[LastName] [nvarchar] (50) NULL,
[SSN] [varchar] (500) NULL
)
GO
PRINT N'Creating primary key [PK_Temp_PatientRecordConsolidation] on [dbo].[Temp_PatientRecordConsolidation]'
GO
ALTER TABLE [dbo].[Temp_PatientRecordConsolidation] ADD CONSTRAINT [PK_Temp_PatientRecordConsolidation] PRIMARY KEY CLUSTERED  ([Original_PatientID])
GO
PRINT N'Creating [dbo].[DATAMIGRATION_BMM_TEST_TEST_List]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_BMM_TEST_TEST_List]
(
[Test No] [int] NOT NULL IDENTITY(1, 1),
[Invoice No] [int] NULL,
[Test Name] [nvarchar] (100) NULL,
[Test Date] [datetime] NULL,
[Test Time] [nvarchar] (5) NULL,
[Test Results] [nvarchar] (50) NULL,
[Test Deposit] [float] NULL,
[Interest Waived] [float] NULL,
[Losses Amount] [float] NULL,
[Payment Plan] [int] NULL,
[Canceled] [bit] NULL,
[Test Cost] [float] NULL,
[Provider No] [int] NULL,
[Deposit From Attorney] [float] NULL,
[Amount Due To Provider Due Date] [datetime] NULL,
[Amount Paid To Provider] [float] NULL,
[Amount Paid To Provider Date] [datetime] NULL,
[Amount Paid To Provider Check No] [nvarchar] (50) NULL,
[Number of Tests] [int] NULL,
[MRI] [int] NULL,
[PPO Discount] [float] NULL,
[AmountDueToFacility] [float] NULL
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_BMM_TEST_Provider_List]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_BMM_TEST_Provider_List]
(
[Facility No] [int] NOT NULL IDENTITY(1, 1),
[Facility Name] [nvarchar] (50) NULL,
[Facility Address] [nvarchar] (50) NULL,
[Facility City] [nvarchar] (50) NULL,
[Facility State] [nvarchar] (50) NULL,
[Facility Zip] [nvarchar] (50) NULL,
[Facility Phone] [nvarchar] (50) NULL,
[Facility Fax] [nvarchar] (50) NULL,
[Contact] [nvarchar] (50) NULL,
[Memo] [ntext] NULL,
[Discount] [float] NULL,
[PPO deposit] [int] NULL,
[FacilityAbbrev] [nvarchar] (50) NULL
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_BMM_TEST_Physician_List]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_BMM_TEST_Physician_List]
(
[Physician No] [int] NOT NULL IDENTITY(1, 1),
[Physician First Name] [nvarchar] (50) NULL,
[Physician Last Name] [nvarchar] (50) NULL,
[Physician Address] [nvarchar] (50) NULL,
[Physician Address2] [nvarchar] (50) NULL,
[Physician City] [nvarchar] (50) NULL,
[Physician State] [nvarchar] (50) NULL,
[Physician Zip] [nvarchar] (50) NULL,
[Physician Phone] [nvarchar] (50) NULL,
[Physician Fax] [nvarchar] (50) NULL,
[Memo] [ntext] NULL,
[Contact] [nvarchar] (50) NULL
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_BMM_TEST_Payments]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_BMM_TEST_Payments]
(
[PaymentID] [int] NOT NULL IDENTITY(1, 1),
[Invoice No] [int] NULL,
[Date Paid] [datetime] NULL,
[Amount] [float] NULL,
[Payment Type] [nvarchar] (10) NULL,
[Check No] [nvarchar] (10) NULL
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_BMM_TEST_BMM]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_BMM_TEST_BMM]
(
[Invoice Number] [int] NULL,
[Invoice Date] [datetime] NULL,
[Client Name] [nvarchar] (50) NULL,
[Client Last Name] [nvarchar] (50) NULL,
[Client Address] [nvarchar] (50) NULL,
[Client City] [nvarchar] (50) NULL,
[Client State] [nvarchar] (50) NULL,
[Client Zip] [nvarchar] (50) NULL,
[Client Phone] [nvarchar] (50) NULL,
[Client WorkPhone] [nvarchar] (50) NULL,
[Client Date of Birth] [datetime] NULL,
[SSN] [nvarchar] (50) NULL,
[Date Of Accident] [datetime] NULL,
[Attorney No] [int] NULL,
[Physician No] [int] NULL,
[Provider No] [int] NULL,
[Invoice Closed] [bit] NULL,
[Notes] [ntext] NULL,
[Invoice Closed Date] [datetime] NULL,
[TotalCost] [float] NULL,
[MaturityDate] [datetime] NULL,
[DepositReceived] [float] NULL,
[DatePaid] [datetime] NULL,
[DueDate] [datetime] NULL,
[ServiceFeeWaived] [float] NULL,
[AmountPaid] [float] NULL,
[BalanceDue] [float] NULL,
[DateServiceFeeBegins] [datetime] NULL,
[LossesAmount] [float] NULL,
[Cumulative] [float] NULL,
[CostOfGoodsSold] [float] NULL,
[EndingBalance] [float] NULL,
[Revenue] [float] NULL,
[AmortizationDate] [datetime] NULL,
[Months] [int] NULL,
[TotalPayments] [float] NULL,
[TotalPPO] [float] NULL,
[TotalPrincipal] [float] NULL,
[CompleteFile] [bit] NULL,
[company] [nvarchar] (50) NULL,
[TotalInterestPaid] [float] NULL,
[GrossCumulative] [float] NULL,
[transferred] [bit] NULL
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_BMM_SURGERY_Services]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_BMM_SURGERY_Services]
(
[InvoiceNumber] [int] NULL,
[provider] [int] NULL,
[DueDate] [datetime] NULL,
[AmountDue] [float] NULL,
[cost] [float] NULL,
[discount] [float] NULL,
[PPODiscount] [float] NULL,
[ProviderByInvoice] [int] NULL,
[AmountWaived] [float] NULL,
[SERVICEID] [int] NOT NULL IDENTITY(1, 1)
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_BMM_SURGERY_Providers]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_BMM_SURGERY_Providers]
(
[provider] [int] NULL,
[date] [datetime] NULL,
[name] [nvarchar] (50) NULL,
[address] [nvarchar] (35) NULL,
[city] [nvarchar] (20) NULL,
[state] [nvarchar] (2) NULL,
[zip] [nvarchar] (10) NULL,
[phone] [nvarchar] (12) NULL,
[contact] [nvarchar] (25) NULL,
[abbrev] [nvarchar] (10) NULL,
[discount] [decimal] (7, 2) NULL,
[fax] [nvarchar] (12) NULL
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_BMM_SURGERY_PaymentsToProviders]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_BMM_SURGERY_PaymentsToProviders]
(
[Invoice Number] [int] NULL,
[Provider] [int] NULL,
[DatePaid] [datetime] NULL,
[Amount] [decimal] (10, 2) NULL,
[PaymentType] [nvarchar] (10) NULL,
[Check] [nvarchar] (10) NULL,
[ProviderByInvoice] [int] NULL,
[PAYMENTID] [int] NOT NULL IDENTITY(1, 1)
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney]
(
[Invoice Number] [int] NULL,
[DatePaid] [datetime] NULL,
[amount] [float] NULL,
[PaymentType] [nvarchar] (10) NULL,
[check] [nvarchar] (10) NULL
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_BMM_SURGERY_CPTCharges]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_BMM_SURGERY_CPTCharges]
(
[Invoice Number] [int] NULL,
[provider] [int] NULL,
[cptcode] [nvarchar] (5) NULL,
[amount] [decimal] (10, 2) NULL,
[description] [nvarchar] (75) NULL,
[ProviderbyInvoice] [int] NULL
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_BMM_SURGERY_CalcTestListTemp]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_BMM_SURGERY_CalcTestListTemp]
(
[InvoiceNumber] [int] NULL,
[TestCosts] [float] NULL,
[TestCostsNet] [float] NULL,
[PPODisc] [float] NULL,
[InterestByDate] [float] NULL,
[DateScheduled] [datetime] NULL,
[InterestDue] [float] NULL,
[Name] [nvarchar] (255) NULL,
[Client Name] [nvarchar] (50) NULL,
[Client Last Name] [nvarchar] (50) NULL,
[Notes] [ntext] NULL,
[attorneyName] [nvarchar] (255) NULL,
[abbrev] [nvarchar] (10) NULL,
[EndingBalance] [float] NULL,
[Balance] [float] NULL,
[Attorney No] [int] NULL,
[PaymentTotals] [float] NULL,
[Company] [nvarchar] (50) NULL,
[Company2] [nvarchar] (50) NULL,
[amortization] [datetime] NULL,
[TestType] [nvarchar] (50) NULL,
[FirstTestDate] [datetime] NULL,
[COGS] [float] NULL,
[Revenue] [float] NULL,
[ContractRevenue] [float] NULL,
[TotalRevenue] [float] NULL,
[maturity] [datetime] NULL,
[amortyear] [nvarchar] (50) NULL
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_BMM_SURGERY_BMM]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_BMM_SURGERY_BMM]
(
[Invoice Number] [int] NULL,
[Invoice Date] [datetime] NULL,
[Client Name] [nvarchar] (50) NULL,
[Client Last Name] [nvarchar] (50) NULL,
[Client Address] [nvarchar] (50) NULL,
[Client City] [nvarchar] (50) NULL,
[Client State] [nvarchar] (50) NULL,
[Client Zip] [nvarchar] (50) NULL,
[Client Phone] [nvarchar] (50) NULL,
[Client WorkPhone] [nvarchar] (50) NULL,
[Client Date of Birth] [datetime] NULL,
[SSN] [nvarchar] (50) NULL,
[Date Of Accident] [datetime] NULL,
[Attorney No] [int] NULL,
[Physician No] [int] NULL,
[Provider No] [int] NULL,
[Invoice Closed] [bit] NULL,
[Notes] [ntext] NULL,
[Invoice Closed Date] [datetime] NULL,
[TotalCost] [float] NULL,
[MaturityDate] [datetime] NULL,
[DepositReceived] [float] NULL,
[DatePaid] [datetime] NULL,
[DueDate] [datetime] NULL,
[ServiceFeeWaived] [float] NULL,
[AmountPaid] [float] NULL,
[BalanceDue] [float] NULL,
[DateServiceFeeBegins] [datetime] NULL,
[LossesAmount] [float] NULL,
[Cumulative] [float] NULL,
[CostOfGoodsSold] [float] NULL,
[EndingBalance] [float] NULL,
[Revenue] [float] NULL,
[AmortizationDate] [datetime] NULL,
[Months] [int] NULL,
[TotalPayments] [float] NULL,
[TotalPPO] [float] NULL,
[TotalPrincipal] [int] NULL,
[CompleteFile] [bit] NULL,
[SurgeryType] [nvarchar] (64) NULL,
[DateScheduled] [datetime] NULL,
[inpatient] [bit] NULL,
[outpatient] [bit] NULL,
[cancelled] [bit] NULL,
[icd9] [nvarchar] (8) NULL,
[drgcode] [nvarchar] (3) NULL,
[company] [nvarchar] (50) NULL,
[transferred] [bit] NULL
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_BMM_SHARED_Attorney_List]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_BMM_SHARED_Attorney_List]
(
[Attorney No] [int] NOT NULL IDENTITY(1, 1),
[Attorney First Name] [nvarchar] (50) NULL,
[Attorney Last Name] [nvarchar] (50) NULL,
[Attorney Address] [nvarchar] (50) NULL,
[Attorney City] [nvarchar] (50) NULL,
[Attorney State] [nvarchar] (50) NULL,
[Attorney Zip] [nvarchar] (50) NULL,
[Attorney Phone] [nvarchar] (50) NULL,
[Attorney Fax] [nvarchar] (50) NULL,
[Attorney Seceretary] [nvarchar] (50) NULL,
[Memo] [ntext] NULL,
[Months] [int] NULL,
[Discount Plan] [int] NULL,
[Deposit Amount Required] [int] NULL,
[test] [bit] NULL
)
GO
PRINT N'Creating [dbo].[CPTCodes]'
GO
CREATE TABLE [dbo].[CPTCodes]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CompanyID] [int] NULL,
[Code] [nvarchar] (50) NULL,
[Description] [ntext] NULL,
[Active] [bit] NULL,
[DateAdded] [datetime] NULL
)
GO
PRINT N'Creating index [IX_CPTCodes_missing_41] on [dbo].[CPTCodes]'
GO
CREATE NONCLUSTERED INDEX [IX_CPTCodes_missing_41] ON [dbo].[CPTCodes] ([ID])
GO
PRINT N'Creating [dbo].[proc_DATAMIGRATIONProcess_BMM]'
GO

CREATE PROCEDURE [dbo].[proc_DATAMIGRATIONProcess_BMM]
	
	@DateTimeVal datetime
		
AS 


BEGIN

--IMPORTANT:  RUN MANUALLY before starting this sequence or invoice numbers will be off!!:  DISABLE TRIGGER t_Invoice_Insert_InvoiceNumber ON Invoice; n


-- Two Step Process Here to Remove payments in the event that any new ones have been entered since 


Update Payments 
Set Temp_CompanyID = 1
From Payments inner join Invoice on Payments.InvoiceID = Invoice.ID
Where Invoice.CompanyID = 1

Delete From Payments where Temp_CompanyID = 1
		PRINT 'Delete From Payments Complete'
				

Delete From InvoiceChangeLog Where Temp_CompanyID = 1
		PRINT 'Delete From InvoiceChangeLog Complete'
		
Delete From Invoice Where CompanyID = 1
		PRINT 'Delete From Invoice Complete'

Delete From Comments where Temp_CompanyID = 1

-- Two Step Process Here to remove InvoiceChangeLog recrds

Update InvoiceChangeLog
Set Temp_CompanyID = 1
From InvoiceChangeLog inner join Invoice on InvoiceChangeLog.InvoiceID = Invoice.ID
Where Invoice.CompanyID = 1

Delete From InvoiceChangeLog where Temp_CompanyID = 1


-- Two Step Process Here to Remove the Interest Calculations

Update InvoiceInterestCalculationLog
Set YearlyInterest = 2 --<Just Updating to something to make easier to remove
From InvoiceInterestCalculationLog inner join Invoice
On  InvoiceInterestCalculationLog.InvoiceID = Invoice.ID
Where  Invoice.CompanyID = 1

Delete From InvoiceInterestCalculationLog
where YearlyInterest = 2


Delete From Invoice where CompanyID = 1

Delete From InvoiceAttorney Where Temp_CompanyID = 1
		PRINT 'Delete From InvoiceAttorney Complete'

Delete From SurgeryInvoice_Provider_Services Where Temp_CompanyID = 1
		PRINT 'Delete From SurgeryInvoice_Provider_Services Complete'

Delete From SurgeryInvoice_Provider_CPTCodes Where Temp_CompanyID = 1
		PRINT 'Delete From SurgeryInvoice_Provider_CPTCodes Complete'

Delete From SurgeryInvoice_Provider_Payments Where Temp_CompanyID = 1
		PRINT 'Delete From SurgeryInvoice_Provider_Payments Complete'

Delete From SurgeryInvoice_Providers Where Temp_CompanyID = 1
		PRINT 'Delete From SurgeryInvoice_Providers Complete'

Delete From TestInvoice_Test_CPTCodes where Temp_CompanyID = 1

Delete From TestInvoice_Test where temp_CompanyID = 1

Delete From TestInvoice where Temp_CompanyID = 1

Delete From InvoiceProvider Where Temp_CompanyID = 1
		PRINT 'Delete From InvoiceProvider Complete'
		
Delete From InvoiceContacts where Temp_CompanyID = 1

Delete From InvoiceFirm where Temp_CompanyID = 1

Delete From InvoicePhysician where Temp_CompanyID = 1


Delete from InvoiceAttorney where Temp_CompanyID = 1


Delete From InvoiceContactList Where Temp_CompanyID = 1
		PRINT 'Delete From InvoiceContactList Complete'

Delete From InvoicePatient Where Temp_CompanyID = 1
		PRINT 'Delete From InvoicePatient Complete'
		
		
Delete From SurgeryInvoice_SurgeryDates Where Temp_CompanyID = 1
		PRINT 'Delete From SurgeryInvoice_SurgeryDates Complete'

Delete From SurgeryInvoice_Surgery Where Temp_CompanyID = 1
		PRINT 'Delete From SurgeryInvoice_Surgery Complete'

Delete From Surgery Where CompanyID = 1
		PRINT 'Delete From Surgery Complete'

Delete From SurgeryInvoice Where Temp_CompanyID = 1
		PRINT 'Delete From SurgeryInvoice Complete'

Delete From Attorney Where CompanyID = 1
		PRINT 'Delete From Attorney Complete'

Delete From Provider Where CompanyID = 1
		PRINT 'Delete From Provider Complete'

Delete From PatientChangeLog Where Temp_CompanyID = 1 
		PRINT 'Delete From PatientChangeLog Complete'
		
Delete From Patient Where CompanyID = 1
		PRINT 'Delete From Patient Complete'
		
Delete From Firm Where CompanyID = 1
		PRINT 'Delete From Firm Complete'
		
Delete From Contacts where Temp_CompanyID = 1

Delete from Physician where CompanyID = 1

		
Delete From ContactList Where ID <> 16 and Temp_CompanyID = 1
-- TempContactID used in inserts below as placeholder
		PRINT 'Delete From ContactList Complete'

Delete From ContactList Where Temp_CompanyID = 1



------------------- INSERTS TO ATTORNEY TABLE---------------------------------

Insert Into Attorney (CompanyID, ContactListID, isActivestatus, FirstName, LastName, Street1, Street2, City, StateID, ZipCode, Phone, Fax, Email, Notes, Temp_AttorneyID, DepositAmountRequired, Active, DateAdded)
Select 1, 16, 1, [Attorney First Name], [Attorney Last Name], [Attorney Address], '', [Attorney City], 19, [Attorney Zip], 
'(' + Left([ATTORNEY Phone], 3) + ') ' + Right(Left([ATTORNEY Phone], 6), 3) + '-' + Right([ATTORNEY Phone], 4), 
'(' + Left([ATTORNEY FAX], 3) + ') ' + Right(Left([ATTORNEY FAX], 6), 3) + '-' + Right([ATTORNEY FAX], 4),
 '', [Memo], [Attorney No], .10 as DepositAmountRequired, 1, --@DateTimeVal 
 '08/6/2013 5:00 PM' 
From [DATAMIGRATION_BMM_SHARED_Attorney_List] 
WHERE [DATAMIGRATION_BMM_SHARED_Attorney_List].[Attorney Last Name] is not null 
and [DATAMIGRATION_BMM_SHARED_Attorney_List].[Attorney First Name] is not null

	PRINT 'Attorney Insert:  Attorney Table'


Insert into ContactList (DateAdded, Temp_AttorneyID, Temp_CompanyID)
Select --@DateTimeVal 
'08/6/2013 5:00 PM', ID, 1  
from [Attorney]
Where Attorney.ContactListID = 16

	PRINT 'Attorney Insert:  ContactList Table'


Update Attorney
Set ContactListID =  ContactList.ID
From Attorney inner join ContactList on Attorney.ID = ContactList.Temp_AttorneyID
Where Attorney.ContactListID = 16
and Temp_CompanyID = 1
-- ContactListID is temporary to get records inserted initially
	
	
	PRINT 'Attorney Insert:  Attorney Table Update with ContactListID'
	
	PRINT '--ATTORNEY INSERT COMPLETE--'



-----------------INSERTS TO PROVIDER TABLE --(Surgery)----------------------------------

INSERT INTO Provider (CompanyID, ContactListID, isActiveStatus, Name, Street1, City, 
StateID, ZipCode, Phone, Fax, FacilityAbbreviation, DiscountPercentage, Active, MRICostTypeID, Temp_ProviderID, Temp_Type)
Select 1, 16, 1, 
IsNull(DATAMIGRATION_BMM_SURGERY_Providers.Name, 'No Name At Import'), 
Isnull(Address, '9191 Siegen Ln'),
IsNull(City, 'Baton Rouge'), 
isnull(States.ID, 19) ,
isnull(Zip, '70810'), 
isnull( '(' + Left([Phone], 3) + ') ' + Right(Left([Phone], 6), 3) + '-' + Right([Phone], 4), 'none'), 
 '(' + Left([FAX], 3) + ') ' + Right(Left([FAX], 6), 3) + '-' + Right([FAX], 4),
Abbrev, discount , 1, 1, DATAMIGRATION_BMM_SURGERY_Providers.provider, 'Surgery' as Temp_Type
 From DATAMIGRATION_BMM_SURGERY_Providers LEFT join States on DATAMIGRATION_BMM_SURGERY_Providers.State = States.Abbreviation

	PRINT 'Provider (Surgery) Insert:  Provider Table'


Insert Into ContactList (DateAdded, Temp_ProviderID, Temp_CompanyID)
Select '08/6/2013 5:00 PM' , ID, 1
from Provider
Where Provider.ContactListID = 16
and Provider.CompanyID = 1

	PRINT 'Provider (Surgery) Insert:  Contact  List'


Update Provider
Set ContactListID = ContactList.ID
From Provider inner join ContactList on Provider.ID = ContactList.Temp_ProviderID
Where Provider.ContactListID = 16
and Temp_CompanyID = 1

	PRINT 'Provider (Surgery) Insert:  Update of Provider Table with Contact List ID'
	PRINT '--PROVIDER SURGERY INSERT COMPLETE--'



-----------------INSERTS TO PROVIDER TABLE --(Tests)----------------------------------


INSERT INTO Provider (CompanyID, ContactListID, isActiveStatus, Name, Street1, City, 
StateID, ZipCode, Phone, Fax, FacilityAbbreviation, DiscountPercentage, Active, MRICostTypeID, Temp_ProviderID, Temp_Type)

Select 1, 16, 1, 
IsNull([Facility Name], 'No Name At Import'), 
Isnull([Facility Address], '9191 Siegen Ln'),
IsNull([Facility City], 'Baton Rouge'), 
isnull(States.ID, 19) ,
isnull([Facility Zip], '70810'), 
isnull( '(' + Left([Facility Phone], 3) + ') ' + Right(Left([Facility Phone], 6), 3) + '-' + Right([Facility Phone], 4), 'none'), 
 '(' + Left([Facility FAX], 3) + ') ' + Right(Left([Facility FAX], 6), 3) + '-' + Right([Facility FAX], 4),
FacilityAbbrev, discount , 1, 1, DATAMIGRATION_BMM_TEST_Provider_List.[Facility No], 'Test' as Temp_Type
 From DATAMIGRATION_BMM_TEST_Provider_List
 LEFT join States on 
 DATAMIGRATION_BMM_TEST_Provider_List.[Facility State]= States.Abbreviation 

	PRINT 'Provider (TEST) Insert:  Provider Table'


Insert Into ContactList (DateAdded, Temp_ProviderID, Temp_CompanyID)
Select --@DateTimeVal 
'08/6/2013 5:00 PM', ID, 1
from Provider
Where Provider.ContactListID = 16

	PRINT 'Provider (TEST) Insert:  Contact  List'


Update Provider
Set ContactListID = ContactList.ID
From Provider inner join ContactList on Provider.ID = ContactList.Temp_ProviderID
Where Provider.ContactListID = 16
and Provider.CompanyID = 1

	PRINT 'Provider (TEST) Insert:  Update of Provider Table with Contact List ID'
	PRINT '--PROVIDER TEST INSERT COMPLETE--'



-----------------INSERTS TO Physician TABLE --(Tests)----------------------------------


INSERT INTO Physician (CompanyID, ContactListID, isActiveStatus, FirstName, LastName, Street1, Street2, City, 
StateID, ZipCode, Phone, Fax,  Active, Notes, Temp_PhysicianID)

Select 1, 16, 1, 
IsNull([Physician First Name] , 'No Name At Import'),
IsNull([Physician Last Name]  , 'No Name At Import'),
 Isnull([Physician Address] , '9191 Siegen Ln'),
 Isnull([Physician Address2], ''),
IsNull([Physician City], 'Baton Rouge'), 
isnull(States.ID, 19) ,
isnull([Physician Zip] , '70810'), 
isnull( '(' + Left([Physician Phone], 3) + ') ' + Right(Left([Physician Phone], 6), 3) + '-' + Right([Physician Phone], 4), 'none'), 
 '(' + Left([Physician FAX], 3) + ') ' + Right(Left([Physician FAX], 6), 3) + '-' + Right([Physician FAX], 4),
1, Memo,
DATAMIGRATION_BMM_TEST_Physician_List.[Physician No]
 From DATAMIGRATION_BMM_TEST_Physician_List
 LEFT join States on 
 DATAMIGRATION_BMM_TEST_Physician_List.[Physician State]= States.Abbreviation 

	PRINT 'Physican (TEST) Insert:  Physican Table'
 
Insert Into ContactList (DateAdded, Temp_PhysicianID, Temp_CompanyID)
Select '08/6/2013 5:00 PM' , ID, 1
from Physician
Where Physician.ContactListID = 16
and Physician.CompanyID = 1

	PRINT 'Physican (TEST) Insert:  Contact  List'


Update Physician
Set ContactListID = ContactList.ID
From Physician inner join ContactList on Physician.ID = ContactList.Temp_PhysicianID
Where Physician.ContactListID = 16
and Physician.CompanyID = 1

	PRINT 'Physician (TEST) Insert:  Update of Physician Table with Contact List ID'
	PRINT '--Physician TEST INSERT COMPLETE--'


-------------------------- Insert into Patients (Surgery) ----------------------------
Insert Into Patient (CompanyID, isActiveStatus, FirstName, LastName, SSN, Street1, City, StateID, ZipCode, Phone, WorkPhone, DateOfBirth, Active, Temp_InvoiceID)
Select 1,1,[Client Name], [Client Last Name], SSN, [Client Address], [Client City], States.ID, isnull([Client Zip], 'none'), 
isnull([Client Phone], 'none'),
[Client WorkPhone],
IsNull([Client Date of Birth], '1/1/1900'), 1, [Invoice Number]
From DATAMIGRATION_BMM_SURGERY_BMM 
inner join States on DATAMIGRATION_BMM_SURGERY_BMM.[Client State] = States.Abbreviation
Where [DATAMIGRATION_BMM_SURGERY_BMM].[SSN] is not null
Group by [Client Name], [Client Last Name], SSN, [Client Address], [Client City], States.ID, [Client Zip], 
[Client Phone],
[Client WorkPhone],
[Client Date of Birth],
[Invoice Number]

		PRINT 'Patient SURGERY Insert:  Patient Table'

		PRINT '--Patient (Surgery) INSERT COMPLETE--'




-------------------------- Insert into Patients (TEST) ----------------------------
Insert Into Patient (CompanyID, isActiveStatus, FirstName, LastName, SSN, Street1, City, StateID, ZipCode, Phone, WorkPhone, DateOfBirth, Active, Temp_InvoiceID)
Select 1,1,[Client Name], [Client Last Name], 
isnull(SSN, '000000000'), 
isnull([Client Address], 'Not Provided'), 
isnull([Client City], 'none'), 
States.ID, isnull([Client Zip], 'none'), 
isnull([Client Phone], 'none'),
[Client WorkPhone],
IsNull([Client Date of Birth], '1/1/1900'), 1, [Invoice Number]
From DATAMIGRATION_BMM_TEST_BMM 
inner join States on DATAMIGRATION_BMM_TEST_BMM.[Client State] = States.Abbreviation
--Where [DATAMIGRATION_BMM_TEST_BMM].[SSN] is not null
Group by [Client Name], [Client Last Name], SSN, [Client Address], [Client City], States.ID, [Client Zip], 
[Client Phone],
[Client WorkPhone],
[Client Date of Birth],
[Invoice Number]


		PRINT 'Patient (Test) Insert:  Patient Table'


Insert Into PatientChangeLog (PatientID, UserID, InformationUpdated, Active, Temp_CompanyID)
Select ID, 84,-- TempUserID
 'Initial Import of Patient (Test) Information', 1, 1
From Patient Where Patient.Active = 1 and Patient.CompanyID = 1

		PRINT 'Patient Insert:  Patient Change Log (Test and Surgery)'
		PRINT '--Patient INSERT COMPLETE--'



------------------------- Insert Into InvoiceContactList (Attorney Info:  SURGERY)

Insert Into InvoiceContactList (Active, DateAdded, Temp_AttorneyID, Temp_Invoice, Temp_CompanyID)
Select 1, '08/6/2013 5:00 PM'
--@DateTimeVal
, [Attorney No], [Invoice Number], 1
From DATAMIGRATION_BMM_SURGERY_BMM

	PRINT '--Invoice Contact List (Attorney:  SURGERY) INSERT COMPLETE--'


------------------------- INSERT Into INvoiceContactList (Attorney Info:  TESTING)

Insert Into InvoiceContactList (Active, DateAdded, Temp_AttorneyID, Temp_Invoice, Temp_CompanyID)
Select 1, '08/6/2013 5:00 PM',
--@DateTimeVal, 
[Attorney No], [Invoice Number], 1
From DATAMIGRATION_BMM_TEST_BMM

	PRINT '--InvoiceContactList (Attorney:  TESTING) INSERT Complete--'
	


------------------------- INSERT Into INvoiceContactList (Provider Info:  TESTING)

Insert Into InvoiceContactList (Active, DateAdded, Temp_ProviderID, Temp_Invoice, Temp_CompanyID)
Select 1,  '08/6/2013 5:00 PM',
--@DateTimeVal,
 [Provider No] , [Invoice No], 1
From DATAMIGRATION_BMM_TEST_Test_List
Group By [Provider No], [Invoice No]


	PRINT '--InvoiceContactList (Provider: TESTING) INSERT Complete--'
	

------------------------- INSERT Into INvoiceContactList (Physician Info:  TESTING)

Insert Into InvoiceContactList (Active, DateAdded, Temp_PhysicianID, Temp_Invoice, Temp_CompanyID)
Select 1, '08/6/2013 5:00 PM', [Physician No], [Invoice Number], 1
From DATAMIGRATION_BMM_TEST_BMM

	PRINT '--InvoiceContactList (Physician:  TESTING) INSERT Complete--'

	


---------------------  INSERT Into InvoiceAttorney (SURGERY)

Insert Into InvoiceAttorney (AttorneyID, InvoiceContactListID, isActivestatus, FirstName, LastName,
Street1, Street2, City, StateID, ZipCode, Phone, Fax, Email, Notes, DiscountNotes, DepositAmountRequired, Active, DateAdded, 
Temp_InvoiceNumber, Temp_AttorneyID, Temp_CompanyID)

SELECT Attorney.ID, InvoiceContactList.ID, 1, Attorney.FirstName, Attorney.LastName,
Attorney.Street1, Attorney.Street2, Attorney.City, Attorney.StateID, Attorney.ZipCode,
Attorney.Phone, Attorney.Fax, Attorney.Email, Attorney.Notes, Attorney.DiscountNotes, Attorney.DepositAmountRequired,
Attorney.Active, Attorney.DateAdded, DataMigration_BMM_Surgery_BMM.[Invoice Number], Attorney.Temp_AttorneyID, 1
From DataMigration_BMM_Surgery_BMM 
inner join Attorney on DATAMIGRATION_BMM_SURGERY_BMM.[Attorney No] =
Attorney.Temp_AttorneyID 
inner join InvoiceContactList on InvoiceContactList.Temp_AttorneyID = Attorney.Temp_AttorneyID 
and InvoiceContactList.Temp_Invoice = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
and Attorney.CompanyID = 1

	PRINT '--Invoice Attorney INSERT COMPLETE--'


---------------------  INSERT Into InvoiceAttorney (TESTING)

Insert Into InvoiceAttorney (AttorneyID, InvoiceContactListID, isActivestatus, FirstName, LastName,
Street1, Street2, City, StateID, ZipCode, Phone, Fax, Email, Notes, DiscountNotes, DepositAmountRequired, Active, DateAdded, 
Temp_InvoiceNumber, Temp_AttorneyID, Temp_CompanyID)

SELECT Attorney.ID, InvoiceContactList.ID, 1, Attorney.FirstName, Attorney.LastName,
Attorney.Street1, Attorney.Street2, Attorney.City, Attorney.StateID, Attorney.ZipCode,
Attorney.Phone, Attorney.Fax, Attorney.Email, Attorney.Notes, Attorney.DiscountNotes, Attorney.DepositAmountRequired,
Attorney.Active, Attorney.DateAdded, DataMigration_BMM_TEST_BMM.[Invoice Number], Attorney.Temp_AttorneyID, 1
From DataMigration_BMM_TEST_BMM 
inner join Attorney on DATAMIGRATION_BMM_TEST_BMM.[Attorney No] =
Attorney.Temp_AttorneyID 
inner join InvoiceContactList on InvoiceContactList.Temp_AttorneyID = Attorney.Temp_AttorneyID 
and InvoiceContactList.Temp_Invoice = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number]
and Attorney.CompanyID = 1
and InvoiceContactList.Temp_CompanyID = 1




-----  insert into Invoice_Patient table (Surgery)

Insert Into InvoicePatient (PatientID, isActiveStatus, FirstName, LastName, SSN, Street1, Street2, City, StateID,
ZipCode, PHone, WorkPhone, DateofBirth, Active, DateAdded, Temp_CompanyID)

SELECT Patient.ID, 1, FirstName, LastName, Patient.SSN, Street1, Street2, City, StateID, 
ZipCode, Phone, WorkPhone, DateOfBirth, Active, DateAdded, 1
From Patient inner join DataMigration_BMM_SURGERY_BMM
on  Patient.Temp_InvoiceID = dbo.DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number] 
and CompanyID = 1

	PRINT '--INVOICE_PATIENT INSERT COMPLETE SURGERY--'


-----  insert into Invoice_Patient table (TESTING)

Insert Into InvoicePatient (PatientID, isActiveStatus, FirstName, LastName, SSN, Street1, Street2, City, StateID,
ZipCode, PHone, WorkPhone, DateofBirth, Active, DateAdded, Temp_CompanyID)

SELECT Patient.ID, 1, FirstName, LastName, Patient.SSN, Street1, Street2, City, StateID, 
ZipCode, Phone, WorkPhone, DateOfBirth, Active, DateAdded, 1
From Patient inner join DataMigration_BMM_TEST_BMM
on  Patient.Temp_InvoiceID = dbo.DATAMIGRATION_BMM_TEST_BMM.[Invoice Number] 
and CompanyID = 1


	PRINT '--INVOICE_PATIENT INSERT COMPLETE TESTS--'


--------------------------INSERT SurgeryInvoice


Insert Into SurgeryInvoice ( Active, DateAdded, Temp_InvoiceID, Temp_CompanyID)
Select 1, --@DateTimeVal 
'08/6/2013 5:00 PM', [Invoice Number], 1
From DATAMIGRATION_BMM_SURGERY_BMM

	PRINT '--SURGERYINVOICE INSERT COMPLETE--'


-----------------------  Insert TEST

-- only inserts new tests since last import

Insert Into Test (CompanyID, Name, Active, DateAdded)
Select 1, [Test Name] , 1, '08/6/2013 5:00 PM'
 --@DateTimeVal 
From DATAMIGRATION_BMM_TEST_TEST_List LEFT join Test on [Test Name] = [Name]
Where [Test Name] is not null 
and [Name] is null
Group By [Test Name]

Update Test 
Set Temp_TestTypeID = 1
Where (Test.Name Like '%IDET%'
or Test.Name Like '%Disk%'
or Test.Name Like '%Disc%'
or Test.Name Like '%ESI%'
or Test.Name Like '%Facet%'
or Test.Name Like '%Anesthesia'
or Test.Name Like '%Myelogram%'
or Test.Name Like '%Cervical%'
or Test.Name Like '%Rhizo%'
or Test.Name Like '%RF%'
or Test.Name Like '%Chiropractic%'
or Test.Name Like '%Injection%'
or Test.Name Like '%Evaluation%'
or test.Name Like '%treatment%'
or test.name Like '%MBB%'
or test.name Like '%Branch%'
or test.name Like '%TP%'
or test.name like '%ONB%'
or test.name like '%OCB%'
or test.name like '%Occipital%'
or test.name like '%eval%'
or test.name like '%Procedure%'
or test.name like '%Office%'
Or test.name like '%Visit%'
or test.name like '%Denervation%'
or test.name like '%SNRB%'
or test.name like '%Transfor%'
or test.name like '%Radio%'
or test.name like '%Arth%'
or test.name like '%Block%'
)
and CompanyID = 1

Update Test 
Set Temp_TestTypeID = 2 -- MRI
Where (Test.Name Like '%MRI%'
or Test.Name Like '%MIR%'
or Test.Name Like '%Lumbar%'
or Test.Name Like '%Cervical%'
or Test.Name Like '%Thoracic%'
or Test.Name Like '%complete%'
or Test.Name Like '%lumbar%')
and CompanyID = 1


Update Test 
Set Temp_TestTypeID = 3 -- OTHER
Where (Test.Name Like '%blood%'
or Test.Name Like '%work%'
or Test.Name Like '%dmx%'
or Test.Name Like '%sedation%'
or Test.Name Like '%urinalysis%'
or Test.Name Like '%fluor%'
or Test.Name Like '%fee%'
or Test.Name Like '%ems%'
or Test.Name Like '%sleep%'
or Test.Name Like '%study%'
or Test.Name Like '%no show%'
or Test.Name Like '%eeg%'
or test.Name Like '%24 hour%'
or test.name Like '%blood patch%'
or test.name Like '%ultra%'
or test.name Like '%radiology%'
or test.name like '%CT%'
or test.name like '%x-ray%'
or test.name like '%ray%'
or test.name like '%scan%'
or test.name like '%CAT%'
or test.name like '%Physical%'
Or test.name like '%Therapy%'
or test.name like '%Gadolinium%'
or test.name like '%FEE%'
or test.name like '%Contrast%'
or test.name like '%EMG%'
or test.name like '%NCV%'
or test.name like '%SSEP%'
or test.name like '%DEP%'
or test.name like '%MRA%'
or test.name like '%MR%'
or test.name like '%Angiogram%'
or test.name like '%Ultrasound%'
or test.name like '%Mammogram%'
or test.name like '%Medical Records%'
or Test.Name like '%left elbow%')
and CompanyID = 1
and Temp_TestTypeID is null

--and Temp_TestTypeID <> 1 and Temp_TestTypeID <> 2

	PRINT '--Updates to Test Name Complete--'


-------------------------INSERT InvoicePhysician (for TESTING)

Insert Into InvoicePhysician (PhysicianID, InvoiceContactListID, isActivestatus, FirstName, LastName,
Street1, Street2, City, StateID, ZipCode, Phone, Fax, EmailAddress, Notes, 
Active, DateAdded, Temp_InvoiceNumber, Temp_PhysicianID, Temp_CompanyID)

SELECT Physician.ID, InvoiceContactList.ID, 1, Physician.FirstName, Physician.LastName,
Physician.Street1, Physician.Street2, Physician.City, Physician.StateID, Physician.ZipCode,
Physician.Phone, Physician.Fax, Physician.EmailAddress, Physician.Notes, 
Physician.Active, Physician.DateAdded, DataMigration_BMM_TEST_BMM.[Invoice Number], PHysician.Temp_PhysicianID, 1
From DataMigration_BMM_TEST_BMM 
inner join Physician on DATAMIGRATION_BMM_TEST_BMM.[Physician No] =
Physician.Temp_PhysicianID 
inner join InvoiceContactList on InvoiceContactList.Temp_PhysicianID = Physician.Temp_PhysicianID 
and InvoiceContactList.Temp_Invoice = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number]
and Physician.CompanyID = 1
and InvoiceContactList.Temp_CompanyID = 1

--Select * From Test Where Temp_TestTypeID is null and CompanyID = 2

--------------------------INSERT TESTInvoice

Insert Into TestInvoice ( TestTypeID, Active, DateAdded, Temp_TestNo, Temp_InvoiceID, Temp_CompanyID)
Select Max(Test.Temp_TestTypeID), 1, '08/6/2013 5:00 PM',
--@DateTimeVal, 
Max(DATAMIGRATION_BMM_TEST_TEST_List.[Test No]), DATAMIGRATION_BMM_TEST_TEST_List.[Invoice No], 1 
from DATAMIGRATION_BMM_TEST_TEST_List inner join Test on Test.Name = DataMigration_BMM_TEst_Test_List.[Test Name]
and Test.CompanyID = 1
Group By DATAMIGRATION_BMM_TEST_TEST_List.[Invoice No] 
having MAX(Test.Temp_TestTypeID) is not null -- Needs to pull as an exception 
--AND DATAMIGRATION_BMM_TEST_TEST_List.[Invoice No] = 1711

--Select * From DATAMIGRATION_BMM_TEST_BMM Where [Invoice Number] = 8067 
--Select * From DATAMIGRATION_BMM_TEST_TEST_List Where [Invoice No] = 8067
--Select * From InvoicePhysician Where Temp_InvoiceNumber = 1714
	PRINT '--INSERT TEST INVOICE COMPLETE--'

--Select * From InvoiceContactList Where Temp_Invoice = 8067

--Where InvoiceContactList.Temp_ProviderID in (5074, 5075)	
	
Insert Into InvoiceProvider (InvoiceContactListID, ProviderID, isActiveStatus, 
Name, Street1, Street2, City, StateID, ZipCode, Phone, Fax, Email, 
Notes, FacilityAbbreviation, DiscountPercentage, MRICostTypeID, MRICostFlatRate, MRICostPercentage, 
DaysUntilPaymentDue, Deposits, Active, DateAdded, Temp_ProviderID, Temp_InvoiceID, Temp_CompanyID)

Select InvoiceContactList.ID, Provider.ID, Provider.isActiveStatus, 
Provider.Name, Provider.Street1, Provider.Street2, Provider.City, Provider.StateID, Provider.ZipCode, Provider.Phone, Provider.Fax, Provider.Email,
Provider.Notes, Provider.FacilityAbbreviation, Provider.DiscountPercentage, Provider.MRICostTypeID, Provider.MRICostFlatRate, Provider.MRICostPercentage,
Provider.DaysUntilPaymentDue, Provider.Deposits, Provider.Active, Provider.DateAdded, Provider.Temp_ProviderID, 
InvoiceContactList.Temp_Invoice, InvoiceContactList.Temp_CompanyID

From InvoiceContactList inner join Provider on InvoiceContactList.Temp_ProviderID = Provider.Temp_ProviderID 
inner join DATAMIGRATION_BMM_TEST_Test_List on InvoiceContactList.Temp_Invoice = DATAMIGRATION_BMM_TEST_TEST_List.[Invoice No] 
and DATAMIGRATION_BMM_TEST_Test_List.[Provider No] = InvoiceContactList.Temp_ProviderID

Where InvoiceContactList.Temp_CompanyID = 1
and Provider.CompanyID = 1
and Provider.Temp_Type = 'Test'
order by Temp_Invoice

--and InvoiceContactList.Temp_Invoice 
-- Stopped here 6/12/2013  too many providers iwthout invoice...
--Select * From Provider Where Temp_ProviderID = 121

--Select * From InvoiceContactList where Temp_ProviderID = 121 and Temp_CompanyID = 1

	PRINT '--INSERT INvoice Contact List:  Providers (TEST Invoice)'


----------------------- Convert Times in DATAMIGRATION_BMM_TEST_TEST_List TABLE ----

/*Select [Test time],  (LTRIM([Test Time])) + ' PM'
From DATAMIGRATION_BMM_TEST_TEST_List 
WHERE
Len(LTRIM([Test Time])) = 4
and (LTRIM([Test Time])) Not Like '%P%' 
and (LTRIM([Test Time])) Not Like '%A%' 
and LEFT((LTRIM([Test Time])), 1) Like '1%'
*/


----------------------- Insert TestInvoice_TEST
Delete From TestInvoice_Test where Temp_CompanyID = 1


Insert Into TestInvoice_Test (TestInvoiceID, TestID, InvoiceProviderID, Notes, TestDate, TestTime, NumberOfTests,
MRI, IsPositive, isCanceled, TestCost, PPODiscount, AmountToProvider, CalculateAmountToProvider, ProviderDueDate, 
DepositToProvider, AmountPaidToProvider, Date, CheckNumber, Active, DateAdded, Temp_InvoiceID, Temp_CompanyID) 

Select TESTInvoice.ID, 
Test.ID, 
InvoiceProvider.ID, 
'test', 
isnull(Convert(date, [Test Date]), '1/1/1900'), 
--ISNULL([TestTimeTIME], '11:59 PM'),
'8:00 PM',

[Number of Tests], 
ISNULL([MRI], 0), 
Case When [Test Results] = 'Negative' Then 0
When [Test Results] = 'Positive' Then 1
When [Test Results] = null then ''
End as IsPositive, 
Canceled, 
isnUll([Test Cost], 0), 
IsNull([PPO Discount], 0), 
IsNull([Amount Paid To Provider],0), 
IsNull([Amount Paid To Provider],0), 

Case When (Convert(date,[Amount Due To Provider Due Date])) is null Then '1/1/2099'
When (Convert(date,[Amount Due To Provider Due Date])) is not null Then (Convert(date,[Amount Due To Provider Due Date])) 
End [Amount Due To Provider Due Date],

[Amount Paid To Provider], 
[Amount Paid To Provider],  
Convert(date,[Amount Due To Provider Due Date]),
[Amount Paid To Provider Check No], 
1 as Active, 

--@DateTimeVal as DateAdded,
'08/6/2013 5:00 PM' as dateadded,
TESTInvoice.Temp_InvoiceID,
1 as Temp_CompanyID 

--Select * 
From TestInvoice inner join DATAMIGRATION_BMM_TEST_BMM 
on TestInvoice.Temp_InvoiceID = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number]

inner join DataMigration_BMM_TEST_TEST_List on DATAMIGRATION_BMM_TEST_BMM.[Invoice Number] 
= DATAMIGRATION_BMM_TEST_TEST_LIST.[Invoice No] 
inner join TEST on TEST.Name = DATAMIGRATION_BMM_TEST_TEST_List.[Test Name] 
--Where DATAMIGRATION_BMM_TEST_Test_List.[Invoice No] = 1002

inner join InvoiceProvider on DATAMIGRATION_BMM_TEST_TEST_List.[Invoice No] = InvoiceProvider.Temp_INvoiceID  
and DATAMIGRATION_BMM_TEST_TEST_List.[Provider no] = InvoiceProvider.Temp_ProviderID 

LEFT Join Temp_TestTimeValConversionTEXTToTime 
on DATAMIGRATION_BMM_TEST_TEST_LIST.[Test time] = Temp_TestTimeValConversionTEXTToTime.TestTimeTEXT  
Where TEST.CompanyID = 1 and 
TestInvoice.Temp_CompanyID = 1
and InvoiceProvider.Temp_CompanyID = 1
--and TestInvoice.Temp_InvoiceID = 1002
order by TestInvoice.Temp_InvoiceID

--Select * from INvoiceProvider Where InvoiceProvider.Temp_CompanyID = 1 and InvoiceProvider.Temp_InvoiceID = 1002
--Select * From DATAMIGRATION_BMM_TEST_Test_List Where [Invoice No] = 1002

--Select * From TestInvoice where Temp_InvoiceID = 1002
--and DATAMIGRATION_BMM_TEST_TEST_LIST.[Invoice No] = 1714


--Select * From InvoiceProvider Where Temp_InvoiceID = 1714

--Select [Invoice no] From DATAMIGRATION_BMM_TEST_TEST_LIST  
--Group by [Invoice No]
--order by [Invoice No]


--Select [Temp_InvoiceID] From TestInvoice
--Group By [Temp_InvoiceID] 
--order by Temp_InvoiceID


--Select * From DATAMIGRATION_BMM_TEST_TEST_LIST
--Where [Invoice No] = 1711

--and [Amount Due To Provider Due Date] is not null -- Add to Exceptions  12/19/2012:  Commenting Out for TEST Invoices Only Because Believed to be Culprit on why some test info is not populating on certain invoices.

 /*

Select * From InvoiceProvider Where Temp_InvoiceID = 8067
Select * From DATAMIGRATION_BMM_TEST Where Provider
Select * From DATAMIGRATION_BMM_TEST_TEST_List Where [Invoice No] = 8067
Select * From Test Where Test.Name = 'RADIOLOGY FEE' OR Test.Name = 'Cervical Spect Scan & X-rays'
Select * From TestINvoice_TEST Where TestINvoice_Test.Temp_InvoiceID = 8067
*/

/*
SELECT     Test.ID AS [Test.ID], Test.CompanyID, TestInvoice.ID AS [TestInvoice.iD], Test.Name AS [Test.Name], Provider.ID AS [Provider.ID]
FROM         DATAMIGRATION_BMM_TEST_BMM INNER JOIN
                      DATAMIGRATION_BMM_TEST_TEST_List ON DATAMIGRATION_BMM_TEST_BMM.[Invoice Number] = DATAMIGRATION_BMM_TEST_TEST_List.[Invoice No] INNER JOIN
                      Test ON DATAMIGRATION_BMM_TEST_TEST_List.[Test Name] = Test.Name INNER JOIN
                      TestInvoice ON DATAMIGRATION_BMM_TEST_BMM.[Invoice Number] = TestInvoice.Temp_InvoiceID INNER JOIN
                      Provider ON DATAMIGRATION_BMM_TEST_BMM.[Provider No] = Provider.Temp_ProviderID
WHERE     (Test.CompanyID = 2)

*/


-----------------------  InSERT Surgery

Insert Into Surgery (CompanyID, Name, Active, DateAdded)
Select 1, SurgeryType, 1,  '08/6/2013 5:00 PM'
--@DateTimeVal 
From DATAMIGRATION_BMM_SURGERY_BMM
where SurgeryType is not null
Group By SurgeryType




	PRINT '--SURGERY INSERT COMPLETE--'



----------------------- Insert SurgeryInvoice_Surgery

Insert Into SurgeryInvoice_Surgery (SurgeryInvoiceID, SurgeryID, isInpatient, Notes, Active, DateAdded, Temp_InvoiceID, Temp_CompanyID)
Select SurgeryInvoice.ID, Surgery.ID, DATAMIGRATION_BMM_SURGERY_BMM.inpatient, DATAMIGRATION_BMM_SURGERY_BMM.Notes,
1, '08/6/2013 5:00 PM',
--@DateTimeVal , 
SurgeryInvoice.Temp_InvoiceID, 1 

From SurgeryInvoice inner join DATAMIGRATION_BMM_SURGERY_BMM on SurgeryInvoice.Temp_InvoiceID = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
inner join Surgery on Surgery.Name = DATAMIGRATION_BMM_SURGERY_BMM.SurgeryType
Where Surgery.CompanyID = 1
and SurgeryInvoice.Temp_CompanyID = 1


	PRINT '--SURGERYINVOICE_SURGERY INSERT COMPLETE--'


------------------------ Insert SurgeryInvoice_SurgeryDates

Insert Into SurgeryInvoice_SurgeryDates (SurgeryInvoice_SurgeryID, ScheduledDate, isPrimaryDate, Active, DateAdded, Temp_CompanyID)
Select SurgeryInvoice_Surgery.ID, DATAMIGRATION_BMM_SURGERY_BMM.DateScheduled, 1, 1, '08/6/2013 5:00 PM',
--@DateTimeVal ,
 1 

From SurgeryInvoice inner join DATAMIGRATION_BMM_SURGERY_BMM on SurgeryInvoice.Temp_InvoiceID = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
inner join Surgery on Surgery.Name = DATAMIGRATION_BMM_SURGERY_BMM.SurgeryType
inner join SurgeryInvoice_Surgery on SurgeryInvoice_Surgery.SurgeryInvoiceID = SurgeryInvoice.ID
Where Surgery.CompanyID = 1
and SurgeryInvoice.Temp_CompanyID = 1
and DATEScheduled is not null

	PRINT '--SURGERYINVOICE_SURGERYDATES INSERT COMPLETE--'


-------------------------  Insert InvoiceContactList (provider info) SURGERY

insert into InvoiceContactList (Active, DateAdded, Temp_ProviderID, Temp_Invoice, Temp_CompanyID)
Select 1, '08/6/2013 5:00 PM' , Provider, DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number], 1  
from DATAMIGRATION_BMM_SURGERY_BMM inner join DATAMIGRATION_BMM_SURGERY_Services
on DATAMIGRATION_BMM_SURGERY_BMM.[invoice number] = DATAMIGRATION_BMM_SURGERY_Services.InvoiceNumber
--Where [Invoice Number] = 2883
Group By Provider, Provider, DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number] 

	PRINT '--INVOICECONTACTLIST TEST INSERT COMPLETE--'


-------------------------  Insert InvoiceContactList (provider info) TEST
/*

insert into InvoiceContactList (Active, DateAdded, Temp_ProviderID, Temp_Invoice, Temp_CompanyID)
Select 1, '10/10/2012 12:30 PM' , Provider, DATAMIGRATION_BMM_TEST_BMM.[Invoice Number], 2  
from DATAMIGRATION_BMM_TEST_BMM inner join DATAMIGRATION_BMM_TEST_Services
on DATAMIGRATION_BMM_TEST_BMM.[invoice number] = DATAMIGRATION_BMM_TEST_Services.InvoiceNumber
--Where [Invoice Number] = 2883
Group By Provider, Provider, DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number] 

	PRINT '--INVOICECONTACTLIST TEST INSERT COMPLETE--'
*/
-------------------------- Insert InvoiceProvider (Surgery) --------

Insert Into InvoiceProvider (InvoiceContactListID, ProviderID, isActiveStatus, Name, Street1, Street2, City, StateID, ZipCode, Phone, Fax, Email, Notes, FacilityAbbreviation, DiscountPercentage, MRICostTypeID, MRICostFlatRate, MRICostPercentage, DaysUntilPaymentDue, Deposits, Active, DateAdded, Temp_providerID, Temp_InvoiceID, Temp_CompanyID)
Select InvoiceContactList.ID as InvoiceContactListID, Provider.ID as ProviderID, 1 as isActiveStatus, Provider.Name, Provider.Street1, Provider.Street2, Provider.City, 
Provider.StateID, Provider.ZipCode, Provider.Phone, Provider.Fax, Provider.Email, Provider.Notes, Provider.FacilityAbbreviation, Provider.DiscountPercentage, Provider.MRICostTypeID, Provider.MRICostFlatRate, Provider.MRICostPercentage, Provider.DaysUntilPaymentDue, Provider.Deposits, Provider.Active, Provider.DateAdded, Provider.Temp_ProviderID, InvoiceContactList.Temp_Invoice, 1

From InvoiceContactList inner join dbo.Provider 
on InvoiceContactList.Temp_ProviderID = Provider.Temp_ProviderID 
Inner join DATAMIGRATION_BMM_SURGERY_BMM on 
InvoiceContactList.Temp_Invoice = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number] 
WHERE Provider.CompanyID = 1
and InvoiceContactList.Temp_CompanyID = 1
and Provider.Temp_Type = 'Surgery'

--WHERE Temp_Invoice = 2883

	PRINT '--INVOICEPROVIDER INSERT COMPLETE--'


--------------------------- Insert SurgeryInvoice_Providers ---------------------------

Insert Into SurgeryInvoice_Providers (SurgeryInvoiceID, InvoiceProviderID, Active, DateAdded, Temp_InvoiceID, Temp_ProviderID, Temp_CompanyID) 
Select SurgeryInvoice.ID, InvoiceProvider.ID, 1 as Active, '08/6/2013 5:00 PM',
--@DateTimeVal , 
InvoiceProvider.Temp_InvoiceID, InvoiceProvider.Temp_ProviderID, 1
From InvoiceProvider inner join SurgeryInvoice 
on InvoiceProvider.Temp_InvoiceID = SurgeryInvoice.Temp_InvoiceID
where InvoiceProvider.Temp_CompanyID = 1
and SurgeryInvoice.Temp_CompanyID = 1

--WHERE InvoiceProvider.Temp_InvoiceID = 2883
--Group By SurgeryInvoice.ID, InvoiceProvider.ID, InvoiceProvider.Temp_InvoiceID, InvoiceProvider.Temp_ProviderID 
/*
Select * From SurgeryInvoice
WHERE SurgeryInvoice.Temp_InvoiceID  = 8000

SELECT * From InvoiceProvider
WHERE InvoiceProvider.Temp_InvoiceID  = 8000
*/


	PRINT '--SURGERYINVOICE_PROVIDERS INSERT COMPLETE--'


--------------------------- Insert SurgeryInvoice_Provider_Services -------------------

/*Insert Into SurgeryInvoice_Provider_Services (SurgeryInvoice_ProviderID, EstimatedCost, Cost, 
Discount, PPODiscount, DueDate, AmountDue, AccountNumber, Active, DateAdded)

Select SurgeryInvoice_Providers.ID, DATAMIGRATION_BMM_SURGERY_SERVICES.Cost, 
DATAMIGRATION_BMM_SURGERY_SERVICES.Cost, 
1 - DATAMIGRATION_BMM_SURGERY_SERVICES.discount, 
(1 - DATAMIGRATION_BMM_SURGERY_SERVICES.discount) * DATAMIGRATION_BMM_SURGERY_Services.cost as PPODiscount, 
DATAMIGRATION_BMM_SURGERY_SERVICES.DueDate, 
DATAMIGRATION_BMM_SURGERY_SERVICES.AmountDue, '' as AccountNumber, 1, '9/25/2012 10:52 AM' 
From DATAMIGRATION_BMM_SURGERY_SERVICES inner join SurgeryInvoice_Providers  
on DATAMIGRATION_BMM_SURGERY_SERVICES.[InvoiceNumber] = SurgeryInvoice_Providers.Temp_InvoiceID
and DATAMIGRATION_BMM_SURGERY_Services.provider = SurgeryInvoice_Providers.Temp_ProviderID
*/

Insert Into SurgeryInvoice_Provider_Services (SurgeryInvoice_ProviderID, EstimatedCost, Cost, 
Discount, PPODiscount, DueDate, AmountDue, AccountNumber, Active, DateAdded, Temp_ServiceID, Temp_CompanyID)

--Select * From SurgeryInvoice_Providers
--Where SurgeryInvoice_Providers.Temp_InvoiceID = 2883

--Select * From DATAMIGRATION_BMM_SURGERY_Services
--Where [Invoicenumber] = 2883


Select SurgeryInvoice_Providers.ID, DATAMIGRATION_BMM_SURGERY_SERVICES.Cost, 
DATAMIGRATION_BMM_SURGERY_SERVICES.Cost, 
1 - DATAMIGRATION_BMM_SURGERY_SERVICES.discount,--<--Leaving as is until checked 
DATAMIGRATION_BMM_SURGERY_SERVICES.PPODiscount as PPODiscount, 
DATAMIGRATION_BMM_SURGERY_SERVICES.DueDate, 
DATAMIGRATION_BMM_SURGERY_SERVICES.AmountDue, '' as AccountNumber, 1,
-- @DateTimeVal , 
'08/6/2013 5:00 PM',
Temp_ServiceID, 1 
-- SELECT *

From DATAMIGRATION_BMM_SURGERY_SERVICES inner join SurgeryInvoice_Providers  
on DATAMIGRATION_BMM_SURGERY_SERVICES.[InvoiceNumber] = SurgeryInvoice_Providers.Temp_InvoiceID
and DATAMIGRATION_BMM_SURGERY_Services.provider = SurgeryInvoice_Providers.Temp_ProviderID

--WHERE SurgeryInvoice_Providers.Temp_InvoiceID = 2883
--order by DATAMIGRATION_BMM_SURGERY_SERVICES.Cost

Where SurgeryInvoice_Providers.Temp_CompanyID = 1

	PRINT '-- SURGERYINVOICE_PROVIDER_SERVICES INSERT COMPLETE--'


---------------------------Insert Surgery CPT Codes in the event not on disk -----------

Insert into CPTCodes (Active, Code, CompanyID, DateAdded, Description)

Select 1, CPtCode, 1, --@DateTimeVal, 
'08/6/2013 5:00 PM',
IsNull(Min(DATAMIGRATION_BMM_SURGERY_CPTCHARGES.[Description]), 'None Provided')
From DATAMIGRATION_BMM_SURGERY_CPTCharges left join CPTCodes 
on DATAMIGRATION_BMM_SURGERY_CPTCharges.cptcode  = CPTCodes.Code
WHERE CPTCodes.Code is null and Len(CPTCode) > 1
and CPTCodes.CompanyID = 1
Group By CPTCode

	PRINT '--CPTCODES INSERT COMPLETE--'


--------------------------- Insert SurgeryInvoice_Provider_CPTCode -------------------

--- NEED TO VERIFY THAT IMPORTED CPT CODES (from Disk) are not missing any codes that are currently in use in DATAMIGRATION_BMM_SURGERY_CPTCODES

Insert Into SurgeryInvoice_Provider_CPTCodes (SurgeryInvoice_ProviderID, CPTCodeID, Amount, Description, Active, DateAdded, Temp_CompanyID, Temp_InvoiceID)
Select SurgeryInvoice_Providers.ID, CPTCodes.ID, isnull(DATAMIGRATION_BMM_SURGERY_CPTCharges.Amount, 0), 

Case WHEN DATAMIGRATION_BMM_SURGERY_CPTCharges.Description is null then 'Not Provided'
WHEN  DATAMIGRATION_BMM_SURGERY_CPTCharges.Description is not null then DATAMIGRATION_BMM_SURGERY_CPTCharges.description
END
,
  1, --@DateTimeVal , 
  '08/6/2013 5:00 PM',1, DATAMIGRATION_BMM_SURGERY_CPTCharges.[Invoice Number]
--Select * 
From DATAMIGRATION_BMM_SURGERY_CPTCharges inner join SurgeryInvoice_Providers  
on DATAMIGRATION_BMM_SURGERY_CPTCharges.[Invoice Number] = SurgeryInvoice_Providers.Temp_InvoiceID
and DATAMIGRATION_BMM_SURGERY_CPTCharges.Provider = SurgeryInvoice_Providers.Temp_ProviderID
inner join CPTCodes on DATAMIGRATION_BMM_SURGERY_CPTCharges.CPTCode  = CPTCodes.Code 
Where CPTCodes.CompanyID = 1 
--and DATAMIGRATION_BMM_SURGERY_CPTCharges.[Invoice Number] = 5836
and SurgeryInvoice_Providers.Temp_CompanyID  = 1
order by Code



	PRINT '--SURGERYINVOICE_PROVIDER_CPTCODES INSERT COMPLETE--'



------------------- Insert Survery Invoice_Providers

/* ALREADY DONE ABOVE  Insert Into SurgeryInvoice_Providers (SurgeryInvoiceID, InvoiceProviderID, Active, DateAdded)

Select SurgeryInvoice_Surgery.ID, DATAMIGRATION_BMM_SURGERY_BMM.DateScheduled, 1, 1, '9/18/2012 3:07 PM' 
From SurgeryInvoice inner join DATAMIGRATION_BMM_SURGERY_BMM on 
SurgeryInvoice.Temp_InvoiceID = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
inner join Surgery on Surgery.Name = DATAMIGRATION_BMM_SURGERY_BMM.SurgeryType
inner join SurgeryInvoice_Surgery on SurgeryInvoice_Surgery.SurgeryInvoiceID = SurgeryInvoice.ID
Where Surgery.CompanyID = 2 */




--------------------------INSERT INTO Invoice Table (Surgery)


--DISABLE TRIGGER t_Invoice_Insert_InvoiceNumber ON Invoice; n

Insert Into Invoice (InvoiceNumber, CompanyID, DateOfAccident,InvoiceStatusTypeID, isComplete, --InvoicePhysicianID,
InvoiceAttorneyID, InvoicePatientID, InvoiceTypeID, --TestInvoiceID, 
SurgeryInvoiceID, InvoiceClosedDate,
DatePaid, ServiceFeeWaived, LossesAmount, YearlyInterest, LoanTermMonths, ServiceFeeWaivedMonths, 
CalculatedCumulativeIntrest, Active, DateAdded)

SELECT dbo.DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number] AS InvoiceNumber,
    1 AS CompanyID, 
    
    'DateOfAccident' = 
		Case When [Date Of Accident] = '1899-12-30' THEN
		'1/1/1900'
		When [Date Of Accident] is null THEN
		'1/1/1900'
		WHen [Date Of Accident] <> '1899-12-30' THEN
		[Date Of Accident]
		End,
    
    'InvoiceStatusTypeID' =  
		Case WHEN [Invoice Closed] = 1  or DatePaid is not null THEN 
		2
		WHEN ([Invoice Closed] = 0 or [Invoice Closed] is null) AND [BalanceDue] = 0  Or Cancelled = 1 THEN   
		2    
		WHEN ([Invoice Closed] = 0 or [Invoice Closed] IS NULL ) and [BalanceDue]  <> 0 and Cancelled <> 1  and GetDate() < [Invoice Date] + 390  THEN
		1
		WHEN ([Invoice Closed] = 0 or [Invoice Closed] IS NULL ) and [BalanceDue]  <> 0 and Cancelled <> 1  and GetDate() > [Invoice Date] + 390  THEN
		3    
		
		WHEN [Invoice Date] is null THEN
		1
		
	END,
        
	DATAMIGRATION_BMM_SURGERY_BMM.CompleteFile AS isComplete,
	--0 as INvoicePhysicianID,
	InvoiceAttorney.ID AS InvoiceAttorneyID,
	InvoicePatient.ID as InvoicePatientID,
	2 as InvoiceTypeID, -- For Surgery
	--0 as TestINvoiceID,
	SurgeryInvoice.ID as SurgeryInvoiceID,
	[Invoice Closed Date] as InvoiceClosedDate,
	DatePaid as DatePaid,
	ServiceFeeWaived as ServiceFeeWaived,
	LossesAmount as LossesAmount,
	.15 as YearlyInterest,  11 as LoanTermMonths, -- shouldbestatic per spec (normally pulls from admin pages)
isNull(DATEDIFF(Month, DATAMIGRATION_BMM_SURGERY_BMM.DateScheduled, [dateservicefeebegins]), 0) as ServiceFeeWaivedMonths,-- should be static (pulls from admin page)

'CalculatedCumulativeIntrest' = 
	Case When [interestdue] is null Then
		IsNull((Select Sum(Amount) From DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney 
		WHERE  DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney.[Invoice Number] = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
		and PaymentType = 'Interest'), 0) + ISNULL(ServiceFeeWaived,0)

		When [interestdue] = 0 Then
		IsNull((Select Sum(Amount) From DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney 
		WHERE  DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney.[Invoice Number] = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
		and PaymentType = 'Interest'), 0) + ISNULL(ServiceFeeWaived,0)
		WHEN [interestdue] > 0.01 Then
		isnull([InterestDue], 0) + IsNull((Select Sum(Amount) From DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney WHERE  DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney.[Invoice Number] = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
		and PaymentType = 'Interest'), 0)  - IsNull(ServiceFeeWaived, 0)
	End,

--(Select Sum(Amount) From Payments Where Temp_InvoiceID = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]and PaymentTypeID = 2) as TotalInterestPaid, 
--Note:  Old Data for Surgeries does not appear to keep the cumulative interest once it has been paid.  Therefore for import, if the Cumulative value = 0, we have to backwards calculate what the total interest 'was' before it was paid off to keep the records in check

	'Active' = 1,
	DATAMIGRATION_BMM_SURGERY_BMM.[DateScheduled] as DateAdded
	--Select *
	FROM dbo.DATAMIGRATION_BMM_SURGERY_BMM 
	INNER JOIN
	dbo.Attorney ON 
	dbo.DATAMIGRATION_BMM_SURGERY_BMM.[Attorney No] = dbo.Attorney.Temp_AttorneyID
	inner join Patient on Patient.Temp_InvoiceID = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
	inner join InvoicePatient on InvoicePatient.PatientID = Patient.ID
	inner join DATAMIGRATION_BMM_SHARED_Attorney_List on DATAMIGRATION_BMM_SHARED_Attorney_List.[Attorney No] = DATAMIGRATION_BMM_SURGERY_BMM.[Attorney No]
	inner join InvoiceAttorney on InvoiceAttorney.Temp_InvoiceNumber = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
	and InvoiceAttorney.Temp_AttorneyID = DATAMIGRATION_BMM_SURGERY_BMM.[Attorney No]
	inner join SurgeryInvoice on SurgeryInvoice.Temp_InvoiceID = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
	LEFT Join DATAMIGRATION_BMM_Surgery_CalcTestListTemp 
	on DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number] = DATAMIGRATION_BMM_SUrgery_CalcTestListTemp.InvoiceNumber
	
	Where DATAMIGRATION_BMM_SURGERY_BMM.[DateScheduled] is not null 
	and Attorney.CompanyID = 1
	and Patient.CompanyID = 1
	and InvoicePatient.Temp_CompanyID = 1
	and InvoiceAttorney.Temp_CompanyID =1
	and SurgeryInvoice.Temp_CompanyID = 1
	and DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number] <>  2814  ---- problem here had to exclude this one because was giving null CalcCumINterest

	order by DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
	


	PRINT '--SURGERY INVOICE INSERT COMPLETE--'



--------------------------INSERT INTO Invoice Table (Testing)


--DISABLE TRIGGER t_Invoice_Insert_InvoiceNumber ON Invoice; n

Insert Into Invoice (InvoiceNumber, CompanyID, DateOfAccident,InvoiceStatusTypeID, isComplete, InvoicePhysicianID,
InvoiceAttorneyID, InvoicePatientID, InvoiceTypeID, TestInvoiceID, InvoiceClosedDate,
DatePaid, ServiceFeeWaived, LossesAmount, YearlyInterest, LoanTermMonths, ServiceFeeWaivedMonths, 
CalculatedCumulativeIntrest, Active, DateAdded)

SELECT dbo.DATAMIGRATION_BMM_TEST_BMM.[Invoice Number] AS InvoiceNumber,
    1 AS CompanyID, 
    
    'DateOfAccident' = 
		Case When [Date Of Accident] = '1899-12-30' THEN
		'1/1/1900'
		When [Date Of Accident] is null THEN
		'1/1/1900'
		WHen [Date Of Accident] <> '1899-12-30' THEN
		[Date Of Accident]
		End,
    
    'InvoiceStatusTypeID' =  
		Case WHEN [Invoice Closed] = 1  or DatePaid is not null THEN 
		2
		WHEN ([Invoice Closed] = 0 or [Invoice Closed] is null) AND [BalanceDue] = 0  THEN   
		2    
		
		WHEN ([Invoice Closed] = 0 or [Invoice Closed] IS NULL ) and [BalanceDue]  <> 0   and (GetDate() < [Invoice Date] + 390 or [Invoice Date] is null) THEN  
		1
	
		WHEN ([Invoice Closed] = 0 or [Invoice Closed] IS NULL ) and [BalanceDue]  <> 0  and GetDate() > [Invoice Date] + 390  THEN
		3    
	END,
        
	DATAMIGRATION_BMM_TEST_BMM.CompleteFile AS isComplete,
	InvoicePhysician.ID as InvoicePhysicianID,
	InvoiceAttorney.ID AS InvoiceAttorneyID,
	InvoicePatient.ID as InvoicePatientID,
	1 as InvoiceTypeID, -- For TEST
	--0 as TestINvoiceID,
	TestInvoice.ID as TestInvoiceID,
	[Invoice Closed Date] as InvoiceClosedDate,
	DatePaid as DatePaid,
	ServiceFeeWaived as ServiceFeeWaived,
	LossesAmount as LossesAmount,
	.15 as YearlyInterest,  11 as LoanTermMonths, -- shouldbestatic per spec (normally pulls from admin pages)
isNull(DATEDIFF(Month, DATAMIGRATION_BMM_TEST_BMM.AmortizationDate, [dateservicefeebegins]), 0) as ServiceFeeWaivedMonths,-- should be static (pulls from admin page)

'CalculatedCumulativeIntrest' = 
	Case When [interestdue] is null Then
		IsNull((Select Sum(Amount) From DATAMIGRATION_BMM_TEST_Payments 
		WHERE  DATAMIGRATION_BMM_TEST_Payments.[Invoice No] = DATAMIGRATION_BMM_Test_BMM.[Invoice Number]
		and [Payment Type] = 'Interest'), 0) + ISNULL(ServiceFeeWaived,0)

		When [interestdue] = 0 Then
		IsNull((Select Sum(Amount) From DATAMIGRATION_BMM_TEST_Payments 
		WHERE  DATAMIGRATION_BMM_TEST_Payments.[Invoice No] = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number]
		and [Payment Type] = 'Interest'), 0) + ISNULL(ServiceFeeWaived,0)
		WHEN [interestdue] > 0.01 Then
		isnull([InterestDue], 0) + IsNull((Select Sum(Amount) From DATAMIGRATION_BMM_TEST_Payments WHERE  
		DATAMIGRATION_BMM_TEST_Payments.[Invoice No]  = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number]
		and [Payment Type] = 'Interest'), 0)  - IsNull(ServiceFeeWaived, 0)
	End,

--(Select Sum(Amount) From Payments Where Temp_InvoiceID = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]and PaymentTypeID = 2) as TotalInterestPaid, 
--Note:  Old Data for Surgeries does not appear to keep the cumulative interest once it has been paid.  Therefore for import, if the Cumulative value = 0, we have to backwards calculate what the total interest 'was' before it was paid off to keep the records in check

	'Active' = 1,
	--@DaateTimeVal
	'08/6/2013 5:00 PM' 
	as DateAdded  -- Should be DateScheduled but needs to pull from test detail [Test Date]]
	--Select *
	FROM dbo.DATAMIGRATION_BMM_TEST_BMM 
	INNER JOIN
	dbo.Attorney ON 
	dbo.DATAMIGRATION_BMM_TEST_BMM.[Attorney No] = dbo.Attorney.Temp_AttorneyID
	inner join Patient on Patient.Temp_InvoiceID = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number]
	inner join InvoicePatient on InvoicePatient.PatientID = Patient.ID
	inner join DATAMIGRATION_BMM_SHARED_Attorney_List on DATAMIGRATION_BMM_SHARED_Attorney_List.[Attorney No] 
	= DATAMIGRATION_BMM_TEST_BMM.[Attorney No]
	inner join InvoiceAttorney on InvoiceAttorney.Temp_InvoiceNumber = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number] 
	and InvoiceAttorney.Temp_AttorneyID = DATAMIGRATION_BMM_TEST_BMM.[Attorney No]
	inner join InvoicePhysician on InvoicePhysician.Temp_InvoiceNumber = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number]
	and InvoicePhysician.Temp_PhysicianID = DATAMIGRATION_BMM_TEST_BMM.[Physician No] 
	inner join TestInvoice on TestInvoice.Temp_InvoiceID = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number]
	LEFT Join DATAMIGRATION_BMM_SURGERY_CalcTestListTemp 
	on DATAMIGRATION_BMM_TEST_BMM.[Invoice Number] = DATAMIGRATION_BMM_SURGERY_CalcTestListTemp.InvoiceNumber
	
	Where Patient.CompanyID =1
	and Attorney.CompanyID = 1
	and InvoicePatient.Temp_CompanyID = 1
	and InvoiceAttorney.Temp_CompanyID = 1
	and InvoicePhysician.Temp_CompanyID = 1
	and TestInvoice.Temp_CompanyID =1

--ENABLE TRIGGER t_Invoice_Insert_InvoiceNumber ON Invoice;
	PRINT '--INVOICE INSERT TESTS COMPLETE--'



----------------------------------- insert into Payments (SURGERY)---------------

Insert Into Payments (InvoiceID, PaymentTypeID, DatePaid, Amount, CheckNumber, Active, DateAdded, Temp_CompanyID, Temp_InvoiceID)
Select Invoice.ID, PaymentType.ID, DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney.DatePaid, amount, 
DATAMIGRATION_BMM_SURGERY_PAYMENTSBYAttorney.[check], 
1, '08/6/2013 5:00 PM' 
--@DateTimeVal
 , 1, [invoice number]  
From DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney inner join PaymentType on DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney.PaymentType = PaymentType.Name 
inner join Invoice on DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney.[Invoice Number] = Invoice.InvoiceNumber
where Invoice.CompanyID = 1

	PRINT '--PAYMENTS INSERT COMPLETE--'
		

----------------------------------- insert into Payments (TESTS)---------------

Insert Into Payments (InvoiceID, PaymentTypeID, DatePaid, Amount, CheckNumber, Active, DateAdded, Temp_CompanyID, Temp_InvoiceID)
Select Invoice.ID, PaymentType.ID, isnull(DATAMIGRATION_BMM_TEST_Payments.[Date Paid], '1/1/1900'), isnull(amount, 0), 
isnull(DATAMIGRATION_BMM_TEST_Payments.[check no], 0), 
1, '08/6/2013 5:00 PM'
--@DateTimeVal
 , 1, [invoice no]  
From DATAMIGRATION_BMM_TEST_Payments inner join PaymentType on DATAMIGRATION_BMM_TEST_Payments.[Payment Type] = PaymentType.Name 
inner join Invoice on DATAMIGRATION_BMM_TEST_Payments.[Invoice No] = Invoice.InvoiceNumber
Where Invoice.CompanyID = 1

	PRINT '--PAYMENTS INSERT COMPLETE--'


------------------------------------ insert into SurgeryInvoice_Provider_Payments

Insert into SurgeryInvoice_Provider_Payments (SurgeryInvoice_ProviderID, PaymentTypeID, DatePaid, Amount, CheckNumber, Active, DateAdded, Temp_CompanyID)
Select SurgeryInvoice_Providers.ID, Paymenttype.ID , DatePaid, Amount, isnull(DATAMIGRATION_BMM_SURGERY_PaymentsToProviders.[Check], '0000'),  
1, '08/6/2013 5:00 PM'
--@DateTimeVal
, 1 
From SurgeryInvoice_Providers inner join DATAMIGRATION_BMM_SURGERY_PaymentsToProviders 
on DATAMIGRATION_BMM_SURGERY_PaymentsToProviders.[Invoice Number] = SurgeryInvoice_Providers.Temp_InvoiceID and
DATAMIGRATION_BMM_SURGERY_PaymentsToProviders.provider = SurgeryInvoice_Providers.Temp_ProviderID
inner join PaymentType on DATAMIGRATION_BMM_SURGERY_PaymentsToProviders.PaymentType = PaymentType.Name 
Where DatePaid is not null and SurgeryInvoice_Providers.Temp_CompanyID = 1 

	PRINT '--SURGERYINVOICE_PROVIDER_PAYMENTS INSERT COMPLETE--'



--Select * From Invoice Where InvoiceNumber = 8024

-- WHERE IS TESTING Provider Payment Info???

------------------------------------ STARTS Patient Record Consolidation Process ----------------------------------------------
--Select * From Invoice

Update  Patient 
Set SSN = '000000000'
Where LEN(SSN) < 3
and CompanyID = 1

Update Patient
Set  SSN = REPLACE(ssn, '-', '')
Where SSN Like '%-%'
and CompanyID = 1

--- Complete Four Times:  Time 1 of 4

Delete From Temp_PatientrecordConsolidation

Insert Into Temp_PatientrecordConsolidation (Original_PatientID, Temp_InvoiceID, New_PatientID, FirstName, LastName, SSN)
Select Min(ID), Min(Temp_InvoiceID), Max(ID), FirstName, LastName, SSN 
From Patient
where Active = 1 and CompanyID = 1
Group By FirstName, LastName, SSN


Update InvoicePatient
Set PatientID = New_PatientID
From InvoicePatient Inner Join Temp_PatientRecordConsolidation on InvoicePatient.PatientID = Temp_PatientRecordConsolidation.Original_PatientID
Where Temp_CompanyID = 1

Update Patient
Set Active = 0
From Patient inner join Temp_PatientRecordConsolidation On Patient.ID = Temp_PatientRecordConsolidation.Original_PatientID
Where Original_PatientID <> New_PatientID
and CompanyID = 1

--- Complete Four Times:  Time 2 of 4

Delete From Temp_PatientrecordConsolidation

Insert Into Temp_PatientrecordConsolidation (Original_PatientID, Temp_InvoiceID, New_PatientID, FirstName, LastName, SSN)
Select Min(ID), Min(Temp_InvoiceID), Max(ID), FirstName, LastName, SSN 
From Patient
where Active = 1 and CompanyID = 1
Group By FirstName, LastName, SSN


Update InvoicePatient
Set PatientID = New_PatientID
From InvoicePatient Inner Join Temp_PatientRecordConsolidation on InvoicePatient.PatientID = Temp_PatientRecordConsolidation.Original_PatientID
WHere Temp_CompanyID = 1

Update Patient
Set Active = 0
From Patient inner join Temp_PatientRecordConsolidation On Patient.ID = Temp_PatientRecordConsolidation.Original_PatientID
Where Original_PatientID <> New_PatientID
and CompanyID = 1

--- Complete Four Times:  Time 3 of 4

Delete From Temp_PatientrecordConsolidation

Insert Into Temp_PatientrecordConsolidation (Original_PatientID, Temp_InvoiceID, New_PatientID, FirstName, LastName, SSN)
Select Min(ID), Min(Temp_InvoiceID), Max(ID), FirstName, LastName, SSN 
From Patient
where Active = 1 and CompanyID = 1
Group By FirstName, LastName, SSN


Update InvoicePatient
Set PatientID = New_PatientID
From InvoicePatient Inner Join Temp_PatientRecordConsolidation on InvoicePatient.PatientID = Temp_PatientRecordConsolidation.Original_PatientID
WHERE Temp_CompanyID = 1


Update Patient
Set Active = 0
From Patient inner join Temp_PatientRecordConsolidation On Patient.ID = Temp_PatientRecordConsolidation.Original_PatientID
Where Original_PatientID <> New_PatientID
and CompanyID = 1


--- Complete Four Times:  Time 4 of 4

Delete From Temp_PatientrecordConsolidation

Insert Into Temp_PatientrecordConsolidation (Original_PatientID, Temp_InvoiceID, New_PatientID, FirstName, LastName, SSN)
Select Min(ID), Min(Temp_InvoiceID), Max(ID), FirstName, LastName, SSN 
From Patient
where Active = 1 and CompanyID = 1
Group By FirstName, LastName, SSN


Update InvoicePatient
Set PatientID = New_PatientID
From InvoicePatient Inner Join Temp_PatientRecordConsolidation on InvoicePatient.PatientID = Temp_PatientRecordConsolidation.Original_PatientID
Where InvoicePatient.Temp_CompanyID = 1

Update Patient
Set Active = 0
From Patient inner join Temp_PatientRecordConsolidation On Patient.ID = Temp_PatientRecordConsolidation.Original_PatientID
Where Original_PatientID <> New_PatientID
and CompanyID = 1

-- IMPORTANT:  NEED TO RUN this items below MANUALLY!!! Does not work in a stored proc..

--ENABLE TRIGGER t_Invoice_Insert_InvoiceNumber ON Invoice

END


GO
PRINT N'Creating [dbo].[f_GetTestInvoiceSummaryTableMinified2]'
GO


/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/19/2012
-- Description:	Testing Invoice Summary Data
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    03/19/2012   Aaron     Created proc
** 2	12/20/2012	 Czarina   Made modifications to populate endingbalance (was showing as 0 for everyone)		  
*******************************/

CREATE FUNCTION [dbo].[f_GetTestInvoiceSummaryTableMinified2] 
(
	@InvoiceID int,
	@StatementDate datetime
)
RETURNS  
@InvoiceSummary TABLE (InvoiceID int, MaturityDate date, BalanceDue decimal(18,2), CumulativeServiceFeeDue decimal(18,2), EndingBalance decimal(18,2), FirstTestDate datetime, InvoicePaymentTotal decimal(18,2))
AS
BEGIN
	
-------------------------Intial Load
----- Insert into Invoice Summary initially with basic table data
INSERT INTO @InvoiceSummary
	SELECT @InvoiceID, null, 0, 0, 0, null, 0

-------------------------Amortization Date
----- Update the Invoice Summary table with the amortization date
----- The Amortization Date will be the date of the earliest test. //From Spec
DECLARE @AmortizationDate datetime = dbo.f_GetFirstTestDate(@InvoiceID)

UPDATE @InvoiceSummary
SET FirstTestDate = @AmortizationDate

DECLARE @ServiceFeeWaivedMonths int
DECLARE @ServiceFeeWaived decimal(18,2)
DECLARE @LoanTermMonths int

SELECT @ServiceFeeWaivedMonths = ServiceFeeWaivedMonths, 
		@ServiceFeeWaived = ServiceFeeWaived, 
		@LoanTermMonths = LoanTermMonths 
		FROM Invoice WHERE ID = @InvoiceID
----- Update the invoice summary with the date service fee begins and the maturity date calculated from the amortization date
----- The Date Service Fee Begins will be determined by the Service Fee Waived Time Period after the Amortization Date. //From Spec
----- The Maturity Date will be determined by the time period entered in the Loan Term (in months) after the Date Service Fee Begins. //From Spec
UPDATE @InvoiceSummary
SET MaturityDate = DATEADD(M,@ServiceFeeWaivedMonths + @LoanTermMonths, @AmortizationDate)

-------------------------Principal_Deposits_Paid, ServiceFeeReceived and AdditionalDeductions
----- Update invoice summary with different payment type totals

DECLARE @Principal_Deposits_Paid decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.DatePaid <= @StatementDate
								AND P.PaymentTypeID in (1,3))
DECLARE @ServiceFeeReceived decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.DatePaid <= @StatementDate
								AND P.PaymentTypeID = 2)
DECLARE @AdditionalDeductions decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.DatePaid <= @StatementDate
								AND P.PaymentTypeID in (4,5))
DECLARE @TotalPrincipal decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.DatePaid <= @StatementDate
								AND P.PaymentTypeID = 1)
DECLARE @TotalDeposits decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.DatePaid <= @StatementDate
								AND P.PaymentTypeID = 3)

DECLARE @TotalTestCost_Minus_PPODiscount decimal(18,2) =  (SELECT (SUM(TestCost) - SUM(TIT.PPODiscount))	
														FROM Invoice AS I
														INNER JOIN TestInvoice AS TI ON I.TestInvoiceID = TI.ID AND TI.Active = 1
														INNER JOIN TestInvoice_Test AS TIT ON TI.ID = TIT.TestInvoiceID AND TIT.Active = 1
														WHERE I.ID = @InvoiceID)

-------------------------Balance Due and Cumulative Service Fee Due
----- Update the invoice summary
----- Balance Due equals The total test cost minus the ppo discount minus the principal deposits made and minus any additional deductions 
UPDATE @InvoiceSummary
SET BalanceDue = ISNULL(@TotalTestCost_Minus_PPODiscount, 0) - ISNULL(@Principal_Deposits_Paid, 0) - ISNULL(@AdditionalDeductions, 0),
	CumulativeServiceFeeDue = (SELECT I.CalculatedCumulativeIntrest FROM Invoice AS I WHERE ID = @InvoiceID),
	InvoicePaymentTotal = ISNULL(@Principal_Deposits_Paid, 0) + ISNULL(@ServiceFeeReceived, 0) + ISNULL(@AdditionalDeductions, 0)

UPDATE @InvoiceSummary
SET CumulativeServiceFeeDue = (ISNULL(CumulativeServiceFeeDue,0) - ISNULL(@ServiceFeeReceived,0) - (ISNULL(@ServiceFeeWaived,0))),
-- CCW:  12/20/2012:  ADDED LINE BELOW to provide EndingBalance (the sum of BalanceDue + CumulativeServiceFeeDue)
	EndingBalance = (ISNULL(@TotalTestCost_Minus_PPODiscount, 0) - ISNULL(@Principal_Deposits_Paid, 0) - ISNULL(@AdditionalDeductions, 0)) + (ISNULL(CumulativeServiceFeeDue,0) - ISNULL(@ServiceFeeReceived,0) - (ISNULL(@ServiceFeeWaived,0)))

	RETURN 
END

GO
PRINT N'Creating [dbo].[f_GetSurgeryInvoiceSummaryTableMinified2]'
GO


CREATE FUNCTION [dbo].[f_GetSurgeryInvoiceSummaryTableMinified2] 
(
	@InvoiceID int,
	@StatementDate datetime
)
RETURNS 
@InvoiceSummary TABLE (InvoiceID int, MaturityDate date, BalanceDue decimal(18,2), CumulativeServiceFeeDue decimal(18,2), EndingBalance decimal(18,2), FirstSurgeryDate datetime, InvoicePaymentTotal decimal(18,2))
AS
BEGIN

-------------------------Intial Load
----- Insert into Invoice Summary initially with basic table data	
INSERT INTO @InvoiceSummary
	SELECT @InvoiceID, null, 0, 0, 0, null, 0
	
-------------------------Amortization Date
----- Update the Invoice Summary table with the amortization date
----- The Amortization Date will be the earliest date scheduled. //From Spec
DECLARE @AmortizationDate datetime = dbo.f_GetFirstSurgeryDate(@InvoiceID)

UPDATE @InvoiceSummary
SET FirstSurgeryDate = @AmortizationDate
						
-------------------------Date Service Fee Begins and Maturity Date
----- Get the months the service fee is waived for
DECLARE @ServiceFeeWaivedMonths int
DECLARE @ServiceFeeWaived decimal(18,2)
DECLARE @LoanTermMonths int

SELECT @ServiceFeeWaivedMonths = ServiceFeeWaivedMonths, 
		@ServiceFeeWaived = ServiceFeeWaived, 
		@LoanTermMonths = LoanTermMonths 
		FROM Invoice WHERE ID = @InvoiceID

----- Update the invoice summary with the date service fee begins and the maturity date calculated from the amortization date
----- The Date Service Fee Begins will be determined by the Service Fee Waived Time Period after the Amortization Date. //From Spec
----- The Maturity Date will be determined by the time period entered in the Loan Term (in months) after the Date Service Fee Begins. //From Spec
UPDATE @InvoiceSummary
SET MaturityDate = DATEADD(M,@ServiceFeeWaivedMonths + @LoanTermMonths, @AmortizationDate)

-------------------------Principal_Deposits_Paid, ServiceFeeReceived and AdditionalDeductions
----- Update invoice summary with different payment type totals
DECLARE @Principal_Deposits_Paid decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active = 1
								AND P.InvoiceID = @InvoiceID
								AND P.DatePaid <= @StatementDate
								AND P.PaymentTypeID in (1,3))
DECLARE @ServiceFeeReceived decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active = 1
								AND P.InvoiceID = @InvoiceID
								AND P.DatePaid <= @StatementDate
								AND P.PaymentTypeID = 2)
DECLARE @AdditionalDeductions decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active = 1
								AND P.InvoiceID = @InvoiceID
								AND P.DatePaid <= @StatementDate
								AND P.PaymentTypeID in (4,5))
DECLARE @TotalPrincipal decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active = 1
								AND P.InvoiceID = @InvoiceID
								AND P.DatePaid <= @StatementDate
								AND P.PaymentTypeID = 1)
DECLARE @TotalDeposits decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active = 1
								AND P.InvoiceID = @InvoiceID
								AND P.DatePaid <= @StatementDate
								AND P.PaymentTypeID = 3)

DECLARE @TotalCost_Minus_PPODiscount decimal(18,2) = (SELECT (SUM(SIPS.Cost) - SUM(SIPS.PPODiscount))
														FROM Invoice AS I
														INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
														INNER JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
														INNER JOIN SurgeryInvoice_Provider_Services AS SIPS ON SIP.ID = SIPS.SurgeryInvoice_ProviderID AND SIPS.Active = 1
														WHERE I.ID = @InvoiceID)

-------------------------Balance Due and Cumulative Service Fee Due
----- Update the invoice summary
----- Balance Due equals The total test cost minus the ppo discount minus the principal deposits made and minus any additional deductions 
UPDATE @InvoiceSummary
SET BalanceDue = ISNULL(@TotalCost_Minus_PPODiscount, 0) - ISNULL(@Principal_Deposits_Paid, 0) - ISNULL(@AdditionalDeductions, 0),
	CumulativeServiceFeeDue = (SELECT I.CalculatedCumulativeIntrest FROM Invoice AS I WHERE ID = @InvoiceID),
	InvoicePaymentTotal = ISNULL(@Principal_Deposits_Paid, 0) + ISNULL(@ServiceFeeReceived, 0) + ISNULL(@AdditionalDeductions, 0)

UPDATE @InvoiceSummary
SET CumulativeServiceFeeDue = (ISNULL(CumulativeServiceFeeDue,0) - ISNULL(@ServiceFeeReceived,0) - (ISNULL(@ServiceFeeWaived,0)))

-------------------------Ending Balance
----- Update the invoice summary setting the ending balance
----- Ending Balance equals the balance due plus the cumulative service fee due, minus losses amount
UPDATE @InvoiceSummary
SET EndingBalance = (BalanceDue + CumulativeServiceFeeDue) - (SELECT ISNULL(LossesAmount, 0) FROM Invoice WHERE ID=@InvoiceID)
	
	RETURN 
END

GO
PRINT N'Creating [dbo].[procAttorneyListReport]'
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[procAttorneyListReport] 
	-- Add the parameters for the stored procedure here
	@CompanyID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		a.LastName + ', ' + a.FirstName as AttorneyName,
		f.Name as FirmName,
		CASE
			WHEN a.Street2 is not null THEN 
			a.Street1 + ' ' + a.Street2 + ' ' + a.City + ', ' + s.Abbreviation + ' ' + a.ZipCode
			ELSE
			a.Street1 + ' ' + a.City + ', ' + s.Abbreviation + ' ' + a.ZipCode
		END as AttorneyAddress,
		a.Phone as PhoneNumber,
		a.Email as Email,
		c.LongName as CompanyName,
		CASE
			WHEN a.isActiveStatus = 1 THEN 'Active'
			ELSE 'Inactive'
		END as AttorneyStatus,
		CASE
			WHEN
		(SELECT top 1 atinner1.YearlyInterest FROM AttorneyTerms atinner1
		 WHERE atinner1.TermType = 2 and atinner1.Status = 'Current' and atinner1.AttorneyID = a.ID and atinner1.Active = 1 and atinner1.Deleted = 0) is not null
		 THEN (SELECT top 1 atinner1.YearlyInterest FROM AttorneyTerms atinner1
				WHERE atinner1.TermType = 2 and atinner1.Status = 'Current' and atinner1.AttorneyID = a.ID and atinner1.Active = 1 and atinner1.Deleted = 0)
		 ELSE
			(SELECT top 1 Surgery_YearlyInterest FROM LoanTerms WHERE CompanyID = @CompanyID AND Active = 1 order by DateAdded desc)
		 END as SurgeryYearlyInterest,

		 CASE
			WHEN
		 (SELECT top 1 atinner1.LoanTermsMonths FROM AttorneyTerms atinner1
		 WHERE atinner1.TermType = 2 and atinner1.Status = 'Current' and atinner1.AttorneyID = a.ID and atinner1.Active = 1 and atinner1.Deleted = 0) is not null
		 THEN
			(SELECT top 1 atinner1.LoanTermsMonths FROM AttorneyTerms atinner1
			WHERE atinner1.TermType = 2 and atinner1.Status = 'Current' and atinner1.AttorneyID = a.ID and atinner1.Active = 1 and atinner1.Deleted = 0)
		 ELSE
			(SELECT top 1 Surgery_LoanTermMonths FROM LoanTerms WHERE CompanyID = @CompanyID AND Active = 1 order by DateAdded desc)
		 END as SurgeryLoanTerms,

		 CASE 
			WHEN
		 (SELECT top 1 atinner1.ServiceFeeWaivedMonths FROM AttorneyTerms atinner1
		 WHERE atinner1.TermType = 2 and atinner1.Status = 'Current' and atinner1.AttorneyID = a.ID and atinner1.Active = 1 and atinner1.Deleted = 0) is not null
		 THEN 
			(SELECT top 1 atinner1.ServiceFeeWaivedMonths FROM AttorneyTerms atinner1
			WHERE atinner1.TermType = 2 and atinner1.Status = 'Current' and atinner1.AttorneyID = a.ID and atinner1.Active = 1 and atinner1.Deleted = 0)
		 ELSE
			(SELECT top 1 Surgery_ServiceFeeWaivedMonths FROM LoanTerms WHERE CompanyID = @CompanyID AND Active = 1 order by DateAdded desc)
		 END as SurgeryServiceFeeWaived,

		 CASE
			WHEN
		 (SELECT top 1 atinner1.YearlyInterest FROM AttorneyTerms atinner1
		 WHERE atinner1.TermType = 1 and atinner1.Status = 'Current' and atinner1.AttorneyID = a.ID and atinner1.Active = 1 and atinner1.Deleted = 0) is not null
		 THEN
			(SELECT top 1 atinner1.YearlyInterest FROM AttorneyTerms atinner1
			WHERE atinner1.TermType = 1 and atinner1.Status = 'Current' and atinner1.AttorneyID = a.ID and atinner1.Active = 1 and atinner1.Deleted = 0)
		 ELSE
			(SELECT top 1 Testing_YearlyInterest FROM LoanTerms WHERE CompanyID = @CompanyID AND Active = 1 order by DateAdded desc)
		 END as TestYearlyInterest,

		 CASE
			WHEN
		 (SELECT top 1 atinner1.LoanTermsMonths FROM AttorneyTerms atinner1
		 WHERE atinner1.TermType = 1 and atinner1.Status = 'Current' and atinner1.AttorneyID = a.ID and atinner1.Active = 1 and atinner1.Deleted = 0) is not null
		 THEN 
			(SELECT top 1 atinner1.LoanTermsMonths FROM AttorneyTerms atinner1
			WHERE atinner1.TermType = 1 and atinner1.Status = 'Current' and atinner1.AttorneyID = a.ID and atinner1.Active = 1 and atinner1.Deleted = 0)
		 ELSE
			(SELECT top 1 Testing_LoanTermMonths FROM LoanTerms WHERE CompanyID = @CompanyID AND Active = 1 order by DateAdded desc)
		 END as TestLoanTerms,

		 CASE
			WHEN
		 (SELECT top 1 atinner1.ServiceFeeWaivedMonths FROM AttorneyTerms atinner1
		 WHERE atinner1.TermType = 1 and atinner1.Status = 'Current' and atinner1.AttorneyID = a.ID and atinner1.Active = 1 and atinner1.Deleted = 0) is not null
		 THEN
			(SELECT top 1 atinner1.ServiceFeeWaivedMonths FROM AttorneyTerms atinner1
		 WHERE atinner1.TermType = 1 and atinner1.Status = 'Current' and atinner1.AttorneyID = a.ID and atinner1.Active = 1 and atinner1.Deleted = 0)
		 ELSE
			(SELECT top 1 Testing_ServiceFeeWaivedMonths FROM LoanTerms WHERE CompanyID = @CompanyID AND Active = 1 order by DateAdded desc)
		 END as TestServiceFeeWaived

	FROM Attorney a
	left outer join Firm f on a.FirmID = f.ID
	left outer join States s on a.StateID = s.ID
	left outer join Company c on a.CompanyID = c.ID
	WHERE a.CompanyID = @CompanyID and a.isActiveStatus = 1
	order by a.LastName,a.FirstName
END

GO
PRINT N'Creating [dbo].[f_GetInvoicePhysicianName]'
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[f_GetInvoicePhysicianName]
(
	-- Add the parameters for the function here
	@InvoiceID int
)
RETURNS varchar(250)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(250)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = ip.LastName + ', ' + ip.FirstName
	FROM Invoice i
	inner join InvoicePhysician ip on i.InvoicePhysicianID = ip.ID
	WHERE i.ID = @InvoiceID

	-- Return the result of the function
	RETURN @Result

END

GO
PRINT N'Creating [dbo].[f_GetInvoiceCostTotal]'
GO
-- =============================================
-- Author:		Bursavich, Andy
-- Create date: 2012.04.12
-- Description:	Gets the Total Cost of an Invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetInvoiceCostTotal]
(
	@InvoiceID INT,
	@InvoiceTypeID INT = NULL
)
RETURNS DECIMAL(18,2)
AS
BEGIN

	DECLARE @TotalCost DECIMAL(18,2)

	IF @InvoiceTypeID IS NULL
	SELECT @InvoiceTypeID = Invoice.InvoiceTypeID FROM Invoice WHERE Invoice.ID=@InvoiceID
	
	DECLARE @TestingInvoiceTypeID INT = 1

	SET @TotalCost = CASE WHEN @InvoiceTypeID=@TestingInvoiceTypeID THEN dbo.f_GetTestCostTotal(@InvoiceID) ELSE dbo.f_GetSurgeryCostTotal(@InvoiceID) END

	RETURN @TotalCost

END
GO
PRINT N'Creating [dbo].[procICDCodeReport]'
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[procICDCodeReport]
	-- Add the parameters for the stored procedure here
	@ICDCodeID int,
	@CompanyID int,
	@StartDate DateTime,
	@EndDate DateTime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		i.InvoiceNumber as InvoiceNumber,
		[dbo].[f_GetFirstSurgeryDate](i.ID)  as ServiceDate,
		s.Name as SurgeryType,
		[dbo].[f_GetInvoicePhysicianName](i.ID) as Physician,
		[dbo].[f_GetInvoiceCostTotal](i.ID,i.InvoiceTypeID) as TotalCost,
		co.LongName as CompanyName
	
	FROM Invoice i
	inner join SurgeryInvoice si on i.SurgeryInvoiceID = si.ID
	inner join SurgeryInvoice_Surgery sis on si.ID = sis.SurgeryInvoiceID
	inner join Surgery s on sis.SurgeryID = s.ID
	inner join SurgeryInvoice_SurgeryDates sisd on sis.ID = sisd.SurgeryInvoice_SurgeryID
	inner join SurgeryInvoice_Surgery_ICDCodes sisi on sis.ID = sisi.SurgeryInvoice_SurgeryID
	INNER JOIN Company co ON i.CompanyID = co.ID AND co.Active = 1
	WHERE i.CompanyID = @CompanyID 
	AND sisi.ICDCodeID = @ICDCodeID
	AND [dbo].[f_GetFirstSurgeryDate](i.ID) >= @StartDate AND [dbo].[f_GetFirstSurgeryDate](i.ID) <= @EndDate
	order by TotalCost desc
END

GO
PRINT N'Creating [dbo].[procCPTReportTest]'
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[procCPTReportTest] 
	-- Add the parameters for the stored procedure here
	@CPTCodeID int,
	@CompanyID int,
	@StartDate DateTime,
	@EndDate DateTime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	(SELECT 
	i.InvoiceNumber as InvoiceNumber,
	CASE
		WHEN i.InvoiceTypeID = 1 THEN 'Test'
		ELSE 'Surgery'
	END as InvoiceTypeID,
	[dbo].[f_GetFirstTestDate](i.ID) as ServiceDate,
	p.Name as ProviderName,
	titc.Amount as Cost,
	co.LongName as CompanyName

	FROM Invoice i
	inner join TestInvoice ti on i.TestInvoiceID = ti.ID
	inner join TestInvoice_Test ti_t on ti.ID = ti_t.TestInvoiceID
	inner join TestInvoice_Test_CPTCodes titc on ti_t.ID = titc.TestInvoice_TestID
	inner join CPTCodes c on titc.CPTCodeID = c.ID
	inner join InvoiceProvider ip on ti_t.InvoiceProviderID = ip.ID
	inner join Provider p on ip.ProviderID = p.ID
	INNER JOIN Company co ON i.CompanyID = co.ID AND co.Active = 1
	WHERE i.CompanyID = @CompanyID
	AND titc.CPTCodeID = @CPTCodeID
	AND [dbo].[f_GetFirstTestDate](i.ID) >= @StartDate AND [dbo].[f_GetFirstTestDate](i.ID) <= @EndDate
	)
	UNION
	(
	SELECT 
		i.InvoiceNumber as InvoiceNumber,
		CASE
		WHEN i.InvoiceTypeID = 1 THEN 'Test'
		ELSE 'Surgery'
	END as InvoiceTypeID,
		[dbo].[f_GetFirstSurgeryDate](i.ID)  as ServiceDate,
		p.Name as ProviderName,
		sipc.Amount as Cost,
		co.LongName as CompanyName

	FROM Invoice i
	inner join SurgeryInvoice si on i.SurgeryInvoiceID = si.ID
	inner join SurgeryInvoice_Providers sip on si.ID = sip.SurgeryInvoiceID
	inner join InvoiceProvider ip on sip.InvoiceProviderID = ip.ID
	inner join Provider p on ip.ProviderID = p.ID
	left outer join SurgeryInvoice_Provider_CPTCodes sipc on sip.ID = sipc.SurgeryInvoice_ProviderID
	inner join CPTCodes c on sipc.CPTCodeID = c.ID
	INNER JOIN Company co ON i.CompanyID = co.ID AND co.Active = 1
	WHERE i.CompanyID = @CompanyID 
	AND sipc.CPTCodeID = @CPTCodeID
	AND [dbo].[f_GetFirstSurgeryDate](i.ID) >= @StartDate AND [dbo].[f_GetFirstSurgeryDate](i.ID) <= @EndDate
	)
	order by Cost desc

END

GO
PRINT N'Creating [dbo].[procAccountsReceivableAgingReport_DateFix]'
GO
-- =============================================
-- Author:		Brad Conley
-- Create date: 6/20/2013
-- Description:	Accounts Receivable Aging Report
-- This Stored Procedure is based on procAccountsReceivableReport.  For tests, we use invoices with a balance due greater than 1 because
-- Customer does not mark testing invoices as complete, instead placeholder value of $1.00 is updated to signify that this invoice needs to appear on receivables report
-- However, we do not want these $1.00 charge amounts effecting the dollar amounts of the report, so we only use balances greate than $1.00
-- The inner select statement and union return individual results that need to be grouped, achieved by the outer select and group by.
-- Case 1007530:  Added @DateAtEndOfMonth in order to filter out all future tests/surgeries.
-- =============================================
--procAccountsReceivableAgingReport_DateFix 1,  '1/1/1900', '10/14/2016'
CREATE PROCEDURE [dbo].[procAccountsReceivableAgingReport_DateFix]
	-- Add the parameters for the stored procedure here
	@CompanyID int = -1,
	@StartDate datetime,
	@EndDate datetime,
	@AttorneyId int = -1,
	@StatementDate datetime = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
DECLARE @ClosedStatusTypeID INT = 2
DECLARE @TestTypeID INT = 1
DECLARE @SurgeryTypeID INT = 2
DECLARE @DateAtEndOfMonth DATE = dateadd(month,1+datediff(month,0,getdate()),-1)

select t.AttorneyId, t.AttorneyDisplayName, SUM(t.Less_Than_60) as Less_Than_60, SUM(t.BT_120_180) as BT_120_180, SUM(t.BT_180_240) as BT_180_240,
 SUM(t.BT_240_300) as BT_240_300, SUM(t.BT_300_360) as BT_300_360, SUM(t.BT_360_420) as BT_360_420, SUM(t.BT_420_480) as BT_420_480,
 SUM(t.BT_480_540) as BT_480_540, SUM(t.BT_540_600) as BT_540_600, SUM(t.BT_60_120) as BT_60_120, SUM(t.BT_600_660) as BT_600_660, 
 SUM(t.BT_660_720) as BT_660_720, SUM(t.BT_720_780) as BT_720_780, SUM(t.BT_780_840) as BT_780_840, SUM(t.BT_840_900) as BT_840_900,
 SUM(t.GT_900) as GT_900, t.CompanyName, SUM(t.TotalDue) as TotalDue
from
(
(
	SELECT													
		I.InvoiceNumber as InvoiceNumber,
		IA.AttorneyID as AttorneyId,	
		A.LastName + ', ' + A.FirstName AS AttorneyDisplayName,
												
		tis.EndingBalance as TotalDue,			
		co.LongName as CompanyName,
		
		case when dateadd("d", -60, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as Less_Than_60,
		
		case when dateadd("d", -120, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -61, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_60_120,
		
		case when dateadd("d", -180, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -121, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_120_180,
		
		case when dateadd("d", -240, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -181, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_180_240,
		
		case when dateadd("d", -300, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -241, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_240_300,
		
		case when dateadd("d", -360, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -301, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_300_360,
		
		case when dateadd("d", -420, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -361, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_360_420,
		
		case when dateadd("d", -480, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -421, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_420_480,
		
		case when dateadd("d", -540, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -481, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_480_540,
		
		case when dateadd("d", -600, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -541, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_540_600,
		
		case when dateadd("d", -660, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -601, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_600_660,
		
		case when dateadd("d", -720, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -661, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_660_720,
		
		case when dateadd("d", -780, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -721, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_720_780,
		
		case when dateadd("d", -840, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -781, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_780_840,
		
		case when dateadd("d", -900, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -841, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_840_900,
		
		case when DATEADD("d", -901, getdate()) >= dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as GT_900
				
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		join Attorney A on IA.AttorneyID = A.ID 
		outer apply dbo.f_GetTestInvoiceSummaryTableMinified(I.ID, @StatementDate) tis
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE I.InvoiceStatusTypeID != @ClosedStatusTypeID		
		AND tis.BalanceDue > 0 -- Taken From procAccountsReceivableReport - CCW:  12/20/2012  Customer does not mark testing invoices as complete, instead placeholder value of $1.00 is updated to signify that this invoice needs to appear on receivables report
		AND I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @TestTypeID	
		AND (@AttorneyId = -1 or A.ID = @AttorneyId)	
		--and cast(tis.FirstTestDate as date) <= @DateAtEndOfMonth
		AND tis.FirstTestDate BETWEEN @StartDate AND @EndDate	
)
UNION
(
	SELECT
		I.InvoiceNumber as InvoiceNumber,							
		IA.AttorneyID as AttorneyId,
		A.LastName + ', ' + A.FirstName AS AttorneyName,				
		sisum.EndingBalance as TotalDue,		
		co.LongName as CompanyName,
		
		case when dateadd("d", -60, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as Less_Than_60,
		
		case when dateadd("d", -120, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -61, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_60_120,
		
		case when dateadd("d", -180, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -121, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_120_180,
		
		case when dateadd("d", -240, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -181, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_180_240,
		
		case when dateadd("d", -300, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -241, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_240_300,
		
		case when dateadd("d", -360, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -301, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_300_360,
		
		case when dateadd("d", -420, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -361, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_360_420,
		
		case when dateadd("d", -480, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -421, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_420_480,
		
		case when dateadd("d", -540, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -481, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_480_540,
		
		case when dateadd("d", -600, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -541, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_540_600,
		
		case when dateadd("d", -660, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -601, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_600_660,
		
		case when dateadd("d", -720, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -661, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_660_720,
		
		case when dateadd("d", -780, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -721, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_720_780,
		
		case when dateadd("d", -840, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -781, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_780_840,
		
		case when dateadd("d", -900, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -841, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_840_900,
		
		case when DATEADD("d", -901, getdate()) >= dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as GT_900
	
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		join Attorney A on IA.AttorneyID = A.ID 
		outer apply dbo.f_GetSurgeryInvoiceSummaryTableMinified(I.ID, @StatementDate) sisum	
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE I.InvoiceStatusTypeID != @ClosedStatusTypeID AND I.isComplete = 1		
		AND I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @SurgeryTypeID
		AND (@AttorneyId = -1 or A.ID = @AttorneyId)
		AND sisum.FirstSurgeryDate BETWEEN @StartDate AND @EndDate
			
)) t

group by t.AttorneyId, t.AttorneyDisplayName, t.CompanyName
order by AttorneyDisplayName 
END
GO
PRINT N'Creating [dbo].[procAccountsReceivableAgingReport]'
GO
-- =============================================
-- Author:		Brad Conley
-- Create date: 6/20/2013
-- Description:	Accounts Receivable Aging Report
-- This Stored Procedure is based on procAccountsReceivableReport.  For tests, we use invoices with a balance due greater than 1 because
-- Customer does not mark testing invoices as complete, instead placeholder value of $1.00 is updated to signify that this invoice needs to appear on receivables report
-- However, we do not want these $1.00 charge amounts effecting the dollar amounts of the report, so we only use balances greate than $1.00
-- The inner select statement and union return individual results that need to be grouped, achieved by the outer select and group by.
-- Case 1007530:  Added @DateAtEndOfMonth in order to filter out all future tests/surgeries.
-- =============================================
--procAccountsReceivableAgingReport 1,  '1/1/1900', '10/14/2016'
CREATE PROCEDURE [dbo].[procAccountsReceivableAgingReport]
	-- Add the parameters for the stored procedure here
	@CompanyID int = -1,
	@StartDate datetime,
	@EndDate datetime,
	@AttorneyId int = -1,
	@StatementDate datetime = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
DECLARE @ClosedStatusTypeID INT = 2
DECLARE @TestTypeID INT = 1
DECLARE @SurgeryTypeID INT = 2
DECLARE @DateAtEndOfMonth DATE = dateadd(month,1+datediff(month,0,getdate()),-1)

select t.AttorneyId, t.AttorneyDisplayName, SUM(t.Less_Than_60) as Less_Than_60, SUM(t.BT_120_180) as BT_120_180, SUM(t.BT_180_240) as BT_180_240,
 SUM(t.BT_240_300) as BT_240_300, SUM(t.BT_300_360) as BT_300_360, SUM(t.BT_360_420) as BT_360_420, SUM(t.BT_420_480) as BT_420_480,
 SUM(t.BT_480_540) as BT_480_540, SUM(t.BT_540_600) as BT_540_600, SUM(t.BT_60_120) as BT_60_120, SUM(t.BT_600_660) as BT_600_660, 
 SUM(t.BT_660_720) as BT_660_720, SUM(t.BT_720_780) as BT_720_780, SUM(t.BT_780_840) as BT_780_840, SUM(t.BT_840_900) as BT_840_900,
 SUM(t.GT_900) as GT_900, t.CompanyName, SUM(t.TotalDue) as TotalDue
from
(
(
	SELECT													
		I.InvoiceNumber as InvoiceNumber,
		IA.AttorneyID as AttorneyId,	
		A.LastName + ', ' + A.FirstName AS AttorneyDisplayName,
												
		tis.EndingBalance as TotalDue,			
		co.LongName as CompanyName,
		
		case when dateadd("d", -60, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as Less_Than_60,
		
		case when dateadd("d", -120, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -61, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_60_120,
		
		case when dateadd("d", -180, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -121, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_120_180,
		
		case when dateadd("d", -240, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -181, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_180_240,
		
		case when dateadd("d", -300, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -241, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_240_300,
		
		case when dateadd("d", -360, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -301, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_300_360,
		
		case when dateadd("d", -420, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -361, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_360_420,
		
		case when dateadd("d", -480, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -421, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_420_480,
		
		case when dateadd("d", -540, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -481, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_480_540,
		
		case when dateadd("d", -600, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -541, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_540_600,
		
		case when dateadd("d", -660, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -601, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_600_660,
		
		case when dateadd("d", -720, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -661, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_660_720,
		
		case when dateadd("d", -780, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -721, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_720_780,
		
		case when dateadd("d", -840, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -781, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_780_840,
		
		case when dateadd("d", -900, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -841, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_840_900,
		
		case when DATEADD("d", -901, getdate()) >= dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as GT_900
				
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		join Attorney A on IA.AttorneyID = A.ID 
		outer apply dbo.f_GetTestInvoiceSummaryTableMinified(I.ID, @StatementDate) tis
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE I.InvoiceStatusTypeID != @ClosedStatusTypeID		
		AND tis.BalanceDue > 0 -- Taken From procAccountsReceivableReport - CCW:  12/20/2012  Customer does not mark testing invoices as complete, instead placeholder value of $1.00 is updated to signify that this invoice needs to appear on receivables report
		AND I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @TestTypeID	
		AND (@AttorneyId = -1 or A.ID = @AttorneyId)	
		--and cast(tis.FirstTestDate as date) <= @DateAtEndOfMonth
		AND tis.FirstTestDate BETWEEN @StartDate AND @EndDate	
)
UNION
(
	SELECT
		I.InvoiceNumber as InvoiceNumber,							
		IA.AttorneyID as AttorneyId,
		A.LastName + ', ' + A.FirstName AS AttorneyName,				
		sisum.EndingBalance as TotalDue,		
		co.LongName as CompanyName,
		
		case when dateadd("d", -60, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as Less_Than_60,
		
		case when dateadd("d", -120, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -61, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_60_120,
		
		case when dateadd("d", -180, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -121, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_120_180,
		
		case when dateadd("d", -240, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -181, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_180_240,
		
		case when dateadd("d", -300, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -241, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_240_300,
		
		case when dateadd("d", -360, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -301, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_300_360,
		
		case when dateadd("d", -420, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -361, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_360_420,
		
		case when dateadd("d", -480, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -421, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_420_480,
		
		case when dateadd("d", -540, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -481, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_480_540,
		
		case when dateadd("d", -600, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -541, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_540_600,
		
		case when dateadd("d", -660, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -601, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_600_660,
		
		case when dateadd("d", -720, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -661, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_660_720,
		
		case when dateadd("d", -780, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -721, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_720_780,
		
		case when dateadd("d", -840, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -781, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_780_840,
		
		case when dateadd("d", -900, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -841, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_840_900,
		
		case when DATEADD("d", -901, getdate()) >= dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as GT_900
	
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		join Attorney A on IA.AttorneyID = A.ID 
		outer apply dbo.f_GetSurgeryInvoiceSummaryTableMinified(I.ID, @StatementDate) sisum	
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE I.InvoiceStatusTypeID != @ClosedStatusTypeID AND I.isComplete = 1		
		AND I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @SurgeryTypeID
		AND (@AttorneyId = -1 or A.ID = @AttorneyId)
		AND sisum.FirstSurgeryDate BETWEEN @StartDate AND @EndDate
			
)) t

group by t.AttorneyId, t.AttorneyDisplayName, t.CompanyName
order by AttorneyDisplayName 
END
GO
PRINT N'Creating [dbo].[f_GetInvoiceNonInterestPaymentsTotal]'
GO
-- =============================================
-- Author:		Bursavich, Andy
-- Create date: 2012.04.12
-- Description:	Gets the total of Non-Interest Paymenrs for an Invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetInvoiceNonInterestPaymentsTotal]
(
	@InvoiceID int
)
RETURNS DECIMAL(18,2)
AS
BEGIN

	DECLARE @Payments DECIMAL(18,2)
	
	DECLARE @InterestPaymentTypeID INT = 2

	SELECT @Payments = ISNULL(SUM(P.Amount), 0)
		FROM Payments P
		WHERE P.InvoiceID=@InvoiceID
			AND P.PaymentTypeID!=@InterestPaymentTypeID
			AND P.Active=1

	RETURN @Payments

END
GO
PRINT N'Creating [dbo].[f_GetInvoicePPODiscountTotal]'
GO
-- =============================================
-- Author:		Bursavich, Andy
-- Create date: 2012.04.12
-- Description:	Gets the Total PPO Discount of an Invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetInvoicePPODiscountTotal]
(
	@InvoiceID INT,
	@InvoiceTypeID INT = NULL
)
RETURNS DECIMAL(18,2)
AS
BEGIN

	DECLARE @PPODiscountTotal DECIMAL(18,2)

	IF @InvoiceTypeID IS NULL
	SELECT @InvoiceTypeID = Invoice.InvoiceTypeID FROM Invoice WHERE Invoice.ID=@InvoiceID
	
	DECLARE @TestingInvoiceTypeID INT = 1

	SET @PPODiscountTotal = CASE WHEN @InvoiceTypeID=@TestingInvoiceTypeID THEN dbo.f_GetTestPPODiscountTotal(@InvoiceID) ELSE dbo.f_GetSurgeryPPODiscountTotal(@InvoiceID) END

	RETURN @PPODiscountTotal

END
GO
PRINT N'Creating [dbo].[f_GetTestInvoiceProviderCost]'
GO
/******************************
-- =============================================
-- Author:		John D'Antonio
-- Create date: 12/27/2011
-- Description:	Gets the provider cost based on the test invoice provider
--				and MRI Count passed in.
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    12/27/2011   John      Created function
** 2	03/21/2012	 Aaron	   Commented and verified function 
*******************************/
CREATE FUNCTION [dbo].[f_GetTestInvoiceProviderCost]
(
		@InvoiceProviderID int,
		@MRICount int
)
RETURNS decimal(18,2)
AS
BEGIN

----- Get the MRI Cost Type Id, the Cost Flat Rate and the Cost Percentage for the specified provider
DECLARE @MRICostTypeID int = (SELECT MRICostTypeID FROM InvoiceProvider WHERE ID = @InvoiceProviderID) -- flat rate or percentage
DECLARE @MRICostFlatRate decimal(18,2) = (SELECT MRICostFlatRate FROM InvoiceProvider WHERE ID = @InvoiceProviderID)
DECLARE @MRICostPercentage decimal(18,2) = (SELECT MRICostPercentage FROM InvoiceProvider WHERE ID = @InvoiceProviderID)

DECLARE @retval decimal(18,2) = 0

IF (@MRICount IS NULL)
BEGIN
	----- If the mri count is null, the amount to the provider is
	----- the test cost minus the test cost multiplied by the providers discount percentage
	SET @retval =
		(SELECT (TIT.TestCost - (TIT.TestCost * IP.DiscountPercentage)) AS AmountToProvider
		FROM TestInvoice_Test AS TIT
		INNER JOIN InvoiceProvider AS IP ON TIT.InvoiceProviderID = IP.ID AND IP.Active = 1
		WHERE TIT.InvoiceProviderID = @InvoiceProviderID AND TIT.Active = 1)
END
ELSE IF (@MRICount IS NOT NULL AND @MRICostTypeID = 1) --flat rate
BEGIN
	----- If the mri count is not null and the type is flat rate, the amount to the provider is
	----- the mri count multiplied by the providers mri cost flat rate
	SET @retval = (SELECT (@MRICount * @MRICostFlatRate) AS AmountToProvider)
END
ELSE IF (@MRICount IS NOT NULL AND @MRICostTypeID = 2) --percentage
BEGIN
	----- If the mri count is not null and the type is percentage, the amount to the provider is
	----- the test cost multiplied by the providers mri cost percentage
	SET @retval =
		(SELECT (TIT.TestCost * @MRICostPercentage) AS AmountToProvider
		FROM TestInvoice_Test AS TIT
		INNER JOIN InvoiceProvider AS IP ON TIT.InvoiceProviderID = IP.ID AND IP.Active = 1
		WHERE TIT.InvoiceProviderID = @InvoiceProviderID AND TIT.Active = 1)
END

return @retval

END
GO
PRINT N'Creating [dbo].[f_GetInvoiceBalanceDue]'
GO
-- =============================================
-- Author:		Bursavich, Andy
-- Create date: 2012.04.12
-- Description:	Gets the Balance Due for an Invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetInvoiceBalanceDue]
(
	@InvoiceID INT,
	@InvoiceTypeID INT = NULL,
	@InvoiceCostTotal DECIMAL(18,2) = NULL,
	@InvoicePPODiscountTotal DECIMAL(18,2) = NULL,
	@InvoiceNonInterestPaymentsTotal DECIMAL(18,2) = NULL
)
RETURNS DECIMAL(18,2)
AS
BEGIN
	
	DECLARE @BalanceDue DECIMAL(18,2)
	
	IF @InvoiceTypeID IS NULL
	SELECT @InvoiceTypeID = Invoice.InvoiceTypeID FROM Invoice WHERE Invoice.ID=@InvoiceID
	
	IF @InvoiceCostTotal IS NULL
	SET @InvoiceCostTotal = dbo.f_GetInvoiceCostTotal(@InvoiceID, @InvoiceTypeID)
	
	IF @InvoicePPODiscountTotal IS NULL
	SET @InvoicePPODiscountTotal = dbo.f_GetInvoicePPODiscountTotal(@InvoiceID, @InvoiceTypeID)
	
	IF @InvoiceNonInterestPaymentsTotal IS NULL
	SET @InvoiceNonInterestPaymentsTotal = dbo.f_GetInvoiceNonInterestPaymentsTotal(@InvoiceID)
	
	SET @BalanceDue = @InvoiceCostTotal - @InvoicePPODiscountTotal - @InvoiceNonInterestPaymentsTotal

	RETURN @BalanceDue

END
GO
PRINT N'Creating [dbo].[procGetGeneralStatistics]'
GO
CREATE PROCEDURE [dbo].[procGetGeneralStatistics]

 @StartDate date,
 @EndDate date,
 @CompanyID int 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @InvoiceTestTypeID INT = 1
	DECLARE @InvoiceSurgeryTypeID INT = 2
	DECLARE @TestTypeMRIID INT = 2

	
	
	--Get the invoice table plus the top test dates and surgery dates
	declare @InvoicePlus table(ID int, InvoiceNumber int, CompanyID int, DateOfAccident datetime, InvoiceStatusTypeID int, InvoiceTypeID int, TestInvoiceID int, SurgeryInvoiceID int, Active bit, topTestDate datetime, topSurgeryDate datetime)

	insert into @InvoicePlus
	select ID,InvoiceNumber,CompanyID, DateOfAccident, InvoiceStatusTypeID, InvoiceTypeID, TestInvoiceID int, SurgeryInvoiceID int, Active,
		(select top 1 TestDate
			from TestInvoice as TI
			inner join TestInvoice_Test as TIT on TI.ID = TIT.TestInvoiceID
			inner join Invoice as I on TI.ID = I.TestInvoiceID
			Where I.ID = Inv.ID
			and I.Active = 1
			and TI.Active = 1
			and TIT.Active = 1
			order by TestDate asc) as topTestDate,
		(select top 1 SISD.ScheduledDate
			from SurgeryInvoice as SI
			inner join SurgeryInvoice_Surgery as SIS on SI.ID = SIS.SurgeryInvoiceID
			inner join Invoice as I on SI.ID = I.SurgeryInvoiceID
			inner join SurgeryInvoice_SurgeryDates as SISD on SIS.ID = SISD.SurgeryInvoice_SurgeryID
			where I.ID = Inv.ID
			and I.Active = 1
			and SI.Active = 1
			and SIS.Active = 1
			and SISD.Active = 1
			order by SISD.ScheduledDate asc) as topSurgeryDate
	from Invoice as Inv


	SELECT (SELECT ISNULL(SUM(ISNULL(tit.NumberOfTests, 0)), 0)
				from TestInvoice_Test tit
				inner join Test t on t.ID = tit.TestID
				where t.CompanyID=@CompanyID
				and tit.isCanceled = 0
				and tit.Active = 1
				AND ((CONVERT(DATE, tit.TestDate, 112) BETWEEN @StartDate AND @EndDate) or (CONVERT(DATE, tit.TestDate, 112) BETWEEN @StartDate AND @EndDate))
			) AS TotalTests,
			(SELECT COUNT(*)
				FROM @InvoicePlus I
					INNER JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.TestTypeID=@TestTypeMRIID
				WHERE I.Active=1
					AND I.CompanyID=@CompanyID
					AND I.InvoiceTypeID=@InvoiceTestTypeID
					AND ((CONVERT(DATE, I.topSurgeryDate, 112) BETWEEN @StartDate AND @EndDate) or (CONVERT(DATE, I.topTestDate, 112) BETWEEN @StartDate AND @EndDate))
			) AS TotalMRIs,
			(SELECT COUNT(Distinct sis.ID)
					from SurgeryInvoice_Surgery sis
					inner join SurgeryInvoice_SurgeryDates sisd on sisd.SurgeryInvoice_SurgeryID = sis.ID
					inner join Surgery s on sis.SurgeryID = s.ID
					where s.CompanyID = @CompanyID
					and sisd.Active = 1
					and sis.Active = 1
					and sis.isCanceled = 0
					and SurgeryInvoice_SurgeryID = sis.ID -- added individual line on  12/3/2014 by Cherie
					AND ((CONVERT(DATE, sisd.ScheduledDate, 112) BETWEEN @StartDate AND @EndDate)) -- added individual line on  12/3/2014 by Cherie
					--Commented out below on 12/3/2014 by Cherie Walker so that all scheduled dates show up in the surgery count.
					--AND ((CONVERT(DATE, (select top 1 ScheduledDate
					--					 from SurgeryInvoice_SurgeryDates
					--					 where SurgeryInvoice_SurgeryID = sis.ID and Active = 1 -- Added on 10/2/2014 to remove inactive dates by Cherie
					--					 order by ScheduledDate asc), 112) BETWEEN @StartDate AND @EndDate))
			) AS TotalSurgeries,
			(SELECT ISNULL(SUM(ISNULL(P.Amount, 0)), 0)
				FROM Payments p
					inner join Invoice i on i.ID = p.InvoiceID AND i.Active = 1
				where Convert(date, p.DatePaid, 112) between @StartDate and @EndDate
				and p.Active = 1 and i.CompanyID = @CompanyID)
			 AS TotalAmountCollected,
			(SELECT
				(SELECT ISNULL(SUM(ISNULL(ti.DepositToProvider, 0) + ISNULL(ti.AmountPaidToProvider, 0)), 0)
					FROM TestInvoice_Test ti
						 inner join Test t on ti.TestID = t.ID
						 where ti.Active = 1 and t.CompanyID = @CompanyID
						 AND Convert(date, ti.Date, 112) BETWEEN @StartDate AND @EndDate)										
				 +
				(select SUM(spp.Amount)
					from SurgeryInvoice_Provider_Payments spp
						  inner join SurgeryInvoice_Providers sip on spp.SurgeryInvoice_ProviderID = sip.ID
						  inner join InvoiceProvider ip on sip.InvoiceProviderID = ip.ID
						  inner join Provider p on ip.ProviderID = p.ID
						  where spp.Active = 1 and p.CompanyID = @CompanyID
						  AND CONVERT(date, spp.DatePaid, 112) BETWEEN @StartDate AND @EndDate)
				)
			 AS TotalPaymentsMade														

END
GO
PRINT N'Creating [dbo].[f_GetInvoiceInterestPaymentsTotal]'
GO
-- =============================================
-- Author:		Bursavich, Andy
-- Create date: 2012.04.12
-- Description:	Gets the total of Interest Payments for an Invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetInvoiceInterestPaymentsTotal]
(
	@InvoiceID int
)
RETURNS DECIMAL(18,2)
AS
BEGIN

	DECLARE @Payments DECIMAL(18,2)
	
	DECLARE @InterestPaymentTypeID INT = 2

	SELECT @Payments = ISNULL(SUM(P.Amount), 0)
		FROM Payments P
		WHERE P.InvoiceID=@InvoiceID
			AND P.PaymentTypeID=@InterestPaymentTypeID
			AND P.Active=1

	RETURN @Payments

END
GO
PRINT N'Creating [dbo].[f_ServiceFeeBegins]'
GO
-- =============================================
-- Author:		Bursavich, Andy
-- Create date: 2012.09.28
-- =============================================
CREATE FUNCTION [dbo].[f_ServiceFeeBegins]
(
	@AmortizationDate datetime,
	@ServiceFeeWaivedMonths int
)
RETURNS datetime
AS
BEGIN

	RETURN  DATEADD(MONTH, @ServiceFeeWaivedMonths+1, CONVERT(DATE, CONVERT(CHAR(2), DATEPART(MONTH, @AmortizationDate)) + '/1/' + CONVERT(CHAR(4), DATEPART(YEAR, @AmortizationDate))))

END
GO
PRINT N'Creating [dbo].[f_GetSurgeryInvoiceSummaryTable]'
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/20/2012
-- Description:	Returns Surgery Invoice Summary Table
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    03/20/2012   Aaron     Created function from stored proc
** 2	03/21/2012	 Aaron	   Commented and verified function calcs 
** 3    03/30/2012   Andy      Get AmortizationDate from scalar function
*******************************/
CREATE FUNCTION [dbo].[f_GetSurgeryInvoiceSummaryTable] 
(
	@InvoiceID int
)
RETURNS 
@InvoiceSummary TABLE (InvoiceID int, DateServiceFeeBegins date, MaturityDate date, AmortizationDate date,
								TotalCost_Minus_PPODiscount decimal(18,2), TotalPPODiscount decimal(18,2), Cost_Before_PPODiscount decimal(18,2),
								Principal_Deposits_Paid decimal(18,2), ServiceFeeReceived decimal(18,2), AdditionalDeductions decimal(18,2),
								BalanceDue decimal(18,2), CumulativeServiceFeeDue decimal(18,2), EndingBalance decimal(18,2),
								CostOfGoodsSold decimal(18,2), TotalRevenue decimal(18,2), TotalCPTs decimal(18,2),
								TotalPrincipal decimal(18,2), TotalDeposits decimal(18,2))
AS
BEGIN

-------------------------Intial Load
----- Insert into Invoice Summary initially with basic table data	
INSERT INTO @InvoiceSummary
	SELECT @InvoiceID,
	null,
	null,
	null,
	(SUM(SIPS.Cost) - SUM(SIPS.PPODiscount)),
	(SUM(SIPS.PPODiscount)),
	(SUM(SIPS.Cost)),
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0
	FROM Invoice AS I
	INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
	INNER JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
	INNER JOIN SurgeryInvoice_Provider_Services AS SIPS ON SIP.ID = SIPS.SurgeryInvoice_ProviderID AND SIPS.Active = 1
	WHERE I.ID = @InvoiceID

-------------------------Amortization Date
----- Update the Invoice Summary table with the amortization date
----- The Amortization Date will be the earliest date scheduled. //From Spec
UPDATE @InvoiceSummary
SET AmortizationDate = dbo.f_GetFirstSurgeryDate(@InvoiceID)
						
-------------------------Date Service Fee Begins and Maturity Date
----- Get the months the service fee is waived for
DECLARE @ServiceFeeWaivedMonths int = (SELECT ServiceFeeWaivedMonths FROM Invoice WHERE ID = @InvoiceID)
----- Get the service fee waived amount
DECLARE @ServiceFeeWaived decimal(18,2) = (SELECT ServiceFeeWaived FROM Invoice WHERE ID = @InvoiceID)
----- Get the loan term months
DECLARE @LoanTermMonths int = (SELECT LoanTermMonths FROM Invoice WHERE ID = @InvoiceID)
----- Update the invoice summary with the date service fee begins and the maturity date calculated from the amortization date
----- The Date Service Fee Begins will be determined by the Service Fee Waived Time Period after the Amortization Date. //From Spec
UPDATE @InvoiceSummary
SET DateServiceFeeBegins = dbo.f_ServiceFeeBegins(AmortizationDate, @ServiceFeeWaivedMonths)
----- The Maturity Date will be determined by the time period entered in the Loan Term (in months) after the Date Service Fee Begins. //From Spec
UPDATE @InvoiceSummary
SET MaturityDate = DATEADD(M, @LoanTermMonths, DateServiceFeeBegins)


-------------------------Principal_Deposits_Paid, ServiceFeeReceived and AdditionalDeductions
----- Update invoice summary with different payment type totals
UPDATE @InvoiceSummary
SET Principal_Deposits_Paid = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active = 1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID in (1,3)),
ServiceFeeReceived = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active = 1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID = 2),
AdditionalDeductions = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active = 1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID in (4,5)),
TotalPrincipal = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active = 1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID = 1),
TotalDeposits = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active = 1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID = 3)

-------------------------Balance Due and Cumulative Service Fee Due
----- Update the invoice summary
----- Balance Due equals The total test cost minus the ppo discount minus the principal deposits made and minus any additional deductions 
UPDATE @InvoiceSummary
SET BalanceDue = ISNULL(TotalCost_Minus_PPODiscount, 0) - ISNULL(Principal_Deposits_Paid, 0) - ISNULL(AdditionalDeductions, 0),
	CumulativeServiceFeeDue = (SELECT I.CalculatedCumulativeIntrest FROM Invoice AS I WHERE ID = @InvoiceID)

UPDATE @InvoiceSummary
SET CumulativeServiceFeeDue = (ISNULL(CumulativeServiceFeeDue,0) - ISNULL(ServiceFeeReceived,0) - (ISNULL(@ServiceFeeWaived,0)))

-------------------------Ending Balance
----- Update the invoice summary setting the ending balance
----- Ending Balance equals the balance due plus the cumulative service fee due, minus losses amount
UPDATE @InvoiceSummary
SET EndingBalance = (BalanceDue + CumulativeServiceFeeDue) - (SELECT ISNULL(LossesAmount, 0) FROM Invoice WHERE ID=@InvoiceID)

-------------------------Cost Of Goods Sold
----- Update the invoice summary setting the cost of the goods sold
----- This field will display the total of the Amount Due fields on the Provider Information pages under the Provider Services for the invoice. //From Spec
UPDATE @InvoiceSummary
SET CostOfGoodsSold = (SELECT SUM(SIPS.AmountDue)
						FROM Invoice AS I
						INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
						INNER JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
						INNER JOIN SurgeryInvoice_Provider_Services AS SIPS ON SIP.ID = SIPS.SurgeryInvoice_ProviderID AND SIPS.Active = 1
						WHERE I.ID = @InvoiceID)
				
-------------------------Total Revenue and Total CPTs
----- Update the invoice summary total revenue and total cpts
UPDATE @InvoiceSummary
SET TotalRevenue = (Cost_Before_PPODiscount - CostOfGoodsSold - TotalPPODiscount),
TotalCPTs = (SELECT SUM(SIPCPT.Amount)
				FROM Invoice AS I
				INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
				INNER JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
				INNER JOIN SurgeryInvoice_Provider_CPTCodes AS SIPCPT ON SIP.ID = SIPCPT.SurgeryInvoice_ProviderID AND SIPCPT.Active = 1
				WHERE I.ID = @InvoiceID)
	
	RETURN 
END
GO
PRINT N'Creating [dbo].[procGetSurgeryInvoiceSummary]'
GO
CREATE PROCEDURE [dbo].[procGetSurgeryInvoiceSummary]

 @InvoiceID int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
--declare @InvoiceSummary table (InvoiceID int, DateServiceFeeBegins date, MaturityDate date, AmortizationDate date,
--								TotalCost_Minus_PPODiscount decimal(18,2), TotalPPODiscount decimal(18,2), Cost_Before_PPODiscount decimal(18,2),
--								Principal_Deposits_Paid decimal(18,2), ServiceFeeReceived decimal(18,2), AdditionalDeductions decimal(18,2),
--								BalanceDue decimal(18,2), CumulativeServiceFeeDue decimal(18,2), EndingBalance decimal(18,2),
--								CostOfGoodsSold decimal(18,2), TotalRevenue decimal(18,2), TotalCPTs decimal(18,2),
--								TotalPrincipal decimal(18,2), TotalDeposits decimal(18,2))
--insert into @InvoiceSummary
--select @InvoiceID,
--	null,
--	null,
--	null,
--	(SUM(SIPS.Cost) - SUM(SIPS.PPODiscount)),
--	(SUM(SIPS.PPODiscount)),
--	(SUM(SIPS.Cost)),
--	0,
--	0,
--	0,
--	0,
--	0,
--	0,
--	0,
--	0,
--	0,
--	0,
--	0
--	from Invoice as I
--	inner join SurgeryInvoice as SI on I.SurgeryInvoiceID = SI.ID
--	inner join SurgeryInvoice_Providers as SIP on SI.ID = SIP.SurgeryInvoiceID and SIP.Active = 1
--	inner join SurgeryInvoice_Provider_Services as SIPS on SIP.ID = SIPS.SurgeryInvoice_ProviderID and SIPS.Active = 1
--	where I.ID = @InvoiceID

---------------------------AmortizationDate

--update @InvoiceSummary
--set AmortizationDate = (select top 1 SISD.ScheduledDate
--						from Invoice as I
--						inner join SurgeryInvoice as SI on I.SurgeryInvoiceID = SI.ID
--						inner join SurgeryInvoice_Surgery as SIS on SI.ID = SIS.SurgeryInvoiceID and SIS.Active = 1
--						inner join SurgeryInvoice_SurgeryDates as SISD on SIS.ID = SISD.SurgeryInvoice_SurgeryID and SISD.Active = 1
--						where I.ID = @InvoiceID
--						order by SISD.ScheduledDate desc)
						
--------------DateServiceFeeBegins and MaturityDate

--declare @ServiceFeeWaivedMonths int = (select ServiceFeeWaivedMonths from Invoice where ID = @InvoiceID)
--declare @LoanTermMonths int = (select LoanTermMonths from Invoice where ID = @InvoiceID)

--update @InvoiceSummary
--set DateServiceFeeBegins =  DATEADD(M,@ServiceFeeWaivedMonths, AmortizationDate),
--	MaturityDate = DATEADD(M,@ServiceFeeWaivedMonths + @LoanTermMonths, AmortizationDate)


--------------Principal_Deposits_Paid, ServiceFeeReceived and AdditionalDeductions

--update @InvoiceSummary
--set Principal_Deposits_Paid = (select SUM (Amount)
--								from Payments as P
--								where P.Active = 1
--								and P.InvoiceID = @InvoiceID
--								and P.PaymentTypeID in (1,3)),
--ServiceFeeReceived = (select SUM (Amount)
--								from Payments as P
--								where P.Active = 1
--								and P.InvoiceID = @InvoiceID
--								and P.PaymentTypeID = 2),
--AdditionalDeductions = (select SUM (Amount)
--								from Payments as P
--								where P.Active = 1
--								and P.InvoiceID = @InvoiceID
--								and P.PaymentTypeID in (4,5)),
--TotalPrincipal = (select SUM (Amount)
--								from Payments as P
--								where P.Active = 1
--								and P.InvoiceID = @InvoiceID
--								and P.PaymentTypeID = 1),
--TotalDeposits = (select SUM (Amount)
--								from Payments as P
--								where P.Active = 1
--								and P.InvoiceID = @InvoiceID
--								and P.PaymentTypeID = 3)

-------------BalanceDue and CumulativeServiceFeeDue

--update @InvoiceSummary
--set BalanceDue = TotalCost_Minus_PPODiscount - Principal_Deposits_Paid - AdditionalDeductions,
--	CumulativeServiceFeeDue = (select I.CalculatedCumulativeIntrest from Invoice as I where ID = @InvoiceID)


--------------EndingBalance

--update @InvoiceSummary
--set EndingBalance = BalanceDue + CumulativeServiceFeeDue - @LossesAmount

--------------CostOfGoodsSold

--update @InvoiceSummary
--set CostOfGoodsSold = (select SUM(SIPS.Cost)
--						from Invoice as I
--						inner join SurgeryInvoice as SI on I.SurgeryInvoiceID = SI.ID
--						inner join SurgeryInvoice_Providers as SIP on SI.ID = SIP.SurgeryInvoiceID and SIP.Active = 1
--						inner join SurgeryInvoice_Provider_Services as SIPS on SIP.ID = SIPS.SurgeryInvoice_ProviderID and SIPS.Active = 1
--						where I.ID = @InvoiceID)
				
---------------TotalRevenue and TotalCPTs
						
--update @InvoiceSummary
--set TotalRevenue = (Cost_Before_PPODiscount - CostOfGoodsSold - TotalPPODiscount),
--TotalCPTs = (select SUM(SIPCPT.Amount)
--				from Invoice as I
--				inner join SurgeryInvoice as SI on I.SurgeryInvoiceID = SI.ID
--				inner join SurgeryInvoice_Providers as SIP on SI.ID = SIP.SurgeryInvoiceID and SIP.Active = 1
--				inner join SurgeryInvoice_Provider_CPTCodes as SIPCPT on SIP.ID = SIPCPT.SurgeryInvoice_ProviderID and SIPCPT.Active = 1
--				where I.ID = @InvoiceID)

--select *
--from @InvoiceSummary

SELECT * FROM dbo.f_GetSurgeryInvoiceSummaryTable(@InvoiceID)

END
GO
PRINT N'Creating [dbo].[f_GetInvoiceCumulativeServiceFeeDue]'
GO
-- =============================================
-- Author:		Bursavich, Andy
-- Create date: 2012.04.12
-- Description:	Gets the Cumulative Service Fee Due for an Invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetInvoiceCumulativeServiceFeeDue]
(
	@InvoiceID INT,
	@InvoiceCalculatedCumulativeIntrest DECIMAL(18,2) = NULL,
	@InvoiceServiceFeeWaived DECIMAL(18,2) = NULL,
	@InvoiceInterestPaymentsTotal DECIMAL(18,2) = NULL
)
RETURNS DECIMAL(18,2)
AS
BEGIN

	DECLARE @CumulativeServiceFeeDue DECIMAL(18,2)

	IF @InvoiceCalculatedCumulativeIntrest IS NULL
	SELECT @InvoiceCalculatedCumulativeIntrest = Invoice.CalculatedCumulativeIntrest FROM Invoice WHERE Invoice.ID=@InvoiceID
	
	IF @InvoiceServiceFeeWaived IS NULL
	SELECT @InvoiceServiceFeeWaived = Invoice.ServiceFeeWaived FROM Invoice WHERE Invoice.ID=@InvoiceID
	
	IF @InvoiceInterestPaymentsTotal IS NULL
	SET @InvoiceInterestPaymentsTotal = dbo.f_GetInvoiceInterestPaymentsTotal(@InvoiceID)

	SET @CumulativeServiceFeeDue = @InvoiceCalculatedCumulativeIntrest - @InvoiceServiceFeeWaived - @InvoiceInterestPaymentsTotal

	RETURN @CumulativeServiceFeeDue

END
GO
PRINT N'Creating [dbo].[f_GetTestInvoiceSummaryTable]'
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/20/2012
-- Description:	Returns Test Invoice Summary Table
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    03/20/2012   Aaron     Created function from stored proc
** 2	03/21/2012	 Aaron	   Commented and verified function calcs
*******************************/
CREATE FUNCTION [dbo].[f_GetTestInvoiceSummaryTable] 
(
	@InvoiceID int
)
RETURNS  
@InvoiceSummary TABLE (InvoiceID int, DateServiceFeeBegins date, MaturityDate date, AmortizationDate date,
						TotalTestCost_Minus_PPODiscount decimal(18,2), TotalPPODiscount decimal(18,2), CostOfTests_Before_PPODiscount decimal(18,2),
						Principal_Deposits_Paid decimal(18,2), ServiceFeeReceived decimal(18,2), AdditionalDeductions decimal(18,2),
						BalanceDue decimal(18,2), CumulativeServiceFeeDue decimal(18,2), EndingBalance decimal(18,2),
						CostOfGoodsSold decimal(18,2), TotalRevenue decimal(18,2), TotalCPTs decimal(18,2),
						TotalPrincipal decimal(18,2), TotalDeposits decimal(18,2))
AS
BEGIN
	
-------------------------Intial Load
----- Insert into Invoice Summary initially with basic table data
INSERT INTO @InvoiceSummary 
	SELECT @InvoiceID,
	NULL,
	NULL,
	NULL,
	(SUM(TestCost) - SUM(TIT.PPODiscount)) AS TotalTestCost_Minus_PPODiscount,	
	(SUM(TIT.PPODiscount)) AS TotalPPODiscount,
	(SUM(TIT.TestCost)) AS TotalTestCost,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0	
FROM Invoice AS I
INNER JOIN TestInvoice AS TI ON I.TestInvoiceID = TI.ID AND TI.Active = 1
INNER JOIN TestInvoice_Test AS TIT ON TI.ID = TIT.TestInvoiceID AND TIT.Active = 1
WHERE I.ID = @InvoiceID

-------------------------Amortization Date
----- Update the Invoice Summary table with the amortization date
----- The Amortization Date will be the date of the earliest test. //From Spec
UPDATE @InvoiceSummary
SET AmortizationDate = dbo.f_GetFirstTestDate(@InvoiceID)

-------------------------Date Service Fee Begins and Maturity Date
----- Get the months the service fee is waived for
DECLARE @ServiceFeeWaivedMonths int = (SELECT ServiceFeeWaivedMonths FROM Invoice WHERE ID = @InvoiceID)
----- Get the service fee waived amount
DECLARE @ServiceFeeWaived decimal(18,2) = (SELECT ServiceFeeWaived FROM Invoice WHERE ID = @InvoiceID)
----- Get the loan term months
DECLARE @LoanTermMonths int = (SELECT LoanTermMonths FROM Invoice WHERE ID = @InvoiceID)
----- Update the invoice summary with the date service fee begins and the maturity date calculated from the amortization date
----- The Date Service Fee Begins will be determined by the Service Fee Waived Time Period after the Amortization Date. //From Spec
UPDATE @InvoiceSummary
SET DateServiceFeeBegins = dbo.f_ServiceFeeBegins(AmortizationDate, @ServiceFeeWaivedMonths)
----- The Maturity Date will be determined by the time period entered in the Loan Term (in months) after the Date Service Fee Begins. //From Spec
UPDATE @InvoiceSummary
SET MaturityDate = DATEADD(M, @LoanTermMonths, DateServiceFeeBegins)


-------------------------Principal_Deposits_Paid, ServiceFeeReceived and AdditionalDeductions
----- Update invoice summary with different payment type totals
UPDATE @InvoiceSummary
SET Principal_Deposits_Paid = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID in (1,3)),
ServiceFeeReceived = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID = 2),
AdditionalDeductions = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID in (4,5)),
TotalPrincipal = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID = 1),
TotalDeposits = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID = 3)

-------------------------Balance Due and Cumulative Service Fee Due
----- Update the invoice summary
----- Balance Due equals The total test cost minus the ppo discount minus the principal deposits made and minus any additional deductions 
UPDATE @InvoiceSummary
SET BalanceDue = ISNULL(TotalTestCost_Minus_PPODiscount, 0) - ISNULL(Principal_Deposits_Paid, 0) - ISNULL(AdditionalDeductions, 0),
	CumulativeServiceFeeDue = (SELECT I.CalculatedCumulativeIntrest FROM Invoice AS I WHERE ID = @InvoiceID)

UPDATE @InvoiceSummary
SET CumulativeServiceFeeDue = (ISNULL(CumulativeServiceFeeDue,0) - ISNULL(ServiceFeeReceived,0) - (ISNULL(@ServiceFeeWaived,0)))
	
-------------------------Ending Balance
----- Update the invoice summary setting the ending balance
----- Ending Balance equals the balance due plus the cumulative service fee due, minus losses amount
UPDATE @InvoiceSummary
SET EndingBalance = (BalanceDue + CumulativeServiceFeeDue) - (SELECT ISNULL(LossesAmount, 0) FROM Invoice WHERE ID=@InvoiceID)

-------------------------Cost Of Goods Sold
----- Update the invoice summary setting the cost of the goods sold
----- Call the provider cost function passing in the provider id and the mri count
UPDATE @InvoiceSummary
SET CostOfGoodsSold = (SELECT SUM(dbo.f_GetTestInvoiceProviderCost(TIT.InvoiceProviderID,TIT.MRI))
						FROM Invoice I
						INNER JOIN TestInvoice AS TI ON I.TestInvoiceID = TI.ID AND Ti.Active = 1
						INNER JOIN TestInvoice_Test AS TIT ON TI.ID = TIT.TestInvoiceID AND TIT.Active = 1
						WHERE I.ID = @InvoiceID)
				
-------------------------Total Revenue and Total CPTs
----- Update the invoice summary total revenue and total cpts				
UPDATE @InvoiceSummary
SET TotalRevenue = (CostOfTests_Before_PPODiscount - CostOfGoodsSold - TotalPPODiscount),
TotalCPTs = (SELECT SUM(TITCPT.Amount) 
				FROM Invoice I
				INNER JOIN TestInvoice AS TI ON I.TestInvoiceID = TI.ID AND TI.Active = 1
				INNER JOIN TestInvoice_Test AS TIT ON TI.ID = TIT.TestInvoiceID AND TIT.Active=1
				INNER JOIN TestInvoice_Test_CPTCodes AS TITCPT ON TIT.ID = TITCPT.TestInvoice_TestID AND TITCPT.Active = 1
				WHERE I.ID = @InvoiceID)

	RETURN 
END
GO
PRINT N'Creating [dbo].[procGetTestInvoiceSummary]'
GO
CREATE PROCEDURE [dbo].[procGetTestInvoiceSummary]

 @InvoiceID int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
--declare @InvoiceSummary table (InvoiceID int, DateServiceFeeBegins date, MaturityDate date, AmortizationDate date,
--								TotalTestCost_Minus_PPODiscount decimal(18,2), TotalPPODiscount decimal(18,2), CostOfTests_Before_PPODiscount decimal(18,2),
--								Principal_Deposits_Paid decimal(18,2), ServiceFeeReceived decimal(18,2), AdditionalDeductions decimal(18,2),
--								BalanceDue decimal(18,2), CumulativeServiceFeeDue decimal(18,2), EndingBalance decimal(18,2),
--								CostOfGoodsSold decimal(18,2), TotalRevenue decimal(18,2), TotalCPTs decimal(18,2),
--								TotalPrincipal decimal(18,2), TotalDeposits decimal(18,2))
--insert into @InvoiceSummary
--select @InvoiceID,
--	null,
--	null,
--	null,
--	(SUM(TestCost) - SUM(TIT.PPODiscount)) as TotalTestCost_Minus_PPODiscount,	
--	(SUM(TIT.PPODiscount)) as TotalPPODiscount,
--	(SUM(TIT.TestCost)) as TotalTestCost,
--	0,
--	0,
--	0,
--	0,
--	0,
--	0,
--	0,
--	0,
--	0,
--	0,
--	0
	
--from Invoice as I
--inner join TestInvoice as TI on I.TestInvoiceID = TI.ID
--inner join TestInvoice_Test as TIT on TI.ID = TIT.TestInvoiceID
--where I.ID = @InvoiceID

---------------------------AmortizationDate

--update @InvoiceSummary
--set AmortizationDate = (select top 1 TIT.TestDate
--						from Invoice as I
--						inner join TestInvoice as TI on I.TestInvoiceID = TI.ID
--						inner join TestInvoice_Test as TIT on TI.ID = TIT.TestInvoiceID
--						where I.ID = @InvoiceID
--						order by TestDate desc)


--------------DateServiceFeeBegins and MaturityDate

--declare @ServiceFeeWaivedMonths int = (select ServiceFeeWaivedMonths from Invoice where ID = @InvoiceID)
--declare @LoanTermMonths int = (select LoanTermMonths from Invoice where ID = @InvoiceID)

--update @InvoiceSummary
--set DateServiceFeeBegins =  DATEADD(M,@ServiceFeeWaivedMonths, AmortizationDate),
--	MaturityDate = DATEADD(M,@ServiceFeeWaivedMonths + @LoanTermMonths, AmortizationDate)


--------------Principal_Deposits_Paid, ServiceFeeReceived and AdditionalDeductions

--update @InvoiceSummary
--set Principal_Deposits_Paid = (select SUM (Amount)
--								from Payments as P
--								where P.Active=1
--								and P.InvoiceID = @InvoiceID
--								and P.PaymentTypeID in (1,3)),
--ServiceFeeReceived = (select SUM (Amount)
--								from Payments as P
--								where P.Active=1
--								and P.InvoiceID = @InvoiceID
--								and P.PaymentTypeID = 2),
--AdditionalDeductions = (select SUM (Amount)
--								from Payments as P
--								where P.Active=1
--								and P.InvoiceID = @InvoiceID
--								and P.PaymentTypeID in (4,5)),
--TotalPrincipal = (select SUM (Amount)
--								from Payments as P
--								where P.Active=1
--								and P.InvoiceID = @InvoiceID
--								and P.PaymentTypeID = 1),
--TotalDeposits = (select SUM (Amount)
--								from Payments as P
--								where P.Active=1
--								and P.InvoiceID = @InvoiceID
--								and P.PaymentTypeID = 3)

-------------BalanceDue and CumulativeServiceFeeDue

--update @InvoiceSummary
--set BalanceDue = TotalTestCost_Minus_PPODiscount - Principal_Deposits_Paid - AdditionalDeductions,
--	CumulativeServiceFeeDue = (select I.CalculatedCumulativeIntrest from Invoice as I where ID = @InvoiceID)


--------------EndingBalance

--update @InvoiceSummary
--set EndingBalance = BalanceDue + CumulativeServiceFeeDue - @LossesAmount

--------------CostOfGoodsSold

--update @InvoiceSummary
--set CostOfGoodsSold = (select SUM(dbo.f_GetTestInvoiceProviderCost(TIT.InvoiceProviderID,TIT.MRI))
--						from Invoice I
--						inner join TestInvoice as TI on I.TestInvoiceID = TI.ID
--						inner join TestInvoice_Test as TIT on TI.ID = TIT.TestInvoiceID and TIT.Active = 1
--						where I.ID = @InvoiceID)
				
---------------TotalRevenue and TotalCPTs
						
--update @InvoiceSummary
--set TotalRevenue = (CostOfTests_Before_PPODiscount - CostOfGoodsSold - TotalPPODiscount),
--TotalCPTs = (select SUM(TITCPT.Amount) 
--				from Invoice I
--				inner join TestInvoice as TI on I.TestInvoiceID = TI.ID
--				inner join TestInvoice_Test as TIT on TI.ID = TIT.TestInvoiceID and TIT.Active=1
--				inner join TestInvoice_Test_CPTCodes as TITCPT on TIT.ID = TITCPT.TestInvoice_TestID and TITCPT.Active = 1
--				where I.ID = @InvoiceID)

--select *
--from @InvoiceSummary

SELECT * FROM dbo.f_GetTestInvoiceSummaryTable(@InvoiceID)

END
GO
PRINT N'Creating [dbo].[f_GetInvoiceEndingBalance]'
GO
-- =============================================
-- Author:		Bursavich, Andy
-- Create date: 2012.04.12
-- Description:	Gets the Ending Balance of an Invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetInvoiceEndingBalance]
(
	@InvoiceID INT,
	-- FROM INVOICE
	@InvoiceTypeID INT = NULL,
	@InvoiceCalculatedCumulativeIntrest DECIMAL(18,2) = NULL,
	@InvoiceServiceFeeWaived DECIMAL(18,2) = NULL,
	@InvoiceLossesAmount DECIMAL(18,2) = NULL,
	-- FOR BALANCE DUE
	@InvoiceCostTotal DECIMAL(18,2) = NULL,
	@InvoicePPODiscountTotal DECIMAL(18,2) = NULL,
	@InvoiceNonInterestPaymentsTotal DECIMAL(18,2) = NULL,
	@InvoiceBalanceDue DECIMAL(18,2) = NULL,
	-- FOR CUMULATIVE SERVICE FEE DUE
	@InvoiceInterestPaymentsTotal DECIMAL(18, 2) = NULL,
	@InvoiceCumServiceFeeDue DECIMAL(18,2) = NULL
)
RETURNS DECIMAL(18,2)
AS
BEGIN

	DECLARE @EndingBalance DECIMAL(18,2)
	
	IF @InvoiceTypeID IS NULL
	SELECT @InvoiceTypeID = Invoice.InvoiceTypeID FROM Invoice WHERE Invoice.ID=@InvoiceID
	
	IF @InvoiceLossesAmount IS NULL
	SELECT @InvoiceLossesAmount = ISNULL(Invoice.LossesAmount, 0) FROM Invoice WHERE Invoice.ID=@InvoiceID
	
	IF @InvoiceBalanceDue IS NULL
	SELECT @InvoiceBalanceDue = dbo.f_GetInvoiceBalanceDue(@InvoiceID, @InvoiceTypeID, @InvoiceCostTotal, @InvoicePPODiscountTotal, @InvoiceNonInterestPaymentsTotal)
	
	IF @InvoiceCumServiceFeeDue IS NULL
	SELECT @InvoiceCumServiceFeeDue = dbo.f_GetInvoiceCumulativeServiceFeeDue(@InvoiceID, @InvoiceCalculatedCumulativeIntrest, @InvoiceServiceFeeWaived, @InvoiceInterestPaymentsTotal)

	SELECT @EndingBalance = @InvoiceBalanceDue + @InvoiceCumServiceFeeDue - @InvoiceLossesAmount

	RETURN @EndingBalance

END
GO
PRINT N'Creating [dbo].[f_GetInvoiceMaturityDate]'
GO
/******************************
-- =============================================
-- Author:		Bursavich, Andy
-- Create date: 2012.04.12
-- Description:	Returns the Maturity Date of an Invoice
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    2012.04.12   Andy      Created function
** 1    2013.02.19   John      Fixed calculation so that DateServiceFeeBegins is used 
** 1	2013.03.12   Brad	   Fixed Amortization Date to calculate for Test or Surgery. Case 948277		
*******************************/
CREATE FUNCTION [dbo].[f_GetInvoiceMaturityDate]
(
	-- Add the parameters for the function here
	@InvoiceID INT,
	@InvoiceTypeID INT = NULL,
	@LoanTermMonths INT = NULL
)
RETURNS DATE
AS
BEGIN

	DECLARE @MaturityDate DATE
	DECLARE @ServiceFeeWaivedMonths int = (SELECT ServiceFeeWaivedMonths FROM Invoice WHERE ID = @InvoiceID)
	--DECLARE @AmortizationDate DATE = dbo.f_GetFirstTestDate(@InvoiceID)
	DECLARE @InvoiceTestID int = (SELECT TestInvoiceID from Invoice where ID = @InvoiceID)
	DECLARE @AmortizationDate DATE
	
	IF @InvoiceTestID IS NULL
	SET @AmortizationDate = dbo.f_GetFirstSurgeryDate(@InvoiceID)
	ELSE
	SET @AmortizationDate = dbo.f_GetFirstTestDate(@InvoiceID)
	
	DECLARE @DateServiceFeeBegins DATE = dbo.f_ServiceFeeBegins(@AmortizationDate, @ServiceFeeWaivedMonths)
			

	IF @InvoiceTypeID IS NULL
	SELECT @InvoiceTypeID = Invoice.InvoiceTypeID FROM Invoice WHERE Invoice.ID=@InvoiceID
	
	IF @LoanTermMonths IS NULL
	SELECT @LoanTermMonths = Invoice.LoanTermMonths FROM Invoice WHERE Invoice.ID=@InvoiceID
	
	DECLARE @TestingInvoiceTypeID INT = 1
	--DECLARE @SurgeryInvoiceTypeID INT = 2

	SET @MaturityDate = DATEADD(MONTH, @LoanTermMonths, @DateServiceFeeBegins)
	
	RETURN @MaturityDate

END
GO
PRINT N'Creating [dbo].[f_GetInvoicePaymentTotal]'
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Gets a total of payments for a specific invoice
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    03/23/2012   Aaron     Created function
*******************************/
CREATE FUNCTION [dbo].[f_GetInvoicePaymentTotal] 
(
	-- Add the parameters for the function here
	@InvoiceID int
)
RETURNS decimal(18,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result decimal(18,2)
	DECLARE @PrinciplePaymentTypeID INT = 1
	DECLARE @DepositPaymentTypeID INT = 3
	DECLARE @CreditPaymentTypeID INT = 5
	DECLARE @RefundPaymentTypeID INT = 4

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = SUM(P.Amount)
	FROM Payments P
	WHERE P.InvoiceID = @InvoiceID AND (P.PaymentTypeID=@PrinciplePaymentTypeID OR P.PaymentTypeID=@DepositPaymentTypeID OR P.PaymentTypeID=@CreditPaymentTypeID OR P.PaymentTypeID=@RefundPaymentTypeID) AND P.Active=1

	-- Return the result of the function
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[f_GetSurgeryDates]'
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Returns all surgery dates in string format
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    03/23/2012   Aaron     Created function
** 2	07/10/2012	 Aaron	   Added 'Order By' for Scheduled Date
*******************************/
CREATE FUNCTION [dbo].[f_GetSurgeryDates] 
(
	-- Add the parameters for the function here
	@InvoiceID int
)
RETURNS varchar(1000)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(1000)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = COALESCE(@Result + ', ', '') + CONVERT(varchar, SISD.ScheduledDate, 1)
	FROM Invoice I
		JOIN SurgeryInvoice SI ON SI.ID=I.SurgeryInvoiceID AND SI.Active=1
		LEFT JOIN SurgeryInvoice_Surgery SIS ON SIS.SurgeryInvoiceID=SI.ID AND SIS.Active=1
			LEFT JOIN Surgery S ON S.ID=SIS.SurgeryID AND S.Active=1
			LEFT JOIN SurgeryInvoice_SurgeryDates SISD ON SISD.SurgeryInvoice_SurgeryID = SIS.ID AND SISD.Active=1
	WHERE I.ID = @InvoiceID 
	Order BY SISD.ScheduledDate ASC
	
	-- Return the result of the function
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[f_GetTestInvoiceSummaryTableByDate]'
GO
CREATE FUNCTION [dbo].[f_GetTestInvoiceSummaryTableByDate] 
(
	@InvoiceID int,
	@StartDate datetime = null, 
	@EndDate datetime = null
)
RETURNS  
@InvoiceSummary TABLE (InvoiceID int, DateServiceFeeBegins date, MaturityDate date, AmortizationDate date,
						TotalTestCost_Minus_PPODiscount decimal(18,2), TotalPPODiscount decimal(18,2), CostOfTests_Before_PPODiscount decimal(18,2),
						Principal_Deposits_Paid decimal(18,2), ServiceFeeReceived decimal(18,2), AdditionalDeductions decimal(18,2),
						BalanceDue decimal(18,2), CumulativeServiceFeeDue decimal(18,2), EndingBalance decimal(18,2),
						CostOfGoodsSold decimal(18,2), TotalRevenue decimal(18,2), TotalCPTs decimal(18,2),
						TotalPrincipal decimal(18,2), TotalDeposits decimal(18,2))
AS
BEGIN
	
-------------------------Intial Load
----- Insert into Invoice Summary initially with basic table data
INSERT INTO @InvoiceSummary 
	SELECT @InvoiceID,
	NULL,
	NULL,
	NULL,
	(SUM(TestCost) - SUM(TIT.PPODiscount)) AS TotalTestCost_Minus_PPODiscount,	
	(SUM(TIT.PPODiscount)) AS TotalPPODiscount,
	(SUM(TIT.TestCost)) AS TotalTestCost,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0
FROM Invoice AS I
INNER JOIN TestInvoice AS TI ON I.TestInvoiceID = TI.ID AND TI.Active = 1
INNER JOIN TestInvoice_Test AS TIT ON TI.ID = TIT.TestInvoiceID AND TIT.Active = 1
WHERE I.ID = @InvoiceID

-------------------------Amortization Date
----- Update the Invoice Summary table with the amortization date
----- The Amortization Date will be the date of the earliest test. //From Spec
UPDATE @InvoiceSummary
SET AmortizationDate = (SELECT TOP 1 TIT.TestDate
						FROM Invoice AS I
						INNER JOIN TestInvoice AS TI ON I.TestInvoiceID = TI.ID AND TI.Active = 1 
						INNER JOIN TestInvoice_Test AS TIT ON TI.ID = TIT.TestInvoiceID AND TIT.Active = 1
						WHERE I.ID = @InvoiceID
						ORDER BY TestDate ASC)


-------------------------Date Service Fee Begins and Maturity Date
----- Get the months the service fee is waived for
DECLARE @ServiceFeeWaivedMonths int = (SELECT ServiceFeeWaivedMonths FROM Invoice WHERE ID = @InvoiceID)
----- Get the service fee waived amount
DECLARE @ServiceFeeWaived decimal(18,2) = (SELECT ServiceFeeWaived FROM Invoice WHERE ID = @InvoiceID)
----- Get the loan term months
DECLARE @LoanTermMonths int = (SELECT LoanTermMonths FROM Invoice WHERE ID = @InvoiceID)
----- Update the invoice summary with the date service fee begins and the maturity date calculated from the amortization date
----- The Date Service Fee Begins will be determined by the Service Fee Waived Time Period after the Amortization Date. //From Spec
----- The Maturity Date will be determined by the time period entered in the Loan Term (in months) after the Date Service Fee Begins. //From Spec
UPDATE @InvoiceSummary
SET DateServiceFeeBegins =  DATEADD(M,@ServiceFeeWaivedMonths, AmortizationDate),
	MaturityDate = DATEADD(M,@ServiceFeeWaivedMonths + @LoanTermMonths, AmortizationDate)


-------------------------Principal_Deposits_Paid, ServiceFeeReceived and AdditionalDeductions
----- Update invoice summary with different payment type totals
UPDATE @InvoiceSummary
SET Principal_Deposits_Paid = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID in (1,3)
								AND P.DatePaid BETWEEN @StartDate AND @EndDate),
ServiceFeeReceived = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID = 2
								AND P.DatePaid BETWEEN @StartDate AND @EndDate),
AdditionalDeductions = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID in (4,5)
								AND P.DatePaid BETWEEN @StartDate AND @EndDate),
TotalPrincipal = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID = 1
								AND P.DatePaid BETWEEN @StartDate AND @EndDate),
TotalDeposits = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID = 3
								AND P.DatePaid BETWEEN @StartDate AND @EndDate)

-------------------------Balance Due and Cumulative Service Fee Due
----- Update the invoice summary
----- Balance Due equals The total test cost minus the ppo discount minus the principal deposits made and minus any additional deductions 
UPDATE @InvoiceSummary
SET BalanceDue = ISNULL(TotalTestCost_Minus_PPODiscount, 0) - ISNULL(Principal_Deposits_Paid, 0) - ISNULL(AdditionalDeductions, 0),
	CumulativeServiceFeeDue = (SELECT I.CalculatedCumulativeIntrest FROM Invoice AS I WHERE ID = @InvoiceID)

UPDATE @InvoiceSummary
SET CumulativeServiceFeeDue = (ISNULL(CumulativeServiceFeeDue,0) - ISNULL(ServiceFeeReceived,0) - (ISNULL(@ServiceFeeWaived,0)))
	
-------------------------Ending Balance
----- Update the invoice summary setting the ending balance
----- Ending Balance equals the balance due plus the cumulative service fee due, minus losses amount
UPDATE @InvoiceSummary
SET EndingBalance = (BalanceDue + CumulativeServiceFeeDue) - (SELECT ISNULL(LossesAmount, 0) FROM Invoice WHERE ID=@InvoiceID)

-------------------------Cost Of Goods Sold
----- Update the invoice summary setting the cost of the goods sold
----- Call the provider cost function passing in the provider id and the mri count
UPDATE @InvoiceSummary
SET CostOfGoodsSold = (SELECT SUM(dbo.f_GetTestInvoiceProviderCost(TIT.InvoiceProviderID,TIT.MRI))
						FROM Invoice I
						INNER JOIN TestInvoice AS TI ON I.TestInvoiceID = TI.ID AND Ti.Active = 1
						INNER JOIN TestInvoice_Test AS TIT ON TI.ID = TIT.TestInvoiceID AND TIT.Active = 1
						WHERE I.ID = @InvoiceID)
				
-------------------------Total Revenue and Total CPTs
----- Update the invoice summary total revenue and total cpts				
UPDATE @InvoiceSummary
SET TotalRevenue = (CostOfTests_Before_PPODiscount - CostOfGoodsSold - TotalPPODiscount),
TotalCPTs = (SELECT SUM(TITCPT.Amount) 
				FROM Invoice I
				INNER JOIN TestInvoice AS TI ON I.TestInvoiceID = TI.ID AND TI.Active = 1
				INNER JOIN TestInvoice_Test AS TIT ON TI.ID = TIT.TestInvoiceID AND TIT.Active=1
				INNER JOIN TestInvoice_Test_CPTCodes AS TITCPT ON TIT.ID = TITCPT.TestInvoice_TestID AND TITCPT.Active = 1
				WHERE I.ID = @InvoiceID)

	RETURN 
END
GO
PRINT N'Creating [dbo].[f_GetSurgeryProvidersByInvoice]'
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Gets multiple providers for a surgery invoice as string
-- =============================================
CREATE FUNCTION [dbo].[f_GetSurgeryProvidersByInvoice] 
(
	-- Add the parameters for the function here
	@InvoiceID int
)
RETURNS varchar(1000)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(1000)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = COALESCE(@Result + ', ', '') + CONVERT(varchar, IP.Name, 1)
	FROM Invoice I
		JOIN SurgeryInvoice SI ON SI.ID=I.SurgeryInvoiceID AND SI.Active=1
		LEFT JOIN SurgeryInvoice_Providers SIP ON SIP.SurgeryInvoiceID=SI.ID AND SIP.Active=1
		LEFT JOIN InvoiceProvider IP ON IP.ID=SIP.InvoiceProviderID AND IP.Active=1
	WHERE I.ID = @InvoiceID 

	-- Return the result of the function
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[f_GetSurgeryInvoiceSummaryTableByDate]'
GO
CREATE FUNCTION [dbo].[f_GetSurgeryInvoiceSummaryTableByDate] 
(
	@InvoiceID int,
	@StartDate datetime = null, 
	@EndDate datetime = null
)
RETURNS 
@InvoiceSummary TABLE (InvoiceID int, DateServiceFeeBegins date, MaturityDate date, AmortizationDate date,
								TotalCost_Minus_PPODiscount decimal(18,2), TotalPPODiscount decimal(18,2), Cost_Before_PPODiscount decimal(18,2),
								Principal_Deposits_Paid decimal(18,2), ServiceFeeReceived decimal(18,2), AdditionalDeductions decimal(18,2),
								BalanceDue decimal(18,2), CumulativeServiceFeeDue decimal(18,2), EndingBalance decimal(18,2),
								CostOfGoodsSold decimal(18,2), TotalRevenue decimal(18,2), TotalCPTs decimal(18,2),
								TotalPrincipal decimal(18,2), TotalDeposits decimal(18,2))
AS
BEGIN

-------------------------Intial Load
----- Insert into Invoice Summary initially with basic table data	
INSERT INTO @InvoiceSummary
	SELECT @InvoiceID,
	null,
	null,
	null,
	(SUM(SIPS.Cost) - SUM(SIPS.PPODiscount)),
	(SUM(SIPS.PPODiscount)),
	(SUM(SIPS.Cost)),
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0
	FROM Invoice AS I
	INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
	INNER JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
	INNER JOIN SurgeryInvoice_Provider_Services AS SIPS ON SIP.ID = SIPS.SurgeryInvoice_ProviderID AND SIPS.Active = 1
	WHERE I.ID = @InvoiceID

-------------------------Amortization Date
----- Update the Invoice Summary table with the amortization date
----- The Amortization Date will be the earliest date scheduled. //From Spec
UPDATE @InvoiceSummary
SET AmortizationDate = dbo.f_GetFirstSurgeryDate(@InvoiceID)
					 --(SELECT TOP 1 SISD.ScheduledDate
						--FROM Invoice AS I
						--INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
						--INNER JOIN SurgeryInvoice_Surgery AS SIS ON SI.ID = SIS.SurgeryInvoiceID AND SIS.Active = 1
						--INNER JOIN SurgeryInvoice_SurgeryDates AS SISD ON SIS.ID = SISD.SurgeryInvoice_SurgeryID AND SISD.Active = 1
						--WHERE I.ID = @InvoiceID
						--ORDER BY SISD.ScheduledDate ASC)
						
-------------------------Date Service Fee Begins and Maturity Date
----- Get the months the service fee is waived for
DECLARE @ServiceFeeWaivedMonths int = (SELECT ServiceFeeWaivedMonths FROM Invoice WHERE ID = @InvoiceID)
----- Get the service fee waived amount
DECLARE @ServiceFeeWaived decimal(18,2) = (SELECT ServiceFeeWaived FROM Invoice WHERE ID = @InvoiceID)
----- Get the loan term months
DECLARE @LoanTermMonths int = (SELECT LoanTermMonths FROM Invoice WHERE ID = @InvoiceID)
----- Update the invoice summary with the date service fee begins and the maturity date calculated from the amortization date
----- The Date Service Fee Begins will be determined by the Service Fee Waived Time Period after the Amortization Date. //From Spec
----- The Maturity Date will be determined by the time period entered in the Loan Term (in months) after the Date Service Fee Begins. //From Spec
UPDATE @InvoiceSummary
SET DateServiceFeeBegins =  DATEADD(M,@ServiceFeeWaivedMonths, AmortizationDate),
	MaturityDate = DATEADD(M,@ServiceFeeWaivedMonths + @LoanTermMonths, AmortizationDate)


-------------------------Principal_Deposits_Paid, ServiceFeeReceived and AdditionalDeductions
----- Update invoice summary with different payment type totals
UPDATE @InvoiceSummary						
SET Principal_Deposits_Paid = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID in (1,3)
								AND P.DatePaid BETWEEN @StartDate AND @EndDate),
ServiceFeeReceived = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID = 2
								AND P.DatePaid BETWEEN @StartDate AND @EndDate),
AdditionalDeductions = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID in (4,5)
								AND P.DatePaid BETWEEN @StartDate AND @EndDate),
TotalPrincipal = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID = 1
								AND P.DatePaid BETWEEN @StartDate AND @EndDate),
TotalDeposits = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID = 3
								AND P.DatePaid BETWEEN @StartDate AND @EndDate)								

-------------------------Balance Due and Cumulative Service Fee Due
----- Update the invoice summary
----- Balance Due equals The total test cost minus the ppo discount minus the principal deposits made and minus any additional deductions 
UPDATE @InvoiceSummary
SET BalanceDue = ISNULL(TotalCost_Minus_PPODiscount, 0) - ISNULL(Principal_Deposits_Paid, 0) - ISNULL(AdditionalDeductions, 0),
	CumulativeServiceFeeDue = (SELECT I.CalculatedCumulativeIntrest FROM Invoice AS I WHERE ID = @InvoiceID)

UPDATE @InvoiceSummary
SET CumulativeServiceFeeDue = (ISNULL(CumulativeServiceFeeDue,0) - ISNULL(ServiceFeeReceived,0) - (ISNULL(@ServiceFeeWaived,0)))

-------------------------Ending Balance
----- Update the invoice summary setting the ending balance
----- Ending Balance equals the balance due plus the cumulative service fee due, minus losses amount
UPDATE @InvoiceSummary
SET EndingBalance = (BalanceDue + CumulativeServiceFeeDue) - (SELECT ISNULL(LossesAmount, 0) FROM Invoice WHERE ID=@InvoiceID)

-------------------------Cost Of Goods Sold
----- Update the invoice summary setting the cost of the goods sold
----- This field will display the total of the Amount Due fields on the Provider Information pages under the Provider Services for the invoice. //From Spec
UPDATE @InvoiceSummary
SET CostOfGoodsSold = (SELECT SUM(SIPS.AmountDue)
						FROM Invoice AS I
						INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
						INNER JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
						INNER JOIN SurgeryInvoice_Provider_Services AS SIPS ON SIP.ID = SIPS.SurgeryInvoice_ProviderID AND SIPS.Active = 1
						WHERE I.ID = @InvoiceID)
				
-------------------------Total Revenue and Total CPTs
----- Update the invoice summary total revenue and total cpts
UPDATE @InvoiceSummary
SET TotalRevenue = (Cost_Before_PPODiscount - CostOfGoodsSold - TotalPPODiscount),
TotalCPTs = (SELECT SUM(SIPCPT.Amount)
				FROM Invoice AS I
				INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
				INNER JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
				INNER JOIN SurgeryInvoice_Provider_CPTCodes AS SIPCPT ON SIP.ID = SIPCPT.SurgeryInvoice_ProviderID AND SIPCPT.Active = 1
				WHERE I.ID = @InvoiceID)
	
	RETURN 
END
GO
PRINT N'Creating [dbo].[f_GetTestDates]'
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Gets all test dates as string for an invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetTestDates] 
(
	-- Add the parameters for the function here
	@InvoiceID int
)
RETURNS varchar(1000)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(1000)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = COALESCE(@Result + ', ', '') + CONVERT(varchar, TIT.TestDate, 1)
	FROM Invoice I
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
		LEFT JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1
	WHERE I.ID = @InvoiceID
	Order By TIT.TestDate ASC

	-- Return the result of the function
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[f_GetTestProvidersAbbrByInvoice]'
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Gets multiple providers, and abbreviations for a test invoice as string
-- =============================================
CREATE FUNCTION [dbo].[f_GetTestProvidersAbbrByInvoice] 
(
	-- Add the parameters for the function here
	@InvoiceID int
)
RETURNS varchar(1000)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(1000)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = COALESCE(@Result + ', ', '') + IP.FacilityAbbreviation
	FROM Invoice I
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
		JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1
		JOIN InvoiceProvider IP ON IP.ID=TIT.InvoiceProviderID AND IP.Active=1
	WHERE I.ID = @InvoiceID AND IP.FacilityAbbreviation IS NOT NULL

	-- Return the result of the function
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[f_GetTestProcedures]'
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Gets all test procedure names associated with an invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetTestProcedures] 
(
	@InvoiceID int
)
RETURNS varchar(1000)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(1000)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = COALESCE(@Result + ', ', '') + CONVERT(varchar, T.Name, 1)
	FROM Invoice I 
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
			LEFT JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1
			LEFT JOIN Test T ON T.ID=TIT.TestID AND T.Active=1
	WHERE I.ID = @InvoiceID

	-- Return the result of the function
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[procAccountsReceivablesPastDueReport_DMA]'
GO
-- =============================================
-- Author:		Brad Conley
-- Create date: 4/30/2014
-- Description:	Data Set for Acounts Receivables Past Due Report
-- =============================================
--procAccountsReceivablesPastDueReport_DMA '5/1/2017', '5/31/2017', 2, -1
CREATE PROCEDURE [dbo].[procAccountsReceivablesPastDueReport_DMA]
	@StartDate datetime = null, 
	@EndDate datetime = '3/31/2017',
	@CompanyId int = 1,
	@AttorneyId int = 34227,
	@StatementDate datetime = null
AS
BEGIN
	SET NOCOUNT ON;

DECLARE @ClosedStatusTypeID INT = 2
DECLARE @PrinciplePaymentTypeID INT = 1
DECLARE @DepositPaymentTypeID INT = 3
DECLARE @CreditPaymentTypeID INT = 5
DECLARE @RefundPaymentTypeID INT = 4
DECLARE @TestTypeID INT = 1
DECLARE @SurgeryTypeID INT = 2
(
	SELECT
		'Test' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		dbo.f_GetTestDates(I.ID) AS [ServiceDate],
		(dbo.f_GetFirstTestDate(I.ID) + I.ServiceFeeWaivedMonths) AS DateServiceFeeBegins,
		dbo.f_GetTestProvidersAbbrByInvoice(I.ID) AS Provider,
		dbo.f_GetTestProcedures(I.ID) as ServiceName,
		A.FirstName AS AttorneyFirstName,
		A.LastName AS AttorneyLastName,
		A.LastName + ', ' + A.FirstName AS AttorneyDisplayName,
		InvF.Name AS FirmName,
		InvP.FirstName AS PatientFirstName,
		InvP.LastName AS PatientLastName,
		InvP.LastName + ', ' + InvP.FirstName AS PatientDisplayName,
		dbo.f_GetTestCostTotal(I.ID) AS TotalCost,
		tis.InvoicePaymentTotal AS PaymentAmount,
	    dbo.f_GetTestPPODiscountTotal(I.ID) AS PPODiscount,
		tis.BalanceDue as BalanceDue,
		tis.CumulativeServiceFeeDue as ServiceFeeDue,
		tis.EndingBalance as EndingBalance,
		tis.BalanceDue + tis.CumulativeServiceFeeDue AS TotalDue,
		dbo.f_GetLastCommentFromInvoice(I.ID) As Comment,
		I.isComplete AS InvoiceCompleted,
		-- Change the DueDate(Maturity Date) to the first of the following month.
		-- This is done to match the maturity date of the invoice on the EditInvoice.aspx
	 	DateAdd(Month, 1, DateAdd(Month, DateDiff(Month, 0, tis.MaturityDate), 0)) As DueDate,
		co.LongName as CompanyName,
		tis.FirstTestDate as SortServiceDate,
		I.InvoiceStatusTypeID as StatusType
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		join Attorney A on IA.AttorneyID = A.ID 
		LEFT JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		JOIN InvoicePatient InvP ON InvP.ID=I.InvoicePatientID AND InvP.Active=1
		outer apply dbo.f_GetTestInvoiceSummaryTableMinified(I.ID, @StatementDate) tis
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE I.InvoiceStatusTypeID != @ClosedStatusTypeID 
		--AND I.isComplete = 1
		AND tis.BalanceDue > 0 -- CCW:  12/20/2012  Customer does not mark testing invoices as complete, instead placeholder value of $1.00 is updated to signify that this invoice needs to appear on receivables report
		AND I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @TestTypeID
		AND (@AttorneyId = -1 or A.ID = @AttorneyId)
		--AND @StartDate <= tis.MaturityDate AND tis.MaturityDate <= @EndDate
)
UNION
(
	SELECT
		'Procedure' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		CONVERT(varchar(1000),dbo.f_GetSurgeryDates(I.ID),1) AS [ServiceDate],
		(dbo.f_GetFirstSurgeryDate(I.ID) + I.ServiceFeeWaivedMonths) As DateServiceFeeBegins,
		dbo.f_GetSurgeryProvidersAbbrByInvoice(I.ID) AS Provider,
		dbo.f_GetSurgeryProcedures(I.ID) as ServiceName,
		A.FirstName AS AttorneyFirstName,
		A.LastName AS AttorneyLastName,
		A.LastName + ', ' + A.FirstName AS AttorneyName,
		InvF.Name AS FirmName,
		InvP.FirstName AS PatientFirstName,
		InvP.LastName AS PatientLastName,
		InvP.LastName + ', ' + InvP.FirstName As PatientName,
		dbo.f_GetSurgeryCostTotal(I.ID) AS TotalCost,
		sisum.InvoicePaymentTotal AS PaymentAmount,
		dbo.f_GetSurgeryPPODiscountTotal(I.ID) AS PPODiscount,
		sisum.BalanceDue as BalanceDue,
		sisum.CumulativeServiceFeeDue as ServiceFeeDue,
		sisum.BalanceDue + sisum.CumulativeServiceFeeDue as TotalDue,
		sisum.EndingBalance as EndingBalance,
		dbo.f_GetLastCommentFromInvoice(I.ID) As Comment,
		I.isComplete AS InvoiceCompleted,
		--sisum.MaturityDate As DueDate,
		-- Change the DueDate(Maturity Date) to the first of the following month.
		-- This is done to match the maturity date of the invoice on the EditInvoice.aspx
	 	DateAdd(Month, 1, DateAdd(Month, DateDiff(Month, 0, sisum.MaturityDate), 0)) As DueDate,
		co.LongName as CompanyName,
		sisum.FirstSurgeryDate as SortServiceDate,
		I.InvoiceStatusTypeID as StatusType
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		join Attorney A on IA.AttorneyID = A.ID 
		LEFT JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		JOIN InvoicePatient InvP ON InvP.ID=I.InvoicePatientID AND InvP.Active=1
		outer apply dbo.f_GetSurgeryInvoiceSummaryTableMinified(I.ID, @StatementDate) sisum
		LEFT JOIN Comments c ON I.ID = c.InvoiceID AND c.Active=1 AND c.isIncludedOnReports = 1
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE I.InvoiceStatusTypeID != @ClosedStatusTypeID AND I.isComplete = 1
		AND I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @SurgeryTypeID
		AND (@AttorneyId = -1 or A.ID = @AttorneyId)
		--AND @StartDate <= sisum.MaturityDate AND sisum.MaturityDate <= @EndDate
)
order by AttorneyDisplayName

END
GO
PRINT N'Creating [dbo].[f_GetSurgeryPaymentsToProviderByDate]'
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 6/21/2012
-- Description:	Gets the sum of the payments to provider for an invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetSurgeryPaymentsToProviderByDate] 
(
	-- Add the parameters for the function here
	@InvoiceID int,
	@StartDate datetime = null, 
	@EndDate datetime = null
)
RETURNS decimal(18,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result decimal(18,2)

	SELECT @Result = ISNULL(SUM(SIPP.Amount), 0)
		FROM Invoice I 
			JOIN SurgeryInvoice SI ON SI.ID=I.SurgeryInvoiceID AND SI.Active=1
				JOIN SurgeryInvoice_Providers SIP ON SIP.SurgeryInvoiceID=SI.ID AND SIP.Active=1
					JOIN SurgeryInvoice_Provider_Payments SIPP ON SIPP.SurgeryInvoice_ProviderID=SIP.ID
		WHERE I.ID = @InvoiceID AND SIPP.DatePaid BETWEEN @StartDate AND @EndDate AND SIPP.Active =1 -- SIPP.Active=1: Case 969913
	
	-- Return the result of the function
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[f_GetTestPaymentsToProviderByDate]'
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 6/21/2012
-- Description:	Gets the sum of the payments to the provider for a specific invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetTestPaymentsToProviderByDate] 
(
	-- Add the parameters for the function here
	@InvoiceID int,
	@StartDate datetime = null, 
	@EndDate datetime = null
)
RETURNS decimal(18,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result decimal(18,2)

	SELECT @Result = (ISNULL(SUM(TIT.DepositToProvider), 0) + ISNULL(SUM(TIT.AmountPaidToProvider), 0))
	FROM Invoice I 
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
		JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1
	WHERE I.ID = @InvoiceID AND TIT.[Date] BETWEEN @StartDate AND @EndDate
	
	-- Return the result of the function
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[procGetPatientReport]'
GO
-- =============================================
-- Author:		John D'Oriocourt
-- Create date: 09/12/2013
-- Description:	Gets the information needed for
-- the Patient Report.
-- 09/12/2013: 983473 - Created procedure.
-- =============================================
CREATE PROCEDURE [dbo].[procGetPatientReport] 
	-- Add the parameters for the stored procedure here
	@CompanyID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT c.Name      AS CompanyName, 
           p.ID        AS PatID, 
           p.FirstName AS PatFirstName, 
           p.LastName  AS PatLastName, 
           i.InvoiceNumber, 
           i.isComplete, 
           a.FirstName AS AttFirstName, 
           a.LastName  AS AttLastName, 
           it.Name     AS InvoiceType, 
           CASE it.ID 
             WHEN 1 THEN (SELECT EndingBalance 
                          FROM   dbo.f_GetTestInvoiceSummaryTable(i.ID)) 
             WHEN 2 THEN (SELECT EndingBalance 
                          FROM   dbo.f_GetSurgeryInvoiceSummaryTable(i.ID)) 
             ELSE 0 
           END         AS EndingBalance 
    FROM   Invoice i 
           INNER JOIN Company c 
                   ON i.CompanyID = c.ID 
           INNER JOIN InvoicePatient ip 
                   ON i.InvoicePatientID = ip.ID 
           INNER JOIN Patient p 
                   ON ip.PatientID = p.ID 
           INNER JOIN InvoiceAttorney ia 
                   ON i.InvoiceAttorneyID = ia.ID 
           INNER JOIN Attorney a 
                   ON ia.AttorneyID = a.ID 
           INNER JOIN InvoiceType it 
                   ON i.InvoiceTypeID = it.ID 
    WHERE  i.Active = 1 
           AND p.Active = 1 
           AND i.InvoiceStatusTypeID IN (1, 3) 
           AND i.CompanyID = @CompanyID
END
GO
PRINT N'Creating [dbo].[f_GetTestProvidersByInvoice]'
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Gets multiple providers for a test invoice as string
-- =============================================
CREATE FUNCTION [dbo].[f_GetTestProvidersByInvoice] 
(
	-- Add the parameters for the function here
	@InvoiceID int
)
RETURNS varchar(1000)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(1000)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = COALESCE(@Result + ', ', '') + CONVERT(varchar, IP.Name, 1)
	FROM Invoice I
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
		LEFT JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1
		LEFT JOIN InvoiceProvider IP ON IP.ID=TIT.InvoiceProviderID AND IP.Active=1
	WHERE I.ID = @InvoiceID 

	-- Return the result of the function
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[procAccountsReceivableReport]'
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/19/2012
-- Description:	Accounts Receivable Report Data
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    03/19/2012   Aaron     Created proc
** 2	03/22/2012	 Aaron	   Commented and verified function calcs 
** 2	03/23/2012	 Aaron	   Fixed duplicate records, added UDFs for total calculations
** 3	10/17/2012	 Aaron	   Made query faster by 40 seconds
** 4	12/20/2012	 Czarina   Made modifications to the criteria to include test invoices because users do not mark as complete 		
** 5    01/03/2013   Cherie    Made modification to the criteria to include all Balance Due > 0
** 6	05/01/2017   Jason A   Added IsPastDue column, fixed PastDue logic
*******************************/
CREATE PROCEDURE [dbo].[procAccountsReceivableReport]
	@StartDate datetime = null, 
	@EndDate datetime = null,
	@CompanyId int = -1,
	@AttorneyId int = -1,
	@StatementDate datetime = null
AS
BEGIN
	SET NOCOUNT ON;
	
DECLARE @ClosedStatusTypeID INT = 2
DECLARE @PrinciplePaymentTypeID INT = 1
DECLARE @DepositPaymentTypeID INT = 3
DECLARE @CreditPaymentTypeID INT = 5
DECLARE @RefundPaymentTypeID INT = 4
DECLARE @TestTypeID INT = 1
DECLARE @SurgeryTypeID INT = 2
if @CompanyId = 1
begin
(
	SELECT
		'Test' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		CONVERT(varchar, dbo.f_GetFirstTestDate(I.ID), 1) AS [ServiceDate],
		(dbo.f_GetFirstTestDate(I.ID) + I.ServiceFeeWaivedMonths) AS DateServiceFeeBegins,
		dbo.f_GetTestProvidersAbbrByInvoiceAndDate(I.ID, dbo.f_GetFirstTestDate(I.ID)) AS Provider,
		dbo.f_GetTestProcedure(I.ID, dbo.f_GetFirstTestDate(I.ID)) as ServiceName,
		A.FirstName AS AttorneyFirstName,
		A.LastName AS AttorneyLastName,
		A.LastName + ', ' + A.FirstName AS AttorneyDisplayName,
		InvF.Name AS FirmName,
		InvP.FirstName AS PatientFirstName,
		InvP.LastName AS PatientLastName,
		InvP.LastName + ', ' + InvP.FirstName AS PatientDisplayName,
		dbo.f_GetTestCostTotal(I.ID) AS TotalCost,
		tis.InvoicePaymentTotal AS PaymentAmount,
	    dbo.f_GetTestPPODiscountTotal(I.ID) AS PPODiscount,
		tis.BalanceDue as BalanceDue,
		tis.CumulativeServiceFeeDue as ServiceFeeDue,
		tis.EndingBalance as EndingBalance,
		tis.BalanceDue + tis.CumulativeServiceFeeDue AS TotalDue,
		dbo.f_GetLastCommentFromInvoice(I.ID) As Comment,
		I.isComplete AS InvoiceCompleted,
		-- Change the DueDate(Maturity Date) to the first of the following month.
		-- This is done to match the maturity date of the invoice on the EditInvoice.aspx
	 	DateAdd(Month, 1, DateAdd(Month, DateDiff(Month, 0, tis.MaturityDate), 0)) As DueDate,
		co.LongName as CompanyName,
		tis.FirstTestDate as SortServiceDate,
		I.InvoiceStatusTypeID as StatusType,
		IsPastDue = case when DateAdd(Month, I.LoanTermMonths, dbo.f_GetFirstTestDate(I.ID)) <= Cast(@StatementDate as date) then 1 else 0 end
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		join Attorney A on IA.AttorneyID = A.ID 
		LEFT JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		JOIN InvoicePatient InvP ON InvP.ID=I.InvoicePatientID AND InvP.Active=1
		outer apply dbo.f_GetTestInvoiceSummaryTableMinified(I.ID, @StatementDate) tis
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE I.InvoiceStatusTypeID != @ClosedStatusTypeID 
		--AND I.isComplete = 1
		AND tis.BalanceDue > 0 -- CCW:  12/20/2012  Customer does not mark testing invoices as complete, instead placeholder value of $1.00 is updated to signify that this invoice needs to appear on receivables report
		AND I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @TestTypeID
		AND (@AttorneyId = -1 or A.ID = @AttorneyId)
		--AND @StartDate <= tis.MaturityDate AND tis.MaturityDate <= @EndDate
)
UNION
(
	SELECT
		'Procedure' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		CONVERT(varchar(1000),dbo.f_GetSurgeryDates(I.ID),1) AS [ServiceDate],
		(dbo.f_GetFirstSurgeryDate(I.ID) + I.ServiceFeeWaivedMonths) As DateServiceFeeBegins,
		dbo.f_GetSurgeryProvidersAbbrByInvoice(I.ID) AS Provider,
		dbo.f_GetSurgeryProcedures(I.ID) as ServiceName,
		A.FirstName AS AttorneyFirstName,
		A.LastName AS AttorneyLastName,
		A.LastName + ', ' + A.FirstName AS AttorneyName,
		InvF.Name AS FirmName,
		InvP.FirstName AS PatientFirstName,
		InvP.LastName AS PatientLastName,
		InvP.LastName + ', ' + InvP.FirstName As PatientName,
		dbo.f_GetSurgeryCostTotal(I.ID) AS TotalCost,
		sisum.InvoicePaymentTotal AS PaymentAmount,
		dbo.f_GetSurgeryPPODiscountTotal(I.ID) AS PPODiscount,
		sisum.BalanceDue as BalanceDue,
		sisum.CumulativeServiceFeeDue as ServiceFeeDue,
		sisum.BalanceDue + sisum.CumulativeServiceFeeDue as TotalDue,
		sisum.EndingBalance as EndingBalance,
		dbo.f_GetLastCommentFromInvoice(I.ID) As Comment,
		I.isComplete AS InvoiceCompleted,
		-- Change the DueDate(Maturity Date) to the first of the following month.
		-- This is done to match the maturity date of the invoice on the EditInvoice.aspx
	 	DateAdd(Month, 1, DateAdd(Month, DateDiff(Month, 0, sisum.MaturityDate), 0)) As DueDate,
		co.LongName as CompanyName,
		sisum.FirstSurgeryDate as SortServiceDate,
		I.InvoiceStatusTypeID as StatusType,
		IsPastDue = case when DateAdd(Month, I.LoanTermMonths, dbo.f_GetFirstSurgeryDate(I.ID)) <= Cast(@StatementDate as date) then 1 else 0 end
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		join Attorney A on IA.AttorneyID = A.ID 
		LEFT JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		JOIN InvoicePatient InvP ON InvP.ID=I.InvoicePatientID AND InvP.Active=1
		outer apply dbo.f_GetSurgeryInvoiceSummaryTableMinified(I.ID, @StatementDate) sisum
		LEFT JOIN Comments c ON I.ID = c.InvoiceID AND c.Active=1 AND c.isIncludedOnReports = 1
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE I.InvoiceStatusTypeID != @ClosedStatusTypeID AND I.isComplete = 1
		AND I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @SurgeryTypeID
		AND (@AttorneyId = -1 or A.ID = @AttorneyId)
		--AND @StartDate <= sisum.MaturityDate AND sisum.MaturityDate <= @EndDate
)

order by AttorneyDisplayName
end
else if @CompanyId = 2
begin
(
	SELECT
		'Test' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		dbo.f_GetTestDates(I.ID) AS [ServiceDate],
		(dbo.f_GetFirstTestDate(I.ID) + I.ServiceFeeWaivedMonths) AS DateServiceFeeBegins,
		dbo.f_GetTestProvidersAbbrByInvoice(I.ID) AS Provider,
		dbo.f_GetTestProcedures(I.ID) as ServiceName,
		A.FirstName AS AttorneyFirstName,
		A.LastName AS AttorneyLastName,
		A.LastName + ', ' + A.FirstName AS AttorneyDisplayName,
		InvF.Name AS FirmName,
		InvP.FirstName AS PatientFirstName,
		InvP.LastName AS PatientLastName,
		InvP.LastName + ', ' + InvP.FirstName AS PatientDisplayName,
		dbo.f_GetTestCostTotal(I.ID) AS TotalCost,
		tis.InvoicePaymentTotal AS PaymentAmount,
	    dbo.f_GetTestPPODiscountTotal(I.ID) AS PPODiscount,
		tis.BalanceDue as BalanceDue,
		tis.CumulativeServiceFeeDue as ServiceFeeDue,
		tis.EndingBalance as EndingBalance,
		tis.BalanceDue + tis.CumulativeServiceFeeDue AS TotalDue,
		dbo.f_GetLastCommentFromInvoice(I.ID) As Comment,
		I.isComplete AS InvoiceCompleted,
		tis.MaturityDate As DueDate,
		co.LongName as CompanyName,
		tis.FirstTestDate as SortServiceDate,
		I.InvoiceStatusTypeID as StatusType,
		IsPastDue = case when tis.MaturityDate < Cast(getdate() as date) and i.InvoiceStatusTypeID != 1 then 1 else 0 end
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		join Attorney A on IA.AttorneyID = A.ID 
		LEFT JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		JOIN InvoicePatient InvP ON InvP.ID=I.InvoicePatientID AND InvP.Active=1
		outer apply dbo.f_GetTestInvoiceSummaryTableMinified(I.ID, @StatementDate) tis
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE I.InvoiceStatusTypeID != @ClosedStatusTypeID 
		--AND I.isComplete = 1
		AND tis.BalanceDue > 0 -- CCW:  12/20/2012  Customer does not mark testing invoices as complete, instead placeholder value of $1.00 is updated to signify that this invoice needs to appear on receivables report
		AND I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @TestTypeID
		AND (@AttorneyId = -1 or A.ID = @AttorneyId)
		AND @StartDate <= tis.FirstTestDate AND tis.FirstTestDate <= @EndDate
)
UNION
(
	SELECT
		'Procedure' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		CONVERT(varchar(1000),dbo.f_GetSurgeryDates(I.ID),1) AS [ServiceDate],
		(dbo.f_GetFirstSurgeryDate(I.ID) + I.ServiceFeeWaivedMonths) As DateServiceFeeBegins,
		dbo.f_GetSurgeryProvidersAbbrByInvoice(I.ID) AS Provider,
		dbo.f_GetSurgeryProcedures(I.ID) as ServiceName,
		A.FirstName AS AttorneyFirstName,
		A.LastName AS AttorneyLastName,
		A.LastName + ', ' + A.FirstName AS AttorneyName,
		InvF.Name AS FirmName,
		InvP.FirstName AS PatientFirstName,
		InvP.LastName AS PatientLastName,
		InvP.LastName + ', ' + InvP.FirstName As PatientName,
		dbo.f_GetSurgeryCostTotal(I.ID) AS TotalCost,
		sisum.InvoicePaymentTotal AS PaymentAmount,
		dbo.f_GetSurgeryPPODiscountTotal(I.ID) AS PPODiscount,
		sisum.BalanceDue as BalanceDue,
		sisum.CumulativeServiceFeeDue as ServiceFeeDue,
		sisum.BalanceDue + sisum.CumulativeServiceFeeDue as TotalDue,
		sisum.EndingBalance as EndingBalance,
		dbo.f_GetLastCommentFromInvoice(I.ID) As Comment,
		I.isComplete AS InvoiceCompleted,
		sisum.MaturityDate As DueDate,
		co.LongName as CompanyName,
		sisum.FirstSurgeryDate as SortServiceDate,
		I.InvoiceStatusTypeID as StatusType,
		IsPastDue = case when sisum.MaturityDate < Cast(getdate() as date) and i.InvoiceStatusTypeID != 1 then 1 else 0 end
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		join Attorney A on IA.AttorneyID = A.ID 
		LEFT JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		JOIN InvoicePatient InvP ON InvP.ID=I.InvoicePatientID AND InvP.Active=1
		outer apply dbo.f_GetSurgeryInvoiceSummaryTableMinified(I.ID, @StatementDate) sisum
		LEFT JOIN Comments c ON I.ID = c.InvoiceID AND c.Active=1 AND c.isIncludedOnReports = 1
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE I.InvoiceStatusTypeID != @ClosedStatusTypeID AND I.isComplete = 1
		AND I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @SurgeryTypeID
		AND (@AttorneyId = -1 or A.ID = @AttorneyId)
		AND @StartDate <= sisum.FirstSurgeryDate AND sisum.FirstSurgeryDate <= @EndDate
)
order by AttorneyDisplayName
end

END
GO
PRINT N'Creating [dbo].[procUpdateInvoiceStatus]'
GO
-- =============================================
-- Author:		Bursavich, Andy
-- Create date: 2012.04.12
-- Description:	Sets Open Invoices that have passed their Maturity Date to Overdue
-- =============================================
CREATE PROCEDURE [dbo].[procUpdateInvoiceStatus]
	@RunDate DATE = null
AS
BEGIN

	SET NOCOUNT ON;

	IF @RunDate IS NULL
	SET @RunDate = GETDATE()
	
	DECLARE @OpenStatusTypeID INT = 1
	DECLARE @OverdueStatusTypeID INT = 3
	
	UPDATE Invoice
		SET Invoice.InvoiceStatusTypeID=@OverdueStatusTypeID
		WHERE Invoice.Active = 1
			AND Invoice.InvoiceStatusTypeID = @OpenStatusTypeID
			AND dbo.f_GetInvoiceMaturityDate(Invoice.ID, Invoice.InvoiceTypeID, Invoice.LoanTermMonths) < @RunDate
			AND dbo.f_GetInvoiceEndingBalance(Invoice.ID, Invoice.InvoiceTypeID, ISNULL(Invoice.CalculatedCumulativeIntrest, 0), ISNULL(Invoice.ServiceFeeWaived, 0), ISNULL(Invoice.LossesAmount, 0), NULL, NULL, NULL, NULL, NULL, NULL) > 0

END
GO
PRINT N'Creating [dbo].[procUpdateLoanInterest]'
GO
-- =============================================================================================
-- Author:		Andy Bursavich
-- Create date: 4.2.2012
-- Description:	Calculates monthly interest for invoices, logs basic information about their
-- states, and updates cumulative interest values
--
-- Updated: 9.27.2012 by Andy Bursavich
--          Added DateServiceFeeBeginsOverride
-- =============================================================================================
CREATE PROCEDURE [dbo].[procUpdateLoanInterest]
	@RunTime DATETIME = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @RunTime IS NULL
	SET @RunTime = GETDATE()

	DECLARE @Month DATE = CONVERT(DATE, CONVERT(CHAR(2), DATEPART(MONTH, @RunTime)) + '/1/' + CONVERT(CHAR(4), DATEPART(YEAR, @RunTime)))
	DECLARE @ClosedStatusTypeID INT = 2
	DECLARE @TestingInvoiceTypeID INT = 1
	DECLARE @InterestPaymentTypeID INT = 2

	-- create temporary table to store intermediate values and calculations
	DECLARE @TempInterestLog TABLE
	(
		Invoice_ID INT,
		YearlyInterest DECIMAL(18, 2),
		ServiceFeeWaivedMonths INT,
		AmortizationDate DATE,
		DateInterestBegins DATE,
		TotalCost DECIMAL(18, 2),
		TotalPPODiscount DECIMAL(18, 2),
		TotalAppliedPayments DECIMAL(18, 2),
		BalanceDue DECIMAL(18, 2),
		CalculatedInterest DECIMAL(18, 2),
		PreviousCumulativeInterest DECIMAL(18, 2),
		NewCumulativeInterest DECIMAL(18, 2)
	)

	-- insert records into the temp table for non-closed invoices that do not have interest calculation logs for the current month (or, technically, future months)
	INSERT INTO @TempInterestLog
		SELECT I.ID,
			I.YearlyInterest,
			I.ServiceFeeWaivedMonths,
			CASE WHEN I.InvoiceTypeID=@TestingInvoiceTypeID THEN dbo.f_GetFirstTestDate(I.ID) ELSE dbo.f_GetFirstSurgeryDate(I.ID) END, -- AmortizationDate
			NULL, -- DateInterestBegins
			ISNULL(CASE WHEN I.InvoiceTypeID=@TestingInvoiceTypeID THEN dbo.f_GetTestCostTotal(I.ID) ELSE dbo.f_GetSurgeryCostTotal(I.ID) END, 0), -- TotalCost
			ISNULL(CASE WHEN I.InvoiceTypeID=@TestingInvoiceTypeID THEN dbo.f_GetTestPPODiscountTotal(I.ID) ELSE dbo.f_GetSurgeryPPODiscountTotal(I.ID) END, 0), -- TotalPPODiscount
			0, -- TotalAppliedPayments
			0, -- BalanceDue
			0, -- CalculatedInterest
			I.CalculatedCumulativeIntrest, -- PreviousCumulativeInterest
			0 -- NewCumulativeInterest
		FROM Invoice I
		WHERE I.Active=1
			AND I.InvoiceStatusTypeID!=@ClosedStatusTypeID -- skip closed invoices
			AND NOT EXISTS (SELECT ID FROM InvoiceInterestCalculationLog L WHERE L.InvoiceID=I.ID AND L.DateAdded>=@Month)
	ORDER BY I.ID ASC
	
	--DELETE FROM @TempInterestLog
	--WHERE AmortizationDate IS NULL
	
	-- calculate the date that interest calculations begin for the invoices
	-- sum all of the payments applicable to the principal balance of the loan
	UPDATE @TempInterestLog
	SET DateInterestBegins = dbo.f_ServiceFeeBegins(AmortizationDate, ServiceFeeWaivedMonths),
		TotalAppliedPayments = ISNULL((SELECT SUM(P.Amount) FROM Payments P WHERE P.InvoiceID=Invoice_ID AND P.Active=1 AND P.PaymentTypeID!=@InterestPaymentTypeID AND P.DatePaid<@Month), 0)
	
	-- calculate the balance due
	UPDATE @TempInterestLog
	SET BalanceDue = TotalCost-TotalPPODiscount-TotalAppliedPayments
	
	-- calculate the interest accrued in the previous month
	UPDATE @TempInterestLog
	SET CalculatedInterest=BalanceDue*YearlyInterest/12
	WHERE DateInterestBegins<=@Month -- we passed the date where interest calculations begin for this invoice
		AND BalanceDue>0 -- the invoice has a positive balance
	
	-- calculate the new cumulative interest
	UPDATE @TempInterestLog
	SET NewCumulativeInterest=PreviousCumulativeInterest+CalculatedInterest
	
	-- update the Invoice table with the new cumulative interest values
	UPDATE Invoice
	SET CalculatedCumulativeIntrest=(SELECT T.NewCumulativeInterest FROM @TempInterestLog T WHERE ID=Invoice_ID)
	WHERE EXISTS (SELECT T.NewCumulativeInterest FROM @TempInterestLog T WHERE ID=Invoice_ID)

	-- log the calculations and updates
	INSERT INTO InvoiceInterestCalculationLog ( InvoiceID, YearlyInterest, ServiceFeeWaivedMOnths, AmortizationDate, DateInterestBegins, TotalCost, TotalPPODiscount, TotalAppliedPayments, BalanceDue, CalculatedInterest, PreviousCumulativeInterest, NewCumulativeInterest, DateAdded )
	SELECT T.Invoice_ID, T.YearlyInterest, T.ServiceFeeWaivedMonths, T.AmortizationDate, T.DateInterestBegins, T.TotalCost, T.TotalPPODiscount, T.TotalAppliedPayments, T.BalanceDue, T.CalculatedInterest, T.PreviousCumulativeInterest, T.NewCumulativeInterest, @RunTime
	FROM @TempInterestLog T

END
GO
PRINT N'Creating [dbo].[proc_DATAMIGRATIONProcess_BMM_SpecificInvoicesOnly]'
GO

CREATE PROCEDURE [dbo].[proc_DATAMIGRATIONProcess_BMM_SpecificInvoicesOnly]
	
	@DateTimeVal datetime
		
AS 


BEGIN

--IMPORTANT:  RUN MANUALLY before starting this sequence or invoice numbers will be off!!:  DISABLE TRIGGER t_Invoice_Insert_InvoiceNumber ON Invoice; n

-- Two Step Process Here to Remove payments in the event that any new ones have been entered since 

------------------- INSERTS TO ATTORNEY TABLE---------------------------------

Insert Into Attorney (CompanyID, ContactListID, isActivestatus, FirstName, LastName, Street1, Street2, City, StateID, ZipCode, Phone, Fax, Email, Notes, Temp_AttorneyID, DepositAmountRequired, Active, DateAdded)
Select 1, 16, 1, [Attorney First Name], [Attorney Last Name], [Attorney Address], '', [Attorney City], 19, [Attorney Zip], 
'(' + Left([ATTORNEY Phone], 3) + ') ' + Right(Left([ATTORNEY Phone], 6), 3) + '-' + Right([ATTORNEY Phone], 4), 
'(' + Left([ATTORNEY FAX], 3) + ') ' + Right(Left([ATTORNEY FAX], 6), 3) + '-' + Right([ATTORNEY FAX], 4),
 '', [Memo], [Attorney No], .10 as DepositAmountRequired, 1, --@DateTimeVal 
 '08/6/2013 5:00 PM' 
From [DATAMIGRATION_BMM_SHARED_Attorney_List] 
WHERE [DATAMIGRATION_BMM_SHARED_Attorney_List].[Attorney Last Name] is not null 
and [DATAMIGRATION_BMM_SHARED_Attorney_List].[Attorney First Name] is not null

	PRINT 'Attorney Insert:  Attorney Table'


Insert into ContactList (DateAdded, Temp_AttorneyID, Temp_CompanyID)
Select --@DateTimeVal 
'08/6/2013 5:00 PM', ID, 1  
from [Attorney]
Where Attorney.ContactListID = 16

	PRINT 'Attorney Insert:  ContactList Table'


Update Attorney
Set ContactListID =  ContactList.ID
From Attorney inner join ContactList on Attorney.ID = ContactList.Temp_AttorneyID
Where Attorney.ContactListID = 16
and Temp_CompanyID = 1
-- ContactListID is temporary to get records inserted initially
	
	
	PRINT 'Attorney Insert:  Attorney Table Update with ContactListID'
	
	PRINT '--ATTORNEY INSERT COMPLETE--'



-----------------INSERTS TO PROVIDER TABLE --(Surgery)----------------------------------

INSERT INTO Provider (CompanyID, ContactListID, isActiveStatus, Name, Street1, City, 
StateID, ZipCode, Phone, Fax, FacilityAbbreviation, DiscountPercentage, Active, MRICostTypeID, Temp_ProviderID, Temp_Type)
Select 1, 16, 1, 
IsNull(DATAMIGRATION_BMM_SURGERY_Providers.Name, 'No Name At Import'), 
Isnull(Address, '9191 Siegen Ln'),
IsNull(City, 'Baton Rouge'), 
isnull(States.ID, 19) ,
isnull(Zip, '70810'), 
isnull( '(' + Left([Phone], 3) + ') ' + Right(Left([Phone], 6), 3) + '-' + Right([Phone], 4), 'none'), 
 '(' + Left([FAX], 3) + ') ' + Right(Left([FAX], 6), 3) + '-' + Right([FAX], 4),
Abbrev, discount , 1, 1, DATAMIGRATION_BMM_SURGERY_Providers.provider, 'Surgery' as Temp_Type
 From DATAMIGRATION_BMM_SURGERY_Providers LEFT join States on DATAMIGRATION_BMM_SURGERY_Providers.State = States.Abbreviation

	PRINT 'Provider (Surgery) Insert:  Provider Table'


Insert Into ContactList (DateAdded, Temp_ProviderID, Temp_CompanyID)
Select '08/6/2013 5:00 PM' , ID, 1
from Provider
Where Provider.ContactListID = 16
and Provider.CompanyID = 1

	PRINT 'Provider (Surgery) Insert:  Contact  List'


Update Provider
Set ContactListID = ContactList.ID
From Provider inner join ContactList on Provider.ID = ContactList.Temp_ProviderID
Where Provider.ContactListID = 16
and Temp_CompanyID = 1

	PRINT 'Provider (Surgery) Insert:  Update of Provider Table with Contact List ID'
	PRINT '--PROVIDER SURGERY INSERT COMPLETE--'



-----------------INSERTS TO PROVIDER TABLE --(Tests)----------------------------------


INSERT INTO Provider (CompanyID, ContactListID, isActiveStatus, Name, Street1, City, 
StateID, ZipCode, Phone, Fax, FacilityAbbreviation, DiscountPercentage, Active, MRICostTypeID, Temp_ProviderID, Temp_Type)

Select 1, 16, 1, 
IsNull([Facility Name], 'No Name At Import'), 
Isnull([Facility Address], '9191 Siegen Ln'),
IsNull([Facility City], 'Baton Rouge'), 
isnull(States.ID, 19) ,
isnull([Facility Zip], '70810'), 
isnull( '(' + Left([Facility Phone], 3) + ') ' + Right(Left([Facility Phone], 6), 3) + '-' + Right([Facility Phone], 4), 'none'), 
 '(' + Left([Facility FAX], 3) + ') ' + Right(Left([Facility FAX], 6), 3) + '-' + Right([Facility FAX], 4),
FacilityAbbrev, discount , 1, 1, DATAMIGRATION_BMM_TEST_Provider_List.[Facility No], 'Test' as Temp_Type
 From DATAMIGRATION_BMM_TEST_Provider_List
 LEFT join States on 
 DATAMIGRATION_BMM_TEST_Provider_List.[Facility State]= States.Abbreviation 

	PRINT 'Provider (TEST) Insert:  Provider Table'


Insert Into ContactList (DateAdded, Temp_ProviderID, Temp_CompanyID)
Select --@DateTimeVal 
'08/6/2013 5:00 PM', ID, 1
from Provider
Where Provider.ContactListID = 16

	PRINT 'Provider (TEST) Insert:  Contact  List'


Update Provider
Set ContactListID = ContactList.ID
From Provider inner join ContactList on Provider.ID = ContactList.Temp_ProviderID
Where Provider.ContactListID = 16
and Provider.CompanyID = 1

	PRINT 'Provider (TEST) Insert:  Update of Provider Table with Contact List ID'
	PRINT '--PROVIDER TEST INSERT COMPLETE--'



-----------------INSERTS TO Physician TABLE --(Tests)----------------------------------


INSERT INTO Physician (CompanyID, ContactListID, isActiveStatus, FirstName, LastName, Street1, Street2, City, 
StateID, ZipCode, Phone, Fax,  Active, Notes, Temp_PhysicianID)

Select 1, 16, 1, 
IsNull([Physician First Name] , 'No Name At Import'),
IsNull([Physician Last Name]  , 'No Name At Import'),
 Isnull([Physician Address] , '9191 Siegen Ln'),
 Isnull([Physician Address2], ''),
IsNull([Physician City], 'Baton Rouge'), 
isnull(States.ID, 19) ,
isnull([Physician Zip] , '70810'), 
isnull( '(' + Left([Physician Phone], 3) + ') ' + Right(Left([Physician Phone], 6), 3) + '-' + Right([Physician Phone], 4), 'none'), 
 '(' + Left([Physician FAX], 3) + ') ' + Right(Left([Physician FAX], 6), 3) + '-' + Right([Physician FAX], 4),
1, Memo,
DATAMIGRATION_BMM_TEST_Physician_List.[Physician No]
 From DATAMIGRATION_BMM_TEST_Physician_List
 LEFT join States on 
 DATAMIGRATION_BMM_TEST_Physician_List.[Physician State]= States.Abbreviation 

	PRINT 'Physican (TEST) Insert:  Physican Table'
 
Insert Into ContactList (DateAdded, Temp_PhysicianID, Temp_CompanyID)
Select '08/6/2013 5:00 PM' , ID, 1
from Physician
Where Physician.ContactListID = 16
and Physician.CompanyID = 1

	PRINT 'Physican (TEST) Insert:  Contact  List'


Update Physician
Set ContactListID = ContactList.ID
From Physician inner join ContactList on Physician.ID = ContactList.Temp_PhysicianID
Where Physician.ContactListID = 16
and Physician.CompanyID = 1

	PRINT 'Physician (TEST) Insert:  Update of Physician Table with Contact List ID'
	PRINT '--Physician TEST INSERT COMPLETE--'


-------------------------- Insert into Patients (Surgery) ----------------------------
Insert Into Patient (CompanyID, isActiveStatus, FirstName, LastName, SSN, Street1, City, StateID, ZipCode, Phone, WorkPhone, DateOfBirth, Active, Temp_InvoiceID)
Select 1,1,[Client Name], [Client Last Name], SSN, [Client Address], [Client City], States.ID, isnull([Client Zip], 'none'), 
isnull([Client Phone], 'none'),
[Client WorkPhone],
IsNull([Client Date of Birth], '1/1/1900'), 1, [Invoice Number]
From DATAMIGRATION_BMM_SURGERY_BMM 
inner join States on DATAMIGRATION_BMM_SURGERY_BMM.[Client State] = States.Abbreviation
Where [DATAMIGRATION_BMM_SURGERY_BMM].[SSN] is not null
Group by [Client Name], [Client Last Name], SSN, [Client Address], [Client City], States.ID, [Client Zip], 
[Client Phone],
[Client WorkPhone],
[Client Date of Birth],
[Invoice Number]

		PRINT 'Patient SURGERY Insert:  Patient Table'

		PRINT '--Patient (Surgery) INSERT COMPLETE--'




-------------------------- Insert into Patients (TEST) ----------------------------
Insert Into Patient (CompanyID, isActiveStatus, FirstName, LastName, SSN, Street1, City, StateID, ZipCode, Phone, WorkPhone, DateOfBirth, Active, Temp_InvoiceID)
Select 1,1,[Client Name], [Client Last Name], 
isnull(SSN, '000000000'), 
isnull([Client Address], 'Not Provided'), 
isnull([Client City], 'none'), 
States.ID, isnull([Client Zip], 'none'), 
isnull([Client Phone], 'none'),
[Client WorkPhone],
IsNull([Client Date of Birth], '1/1/1900'), 1, [Invoice Number]
From DATAMIGRATION_BMM_TEST_BMM 
inner join States on DATAMIGRATION_BMM_TEST_BMM.[Client State] = States.Abbreviation
--Where [DATAMIGRATION_BMM_TEST_BMM].[SSN] is not null
Group by [Client Name], [Client Last Name], SSN, [Client Address], [Client City], States.ID, [Client Zip], 
[Client Phone],
[Client WorkPhone],
[Client Date of Birth],
[Invoice Number]


		PRINT 'Patient (Test) Insert:  Patient Table'


Insert Into PatientChangeLog (PatientID, UserID, InformationUpdated, Active, Temp_CompanyID)
Select ID, 84,-- TempUserID
 'Initial Import of Patient (Test) Information', 1, 1
From Patient Where Patient.Active = 1 and Patient.CompanyID = 1

		PRINT 'Patient Insert:  Patient Change Log (Test and Surgery)'
		PRINT '--Patient INSERT COMPLETE--'



------------------------- Insert Into InvoiceContactList (Attorney Info:  SURGERY)

Insert Into InvoiceContactList (Active, DateAdded, Temp_AttorneyID, Temp_Invoice, Temp_CompanyID)
Select 1, '08/6/2013 5:00 PM'
--@DateTimeVal
, [Attorney No], [Invoice Number], 1
From DATAMIGRATION_BMM_SURGERY_BMM

	PRINT '--Invoice Contact List (Attorney:  SURGERY) INSERT COMPLETE--'


------------------------- INSERT Into INvoiceContactList (Attorney Info:  TESTING)

Insert Into InvoiceContactList (Active, DateAdded, Temp_AttorneyID, Temp_Invoice, Temp_CompanyID)
Select 1, '08/6/2013 5:00 PM',
--@DateTimeVal, 
[Attorney No], [Invoice Number], 1
From DATAMIGRATION_BMM_TEST_BMM

	PRINT '--InvoiceContactList (Attorney:  TESTING) INSERT Complete--'
	


------------------------- INSERT Into INvoiceContactList (Provider Info:  TESTING)

Insert Into InvoiceContactList (Active, DateAdded, Temp_ProviderID, Temp_Invoice, Temp_CompanyID)
Select 1,  '08/6/2013 5:00 PM',
--@DateTimeVal,
 [Provider No] , [Invoice No], 1
From DATAMIGRATION_BMM_TEST_Test_List
Group By [Provider No], [Invoice No]


	PRINT '--InvoiceContactList (Provider: TESTING) INSERT Complete--'
	

------------------------- INSERT Into INvoiceContactList (Physician Info:  TESTING)

Insert Into InvoiceContactList (Active, DateAdded, Temp_PhysicianID, Temp_Invoice, Temp_CompanyID)
Select 1, '08/6/2013 5:00 PM', [Physician No], [Invoice Number], 1
From DATAMIGRATION_BMM_TEST_BMM

	PRINT '--InvoiceContactList (Physician:  TESTING) INSERT Complete--'

	


---------------------  INSERT Into InvoiceAttorney (SURGERY)

Insert Into InvoiceAttorney (AttorneyID, InvoiceContactListID, isActivestatus, FirstName, LastName,
Street1, Street2, City, StateID, ZipCode, Phone, Fax, Email, Notes, DiscountNotes, DepositAmountRequired, Active, DateAdded, 
Temp_InvoiceNumber, Temp_AttorneyID, Temp_CompanyID)

SELECT Attorney.ID, InvoiceContactList.ID, 1, Attorney.FirstName, Attorney.LastName,
Attorney.Street1, Attorney.Street2, Attorney.City, Attorney.StateID, Attorney.ZipCode,
Attorney.Phone, Attorney.Fax, Attorney.Email, Attorney.Notes, Attorney.DiscountNotes, Attorney.DepositAmountRequired,
Attorney.Active, Attorney.DateAdded, DataMigration_BMM_Surgery_BMM.[Invoice Number], Attorney.Temp_AttorneyID, 1
From DataMigration_BMM_Surgery_BMM 
inner join Attorney on DATAMIGRATION_BMM_SURGERY_BMM.[Attorney No] =
Attorney.Temp_AttorneyID 
inner join InvoiceContactList on InvoiceContactList.Temp_AttorneyID = Attorney.Temp_AttorneyID 
and InvoiceContactList.Temp_Invoice = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
and Attorney.CompanyID = 1

	PRINT '--Invoice Attorney INSERT COMPLETE--'


---------------------  INSERT Into InvoiceAttorney (TESTING)

Insert Into InvoiceAttorney (AttorneyID, InvoiceContactListID, isActivestatus, FirstName, LastName,
Street1, Street2, City, StateID, ZipCode, Phone, Fax, Email, Notes, DiscountNotes, DepositAmountRequired, Active, DateAdded, 
Temp_InvoiceNumber, Temp_AttorneyID, Temp_CompanyID)

SELECT Attorney.ID, InvoiceContactList.ID, 1, Attorney.FirstName, Attorney.LastName,
Attorney.Street1, Attorney.Street2, Attorney.City, Attorney.StateID, Attorney.ZipCode,
Attorney.Phone, Attorney.Fax, Attorney.Email, Attorney.Notes, Attorney.DiscountNotes, Attorney.DepositAmountRequired,
Attorney.Active, Attorney.DateAdded, DataMigration_BMM_TEST_BMM.[Invoice Number], Attorney.Temp_AttorneyID, 1
From DataMigration_BMM_TEST_BMM 
inner join Attorney on DATAMIGRATION_BMM_TEST_BMM.[Attorney No] =
Attorney.Temp_AttorneyID 
inner join InvoiceContactList on InvoiceContactList.Temp_AttorneyID = Attorney.Temp_AttorneyID 
and InvoiceContactList.Temp_Invoice = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number]
and Attorney.CompanyID = 1
and InvoiceContactList.Temp_CompanyID = 1




-----  insert into Invoice_Patient table (Surgery)

Insert Into InvoicePatient (PatientID, isActiveStatus, FirstName, LastName, SSN, Street1, Street2, City, StateID,
ZipCode, PHone, WorkPhone, DateofBirth, Active, DateAdded, Temp_CompanyID)

SELECT Patient.ID, 1, FirstName, LastName, Patient.SSN, Street1, Street2, City, StateID, 
ZipCode, Phone, WorkPhone, DateOfBirth, Active, DateAdded, 1
From Patient inner join DataMigration_BMM_SURGERY_BMM
on  Patient.Temp_InvoiceID = dbo.DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number] 
and CompanyID = 1

	PRINT '--INVOICE_PATIENT INSERT COMPLETE SURGERY--'


-----  insert into Invoice_Patient table (TESTING)

Insert Into InvoicePatient (PatientID, isActiveStatus, FirstName, LastName, SSN, Street1, Street2, City, StateID,
ZipCode, PHone, WorkPhone, DateofBirth, Active, DateAdded, Temp_CompanyID)

SELECT Patient.ID, 1, FirstName, LastName, Patient.SSN, Street1, Street2, City, StateID, 
ZipCode, Phone, WorkPhone, DateOfBirth, Active, DateAdded, 1
From Patient inner join DataMigration_BMM_TEST_BMM
on  Patient.Temp_InvoiceID = dbo.DATAMIGRATION_BMM_TEST_BMM.[Invoice Number] 
and CompanyID = 1


	PRINT '--INVOICE_PATIENT INSERT COMPLETE TESTS--'


--------------------------INSERT SurgeryInvoice


Insert Into SurgeryInvoice ( Active, DateAdded, Temp_InvoiceID, Temp_CompanyID)
Select 1, --@DateTimeVal 
'08/6/2013 5:00 PM', [Invoice Number], 1
From DATAMIGRATION_BMM_SURGERY_BMM

	PRINT '--SURGERYINVOICE INSERT COMPLETE--'


-----------------------  Insert TEST

-- only inserts new tests since last import

Insert Into Test (CompanyID, Name, Active, DateAdded)
Select 1, [Test Name] , 1, '08/6/2013 5:00 PM'
 --@DateTimeVal 
From DATAMIGRATION_BMM_TEST_TEST_List LEFT join Test on [Test Name] = [Name]
Where [Test Name] is not null 
and [Name] is null
Group By [Test Name]

Update Test 
Set Temp_TestTypeID = 1
Where (Test.Name Like '%IDET%'
or Test.Name Like '%Disk%'
or Test.Name Like '%Disc%'
or Test.Name Like '%ESI%'
or Test.Name Like '%Facet%'
or Test.Name Like '%Anesthesia'
or Test.Name Like '%Myelogram%'
or Test.Name Like '%Cervical%'
or Test.Name Like '%Rhizo%'
or Test.Name Like '%RF%'
or Test.Name Like '%Chiropractic%'
or Test.Name Like '%Injection%'
or Test.Name Like '%Evaluation%'
or test.Name Like '%treatment%'
or test.name Like '%MBB%'
or test.name Like '%Branch%'
or test.name Like '%TP%'
or test.name like '%ONB%'
or test.name like '%OCB%'
or test.name like '%Occipital%'
or test.name like '%eval%'
or test.name like '%Procedure%'
or test.name like '%Office%'
Or test.name like '%Visit%'
or test.name like '%Denervation%'
or test.name like '%SNRB%'
or test.name like '%Transfor%'
or test.name like '%Radio%'
or test.name like '%Arth%'
or test.name like '%Block%'
)
and CompanyID = 1

Update Test 
Set Temp_TestTypeID = 2 -- MRI
Where (Test.Name Like '%MRI%'
or Test.Name Like '%MIR%'
or Test.Name Like '%Lumbar%'
or Test.Name Like '%Cervical%'
or Test.Name Like '%Thoracic%'
or Test.Name Like '%complete%'
or Test.Name Like '%lumbar%')
and CompanyID = 1


Update Test 
Set Temp_TestTypeID = 3 -- OTHER
Where (Test.Name Like '%blood%'
or Test.Name Like '%work%'
or Test.Name Like '%dmx%'
or Test.Name Like '%sedation%'
or Test.Name Like '%urinalysis%'
or Test.Name Like '%fluor%'
or Test.Name Like '%fee%'
or Test.Name Like '%ems%'
or Test.Name Like '%sleep%'
or Test.Name Like '%study%'
or Test.Name Like '%no show%'
or Test.Name Like '%eeg%'
or test.Name Like '%24 hour%'
or test.name Like '%blood patch%'
or test.name Like '%ultra%'
or test.name Like '%radiology%'
or test.name like '%CT%'
or test.name like '%x-ray%'
or test.name like '%ray%'
or test.name like '%scan%'
or test.name like '%CAT%'
or test.name like '%Physical%'
Or test.name like '%Therapy%'
or test.name like '%Gadolinium%'
or test.name like '%FEE%'
or test.name like '%Contrast%'
or test.name like '%EMG%'
or test.name like '%NCV%'
or test.name like '%SSEP%'
or test.name like '%DEP%'
or test.name like '%MRA%'
or test.name like '%MR%'
or test.name like '%Angiogram%'
or test.name like '%Ultrasound%'
or test.name like '%Mammogram%'
or test.name like '%Medical Records%'
or Test.Name like '%left elbow%')
and CompanyID = 1
and Temp_TestTypeID is null

--and Temp_TestTypeID <> 1 and Temp_TestTypeID <> 2

	PRINT '--Updates to Test Name Complete--'


-------------------------INSERT InvoicePhysician (for TESTING)

Insert Into InvoicePhysician (PhysicianID, InvoiceContactListID, isActivestatus, FirstName, LastName,
Street1, Street2, City, StateID, ZipCode, Phone, Fax, EmailAddress, Notes, 
Active, DateAdded, Temp_InvoiceNumber, Temp_PhysicianID, Temp_CompanyID)

SELECT Physician.ID, InvoiceContactList.ID, 1, Physician.FirstName, Physician.LastName,
Physician.Street1, Physician.Street2, Physician.City, Physician.StateID, Physician.ZipCode,
Physician.Phone, Physician.Fax, Physician.EmailAddress, Physician.Notes, 
Physician.Active, Physician.DateAdded, DataMigration_BMM_TEST_BMM.[Invoice Number], PHysician.Temp_PhysicianID, 1
From DataMigration_BMM_TEST_BMM 
inner join Physician on DATAMIGRATION_BMM_TEST_BMM.[Physician No] =
Physician.Temp_PhysicianID 
inner join InvoiceContactList on InvoiceContactList.Temp_PhysicianID = Physician.Temp_PhysicianID 
and InvoiceContactList.Temp_Invoice = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number]
and Physician.CompanyID = 1
and InvoiceContactList.Temp_CompanyID = 1

--Select * From Test Where Temp_TestTypeID is null and CompanyID = 2

--------------------------INSERT TESTInvoice

Insert Into TestInvoice ( TestTypeID, Active, DateAdded, Temp_TestNo, Temp_InvoiceID, Temp_CompanyID)
Select Max(Test.Temp_TestTypeID), 1, '08/6/2013 5:00 PM',
--@DateTimeVal, 
Max(DATAMIGRATION_BMM_TEST_TEST_List.[Test No]), DATAMIGRATION_BMM_TEST_TEST_List.[Invoice No], 1 
from DATAMIGRATION_BMM_TEST_TEST_List inner join Test on Test.Name = DataMigration_BMM_TEst_Test_List.[Test Name]
and Test.CompanyID = 1
Group By DATAMIGRATION_BMM_TEST_TEST_List.[Invoice No] 
having MAX(Test.Temp_TestTypeID) is not null -- Needs to pull as an exception 
--AND DATAMIGRATION_BMM_TEST_TEST_List.[Invoice No] = 1711

--Select * From DATAMIGRATION_BMM_TEST_BMM Where [Invoice Number] = 8067 
--Select * From DATAMIGRATION_BMM_TEST_TEST_List Where [Invoice No] = 8067
--Select * From InvoicePhysician Where Temp_InvoiceNumber = 1714
	PRINT '--INSERT TEST INVOICE COMPLETE--'

--Select * From InvoiceContactList Where Temp_Invoice = 8067

--Where InvoiceContactList.Temp_ProviderID in (5074, 5075)	
	
Insert Into InvoiceProvider (InvoiceContactListID, ProviderID, isActiveStatus, 
Name, Street1, Street2, City, StateID, ZipCode, Phone, Fax, Email, 
Notes, FacilityAbbreviation, DiscountPercentage, MRICostTypeID, MRICostFlatRate, MRICostPercentage, 
DaysUntilPaymentDue, Deposits, Active, DateAdded, Temp_ProviderID, Temp_InvoiceID, Temp_CompanyID)

Select InvoiceContactList.ID, Provider.ID, Provider.isActiveStatus, 
Provider.Name, Provider.Street1, Provider.Street2, Provider.City, Provider.StateID, Provider.ZipCode, Provider.Phone, Provider.Fax, Provider.Email,
Provider.Notes, Provider.FacilityAbbreviation, Provider.DiscountPercentage, Provider.MRICostTypeID, Provider.MRICostFlatRate, Provider.MRICostPercentage,
Provider.DaysUntilPaymentDue, Provider.Deposits, Provider.Active, Provider.DateAdded, Provider.Temp_ProviderID, 
InvoiceContactList.Temp_Invoice, InvoiceContactList.Temp_CompanyID

From InvoiceContactList inner join Provider on InvoiceContactList.Temp_ProviderID = Provider.Temp_ProviderID 
inner join DATAMIGRATION_BMM_TEST_Test_List on InvoiceContactList.Temp_Invoice = DATAMIGRATION_BMM_TEST_TEST_List.[Invoice No] 
and DATAMIGRATION_BMM_TEST_Test_List.[Provider No] = InvoiceContactList.Temp_ProviderID

Where InvoiceContactList.Temp_CompanyID = 1
and Provider.CompanyID = 1
and Provider.Temp_Type = 'Test'
order by Temp_Invoice

--and InvoiceContactList.Temp_Invoice 
-- Stopped here 6/12/2013  too many providers iwthout invoice...
--Select * From Provider Where Temp_ProviderID = 121

--Select * From InvoiceContactList where Temp_ProviderID = 121 and Temp_CompanyID = 1

	PRINT '--INSERT INvoice Contact List:  Providers (TEST Invoice)'


----------------------- Convert Times in DATAMIGRATION_BMM_TEST_TEST_List TABLE ----

/*Select [Test time],  (LTRIM([Test Time])) + ' PM'
From DATAMIGRATION_BMM_TEST_TEST_List 
WHERE
Len(LTRIM([Test Time])) = 4
and (LTRIM([Test Time])) Not Like '%P%' 
and (LTRIM([Test Time])) Not Like '%A%' 
and LEFT((LTRIM([Test Time])), 1) Like '1%'
*/


----------------------- Insert TestInvoice_TEST
Delete From TestInvoice_Test where Temp_CompanyID = 1


Insert Into TestInvoice_Test (TestInvoiceID, TestID, InvoiceProviderID, Notes, TestDate, TestTime, NumberOfTests,
MRI, IsPositive, isCanceled, TestCost, PPODiscount, AmountToProvider, CalculateAmountToProvider, ProviderDueDate, 
DepositToProvider, AmountPaidToProvider, Date, CheckNumber, Active, DateAdded, Temp_InvoiceID, Temp_CompanyID) 

Select TESTInvoice.ID, 
Test.ID, 
InvoiceProvider.ID, 
'test', 
isnull(Convert(date, [Test Date]), '1/1/1900'), 
--ISNULL([TestTimeTIME], '11:59 PM'),
'8:00 PM',

[Number of Tests], 
ISNULL([MRI], 0), 
Case When [Test Results] = 'Negative' Then 0
When [Test Results] = 'Positive' Then 1
When [Test Results] = null then ''
End as IsPositive, 
Canceled, 
isnUll([Test Cost], 0), 
IsNull([PPO Discount], 0), 
IsNull([Amount Paid To Provider],0), 
IsNull([Amount Paid To Provider],0), 

Case When (Convert(date,[Amount Due To Provider Due Date])) is null Then '1/1/2099'
When (Convert(date,[Amount Due To Provider Due Date])) is not null Then (Convert(date,[Amount Due To Provider Due Date])) 
End [Amount Due To Provider Due Date],

[Amount Paid To Provider], 
[Amount Paid To Provider],  
Convert(date,[Amount Due To Provider Due Date]),
[Amount Paid To Provider Check No], 
1 as Active, 

--@DateTimeVal as DateAdded,
'08/6/2013 5:00 PM' as dateadded,
TESTInvoice.Temp_InvoiceID,
1 as Temp_CompanyID 

--Select * 
From TestInvoice inner join DATAMIGRATION_BMM_TEST_BMM 
on TestInvoice.Temp_InvoiceID = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number]

inner join DataMigration_BMM_TEST_TEST_List on DATAMIGRATION_BMM_TEST_BMM.[Invoice Number] 
= DATAMIGRATION_BMM_TEST_TEST_LIST.[Invoice No] 
inner join TEST on TEST.Name = DATAMIGRATION_BMM_TEST_TEST_List.[Test Name] 
--Where DATAMIGRATION_BMM_TEST_Test_List.[Invoice No] = 1002

inner join InvoiceProvider on DATAMIGRATION_BMM_TEST_TEST_List.[Invoice No] = InvoiceProvider.Temp_INvoiceID  
and DATAMIGRATION_BMM_TEST_TEST_List.[Provider no] = InvoiceProvider.Temp_ProviderID 

LEFT Join Temp_TestTimeValConversionTEXTToTime 
on DATAMIGRATION_BMM_TEST_TEST_LIST.[Test time] = Temp_TestTimeValConversionTEXTToTime.TestTimeTEXT  
Where TEST.CompanyID = 1 and 
TestInvoice.Temp_CompanyID = 1
and InvoiceProvider.Temp_CompanyID = 1
--and TestInvoice.Temp_InvoiceID = 1002
order by TestInvoice.Temp_InvoiceID

--Select * from INvoiceProvider Where InvoiceProvider.Temp_CompanyID = 1 and InvoiceProvider.Temp_InvoiceID = 1002
--Select * From DATAMIGRATION_BMM_TEST_Test_List Where [Invoice No] = 1002

--Select * From TestInvoice where Temp_InvoiceID = 1002
--and DATAMIGRATION_BMM_TEST_TEST_LIST.[Invoice No] = 1714


--Select * From InvoiceProvider Where Temp_InvoiceID = 1714

--Select [Invoice no] From DATAMIGRATION_BMM_TEST_TEST_LIST  
--Group by [Invoice No]
--order by [Invoice No]


--Select [Temp_InvoiceID] From TestInvoice
--Group By [Temp_InvoiceID] 
--order by Temp_InvoiceID


--Select * From DATAMIGRATION_BMM_TEST_TEST_LIST
--Where [Invoice No] = 1711

--and [Amount Due To Provider Due Date] is not null -- Add to Exceptions  12/19/2012:  Commenting Out for TEST Invoices Only Because Believed to be Culprit on why some test info is not populating on certain invoices.

 /*

Select * From InvoiceProvider Where Temp_InvoiceID = 8067
Select * From DATAMIGRATION_BMM_TEST Where Provider
Select * From DATAMIGRATION_BMM_TEST_TEST_List Where [Invoice No] = 8067
Select * From Test Where Test.Name = 'RADIOLOGY FEE' OR Test.Name = 'Cervical Spect Scan & X-rays'
Select * From TestINvoice_TEST Where TestINvoice_Test.Temp_InvoiceID = 8067
*/

/*
SELECT     Test.ID AS [Test.ID], Test.CompanyID, TestInvoice.ID AS [TestInvoice.iD], Test.Name AS [Test.Name], Provider.ID AS [Provider.ID]
FROM         DATAMIGRATION_BMM_TEST_BMM INNER JOIN
                      DATAMIGRATION_BMM_TEST_TEST_List ON DATAMIGRATION_BMM_TEST_BMM.[Invoice Number] = DATAMIGRATION_BMM_TEST_TEST_List.[Invoice No] INNER JOIN
                      Test ON DATAMIGRATION_BMM_TEST_TEST_List.[Test Name] = Test.Name INNER JOIN
                      TestInvoice ON DATAMIGRATION_BMM_TEST_BMM.[Invoice Number] = TestInvoice.Temp_InvoiceID INNER JOIN
                      Provider ON DATAMIGRATION_BMM_TEST_BMM.[Provider No] = Provider.Temp_ProviderID
WHERE     (Test.CompanyID = 2)

*/


-----------------------  InSERT Surgery

Insert Into Surgery (CompanyID, Name, Active, DateAdded)
Select 1, SurgeryType, 1,  '08/6/2013 5:00 PM'
--@DateTimeVal 
From DATAMIGRATION_BMM_SURGERY_BMM
where SurgeryType is not null
Group By SurgeryType




	PRINT '--SURGERY INSERT COMPLETE--'



----------------------- Insert SurgeryInvoice_Surgery

Insert Into SurgeryInvoice_Surgery (SurgeryInvoiceID, SurgeryID, isInpatient, Notes, Active, DateAdded, Temp_InvoiceID, Temp_CompanyID)
Select SurgeryInvoice.ID, Surgery.ID, DATAMIGRATION_BMM_SURGERY_BMM.inpatient, DATAMIGRATION_BMM_SURGERY_BMM.Notes,
1, '08/6/2013 5:00 PM',
--@DateTimeVal , 
SurgeryInvoice.Temp_InvoiceID, 1 

From SurgeryInvoice inner join DATAMIGRATION_BMM_SURGERY_BMM on SurgeryInvoice.Temp_InvoiceID = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
inner join Surgery on Surgery.Name = DATAMIGRATION_BMM_SURGERY_BMM.SurgeryType
Where Surgery.CompanyID = 1
and SurgeryInvoice.Temp_CompanyID = 1


	PRINT '--SURGERYINVOICE_SURGERY INSERT COMPLETE--'


------------------------ Insert SurgeryInvoice_SurgeryDates

Insert Into SurgeryInvoice_SurgeryDates (SurgeryInvoice_SurgeryID, ScheduledDate, isPrimaryDate, Active, DateAdded, Temp_CompanyID)
Select SurgeryInvoice_Surgery.ID, DATAMIGRATION_BMM_SURGERY_BMM.DateScheduled, 1, 1, '08/6/2013 5:00 PM',
--@DateTimeVal ,
 1 

From SurgeryInvoice inner join DATAMIGRATION_BMM_SURGERY_BMM on SurgeryInvoice.Temp_InvoiceID = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
inner join Surgery on Surgery.Name = DATAMIGRATION_BMM_SURGERY_BMM.SurgeryType
inner join SurgeryInvoice_Surgery on SurgeryInvoice_Surgery.SurgeryInvoiceID = SurgeryInvoice.ID
Where Surgery.CompanyID = 1
and SurgeryInvoice.Temp_CompanyID = 1
and DATEScheduled is not null

	PRINT '--SURGERYINVOICE_SURGERYDATES INSERT COMPLETE--'


-------------------------  Insert InvoiceContactList (provider info) SURGERY

insert into InvoiceContactList (Active, DateAdded, Temp_ProviderID, Temp_Invoice, Temp_CompanyID)
Select 1, '08/6/2013 5:00 PM' , Provider, DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number], 1  
from DATAMIGRATION_BMM_SURGERY_BMM inner join DATAMIGRATION_BMM_SURGERY_Services
on DATAMIGRATION_BMM_SURGERY_BMM.[invoice number] = DATAMIGRATION_BMM_SURGERY_Services.InvoiceNumber
--Where [Invoice Number] = 2883
Group By Provider, Provider, DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number] 

	PRINT '--INVOICECONTACTLIST TEST INSERT COMPLETE--'


-------------------------  Insert InvoiceContactList (provider info) TEST
/*

insert into InvoiceContactList (Active, DateAdded, Temp_ProviderID, Temp_Invoice, Temp_CompanyID)
Select 1, '10/10/2012 12:30 PM' , Provider, DATAMIGRATION_BMM_TEST_BMM.[Invoice Number], 2  
from DATAMIGRATION_BMM_TEST_BMM inner join DATAMIGRATION_BMM_TEST_Services
on DATAMIGRATION_BMM_TEST_BMM.[invoice number] = DATAMIGRATION_BMM_TEST_Services.InvoiceNumber
--Where [Invoice Number] = 2883
Group By Provider, Provider, DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number] 

	PRINT '--INVOICECONTACTLIST TEST INSERT COMPLETE--'
*/
-------------------------- Insert InvoiceProvider (Surgery) --------

Insert Into InvoiceProvider (InvoiceContactListID, ProviderID, isActiveStatus, Name, Street1, Street2, City, StateID, ZipCode, Phone, Fax, Email, Notes, FacilityAbbreviation, DiscountPercentage, MRICostTypeID, MRICostFlatRate, MRICostPercentage, DaysUntilPaymentDue, Deposits, Active, DateAdded, Temp_providerID, Temp_InvoiceID, Temp_CompanyID)
Select InvoiceContactList.ID as InvoiceContactListID, Provider.ID as ProviderID, 1 as isActiveStatus, Provider.Name, Provider.Street1, Provider.Street2, Provider.City, 
Provider.StateID, Provider.ZipCode, Provider.Phone, Provider.Fax, Provider.Email, Provider.Notes, Provider.FacilityAbbreviation, Provider.DiscountPercentage, Provider.MRICostTypeID, Provider.MRICostFlatRate, Provider.MRICostPercentage, Provider.DaysUntilPaymentDue, Provider.Deposits, Provider.Active, Provider.DateAdded, Provider.Temp_ProviderID, InvoiceContactList.Temp_Invoice, 1

From InvoiceContactList inner join dbo.Provider 
on InvoiceContactList.Temp_ProviderID = Provider.Temp_ProviderID 
Inner join DATAMIGRATION_BMM_SURGERY_BMM on 
InvoiceContactList.Temp_Invoice = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number] 
WHERE Provider.CompanyID = 1
and InvoiceContactList.Temp_CompanyID = 1
and Provider.Temp_Type = 'Surgery'

--WHERE Temp_Invoice = 2883

	PRINT '--INVOICEPROVIDER INSERT COMPLETE--'


--------------------------- Insert SurgeryInvoice_Providers ---------------------------

Insert Into SurgeryInvoice_Providers (SurgeryInvoiceID, InvoiceProviderID, Active, DateAdded, Temp_InvoiceID, Temp_ProviderID, Temp_CompanyID) 
Select SurgeryInvoice.ID, InvoiceProvider.ID, 1 as Active, '08/6/2013 5:00 PM',
--@DateTimeVal , 
InvoiceProvider.Temp_InvoiceID, InvoiceProvider.Temp_ProviderID, 1
From InvoiceProvider inner join SurgeryInvoice 
on InvoiceProvider.Temp_InvoiceID = SurgeryInvoice.Temp_InvoiceID
where InvoiceProvider.Temp_CompanyID = 1
and SurgeryInvoice.Temp_CompanyID = 1

--WHERE InvoiceProvider.Temp_InvoiceID = 2883
--Group By SurgeryInvoice.ID, InvoiceProvider.ID, InvoiceProvider.Temp_InvoiceID, InvoiceProvider.Temp_ProviderID 
/*
Select * From SurgeryInvoice
WHERE SurgeryInvoice.Temp_InvoiceID  = 8000

SELECT * From InvoiceProvider
WHERE InvoiceProvider.Temp_InvoiceID  = 8000
*/


	PRINT '--SURGERYINVOICE_PROVIDERS INSERT COMPLETE--'


--------------------------- Insert SurgeryInvoice_Provider_Services -------------------

/*Insert Into SurgeryInvoice_Provider_Services (SurgeryInvoice_ProviderID, EstimatedCost, Cost, 
Discount, PPODiscount, DueDate, AmountDue, AccountNumber, Active, DateAdded)

Select SurgeryInvoice_Providers.ID, DATAMIGRATION_BMM_SURGERY_SERVICES.Cost, 
DATAMIGRATION_BMM_SURGERY_SERVICES.Cost, 
1 - DATAMIGRATION_BMM_SURGERY_SERVICES.discount, 
(1 - DATAMIGRATION_BMM_SURGERY_SERVICES.discount) * DATAMIGRATION_BMM_SURGERY_Services.cost as PPODiscount, 
DATAMIGRATION_BMM_SURGERY_SERVICES.DueDate, 
DATAMIGRATION_BMM_SURGERY_SERVICES.AmountDue, '' as AccountNumber, 1, '9/25/2012 10:52 AM' 
From DATAMIGRATION_BMM_SURGERY_SERVICES inner join SurgeryInvoice_Providers  
on DATAMIGRATION_BMM_SURGERY_SERVICES.[InvoiceNumber] = SurgeryInvoice_Providers.Temp_InvoiceID
and DATAMIGRATION_BMM_SURGERY_Services.provider = SurgeryInvoice_Providers.Temp_ProviderID
*/

Insert Into SurgeryInvoice_Provider_Services (SurgeryInvoice_ProviderID, EstimatedCost, Cost, 
Discount, PPODiscount, DueDate, AmountDue, AccountNumber, Active, DateAdded, Temp_ServiceID, Temp_CompanyID)

--Select * From SurgeryInvoice_Providers
--Where SurgeryInvoice_Providers.Temp_InvoiceID = 2883

--Select * From DATAMIGRATION_BMM_SURGERY_Services
--Where [Invoicenumber] = 2883


Select SurgeryInvoice_Providers.ID, DATAMIGRATION_BMM_SURGERY_SERVICES.Cost, 
DATAMIGRATION_BMM_SURGERY_SERVICES.Cost, 
1 - DATAMIGRATION_BMM_SURGERY_SERVICES.discount,--<--Leaving as is until checked 
DATAMIGRATION_BMM_SURGERY_SERVICES.PPODiscount as PPODiscount, 
DATAMIGRATION_BMM_SURGERY_SERVICES.DueDate, 
DATAMIGRATION_BMM_SURGERY_SERVICES.AmountDue, '' as AccountNumber, 1,
-- @DateTimeVal , 
'08/6/2013 5:00 PM',
Temp_ServiceID, 1 
-- SELECT *

From DATAMIGRATION_BMM_SURGERY_SERVICES inner join SurgeryInvoice_Providers  
on DATAMIGRATION_BMM_SURGERY_SERVICES.[InvoiceNumber] = SurgeryInvoice_Providers.Temp_InvoiceID
and DATAMIGRATION_BMM_SURGERY_Services.provider = SurgeryInvoice_Providers.Temp_ProviderID

--WHERE SurgeryInvoice_Providers.Temp_InvoiceID = 2883
--order by DATAMIGRATION_BMM_SURGERY_SERVICES.Cost

Where SurgeryInvoice_Providers.Temp_CompanyID = 1

	PRINT '-- SURGERYINVOICE_PROVIDER_SERVICES INSERT COMPLETE--'


---------------------------Insert Surgery CPT Codes in the event not on disk -----------

Insert into CPTCodes (Active, Code, CompanyID, DateAdded, Description)

Select 1, CPtCode, 1, --@DateTimeVal, 
'08/6/2013 5:00 PM',
IsNull(Min(DATAMIGRATION_BMM_SURGERY_CPTCHARGES.[Description]), 'None Provided')
From DATAMIGRATION_BMM_SURGERY_CPTCharges left join CPTCodes 
on DATAMIGRATION_BMM_SURGERY_CPTCharges.cptcode  = CPTCodes.Code
WHERE CPTCodes.Code is null and Len(CPTCode) > 1
and CPTCodes.CompanyID = 1
Group By CPTCode

	PRINT '--CPTCODES INSERT COMPLETE--'


--------------------------- Insert SurgeryInvoice_Provider_CPTCode -------------------

--- NEED TO VERIFY THAT IMPORTED CPT CODES (from Disk) are not missing any codes that are currently in use in DATAMIGRATION_BMM_SURGERY_CPTCODES

Insert Into SurgeryInvoice_Provider_CPTCodes (SurgeryInvoice_ProviderID, CPTCodeID, Amount, Description, Active, DateAdded, Temp_CompanyID, Temp_InvoiceID)
Select SurgeryInvoice_Providers.ID, CPTCodes.ID, isnull(DATAMIGRATION_BMM_SURGERY_CPTCharges.Amount, 0), 

Case WHEN DATAMIGRATION_BMM_SURGERY_CPTCharges.Description is null then 'Not Provided'
WHEN  DATAMIGRATION_BMM_SURGERY_CPTCharges.Description is not null then DATAMIGRATION_BMM_SURGERY_CPTCharges.description
END
,
  1, --@DateTimeVal , 
  '08/6/2013 5:00 PM',1, DATAMIGRATION_BMM_SURGERY_CPTCharges.[Invoice Number]
--Select * 
From DATAMIGRATION_BMM_SURGERY_CPTCharges inner join SurgeryInvoice_Providers  
on DATAMIGRATION_BMM_SURGERY_CPTCharges.[Invoice Number] = SurgeryInvoice_Providers.Temp_InvoiceID
and DATAMIGRATION_BMM_SURGERY_CPTCharges.Provider = SurgeryInvoice_Providers.Temp_ProviderID
inner join CPTCodes on DATAMIGRATION_BMM_SURGERY_CPTCharges.CPTCode  = CPTCodes.Code 
Where CPTCodes.CompanyID = 1 
--and DATAMIGRATION_BMM_SURGERY_CPTCharges.[Invoice Number] = 5836
and SurgeryInvoice_Providers.Temp_CompanyID  = 1
order by Code



	PRINT '--SURGERYINVOICE_PROVIDER_CPTCODES INSERT COMPLETE--'



------------------- Insert Survery Invoice_Providers

/* ALREADY DONE ABOVE  Insert Into SurgeryInvoice_Providers (SurgeryInvoiceID, InvoiceProviderID, Active, DateAdded)

Select SurgeryInvoice_Surgery.ID, DATAMIGRATION_BMM_SURGERY_BMM.DateScheduled, 1, 1, '9/18/2012 3:07 PM' 
From SurgeryInvoice inner join DATAMIGRATION_BMM_SURGERY_BMM on 
SurgeryInvoice.Temp_InvoiceID = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
inner join Surgery on Surgery.Name = DATAMIGRATION_BMM_SURGERY_BMM.SurgeryType
inner join SurgeryInvoice_Surgery on SurgeryInvoice_Surgery.SurgeryInvoiceID = SurgeryInvoice.ID
Where Surgery.CompanyID = 2 */




--------------------------INSERT INTO Invoice Table (Surgery)


--DISABLE TRIGGER t_Invoice_Insert_InvoiceNumber ON Invoice; n

Insert Into Invoice (InvoiceNumber, CompanyID, DateOfAccident,InvoiceStatusTypeID, isComplete, --InvoicePhysicianID,
InvoiceAttorneyID, InvoicePatientID, InvoiceTypeID, --TestInvoiceID, 
SurgeryInvoiceID, InvoiceClosedDate,
DatePaid, ServiceFeeWaived, LossesAmount, YearlyInterest, LoanTermMonths, ServiceFeeWaivedMonths, 
CalculatedCumulativeIntrest, Active, DateAdded)

SELECT dbo.DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number] AS InvoiceNumber,
    1 AS CompanyID, 
    
    'DateOfAccident' = 
		Case When [Date Of Accident] = '1899-12-30' THEN
		'1/1/1900'
		When [Date Of Accident] is null THEN
		'1/1/1900'
		WHen [Date Of Accident] <> '1899-12-30' THEN
		[Date Of Accident]
		End,
    
    'InvoiceStatusTypeID' =  
		Case WHEN [Invoice Closed] = 1  or DatePaid is not null THEN 
		2
		WHEN ([Invoice Closed] = 0 or [Invoice Closed] is null) AND [BalanceDue] = 0  Or Cancelled = 1 THEN   
		2    
		WHEN ([Invoice Closed] = 0 or [Invoice Closed] IS NULL ) and [BalanceDue]  <> 0 and Cancelled <> 1  and GetDate() < [Invoice Date] + 390  THEN
		1
		WHEN ([Invoice Closed] = 0 or [Invoice Closed] IS NULL ) and [BalanceDue]  <> 0 and Cancelled <> 1  and GetDate() > [Invoice Date] + 390  THEN
		3    
		
		WHEN [Invoice Date] is null THEN
		1
		
	END,
        
	DATAMIGRATION_BMM_SURGERY_BMM.CompleteFile AS isComplete,
	--0 as INvoicePhysicianID,
	InvoiceAttorney.ID AS InvoiceAttorneyID,
	InvoicePatient.ID as InvoicePatientID,
	2 as InvoiceTypeID, -- For Surgery
	--0 as TestINvoiceID,
	SurgeryInvoice.ID as SurgeryInvoiceID,
	[Invoice Closed Date] as InvoiceClosedDate,
	DatePaid as DatePaid,
	ServiceFeeWaived as ServiceFeeWaived,
	LossesAmount as LossesAmount,
	.15 as YearlyInterest,  11 as LoanTermMonths, -- shouldbestatic per spec (normally pulls from admin pages)
isNull(DATEDIFF(Month, DATAMIGRATION_BMM_SURGERY_BMM.DateScheduled, [dateservicefeebegins]), 0) as ServiceFeeWaivedMonths,-- should be static (pulls from admin page)

'CalculatedCumulativeIntrest' = 
	Case When [interestdue] is null Then
		IsNull((Select Sum(Amount) From DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney 
		WHERE  DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney.[Invoice Number] = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
		and PaymentType = 'Interest'), 0) + ISNULL(ServiceFeeWaived,0)

		When [interestdue] = 0 Then
		IsNull((Select Sum(Amount) From DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney 
		WHERE  DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney.[Invoice Number] = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
		and PaymentType = 'Interest'), 0) + ISNULL(ServiceFeeWaived,0)
		WHEN [interestdue] > 0.01 Then
		isnull([InterestDue], 0) + IsNull((Select Sum(Amount) From DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney WHERE  DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney.[Invoice Number] = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
		and PaymentType = 'Interest'), 0)  - IsNull(ServiceFeeWaived, 0)
	End,

--(Select Sum(Amount) From Payments Where Temp_InvoiceID = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]and PaymentTypeID = 2) as TotalInterestPaid, 
--Note:  Old Data for Surgeries does not appear to keep the cumulative interest once it has been paid.  Therefore for import, if the Cumulative value = 0, we have to backwards calculate what the total interest 'was' before it was paid off to keep the records in check

	'Active' = 1,
	DATAMIGRATION_BMM_SURGERY_BMM.[DateScheduled] as DateAdded
	--Select *
	FROM dbo.DATAMIGRATION_BMM_SURGERY_BMM 
	INNER JOIN
	dbo.Attorney ON 
	dbo.DATAMIGRATION_BMM_SURGERY_BMM.[Attorney No] = dbo.Attorney.Temp_AttorneyID
	inner join Patient on Patient.Temp_InvoiceID = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
	inner join InvoicePatient on InvoicePatient.PatientID = Patient.ID
	inner join DATAMIGRATION_BMM_SHARED_Attorney_List on DATAMIGRATION_BMM_SHARED_Attorney_List.[Attorney No] = DATAMIGRATION_BMM_SURGERY_BMM.[Attorney No]
	inner join InvoiceAttorney on InvoiceAttorney.Temp_InvoiceNumber = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
	and InvoiceAttorney.Temp_AttorneyID = DATAMIGRATION_BMM_SURGERY_BMM.[Attorney No]
	inner join SurgeryInvoice on SurgeryInvoice.Temp_InvoiceID = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
	LEFT Join DATAMIGRATION_BMM_Surgery_CalcTestListTemp 
	on DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number] = DATAMIGRATION_BMM_SUrgery_CalcTestListTemp.InvoiceNumber
	
	Where DATAMIGRATION_BMM_SURGERY_BMM.[DateScheduled] is not null 
	and Attorney.CompanyID = 1
	and Patient.CompanyID = 1
	and InvoicePatient.Temp_CompanyID = 1
	and InvoiceAttorney.Temp_CompanyID =1
	and SurgeryInvoice.Temp_CompanyID = 1
	and DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number] <>  2814  ---- problem here had to exclude this one because was giving null CalcCumINterest

	order by DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]
	


	PRINT '--SURGERY INVOICE INSERT COMPLETE--'



--------------------------INSERT INTO Invoice Table (Testing)


--DISABLE TRIGGER t_Invoice_Insert_InvoiceNumber ON Invoice; n

Insert Into Invoice (InvoiceNumber, CompanyID, DateOfAccident,InvoiceStatusTypeID, isComplete, InvoicePhysicianID,
InvoiceAttorneyID, InvoicePatientID, InvoiceTypeID, TestInvoiceID, InvoiceClosedDate,
DatePaid, ServiceFeeWaived, LossesAmount, YearlyInterest, LoanTermMonths, ServiceFeeWaivedMonths, 
CalculatedCumulativeIntrest, Active, DateAdded)

SELECT dbo.DATAMIGRATION_BMM_TEST_BMM.[Invoice Number] AS InvoiceNumber,
    1 AS CompanyID, 
    
    'DateOfAccident' = 
		Case When [Date Of Accident] = '1899-12-30' THEN
		'1/1/1900'
		When [Date Of Accident] is null THEN
		'1/1/1900'
		WHen [Date Of Accident] <> '1899-12-30' THEN
		[Date Of Accident]
		End,
    
    'InvoiceStatusTypeID' =  
		Case WHEN [Invoice Closed] = 1  or DatePaid is not null THEN 
		2
		WHEN ([Invoice Closed] = 0 or [Invoice Closed] is null) AND [BalanceDue] = 0  THEN   
		2    
		
		WHEN ([Invoice Closed] = 0 or [Invoice Closed] IS NULL ) and [BalanceDue]  <> 0   and (GetDate() < [Invoice Date] + 390 or [Invoice Date] is null) THEN  
		1
	
		WHEN ([Invoice Closed] = 0 or [Invoice Closed] IS NULL ) and [BalanceDue]  <> 0  and GetDate() > [Invoice Date] + 390  THEN
		3    
	END,
        
	DATAMIGRATION_BMM_TEST_BMM.CompleteFile AS isComplete,
	InvoicePhysician.ID as InvoicePhysicianID,
	InvoiceAttorney.ID AS InvoiceAttorneyID,
	InvoicePatient.ID as InvoicePatientID,
	1 as InvoiceTypeID, -- For TEST
	--0 as TestINvoiceID,
	TestInvoice.ID as TestInvoiceID,
	[Invoice Closed Date] as InvoiceClosedDate,
	DatePaid as DatePaid,
	ServiceFeeWaived as ServiceFeeWaived,
	LossesAmount as LossesAmount,
	.15 as YearlyInterest,  11 as LoanTermMonths, -- shouldbestatic per spec (normally pulls from admin pages)
isNull(DATEDIFF(Month, DATAMIGRATION_BMM_TEST_BMM.AmortizationDate, [dateservicefeebegins]), 0) as ServiceFeeWaivedMonths,-- should be static (pulls from admin page)

'CalculatedCumulativeIntrest' = 
	Case When [interestdue] is null Then
		IsNull((Select Sum(Amount) From DATAMIGRATION_BMM_TEST_Payments 
		WHERE  DATAMIGRATION_BMM_TEST_Payments.[Invoice No] = DATAMIGRATION_BMM_Test_BMM.[Invoice Number]
		and [Payment Type] = 'Interest'), 0) + ISNULL(ServiceFeeWaived,0)

		When [interestdue] = 0 Then
		IsNull((Select Sum(Amount) From DATAMIGRATION_BMM_TEST_Payments 
		WHERE  DATAMIGRATION_BMM_TEST_Payments.[Invoice No] = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number]
		and [Payment Type] = 'Interest'), 0) + ISNULL(ServiceFeeWaived,0)
		WHEN [interestdue] > 0.01 Then
		isnull([InterestDue], 0) + IsNull((Select Sum(Amount) From DATAMIGRATION_BMM_TEST_Payments WHERE  
		DATAMIGRATION_BMM_TEST_Payments.[Invoice No]  = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number]
		and [Payment Type] = 'Interest'), 0)  - IsNull(ServiceFeeWaived, 0)
	End,

--(Select Sum(Amount) From Payments Where Temp_InvoiceID = DATAMIGRATION_BMM_SURGERY_BMM.[Invoice Number]and PaymentTypeID = 2) as TotalInterestPaid, 
--Note:  Old Data for Surgeries does not appear to keep the cumulative interest once it has been paid.  Therefore for import, if the Cumulative value = 0, we have to backwards calculate what the total interest 'was' before it was paid off to keep the records in check

	'Active' = 1,
	--@DaateTimeVal
	'08/6/2013 5:00 PM' 
	as DateAdded  -- Should be DateScheduled but needs to pull from test detail [Test Date]]
	--Select *
	FROM dbo.DATAMIGRATION_BMM_TEST_BMM 
	INNER JOIN
	dbo.Attorney ON 
	dbo.DATAMIGRATION_BMM_TEST_BMM.[Attorney No] = dbo.Attorney.Temp_AttorneyID
	inner join Patient on Patient.Temp_InvoiceID = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number]
	inner join InvoicePatient on InvoicePatient.PatientID = Patient.ID
	inner join DATAMIGRATION_BMM_SHARED_Attorney_List on DATAMIGRATION_BMM_SHARED_Attorney_List.[Attorney No] 
	= DATAMIGRATION_BMM_TEST_BMM.[Attorney No]
	inner join InvoiceAttorney on InvoiceAttorney.Temp_InvoiceNumber = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number] 
	and InvoiceAttorney.Temp_AttorneyID = DATAMIGRATION_BMM_TEST_BMM.[Attorney No]
	inner join InvoicePhysician on InvoicePhysician.Temp_InvoiceNumber = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number]
	and InvoicePhysician.Temp_PhysicianID = DATAMIGRATION_BMM_TEST_BMM.[Physician No] 
	inner join TestInvoice on TestInvoice.Temp_InvoiceID = DATAMIGRATION_BMM_TEST_BMM.[Invoice Number]
	LEFT Join DATAMIGRATION_BMM_SURGERY_CalcTestListTemp 
	on DATAMIGRATION_BMM_TEST_BMM.[Invoice Number] = DATAMIGRATION_BMM_SURGERY_CalcTestListTemp.InvoiceNumber
	
	Where Patient.CompanyID =1
	and Attorney.CompanyID = 1
	and InvoicePatient.Temp_CompanyID = 1
	and InvoiceAttorney.Temp_CompanyID = 1
	and InvoicePhysician.Temp_CompanyID = 1
	and TestInvoice.Temp_CompanyID =1

--ENABLE TRIGGER t_Invoice_Insert_InvoiceNumber ON Invoice;
	PRINT '--INVOICE INSERT TESTS COMPLETE--'



----------------------------------- insert into Payments (SURGERY)---------------

Insert Into Payments (InvoiceID, PaymentTypeID, DatePaid, Amount, CheckNumber, Active, DateAdded, Temp_CompanyID, Temp_InvoiceID)
Select Invoice.ID, PaymentType.ID, DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney.DatePaid, amount, 
DATAMIGRATION_BMM_SURGERY_PAYMENTSBYAttorney.[check], 
1, '08/6/2013 5:00 PM' 
--@DateTimeVal
 , 1, [invoice number]  
From DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney inner join PaymentType on DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney.PaymentType = PaymentType.Name 
inner join Invoice on DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney.[Invoice Number] = Invoice.InvoiceNumber
where Invoice.CompanyID = 1

	PRINT '--PAYMENTS INSERT COMPLETE--'
		

----------------------------------- insert into Payments (TESTS)---------------

Insert Into Payments (InvoiceID, PaymentTypeID, DatePaid, Amount, CheckNumber, Active, DateAdded, Temp_CompanyID, Temp_InvoiceID)
Select Invoice.ID, PaymentType.ID, isnull(DATAMIGRATION_BMM_TEST_Payments.[Date Paid], '1/1/1900'), isnull(amount, 0), 
isnull(DATAMIGRATION_BMM_TEST_Payments.[check no], 0), 
1, '08/6/2013 5:00 PM'
--@DateTimeVal
 , 1, [invoice no]  
From DATAMIGRATION_BMM_TEST_Payments inner join PaymentType on DATAMIGRATION_BMM_TEST_Payments.[Payment Type] = PaymentType.Name 
inner join Invoice on DATAMIGRATION_BMM_TEST_Payments.[Invoice No] = Invoice.InvoiceNumber
Where Invoice.CompanyID = 1

	PRINT '--PAYMENTS INSERT COMPLETE--'


------------------------------------ insert into SurgeryInvoice_Provider_Payments

Insert into SurgeryInvoice_Provider_Payments (SurgeryInvoice_ProviderID, PaymentTypeID, DatePaid, Amount, CheckNumber, Active, DateAdded, Temp_CompanyID)
Select SurgeryInvoice_Providers.ID, Paymenttype.ID , DatePaid, Amount, isnull(DATAMIGRATION_BMM_SURGERY_PaymentsToProviders.[Check], '0000'),  
1, '08/6/2013 5:00 PM'
--@DateTimeVal
, 1 
From SurgeryInvoice_Providers inner join DATAMIGRATION_BMM_SURGERY_PaymentsToProviders 
on DATAMIGRATION_BMM_SURGERY_PaymentsToProviders.[Invoice Number] = SurgeryInvoice_Providers.Temp_InvoiceID and
DATAMIGRATION_BMM_SURGERY_PaymentsToProviders.provider = SurgeryInvoice_Providers.Temp_ProviderID
inner join PaymentType on DATAMIGRATION_BMM_SURGERY_PaymentsToProviders.PaymentType = PaymentType.Name 
Where DatePaid is not null and SurgeryInvoice_Providers.Temp_CompanyID = 1 

	PRINT '--SURGERYINVOICE_PROVIDER_PAYMENTS INSERT COMPLETE--'



--Select * From Invoice Where InvoiceNumber = 8024

-- WHERE IS TESTING Provider Payment Info???

------------------------------------ STARTS Patient Record Consolidation Process ----------------------------------------------
--Select * From Invoice

Update  Patient 
Set SSN = '000000000'
Where LEN(SSN) < 3
and CompanyID = 1

Update Patient
Set  SSN = REPLACE(ssn, '-', '')
Where SSN Like '%-%'
and CompanyID = 1

--- Complete Four Times:  Time 1 of 4

Delete From Temp_PatientrecordConsolidation

Insert Into Temp_PatientrecordConsolidation (Original_PatientID, Temp_InvoiceID, New_PatientID, FirstName, LastName, SSN)
Select Min(ID), Min(Temp_InvoiceID), Max(ID), FirstName, LastName, SSN 
From Patient
where Active = 1 and CompanyID = 1
Group By FirstName, LastName, SSN


Update InvoicePatient
Set PatientID = New_PatientID
From InvoicePatient Inner Join Temp_PatientRecordConsolidation on InvoicePatient.PatientID = Temp_PatientRecordConsolidation.Original_PatientID
Where Temp_CompanyID = 1

Update Patient
Set Active = 0
From Patient inner join Temp_PatientRecordConsolidation On Patient.ID = Temp_PatientRecordConsolidation.Original_PatientID
Where Original_PatientID <> New_PatientID
and CompanyID = 1

--- Complete Four Times:  Time 2 of 4

Delete From Temp_PatientrecordConsolidation

Insert Into Temp_PatientrecordConsolidation (Original_PatientID, Temp_InvoiceID, New_PatientID, FirstName, LastName, SSN)
Select Min(ID), Min(Temp_InvoiceID), Max(ID), FirstName, LastName, SSN 
From Patient
where Active = 1 and CompanyID = 1
Group By FirstName, LastName, SSN


Update InvoicePatient
Set PatientID = New_PatientID
From InvoicePatient Inner Join Temp_PatientRecordConsolidation on InvoicePatient.PatientID = Temp_PatientRecordConsolidation.Original_PatientID
WHere Temp_CompanyID = 1

Update Patient
Set Active = 0
From Patient inner join Temp_PatientRecordConsolidation On Patient.ID = Temp_PatientRecordConsolidation.Original_PatientID
Where Original_PatientID <> New_PatientID
and CompanyID = 1

--- Complete Four Times:  Time 3 of 4

Delete From Temp_PatientrecordConsolidation

Insert Into Temp_PatientrecordConsolidation (Original_PatientID, Temp_InvoiceID, New_PatientID, FirstName, LastName, SSN)
Select Min(ID), Min(Temp_InvoiceID), Max(ID), FirstName, LastName, SSN 
From Patient
where Active = 1 and CompanyID = 1
Group By FirstName, LastName, SSN


Update InvoicePatient
Set PatientID = New_PatientID
From InvoicePatient Inner Join Temp_PatientRecordConsolidation on InvoicePatient.PatientID = Temp_PatientRecordConsolidation.Original_PatientID
WHERE Temp_CompanyID = 1


Update Patient
Set Active = 0
From Patient inner join Temp_PatientRecordConsolidation On Patient.ID = Temp_PatientRecordConsolidation.Original_PatientID
Where Original_PatientID <> New_PatientID
and CompanyID = 1


--- Complete Four Times:  Time 4 of 4

Delete From Temp_PatientrecordConsolidation

Insert Into Temp_PatientrecordConsolidation (Original_PatientID, Temp_InvoiceID, New_PatientID, FirstName, LastName, SSN)
Select Min(ID), Min(Temp_InvoiceID), Max(ID), FirstName, LastName, SSN 
From Patient
where Active = 1 and CompanyID = 1
Group By FirstName, LastName, SSN


Update InvoicePatient
Set PatientID = New_PatientID
From InvoicePatient Inner Join Temp_PatientRecordConsolidation on InvoicePatient.PatientID = Temp_PatientRecordConsolidation.Original_PatientID
Where InvoicePatient.Temp_CompanyID = 1

Update Patient
Set Active = 0
From Patient inner join Temp_PatientRecordConsolidation On Patient.ID = Temp_PatientRecordConsolidation.Original_PatientID
Where Original_PatientID <> New_PatientID
and CompanyID = 1

-- IMPORTANT:  NEED TO RUN this items below MANUALLY!!! Does not work in a stored proc..

--ENABLE TRIGGER t_Invoice_Insert_InvoiceNumber ON Invoice

END


GO
PRINT N'Creating [dbo].[f_GetSurgeryInvoiceStrings]'
GO
CREATE FUNCTION [dbo].[f_GetSurgeryInvoiceStrings] 
(
	@InvoiceID int
)
RETURNS 
@InvoiceSummary TABLE (ServiceDates varchar(1000), Providers varchar(1000), ServiceNames varchar(1000))
AS
BEGIN

-- Declare the return variable here
	DECLARE @Result varchar(1000)

-------------------------Intial Load
INSERT INTO @InvoiceSummary
	SELECT CONVERT(varchar(1000),'',1),
	dbo.f_GetSurgeryProvidersByInvoice(@InvoiceID),
	dbo.f_GetSurgeryProcedures(@InvoiceID)

	RETURN 
END
GO
PRINT N'Creating [dbo].[f_GetFirstTestDateAccountsPayableReport]'
GO
-- =============================================
-- Author:		Brad Conley
-- Create date: 2/17/2014
-- Description:	-- case 1006403 Added the TestInvoice_Test ID parameter to allow for multiple tests on the same invoice with different test dates
-- =============================================
CREATE FUNCTION [dbo].[f_GetFirstTestDateAccountsPayableReport] 
(
	-- Add the parameters for the function here
	@InvoiceID int,
	@TestInvoiceID int
)
RETURNS datetime
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result datetime

	-- Add the T-SQL statements to compute the return value here
	SELECT TOP 1 @Result = TIT.TestDate
	FROM Invoice I
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
		LEFT JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1 AND TIT.ID = @TestInvoiceID			
	WHERE I.ID = @InvoiceID
	ORDER BY TIT.TestDate Asc

	-- Return the result of the function
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[f_GetSurgeryPaymentsToProvider]'
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 6/21/2012
-- Description:	Gets the sum of the payments to provider for an invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetSurgeryPaymentsToProvider] 
(
	-- Add the parameters for the function here
	@InvoiceID int
)
RETURNS decimal(18,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result decimal(18,2)

	SELECT @Result = ISNULL(SUM(SIPP.Amount), 0)
		FROM Invoice I 
			JOIN SurgeryInvoice SI ON SI.ID=I.SurgeryInvoiceID AND SI.Active=1
				JOIN SurgeryInvoice_Providers SIP ON SIP.SurgeryInvoiceID=SI.ID AND SIP.Active=1
					JOIN SurgeryInvoice_Provider_Payments SIPP ON SIPP.SurgeryInvoice_ProviderID=SIP.ID
		WHERE I.ID = @InvoiceID
	
	-- Return the result of the function
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[DATAMIGRATION_DMA_TEST_TEST_LIST]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_DMA_TEST_TEST_LIST]
(
[Test No] [int] NOT NULL IDENTITY(1, 1),
[Invoice No] [int] NULL,
[Test Name] [nvarchar] (100) NULL,
[Test Date] [datetime] NULL,
[Test Time] [nvarchar] (5) NULL,
[Test Results] [nvarchar] (50) NULL,
[Test Deposit] [float] NULL,
[Interest Waived] [float] NULL,
[Losses Amount] [float] NULL,
[Payment Plan] [int] NULL,
[Canceled] [bit] NULL,
[Test Cost] [float] NULL,
[Provider No] [int] NULL,
[Deposit From Attorney] [float] NULL,
[Amount Due To Provider Due Date] [datetime] NULL,
[Amount Paid To Provider] [float] NULL,
[Amount Paid To Provider Date] [datetime] NULL,
[Amount Paid To Provider Check No] [nvarchar] (50) NULL,
[Number of Tests] [int] NULL,
[MRI] [int] NULL,
[PPO Discount] [float] NULL,
[AmountDueToFacility] [float] NULL
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_DMA_TEST_Provider_List]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_DMA_TEST_Provider_List]
(
[Facility No] [int] NULL,
[Facility Name] [nvarchar] (50) NULL,
[Facility Address] [nvarchar] (50) NULL,
[Facility City] [nvarchar] (50) NULL,
[Facility State] [nvarchar] (50) NULL,
[Facility Zip] [nvarchar] (50) NULL,
[Facility Phone] [nvarchar] (50) NULL,
[Facility Fax] [nvarchar] (50) NULL,
[Contact] [nvarchar] (50) NULL,
[Memo] [ntext] NULL,
[Discount] [float] NULL,
[PPO deposit] [int] NULL,
[FacilityAbbrev] [nvarchar] (50) NULL
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_DMA_TEST_Physician_List]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_DMA_TEST_Physician_List]
(
[Physician No] [int] NULL,
[Physician First Name] [nvarchar] (50) NULL,
[Physician Last Name] [nvarchar] (50) NULL,
[Physician Address] [nvarchar] (50) NULL,
[Physician Address2] [nvarchar] (50) NULL,
[Physician City] [nvarchar] (50) NULL,
[Physician State] [nvarchar] (50) NULL,
[Physician Zip] [nvarchar] (50) NULL,
[Physician Phone] [nvarchar] (50) NULL,
[Physician Fax] [nvarchar] (50) NULL,
[Memo] [ntext] NULL,
[Contact] [nvarchar] (50) NULL
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_DMA_TEST_Payments]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_DMA_TEST_Payments]
(
[Invoice No] [int] NULL,
[Date Paid] [datetime] NULL,
[Amount] [float] NULL,
[Payment Type] [nvarchar] (10) NULL,
[Check No] [nvarchar] (10) NULL
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_DMA_TEST_DMA]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_DMA_TEST_DMA]
(
[Invoice Number] [int] NULL,
[Invoice Date] [datetime] NULL,
[Client Name] [nvarchar] (50) NULL,
[Client Last Name] [nvarchar] (50) NULL,
[Client Address] [nvarchar] (50) NULL,
[Client City] [nvarchar] (50) NULL,
[Client State] [nvarchar] (50) NULL,
[Client Zip] [nvarchar] (50) NULL,
[Client Phone] [nvarchar] (50) NULL,
[Client WorkPhone] [nvarchar] (50) NULL,
[Client Date of Birth] [datetime] NULL,
[SSN] [nvarchar] (50) NULL,
[Date Of Accident] [datetime] NULL,
[Attorney No] [int] NULL,
[Physician No] [int] NULL,
[Provider No] [int] NULL,
[Invoice Closed] [bit] NULL,
[Notes] [ntext] NULL,
[Invoice Closed Date] [datetime] NULL,
[TotalCost] [float] NULL,
[MaturityDate] [datetime] NULL,
[DepositReceived] [float] NULL,
[DatePaid] [datetime] NULL,
[DueDate] [datetime] NULL,
[ServiceFeeWaived] [float] NULL,
[AmountPaid] [float] NULL,
[BalanceDue] [float] NULL,
[DateServiceFeeBegins] [datetime] NULL,
[LossesAmount] [float] NULL,
[Cumulative] [float] NULL,
[CostOfGoodsSold] [float] NULL,
[EndingBalance] [float] NULL,
[Revenue] [float] NULL,
[AmortizationDate] [datetime] NULL,
[Months] [int] NULL,
[TotalPayments] [float] NULL,
[TotalPPO] [float] NULL,
[TotalPrincipal] [float] NULL,
[CompleteFile] [bit] NULL,
[company] [nvarchar] (50) NULL,
[TotalInterestPaid] [float] NULL,
[GrossCumulative] [float] NULL,
[transferred] [bit] NULL
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_DMA_SURGERY_Services]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_DMA_SURGERY_Services]
(
[InvoiceNumber] [int] NULL,
[provider] [int] NULL,
[DueDate] [datetime] NULL,
[AmountDue] [float] NULL,
[cost] [float] NULL,
[discount] [float] NULL,
[PPODiscount] [float] NULL,
[ProviderByInvoice] [int] NULL,
[AmountWaived] [float] NULL,
[SERVICEID] [int] NOT NULL IDENTITY(1, 1)
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_DMA_SURGERY_Providers]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_DMA_SURGERY_Providers]
(
[provider] [int] NULL,
[date] [datetime] NULL,
[name] [nvarchar] (50) NULL,
[address] [nvarchar] (35) NULL,
[city] [nvarchar] (20) NULL,
[state] [nvarchar] (2) NULL,
[zip] [nvarchar] (10) NULL,
[phone] [nvarchar] (12) NULL,
[contact] [nvarchar] (25) NULL,
[abbrev] [nvarchar] (10) NULL,
[discount] [decimal] (7, 2) NULL,
[fax] [nvarchar] (12) NULL
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_DMA_SURGERY_PaymentsToProviders]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_DMA_SURGERY_PaymentsToProviders]
(
[Invoice Number] [int] NULL,
[Provider] [int] NULL,
[DatePaid] [datetime] NULL,
[Amount] [decimal] (10, 2) NULL,
[PaymentType] [nvarchar] (10) NULL,
[Check] [nvarchar] (10) NULL,
[ProviderByInvoice] [int] NULL,
[PAYMENTID] [int] NOT NULL IDENTITY(1, 1)
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_DMA_SURGERY_PaymentsByAttorney]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_DMA_SURGERY_PaymentsByAttorney]
(
[Invoice Number] [int] NULL,
[DatePaid] [datetime] NULL,
[amount] [float] NULL,
[PaymentType] [nvarchar] (10) NULL,
[check] [nvarchar] (10) NULL
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_DMA_SURGERY_DMA]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_DMA_SURGERY_DMA]
(
[Invoice Number] [int] NULL,
[Invoice Date] [datetime] NULL,
[Client Name] [nvarchar] (50) NULL,
[Client Last Name] [nvarchar] (50) NULL,
[Client Address] [nvarchar] (50) NULL,
[Client City] [nvarchar] (50) NULL,
[Client State] [nvarchar] (50) NULL,
[Client Zip] [nvarchar] (50) NULL,
[Client Phone] [nvarchar] (50) NULL,
[Client WorkPhone] [nvarchar] (50) NULL,
[Client Date of Birth] [datetime] NULL,
[SSN] [nvarchar] (50) NULL,
[Date Of Accident] [datetime] NULL,
[Attorney No] [int] NULL,
[Physician No] [int] NULL,
[Provider No] [int] NULL,
[Invoice Closed] [bit] NULL,
[Notes] [ntext] NULL,
[Invoice Closed Date] [datetime] NULL,
[TotalCost] [float] NULL,
[MaturityDate] [datetime] NULL,
[DepositReceived] [float] NULL,
[DatePaid] [datetime] NULL,
[DueDate] [datetime] NULL,
[ServiceFeeWaived] [float] NULL,
[AmountPaid] [float] NULL,
[BalanceDue] [float] NULL,
[DateServiceFeeBegins] [datetime] NULL,
[LossesAmount] [float] NULL,
[Cumulative] [float] NULL,
[CostOfGoodsSold] [float] NULL,
[EndingBalance] [float] NULL,
[Revenue] [float] NULL,
[AmortizationDate] [datetime] NULL,
[Months] [int] NULL,
[TotalPayments] [float] NULL,
[TotalPPO] [float] NULL,
[TotalPrincipal] [int] NULL,
[CompleteFile] [bit] NULL,
[SurgeryType] [nvarchar] (64) NULL,
[DateScheduled] [datetime] NULL,
[inpatient] [bit] NULL,
[outpatient] [bit] NULL,
[cancelled] [bit] NULL,
[icd9] [nvarchar] (8) NULL,
[drgcode] [nvarchar] (3) NULL,
[company] [nvarchar] (50) NULL,
[transferred] [bit] NULL
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_DMA_SURGERY_CPTCharges]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_DMA_SURGERY_CPTCharges]
(
[Invoice Number] [int] NULL,
[provider] [int] NULL,
[cptcode] [nvarchar] (5) NULL,
[amount] [decimal] (10, 2) NULL,
[description] [nvarchar] (75) NULL,
[ProviderbyInvoice] [int] NULL
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_DMA_SURGERY_CalcTestListTemp]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_DMA_SURGERY_CalcTestListTemp]
(
[InvoiceNumber] [int] NULL,
[TestCosts] [float] NULL,
[TestCostsNet] [float] NULL,
[PPODisc] [float] NULL,
[InterestByDate] [float] NULL,
[DateScheduled] [datetime] NULL,
[InterestDue] [float] NULL,
[Name] [nvarchar] (255) NULL,
[Client Name] [nvarchar] (50) NULL,
[Client Last Name] [nvarchar] (50) NULL,
[Notes] [ntext] NULL,
[attorneyName] [nvarchar] (255) NULL,
[abbrev] [nvarchar] (10) NULL,
[EndingBalance] [float] NULL,
[Balance] [float] NULL,
[Attorney No] [int] NULL,
[PaymentTotals] [float] NULL,
[Company] [nvarchar] (50) NULL,
[Company2] [nvarchar] (50) NULL,
[amortization] [datetime] NULL,
[TestType] [nvarchar] (50) NULL,
[FirstTestDate] [datetime] NULL,
[COGS] [float] NULL,
[Revenue] [float] NULL,
[ContractRevenue] [float] NULL,
[TotalRevenue] [float] NULL,
[maturity] [datetime] NULL,
[amortyear] [nvarchar] (50) NULL
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_DMA_SHARED_Attorney_List]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_DMA_SHARED_Attorney_List]
(
[Attorney No] [int] NULL,
[Attorney First Name] [nvarchar] (50) NULL,
[Attorney Last Name] [nvarchar] (50) NULL,
[Attorney Address] [nvarchar] (50) NULL,
[Attorney City] [nvarchar] (50) NULL,
[Attorney State] [nvarchar] (50) NULL,
[Attorney Zip] [nvarchar] (50) NULL,
[Attorney Phone] [nvarchar] (50) NULL,
[Attorney Fax] [nvarchar] (50) NULL,
[Attorney Seceretary] [nvarchar] (50) NULL,
[Memo] [ntext] NULL,
[Months] [int] NULL,
[Discount Plan] [int] NULL,
[Deposit Amount Required] [int] NULL,
[test] [bit] NULL
)
GO
PRINT N'Creating [dbo].[proc_DATAMIGRATIONProcess_DMA]'
GO

CREATE PROCEDURE [dbo].[proc_DATAMIGRATIONProcess_DMA]
	
	@DateTimeVal datetime
		
AS 


BEGIN

Delete From Payments --where Temp_CompanyID = 2
		PRINT 'Delete From Payments Complete'

Delete From InvoiceChangeLog 
		PRINT 'Delete From InvoiceChangeLog Complete'
		
Delete From Invoice Where CompanyID = 2
		PRINT 'Delete From Invoice Complete'

Delete From Comments

Delete From InvoiceChangeLog

Delete From Invoice

Delete From InvoiceAttorney Where Temp_CompanyID = 2
		PRINT 'Delete From InvoiceAttorney Complete'

Delete From SurgeryInvoice_Provider_Services --Where Temp_CompanyID = 2
		PRINT 'Delete From SurgeryInvoice_Provider_Services Complete'

Delete From SurgeryInvoice_Provider_CPTCodes --Where Temp_CompanyID = 2
		PRINT 'Delete From SurgeryInvoice_Provider_CPTCodes Complete'

Delete From SurgeryInvoice_Provider_Payments --Where Temp_CompanyID = 2
		PRINT 'Delete From SurgeryInvoice_Provider_Payments Complete'

Delete From SurgeryInvoice_Providers --Where Temp_CompanyID = 2
		PRINT 'Delete From SurgeryInvoice_Providers Complete'


Delete From TestInvoice_Test_CPTCodes

Delete From TestInvoice_Test

Delete From TestInvoice

Delete From InvoiceProvider --Where Temp_CompanyID = 2
		PRINT 'Delete From InvoiceProvider Complete'
		
Delete From InvoiceContacts 

Delete From InvoiceFirm

Delete From InvoicePhysician

Delete from InvoiceAttorney

Delete From InvoiceContactList	--Where Temp_CompanyID = 2
		PRINT 'Delete From InvoiceContactList Complete'

Delete From InvoicePatient --Where Temp_CompanyID = 2
		PRINT 'Delete From InvoicePatient Complete'
		
		
Delete From SurgeryInvoice_SurgeryDates-- Where Temp_CompanyID = 2
		PRINT 'Delete From SurgeryInvoice_SurgeryDates Complete'

Delete From SurgeryInvoice_Surgery --Where Temp_CompanyID = 2
		PRINT 'Delete From SurgeryInvoice_Surgery Complete'

Delete From Surgery --Where CompanyID = 2
		PRINT 'Delete From Surgery Complete'

Delete From SurgeryInvoice --Where Temp_CompanyID = 2
		PRINT 'Delete From SurgeryInvoice Complete'

Delete From Attorney --Where CompanyID = 2
		PRINT 'Delete From Attorney Complete'

Delete From Provider --Where CompanyID = 2
		PRINT 'Delete From Provider Complete'

Delete From PatientChangeLog --Where Temp_CompanyID = 2
		PRINT 'Delete From PatientChangeLog Complete'

Delete From Patient --Where CompanyID = 2
		PRINT 'Delete From Patient Complete'
		
Delete From Firm --Where CompanyID = 2
		PRINT 'Delete From Firm Complete'
		
Delete From Contacts 

Delete from Physician --where CompanyID = 2

		
Delete From ContactList Where ID <> 16 and Temp_CompanyID = 2-- TempContactID used in inserts below as placeholder
		PRINT 'Delete From ContactList Complete'




------------------- INSERTS TO ATTORNEY TABLE---------------------------------

Insert Into Attorney (CompanyID, ContactListID, isActivestatus, FirstName, LastName, Street1, Street2, City, StateID, ZipCode, Phone, Fax, Email, Notes, Temp_AttorneyID, DepositAmountRequired, Active, DateAdded)
Select 2, 16, 1, [Attorney First Name], [Attorney Last Name], [Attorney Address], '', [Attorney City], 19, [Attorney Zip], 
'(' + Left([ATTORNEY Phone], 3) + ') ' + Right(Left([ATTORNEY Phone], 6), 3) + '-' + Right([ATTORNEY Phone], 4), 
'(' + Left([ATTORNEY FAX], 3) + ') ' + Right(Left([ATTORNEY FAX], 6), 3) + '-' + Right([ATTORNEY FAX], 4),
 '', [Memo], [Attorney No], .13 as DepositAmountRequired, 1, @DateTimeVal --'10/10/2012 12:30 PM' 
From [DATAMIGRATION_DMA_SHARED_Attorney_List] 
WHERE [DATAMIGRATION_DMA_SHARED_Attorney_List].[Attorney Last Name] is not null 
and [DATAMIGRATION_DMA_SHARED_Attorney_List].[Attorney First Name] is not null

	PRINT 'Attorney Insert:  Attorney Table'


Insert into ContactList (DateAdded, Temp_AttorneyID, Temp_CompanyID)
Select @DateTimeVal , ID, 2  
from [Attorney]
Where Attorney.ContactListID = 16

	PRINT 'Attorney Insert:  ContactList Table'


Update Attorney
Set ContactListID =  ContactList.ID
From Attorney inner join ContactList on Attorney.ID = ContactList.Temp_AttorneyID
Where Attorney.ContactListID = 16
-- ContactListID is temporary to get records inserted initially
	
	PRINT 'Attorney Insert:  Attorney Table Update with ContactListID'
	
	PRINT '--ATTORNEY INSERT COMPLETE--'



-----------------INSRTS TO PROVIDER TABLE --(Surgery)----------------------------------

INSERT INTO Provider (CompanyID, ContactListID, isActiveStatus, Name, Street1, City, 
StateID, ZipCode, Phone, Fax, FacilityAbbreviation, DiscountPercentage, Active, MRICostTypeID, Temp_ProviderID)
Select 2, 16, 1, 
IsNull(DATAMIGRATION_DMA_SURGERY_Providers.Name, 'No Name At Import'), 
Isnull(Address, '3532 Canal Street, Suite 6'),
IsNull(City, 'New Orleans'), 
isnull(States.ID, 19) ,
isnull(Zip, '70119'), 
isnull( '(' + Left([Phone], 3) + ') ' + Right(Left([Phone], 6), 3) + '-' + Right([Phone], 4), 'none'), 
 '(' + Left([FAX], 3) + ') ' + Right(Left([FAX], 6), 3) + '-' + Right([FAX], 4),
Abbrev, discount , 1, 1, DATAMIGRATION_DMA_SURGERY_Providers.provider
 From DATAMIGRATION_DMA_SURGERY_Providers LEFT join States on DATAMIGRATION_DMA_SURGERY_Providers.State = States.Abbreviation

	PRINT 'Provider (Surgery) Insert:  Provider Table'


Insert Into ContactList (DateAdded, Temp_ProviderID, Temp_CompanyID)
Select '10/10/2012 12:30 PM' , ID, 2
from Provider
Where Provider.ContactListID = 16

	PRINT 'Provider (Surgery) Insert:  Contact  List'


Update Provider
Set ContactListID = ContactList.ID
From Provider inner join ContactList on Provider.ID = ContactList.Temp_ProviderID
Where Provider.ContactListID = 16

	PRINT 'Provider (Surgery) Insert:  Update of Provider Table with Contact List ID'
	PRINT '--PROVIDER SURGERY INSERT COMPLETE--'



-----------------INSERTS TO PROVIDER TABLE --(Tests)----------------------------------


INSERT INTO Provider (CompanyID, ContactListID, isActiveStatus, Name, Street1, City, 
StateID, ZipCode, Phone, Fax, FacilityAbbreviation, DiscountPercentage, Active, MRICostTypeID, Temp_ProviderID)

Select 2, 16, 1, 
IsNull([Facility Name], 'No Name At Import'), 
Isnull([Facility Address], '3532 Canal Street, Suite 6'),
IsNull([Facility City], 'New Orleans'), 
isnull(States.ID, 19) ,
isnull([Facility Zip], '70119'), 
isnull( '(' + Left([Facility Phone], 3) + ') ' + Right(Left([Facility Phone], 6), 3) + '-' + Right([Facility Phone], 4), 'none'), 
 '(' + Left([Facility FAX], 3) + ') ' + Right(Left([Facility FAX], 6), 3) + '-' + Right([Facility FAX], 4),
FacilityAbbrev, discount , 1, 1, DATAMIGRATION_DMA_TEST_Provider_List.[Facility No]
 From DATAMIGRATION_DMA_TEST_Provider_List
 LEFT join States on 
 DATAMIGRATION_DMA_TEST_Provider_List.[Facility State]= States.Abbreviation 

	PRINT 'Provider (TEST) Insert:  Provider Table'


Insert Into ContactList (DateAdded, Temp_ProviderID, Temp_CompanyID)
Select @DateTimeVal , ID, 2
from Provider
Where Provider.ContactListID = 16

	PRINT 'Provider (TEST) Insert:  Contact  List'


Update Provider
Set ContactListID = ContactList.ID
From Provider inner join ContactList on Provider.ID = ContactList.Temp_ProviderID
Where Provider.ContactListID = 16

	PRINT 'Provider (TEST) Insert:  Update of Provider Table with Contact List ID'
	PRINT '--PROVIDER TEST INSERT COMPLETE--'



-----------------INSERTS TO Physician TABLE --(Tests)----------------------------------


INSERT INTO Physician (CompanyID, ContactListID, isActiveStatus, FirstName, LastName, Street1, Street2, City, 
StateID, ZipCode, Phone, Fax,  Active, Notes, Temp_PhysicianID)

Select 2, 16, 1, 
IsNull([Physician First Name] , 'No Name At Import'),
IsNull([Physician Last Name]  , 'No Name At Import'),
 Isnull([Physician Address] , '3532 Canal Street, Suite 6'),
 Isnull([Physician Address2], ''),
IsNull([Physician City], 'New Orleans'), 
isnull(States.ID, 19) ,
isnull([Physician Zip] , '70119'), 
isnull( '(' + Left([Physician Phone], 3) + ') ' + Right(Left([Physician Phone], 6), 3) + '-' + Right([Physician Phone], 4), 'none'), 
 '(' + Left([Physician FAX], 3) + ') ' + Right(Left([Physician FAX], 6), 3) + '-' + Right([Physician FAX], 4),
1, Memo,
DATAMIGRATION_DMA_TEST_Physician_List.[Physician No]
 From DATAMIGRATION_DMA_TEST_Physician_List
 LEFT join States on 
 DATAMIGRATION_DMA_TEST_Physician_List.[Physician State]= States.Abbreviation 

	PRINT 'Physican (TEST) Insert:  Physican Table'
 
Insert Into ContactList (DateAdded, Temp_PhysicianID, Temp_CompanyID)
Select '11/9/2012 3:45 PM' , ID, 2
from Physician
Where Physician.ContactListID = 16

	PRINT 'Physican (TEST) Insert:  Contact  List'


Update Physician
Set ContactListID = ContactList.ID
From Physician inner join ContactList on Physician.ID = ContactList.Temp_PhysicianID
Where Physician.ContactListID = 16

	PRINT 'Physician (TEST) Insert:  Update of Physician Table with Contact List ID'
	PRINT '--Physician TEST INSERT COMPLETE--'


-------------------------- Insert into Patients (Surgery) ----------------------------
Insert Into Patient (CompanyID, isActiveStatus, FirstName, LastName, SSN, Street1, City, StateID, ZipCode, Phone, WorkPhone, DateOfBirth, Active, Temp_InvoiceID)
Select 2,1,[Client Name], [Client Last Name], SSN, [Client Address], [Client City], States.ID, isnull([Client Zip], 'none'), 
isnull([Client Phone], 'none'),
[Client WorkPhone],
IsNull([Client Date of Birth], '1/1/1900'), 1, [Invoice Number]
From DATAMIGRATION_DMA_SURGERY_dma 
inner join States on DATAMIGRATION_DMA_SURGERY_DMA.[Client State] = States.Abbreviation
Where [DATAMIGRATION_DMA_SURGERY_DMA].[SSN] is not null
Group by [Client Name], [Client Last Name], SSN, [Client Address], [Client City], States.ID, [Client Zip], 
[Client Phone],
[Client WorkPhone],
[Client Date of Birth],
[Invoice Number]

		PRINT 'Patient SURGERY Insert:  Patient Table'

		PRINT '--Patient (Surgery) INSERT COMPLETE--'




-------------------------- Insert into Patients (TEST) ----------------------------
Insert Into Patient (CompanyID, isActiveStatus, FirstName, LastName, SSN, Street1, City, StateID, ZipCode, Phone, WorkPhone, DateOfBirth, Active, Temp_InvoiceID)
Select 2,1,[Client Name], [Client Last Name], 
isnull(SSN, '000000000'), 
isnull([Client Address], 'Not Provided'), 
isnull([Client City], 'none'), 
States.ID, isnull([Client Zip], 'none'), 
isnull([Client Phone], 'none'),
[Client WorkPhone],
IsNull([Client Date of Birth], '1/1/1900'), 1, [Invoice Number]
From DATAMIGRATION_DMA_TEST_dma 
inner join States on DATAMIGRATION_DMA_TEST_DMA.[Client State] = States.Abbreviation
--Where [DATAMIGRATION_DMA_TEST_DMA].[SSN] is not null
Group by [Client Name], [Client Last Name], SSN, [Client Address], [Client City], States.ID, [Client Zip], 
[Client Phone],
[Client WorkPhone],
[Client Date of Birth],
[Invoice Number]


		PRINT 'Patient (Test) Insert:  Patient Table'


Insert Into PatientChangeLog (PatientID, UserID, InformationUpdated, Active, Temp_CompanyID)
Select ID, 84,-- TempUserID
 'Initial Import of Patient (Test) Information', 1, 2
From Patient Where Patient.Active = 1 and Patient.CompanyID = 2

		PRINT 'Patient Insert:  Patient Change Log (Test and Surgery)'
		PRINT '--Patient INSERT COMPLETE--'






------------------------- Insert Into InvoiceContactList (Attorney Info:  SURGERY)

Insert Into InvoiceContactList (Active, DateAdded, Temp_AttorneyID, Temp_Invoice, Temp_CompanyID)
Select 1, @DateTimeVal, [Attorney No], [Invoice Number], 2
From DATAMIGRATION_DMA_SURGERY_DMA
	PRINT '--Invoice Contact List (Attorney:  SURGERY) INSERT COMPLETE--'


------------------------- INSERT Into INvoiceContactList (Attorney Info:  TESTING)

Insert Into InvoiceContactList (Active, DateAdded, Temp_AttorneyID, Temp_Invoice, Temp_CompanyID)
Select 1, @DateTimeVal, [Attorney No], [Invoice Number], 2
From DATAMIGRATION_DMA_TEST_DMA

	PRINT '--InvoiceContactList (Attorney:  TESTING) INSERT Complete--'
	


------------------------- INSERT Into INvoiceContactList (Provider Info:  TESTING)

Insert Into InvoiceContactList (Active, DateAdded, Temp_ProviderID, Temp_Invoice, Temp_CompanyID)
Select 1, @DateTimeVal, [Provider No] , [Invoice No], 2
From DATAMIGRATION_DMA_TEST_Test_List
Group By [Provider No], [Invoice No]

	PRINT '--InvoiceContactList (Provider: TESTING) INSERT Complete--'
	

------------------------- INSERT Into INvoiceContactList (Physician Info:  TESTING)

Insert Into InvoiceContactList (Active, DateAdded, Temp_PhysicianID, Temp_Invoice, Temp_CompanyID)
Select 1, '11/9/2012 3:50 PM', [Physician No], [Invoice Number], 2
From DATAMIGRATION_DMA_TEST_DMA

	PRINT '--InvoiceContactList (Physician:  TESTING) INSERT Complete--'

	


---------------------  INSERT Into InvoiceAttorney (SURGERY)

Insert Into InvoiceAttorney (AttorneyID, InvoiceContactListID, isActivestatus, FirstName, LastName,
Street1, Street2, City, StateID, ZipCode, Phone, Fax, Email, Notes, DiscountNotes, DepositAmountRequired, Active, DateAdded, 
Temp_InvoiceNumber, Temp_AttorneyID, Temp_CompanyID)

SELECT Attorney.ID, InvoiceContactList.ID, 1, Attorney.FirstName, Attorney.LastName,
Attorney.Street1, Attorney.Street2, Attorney.City, Attorney.StateID, Attorney.ZipCode,
Attorney.Phone, Attorney.Fax, Attorney.Email, Attorney.Notes, Attorney.DiscountNotes, Attorney.DepositAmountRequired,
Attorney.Active, Attorney.DateAdded, DataMigration_DMA_Surgery_Dma.[Invoice Number], Attorney.Temp_AttorneyID, 2
From DataMigration_DMA_Surgery_DMA 
inner join Attorney on DATAMIGRATION_DMA_SURGERY_DMA.[Attorney No] =
Attorney.Temp_AttorneyID 
inner join InvoiceContactList on InvoiceContactList.Temp_AttorneyID = Attorney.Temp_AttorneyID 
and InvoiceContactList.Temp_Invoice = DATAMIGRATION_DMA_SURGERY_DMA.[Invoice Number]

	PRINT '--Invoice Attorney INSERT COMPLETE--'


---------------------  INSERT Into InvoiceAttorney (TESTING)

Insert Into InvoiceAttorney (AttorneyID, InvoiceContactListID, isActivestatus, FirstName, LastName,
Street1, Street2, City, StateID, ZipCode, Phone, Fax, Email, Notes, DiscountNotes, DepositAmountRequired, Active, DateAdded, 
Temp_InvoiceNumber, Temp_AttorneyID, Temp_CompanyID)

SELECT Attorney.ID, InvoiceContactList.ID, 1, Attorney.FirstName, Attorney.LastName,
Attorney.Street1, Attorney.Street2, Attorney.City, Attorney.StateID, Attorney.ZipCode,
Attorney.Phone, Attorney.Fax, Attorney.Email, Attorney.Notes, Attorney.DiscountNotes, Attorney.DepositAmountRequired,
Attorney.Active, Attorney.DateAdded, DataMigration_DMA_TEST_Dma.[Invoice Number], Attorney.Temp_AttorneyID, 2
From DataMigration_DMA_TEST_DMA 
inner join Attorney on DATAMIGRATION_DMA_TEST_DMA.[Attorney No] =
Attorney.Temp_AttorneyID 
inner join InvoiceContactList on InvoiceContactList.Temp_AttorneyID = Attorney.Temp_AttorneyID 
and InvoiceContactList.Temp_Invoice = DATAMIGRATION_DMA_TEST_DMA.[Invoice Number]




-----  insert into Invoice_Patient table (Surgery)

Insert Into InvoicePatient (PatientID, isActiveStatus, FirstName, LastName, SSN, Street1, Street2, City, StateID,
ZipCode, PHone, WorkPhone, DateofBirth, Active, DateAdded, Temp_CompanyID)

SELECT Patient.ID, 1, FirstName, LastName, Patient.SSN, Street1, Street2, City, StateID, 
ZipCode, Phone, WorkPhone, DateOfBirth, Active, DateAdded, 2
From Patient inner join DataMigration_DMA_SURGERY_DMA
on  Patient.Temp_InvoiceID = dbo.DATAMIGRATION_DMA_SURGERY_dma.[Invoice Number] and CompanyID = 2

	PRINT '--INVOICE_PATIENT INSERT COMPLETE SURGERY--'


-----  insert into Invoice_Patient table (TESTING)

Insert Into InvoicePatient (PatientID, isActiveStatus, FirstName, LastName, SSN, Street1, Street2, City, StateID,
ZipCode, PHone, WorkPhone, DateofBirth, Active, DateAdded, Temp_CompanyID)

SELECT Patient.ID, 1, FirstName, LastName, Patient.SSN, Street1, Street2, City, StateID, 
ZipCode, Phone, WorkPhone, DateOfBirth, Active, DateAdded, 2
From Patient inner join DataMigration_DMA_TEST_DMA
on  Patient.Temp_InvoiceID = dbo.DATAMIGRATION_DMA_TEST_dma.[Invoice Number] and CompanyID = 2


	PRINT '--INVOICE_PATIENT INSERT COMPLETE TESTS--'


--------------------------INSERT SurgeryInvoice


Insert Into SurgeryInvoice ( Active, DateAdded, Temp_InvoiceID, Temp_CompanyID)
Select 1, @DateTimeVal , [Invoice Number], 2
From DATAMIGRATION_DMA_SURGERY_DMA

	PRINT '--SURGERYINVOICE INSERT COMPLETE--'


-----------------------  Insert TEST

Delete From Test Where CompanyID = 2

Insert Into Test (CompanyID, Name, Active, DateAdded)
Select 2, [Test Name] , 1, @DateTimeVal 
From DATAMIGRATION_DMA_TEST_TEST_List
Where [Test Name] is not null
Group By [Test Name]

Update Test 
Set Temp_TestTypeID = 1
Where (Test.Name Like '%IDET%'
or Test.Name Like '%Disk%'
or Test.Name Like '%Disc%'
or Test.Name Like '%ESI%'
or Test.Name Like '%Facet%'
or Test.Name Like '%Anesthesia'
or Test.Name Like '%Myelogram%'
or Test.Name Like '%Cervical%'
or Test.Name Like '%Rhizo%'
or Test.Name Like '%RF%'
or Test.Name Like '%Chiropractic%'
or Test.Name Like '%Injection%'
or Test.Name Like '%Evaluation%'
or test.Name Like '%treatment%'
or test.name Like '%MBB%'
or test.name Like '%Branch%'
or test.name Like '%TP%'
or test.name like '%ONB%'
or test.name like '%OCB%'
or test.name like '%Occipital%'
or test.name like '%eval%'
or test.name like '%Procedure%'
or test.name like '%Office%'
Or test.name like '%Visit%'
or test.name like '%Denervation%'
or test.name like '%SNRB%'
or test.name like '%Transfor%'
or test.name like '%Radio%'
or test.name like '%Arth%'
or test.name like '%Block%'
)
and CompanyID = 2

Update Test 
Set Temp_TestTypeID = 2 -- MRI
Where (Test.Name Like '%MRI%'
or Test.Name Like '%MIR%'
or Test.Name Like '%Lumbar%'
or Test.Name Like '%Cervical%'
or Test.Name Like '%Thoracic%'
or Test.Name Like '%complete%'
or Test.Name Like '%lumbar%')
and CompanyID = 2


Update Test 
Set Temp_TestTypeID = 3 -- OTHER
Where (Test.Name Like '%blood%'
or Test.Name Like '%work%'
or Test.Name Like '%dmx%'
or Test.Name Like '%sedation%'
or Test.Name Like '%urinalysis%'
or Test.Name Like '%fluor%'
or Test.Name Like '%fee%'
or Test.Name Like '%ems%'
or Test.Name Like '%sleep%'
or Test.Name Like '%study%'
or Test.Name Like '%no show%'
or Test.Name Like '%eeg%'
or test.Name Like '%24 hour%'
or test.name Like '%blood patch%'
or test.name Like '%ultra%'
or test.name Like '%radiology%'
or test.name like '%CT%'
or test.name like '%x-ray%'
or test.name like '%ray%'
or test.name like '%scan%'
or test.name like '%CAT%'
or test.name like '%Physical%'
Or test.name like '%Therapy%'
or test.name like '%Gadolinium%'
or test.name like '%FEE%'
or test.name like '%Contrast%'
or test.name like '%EMG%'
or test.name like '%NCV%'
or test.name like '%SSEP%'
or test.name like '%DEP%'
or test.name like '%MRA%'
or test.name like '%MR%'
or test.name like '%Angiogram%'
or test.name like '%Ultrasound%'
or test.name like '%Mammogram%'
or test.name like '%Medical Records%'
or Test.Name like '%left elbow%')
and CompanyID = 2
and Temp_TestTypeID is null

--and Temp_TestTypeID <> 1 and Temp_TestTypeID <> 2

	PRINT '--Updates to Test Name Complete--'


-------------------------INSERT InvoicePhysician (for TESTING)

Insert Into InvoicePhysician (PhysicianID, InvoiceContactListID, isActivestatus, FirstName, LastName,
Street1, Street2, City, StateID, ZipCode, Phone, Fax, EmailAddress, Notes, 
Active, DateAdded, Temp_InvoiceNumber, Temp_PhysicianID, Temp_CompanyID)

SELECT Physician.ID, InvoiceContactList.ID, 1, Physician.FirstName, Physician.LastName,
Physician.Street1, Physician.Street2, Physician.City, Physician.StateID, Physician.ZipCode,
Physician.Phone, Physician.Fax, Physician.EmailAddress, Physician.Notes, 
Physician.Active, Physician.DateAdded, DataMigration_DMA_TEST_Dma.[Invoice Number], PHysician.Temp_PhysicianID, 2
From DataMigration_DMA_TEST_DMA 
inner join Physician on DATAMIGRATION_DMA_TEST_DMA.[Physician No] =
Physician.Temp_PhysicianID 
inner join InvoiceContactList on InvoiceContactList.Temp_PhysicianID = Physician.Temp_PhysicianID 
and InvoiceContactList.Temp_Invoice = DATAMIGRATION_DMA_TEST_DMA.[Invoice Number]


--Select * From Test Where Temp_TestTypeID is null and CompanyID = 2

--------------------------INSERT TESTInvoice

Insert Into TestInvoice ( TestTypeID, Active, DateAdded, Temp_TestNo, Temp_InvoiceID)
Select Max(Test.Temp_TestTypeID), 1, --'12/19/2012',
@DateTimeVal, 
Max(DATAMIGRATION_DMA_TEST_TEST_List.[Test No]), DATAMIGRATION_DMA_TEST_TEST_List.[Invoice No] 
from DATAMIGRATION_DMA_TEST_TEST_List inner join Test on Test.Name = DataMigration_DMA_TEst_Test_List.[Test Name]
and Test.CompanyID = 2
Group By DATAMIGRATION_DMA_TEST_TEST_List.[Invoice No] 
having MAX(Test.Temp_TestTypeID) is not null -- Needs to pull as an exception 
--AND DATAMIGRATION_DMA_TEST_TEST_List.[Invoice No] = 1711

--Select * From DATAMIGRATION_DMA_TEST_DMA Where [Invoice Number] = 8067 
--Select * From DATAMIGRATION_DMA_TEST_TEST_List Where [Invoice No] = 8067
--Select * From InvoicePhysician Where Temp_InvoiceNumber = 1714
	PRINT '--INSERT TEST INVOICE COMPLETE--'

--Select * From InvoiceContactList Where Temp_Invoice = 8067

--Where InvoiceContactList.Temp_ProviderID in (5074, 5075)	
	
Insert Into InvoiceProvider (InvoiceContactListID, ProviderID, isActiveStatus, 
Name, Street1, Street2, City, StateID, ZipCode, Phone, Fax, Email, 
Notes, FacilityAbbreviation, DiscountPercentage, MRICostTypeID, MRICostFlatRate, MRICostPercentage, 
DaysUntilPaymentDue, Deposits, Active, DateAdded, Temp_ProviderID, Temp_InvoiceID, Temp_CompanyID)

Select InvoiceContactList.ID, Provider.ID, Provider.isActiveStatus, 
Provider.Name, Provider.Street1, Provider.Street2, Provider.City, Provider.StateID, Provider.ZipCode, Provider.Phone, Provider.Fax, Provider.Email,
Provider.Notes, Provider.FacilityAbbreviation, Provider.DiscountPercentage, Provider.MRICostTypeID, Provider.MRICostFlatRate, Provider.MRICostPercentage,
Provider.DaysUntilPaymentDue, Provider.Deposits, Provider.Active, Provider.DateAdded, Provider.Temp_ProviderID, InvoiceContactList.Temp_Invoice, InvoiceContactList.Temp_CompanyID

From InvoiceContactList inner join Provider on InvoiceContactList.Temp_ProviderID = Provider.Temp_ProviderID 
Where InvoiceContactList.Temp_CompanyID = 2 


	PRINT '--INSERT INvoice Contact List:  Providers (TEST Invoice)'


----------------------- Convert Times in DATAMIGRATION_DMA_TEST_TEST_List TABLE ----

/*Select [Test time],  (LTRIM([Test Time])) + ' PM'
From DATAMIGRATION_DMA_TEST_TEST_List 
WHERE
Len(LTRIM([Test Time])) = 4
and (LTRIM([Test Time])) Not Like '%P%' 
and (LTRIM([Test Time])) Not Like '%A%' 
and LEFT((LTRIM([Test Time])), 1) Like '1%'
*/



----------------------- Insert TestInvoice_TEST
Delete From TestInvoice_Test

Insert Into TestInvoice_Test (TestInvoiceID, TestID, InvoiceProviderID, Notes, TestDate, TestTime, NumberOfTests,
MRI, IsPositive, isCanceled, TestCost, PPODiscount, AmountToProvider, CalculateAmountToProvider, ProviderDueDate, 
DepositToProvider, AmountPaidToProvider, Date, CheckNumber, Active, DateAdded, Temp_InvoiceID) 

Select TESTInvoice.ID, 
Test.ID, 
InvoiceProvider.ID, 
'test', 
isnull(Convert(date, [Test Date]), '1/1/1900'), 
--ISNULL([TestTimeTIME], '11:59 PM'),
'8:00 PM',

[Number of Tests], 
ISNULL([MRI], 0), 
Case When [Test Results] = 'Negative' Then 0
When [Test Results] = 'Positive' Then 1
When [Test Results] = null then ''
End as IsPositive, 
Canceled, 
[Test Cost], 
IsNull([PPO Discount], 0), 
IsNull([Amount Paid To Provider],0), 
IsNull([Amount Paid To Provider],0), 

Case When (Convert(date,[Amount Due To Provider Due Date])) is null Then '1/1/2099'
When (Convert(date,[Amount Due To Provider Due Date])) is not null Then (Convert(date,[Amount Due To Provider Due Date])) 
End [Amount Due To Provider Due Date],

[Amount Paid To Provider], 
[Amount Paid To Provider],  
Convert(date,[Amount Due To Provider Due Date]),
[Amount Paid To Provider Check No], 
1 as Active, 

--@DateTimeVal as DateAdded,
'12/19/2012' as dateadded,
TESTInvoice.Temp_InvoiceID 

From TestInvoice inner join DATAMIGRATION_DMA_TEST_DMA on TestInvoice.Temp_InvoiceID = DATAMIGRATION_DMA_TEST_DMA.[Invoice Number]

inner join DataMigration_DMA_TEST_TEST_List on DATAMIGRATION_DMA_TEST_DMA.[Invoice Number] = DATAMIGRATION_DMA_TEST_TEST_LIST.[Invoice No]
inner join TEST on TEST.Name = DATAMIGRATION_DMA_TEST_TEST_List.[Test Name] 
inner join InvoiceProvider on DATAMIGRATION_DMA_TEST_TEST_List.[Invoice No] = InvoiceProvider.Temp_INvoiceID  
and DATAMIGRATION_DMA_TEST_TEST_List.[Provider no] = InvoiceProvider.Temp_ProviderID 
LEFT Join Temp_TestTimeValConversionTEXTToTime on DATAMIGRATION_DMA_TEST_TEST_LIST.[Test time] = Temp_TestTimeValConversionTEXTToTime.TestTimeTEXT  
Where TEST.CompanyID = 2
--and DATAMIGRATION_DMA_TEST_TEST_LIST.[Invoice No] = 1714


--Select * From InvoiceProvider Where Temp_InvoiceID = 1714

--Select [Invoice no] From DATAMIGRATION_DMA_TEST_TEST_LIST  
--Group by [Invoice No]
--order by [Invoice No]


--Select [Temp_InvoiceID] From TestInvoice
--Group By [Temp_InvoiceID] 
--order by Temp_InvoiceID


--Select * From DATAMIGRATION_DMA_TEST_TEST_LIST
--Where [Invoice No] = 1711

--and [Amount Due To Provider Due Date] is not null -- Add to Exceptions  12/19/2012:  Commenting Out for TEST Invoices Only Because Believed to be Culprit on why some test info is not populating on certain invoices.

 /*

Select * From InvoiceProvider Where Temp_InvoiceID = 8067
Select * From DATAMIGRATION_DMA_TEST Where Provider
Select * From DATAMIGRATION_DMA_TEST_TEST_List Where [Invoice No] = 8067
Select * From Test Where Test.Name = 'RADIOLOGY FEE' OR Test.Name = 'Cervical Spect Scan & X-rays'
Select * From TestINvoice_TEST Where TestINvoice_Test.Temp_InvoiceID = 8067
*/

/*
SELECT     Test.ID AS [Test.ID], Test.CompanyID, TestInvoice.ID AS [TestInvoice.iD], Test.Name AS [Test.Name], Provider.ID AS [Provider.ID]
FROM         DATAMIGRATION_DMA_TEST_DMA INNER JOIN
                      DATAMIGRATION_DMA_TEST_TEST_List ON DATAMIGRATION_DMA_TEST_DMA.[Invoice Number] = DATAMIGRATION_DMA_TEST_TEST_List.[Invoice No] INNER JOIN
                      Test ON DATAMIGRATION_DMA_TEST_TEST_List.[Test Name] = Test.Name INNER JOIN
                      TestInvoice ON DATAMIGRATION_DMA_TEST_DMA.[Invoice Number] = TestInvoice.Temp_InvoiceID INNER JOIN
                      Provider ON DATAMIGRATION_DMA_TEST_DMA.[Provider No] = Provider.Temp_ProviderID
WHERE     (Test.CompanyID = 2)

*/


-----------------------  InSERT Surgery

Insert Into Surgery (CompanyID, Name, Active, DateAdded)
Select 2, SurgeryType, 1, @DateTimeVal 
From DATAMIGRATION_DMA_SURGERY_DMA
Group By SurgeryType


	PRINT '--SURGERY INSERT COMPLETE--'



----------------------- Insert SurgeryInvoice_Surgery

Insert Into SurgeryInvoice_Surgery (SurgeryInvoiceID, SurgeryID, isInpatient, Notes, Active, DateAdded, Temp_InvoiceID, Temp_CompanyID)
Select SurgeryInvoice.ID, Surgery.ID, DATAMIGRATION_DMA_SURGERY_DMA.inpatient, DATAMIGRATION_DMA_SURGERY_DMA.Notes,
1, @DateTimeVal , SurgeryInvoice.Temp_InvoiceID, 2 

From SurgeryInvoice inner join DATAMIGRATION_DMA_SURGERY_DMA on SurgeryInvoice.Temp_InvoiceID = DATAMIGRATION_DMA_SURGERY_DMA.[Invoice Number]
inner join Surgery on Surgery.Name = DATAMIGRATION_DMA_SURGERY_DMA.SurgeryType
Where Surgery.CompanyID = 2


	PRINT '--SURGERYINVOICE_SURGERY INSERT COMPLETE--'


------------------------ Insert SurgeryInvoice_SurgeryDates

Insert Into SurgeryInvoice_SurgeryDates (SurgeryInvoice_SurgeryID, ScheduledDate, isPrimaryDate, Active, DateAdded, Temp_CompanyID)
Select SurgeryInvoice_Surgery.ID, DATAMIGRATION_DMA_SURGERY_DMA.DateScheduled, 1, 1, @DateTimeVal , 2 

From SurgeryInvoice inner join DATAMIGRATION_DMA_SURGERY_DMA on SurgeryInvoice.Temp_InvoiceID = DATAMIGRATION_DMA_SURGERY_DMA.[Invoice Number]
inner join Surgery on Surgery.Name = DATAMIGRATION_DMA_SURGERY_DMA.SurgeryType
inner join SurgeryInvoice_Surgery on SurgeryInvoice_Surgery.SurgeryInvoiceID = SurgeryInvoice.ID
Where Surgery.CompanyID = 2 
and DATEScheduled is not null

	PRINT '--SURGERYINVOICE_SURGERYDATES INSERT COMPLETE--'


-------------------------  Insert InvoiceContactList (provider info) SURGERY

insert into InvoiceContactList (Active, DateAdded, Temp_ProviderID, Temp_Invoice, Temp_CompanyID)
Select 1, '10/10/2012 12:30 PM' , Provider, DATAMIGRATION_DMA_SURGERY_DMA.[Invoice Number], 2  
from DATAMIGRATION_DMA_SURGERY_DMA inner join DATAMIGRATION_DMA_SURGERY_Services
on DATAMIGRATION_DMA_SURGERY_DMA.[invoice number] = DATAMIGRATION_DMA_SURGERY_Services.InvoiceNumber
--Where [Invoice Number] = 2883
Group By Provider, Provider, DATAMIGRATION_DMA_SURGERY_DMA.[Invoice Number] 

	PRINT '--INVOICECONTACTLIST TEST INSERT COMPLETE--'


-------------------------  Insert InvoiceContactList (provider info) TEST
/*

insert into InvoiceContactList (Active, DateAdded, Temp_ProviderID, Temp_Invoice, Temp_CompanyID)
Select 1, '10/10/2012 12:30 PM' , Provider, DATAMIGRATION_DMA_TEST_DMA.[Invoice Number], 2  
from DATAMIGRATION_DMA_TEST_DMA inner join DATAMIGRATION_DMA_TEST_Services
on DATAMIGRATION_DMA_TEST_DMA.[invoice number] = DATAMIGRATION_DMA_TEST_Services.InvoiceNumber
--Where [Invoice Number] = 2883
Group By Provider, Provider, DATAMIGRATION_DMA_SURGERY_DMA.[Invoice Number] 

	PRINT '--INVOICECONTACTLIST TEST INSERT COMPLETE--'
*/
-------------------------- Insert InvoiceProvider (Surgery) --------

Insert Into InvoiceProvider (InvoiceContactListID, ProviderID, isActiveStatus, Name, Street1, Street2, City, StateID, ZipCode, Phone, Fax, Email, Notes, FacilityAbbreviation, DiscountPercentage, MRICostTypeID, MRICostFlatRate, MRICostPercentage, DaysUntilPaymentDue, Deposits, Active, DateAdded, Temp_providerID, Temp_InvoiceID, Temp_CompanyID)
Select InvoiceContactList.ID as InvoiceContactListID, Provider.ID as ProviderID, 1 as isActiveStatus, Provider.Name, Provider.Street1, Provider.Street2, Provider.City, 
Provider.StateID, Provider.ZipCode, Provider.Phone, Provider.Fax, Provider.Email, Provider.Notes, Provider.FacilityAbbreviation, Provider.DiscountPercentage, Provider.MRICostTypeID, Provider.MRICostFlatRate, Provider.MRICostPercentage, Provider.DaysUntilPaymentDue, Provider.Deposits, Provider.Active, Provider.DateAdded, Provider.Temp_ProviderID, InvoiceContactList.Temp_Invoice, 2
From InvoiceContactList inner join dbo.Provider 
on InvoiceContactList.Temp_ProviderID = Provider.Temp_ProviderID 
Inner join DATAMIGRATION_DMA_SURGERY_DMA on 
InvoiceContactList.Temp_Invoice = DATAMIGRATION_DMA_SURGERY_DMA.[Invoice Number] 
and Provider.CompanyID = 2 
--WHERE Temp_Invoice = 2883

	PRINT '--INVOICEPROVIDER INSERT COMPLETE--'


--------------------------- Insert SurgeryInvoice_Providers ---------------------------

Insert Into SurgeryInvoice_Providers (SurgeryInvoiceID, InvoiceProviderID, Active, DateAdded, Temp_InvoiceID, Temp_ProviderID, Temp_CompanyID) 
Select SurgeryInvoice.ID, InvoiceProvider.ID, 1 as Active, @DateTimeVal , InvoiceProvider.Temp_InvoiceID, InvoiceProvider.Temp_ProviderID, 2 
From InvoiceProvider inner join SurgeryInvoice 
on InvoiceProvider.Temp_InvoiceID = SurgeryInvoice.Temp_InvoiceID
--WHERE InvoiceProvider.Temp_InvoiceID = 2883
--Group By SurgeryInvoice.ID, InvoiceProvider.ID, InvoiceProvider.Temp_InvoiceID, InvoiceProvider.Temp_ProviderID 
/*
Select * From SurgeryInvoice
WHERE SurgeryInvoice.Temp_InvoiceID  = 8000

SELECT * From InvoiceProvider
WHERE InvoiceProvider.Temp_InvoiceID  = 8000
*/


	PRINT '--SURGERYINVOICE_PROVIDERS INSERT COMPLETE--'


--------------------------- Insert SurgeryInvoice_Provider_Services -------------------

/*Insert Into SurgeryInvoice_Provider_Services (SurgeryInvoice_ProviderID, EstimatedCost, Cost, 
Discount, PPODiscount, DueDate, AmountDue, AccountNumber, Active, DateAdded)

Select SurgeryInvoice_Providers.ID, DATAMIGRATION_DMA_SURGERY_SERVICES.Cost, 
DATAMIGRATION_DMA_SURGERY_SERVICES.Cost, 
1 - DATAMIGRATION_DMA_SURGERY_SERVICES.discount, 
(1 - DATAMIGRATION_DMA_SURGERY_SERVICES.discount) * DATAMIGRATION_DMA_SURGERY_Services.cost as PPODiscount, 
DATAMIGRATION_DMA_SURGERY_SERVICES.DueDate, 
DATAMIGRATION_DMA_SURGERY_SERVICES.AmountDue, '' as AccountNumber, 1, '9/25/2012 10:52 AM' 
From DATAMIGRATION_DMA_SURGERY_SERVICES inner join SurgeryInvoice_Providers  
on DATAMIGRATION_DMA_SURGERY_SERVICES.[InvoiceNumber] = SurgeryInvoice_Providers.Temp_InvoiceID
and DATAMIGRATION_DMA_SURGERY_Services.provider = SurgeryInvoice_Providers.Temp_ProviderID
*/

Insert Into SurgeryInvoice_Provider_Services (SurgeryInvoice_ProviderID, EstimatedCost, Cost, 
Discount, PPODiscount, DueDate, AmountDue, AccountNumber, Active, DateAdded, Temp_ServiceID, Temp_CompanyID)

--Select * From SurgeryInvoice_Providers
--Where SurgeryInvoice_Providers.Temp_InvoiceID = 2883

--Select * From DATAMIGRATION_DMA_SURGERY_Services
--Where [Invoicenumber] = 2883


Select SurgeryInvoice_Providers.ID, DATAMIGRATION_DMA_SURGERY_SERVICES.Cost, 
DATAMIGRATION_DMA_SURGERY_SERVICES.Cost, 
1 - DATAMIGRATION_DMA_SURGERY_SERVICES.discount,--<--Leaving as is until checked 
DATAMIGRATION_DMA_SURGERY_SERVICES.PPODiscount as PPODiscount, 
DATAMIGRATION_DMA_SURGERY_SERVICES.DueDate, 
DATAMIGRATION_DMA_SURGERY_SERVICES.AmountDue, '' as AccountNumber, 1, @DateTimeVal , Temp_ServiceID, 2 
-- SELECT *

From DATAMIGRATION_DMA_SURGERY_SERVICES inner join SurgeryInvoice_Providers  
on DATAMIGRATION_DMA_SURGERY_SERVICES.[InvoiceNumber] = SurgeryInvoice_Providers.Temp_InvoiceID
and DATAMIGRATION_DMA_SURGERY_Services.provider = SurgeryInvoice_Providers.Temp_ProviderID

--WHERE SurgeryInvoice_Providers.Temp_InvoiceID = 2883
--order by DATAMIGRATION_DMA_SURGERY_SERVICES.Cost

	PRINT '-- SURGERYINVOICE_PROVIDER_SERVICES INSERT COMPLETE--'


---------------------------Insert Surgery CPT Codes in the event not on disk -----------

Insert into CPTCodes (Active, Code, CompanyID, DateAdded, Description)

Select 1, CPtCode, 2, @DateTimeVal, IsNull(Min(DATAMIGRATION_DMA_SURGERY_CPTCHARGES.[Description]), 'None Provided')
From DATAMIGRATION_DMA_SURGERY_CPTCharges left join CPTCodes 
on DATAMIGRATION_DMA_SURGERY_CPTCharges.cptcode  = CPTCodes.Code
WHERE CPTCodes.Code is null and Len(CPTCode) > 1
Group By CPTCode

	PRINT '--CPTCODES INSERT COMPLETE--'


--------------------------- Insert SurgeryInvoice_Provider_CPTCode -------------------

--- NEED TO VERIFY THAT IMPORTED CPT CODES (from Disk) are not missing any codes that are currently in use in DATAMIGRATION_DMA_SURGERY_CPTCODES

Insert Into SurgeryInvoice_Provider_CPTCodes (SurgeryInvoice_ProviderID, CPTCodeID, Amount, Description, Active, DateAdded, Temp_CompanyID, Temp_InvoiceID)
Select SurgeryInvoice_Providers.ID, CPTCodes.ID, isnull(DATAMIGRATION_DMA_SURGERY_CPTCharges.Amount, 0), 

Case WHEN DATAMIGRATION_DMA_SURGERY_CPTCharges.Description is null then 'Not Provided'
WHEN  DATAMIGRATION_DMA_SURGERY_CPTCharges.Description is not null then DATAMIGRATION_DMA_SURGERY_CPTCharges.description
END
,
  1, @DateTimeVal , 2, DATAMIGRATION_DMA_SURGERY_CPTCharges.[Invoice Number]
--Select * 
From DATAMIGRATION_DMA_SURGERY_CPTCharges inner join SurgeryInvoice_Providers  
on DATAMIGRATION_DMA_SURGERY_CPTCharges.[Invoice Number] = SurgeryInvoice_Providers.Temp_InvoiceID
and DATAMIGRATION_DMA_SURGERY_CPTCharges.Provider = SurgeryInvoice_Providers.Temp_ProviderID
inner join CPTCodes on DATAMIGRATION_DMA_SURGERY_CPTCharges.CPTCode  = CPTCodes.Code 
Where CPTCodes.CompanyID = 2 
--and DATAMIGRATION_DMA_SURGERY_CPTCharges.[Invoice Number] = 5836
order by Code



	PRINT '--SURGERYINVOICE_PROVIDER_CPTCODES INSERT COMPLETE--'



------------------- Insert Survery Invoice_Providers

/* ALREADY DONE ABOVE  Insert Into SurgeryInvoice_Providers (SurgeryInvoiceID, InvoiceProviderID, Active, DateAdded)

Select SurgeryInvoice_Surgery.ID, DATAMIGRATION_DMA_SURGERY_DMA.DateScheduled, 1, 1, '9/18/2012 3:07 PM' 
From SurgeryInvoice inner join DATAMIGRATION_DMA_SURGERY_DMA on 
SurgeryInvoice.Temp_InvoiceID = DATAMIGRATION_DMA_SURGERY_DMA.[Invoice Number]
inner join Surgery on Surgery.Name = DATAMIGRATION_DMA_SURGERY_DMA.SurgeryType
inner join SurgeryInvoice_Surgery on SurgeryInvoice_Surgery.SurgeryInvoiceID = SurgeryInvoice.ID
Where Surgery.CompanyID = 2 */




--------------------------INSERT INTO Invoice Table (Surgery)


--DISABLE TRIGGER t_Invoice_Insert_InvoiceNumber ON Invoice; n

Insert Into Invoice (InvoiceNumber, CompanyID, DateOfAccident,InvoiceStatusTypeID, isComplete, --InvoicePhysicianID,
InvoiceAttorneyID, InvoicePatientID, InvoiceTypeID, --TestInvoiceID, 
SurgeryInvoiceID, InvoiceClosedDate,
DatePaid, ServiceFeeWaived, LossesAmount, YearlyInterest, LoanTermMonths, ServiceFeeWaivedMonths, 
CalculatedCumulativeIntrest, Active, DateAdded)

SELECT dbo.DATAMIGRATION_DMA_SURGERY_dma.[Invoice Number] AS InvoiceNumber,
    2 AS CompanyID, 
    
    'DateOfAccident' = 
		Case When [Date Of Accident] = '1899-12-30' THEN
		'1/1/1900'
		When [Date Of Accident] is null THEN
		'1/1/1900'
		WHen [Date Of Accident] <> '1899-12-30' THEN
		[Date Of Accident]
		End,
    
    'InvoiceStatusTypeID' =  
		Case WHEN [Invoice Closed] = 1  or DatePaid is not null THEN 
		2
		WHEN ([Invoice Closed] = 0 or [Invoice Closed] is null) AND [BalanceDue] = 0  Or Cancelled = 1 THEN   
		2    
		WHEN ([Invoice Closed] = 0 or [Invoice Closed] IS NULL ) and [BalanceDue]  <> 0 and Cancelled <> 1  and GetDate() < [Invoice Date] + 390  THEN
		1
		WHEN ([Invoice Closed] = 0 or [Invoice Closed] IS NULL ) and [BalanceDue]  <> 0 and Cancelled <> 1  and GetDate() > [Invoice Date] + 390  THEN
		3    
	END,
        
	DATAMIGRATION_DMA_SURGERY_dma.CompleteFile AS isComplete,
	--0 as INvoicePhysicianID,
	InvoiceAttorney.ID AS InvoiceAttorneyID,
	InvoicePatient.ID as InvoicePatientID,
	2 as InvoiceTypeID, -- For Surgery
	--0 as TestINvoiceID,
	SurgeryInvoice.ID as SurgeryInvoiceID,
	[Invoice Closed Date] as InvoiceClosedDate,
	DatePaid as DatePaid,
	ServiceFeeWaived as ServiceFeeWaived,
	LossesAmount as LossesAmount,
	.15 as YearlyInterest,  11 as LoanTermMonths, -- shouldbestatic per spec (normally pulls from admin pages)
isNull(DATEDIFF(Month, DATAMIGRATION_DMA_SURGERY_DMA.DateScheduled, [dateservicefeebegins]), 0) as ServiceFeeWaivedMonths,-- should be static (pulls from admin page)

'CalculatedCumulativeIntrest' = 
	Case When [interestdue] is null Then
		IsNull((Select Sum(Amount) From DATAMIGRATION_DMA_SURGERY_PaymentsByAttorney 
		WHERE  DATAMIGRATION_DMA_SURGERY_PaymentsByAttorney.[Invoice Number] = DATAMIGRATION_DMA_SURGERY_DMA.[Invoice Number]
		and PaymentType = 'Interest'), 0) + ISNULL(ServiceFeeWaived,0)

		When [interestdue] = 0 Then
		IsNull((Select Sum(Amount) From DATAMIGRATION_DMA_SURGERY_PaymentsByAttorney 
		WHERE  DATAMIGRATION_DMA_SURGERY_PaymentsByAttorney.[Invoice Number] = DATAMIGRATION_DMA_SURGERY_DMA.[Invoice Number]
		and PaymentType = 'Interest'), 0) + ISNULL(ServiceFeeWaived,0)
		WHEN [interestdue] > 0.01 Then
		isnull([InterestDue], 0) + IsNull((Select Sum(Amount) From DATAMIGRATION_DMA_SURGERY_PaymentsByAttorney WHERE  DATAMIGRATION_DMA_SURGERY_PaymentsByAttorney.[Invoice Number] = DATAMIGRATION_DMA_SURGERY_DMA.[Invoice Number]
		and PaymentType = 'Interest'), 0)  - IsNull(ServiceFeeWaived, 0)
	End,

--(Select Sum(Amount) From Payments Where Temp_InvoiceID = DATAMIGRATION_DMA_SURGERY_DMA.[Invoice Number]and PaymentTypeID = 2) as TotalInterestPaid, 
--Note:  Old Data for Surgeries does not appear to keep the cumulative interest once it has been paid.  Therefore for import, if the Cumulative value = 0, we have to backwards calculate what the total interest 'was' before it was paid off to keep the records in check

	'Active' = 1,
	DATAMIGRATION_DMA_SURGERY_DMA.[DateScheduled] as DateAdded
	--Select *
	FROM dbo.DATAMIGRATION_DMA_SURGERY_dma 
	INNER JOIN
	dbo.Attorney ON 
	dbo.DATAMIGRATION_DMA_SURGERY_dma.[Attorney No] = dbo.Attorney.Temp_AttorneyID
	inner join Patient on Patient.Temp_InvoiceID = DATAMIGRATION_DMA_SURGERY_dma.[Invoice Number]
	inner join InvoicePatient on InvoicePatient.PatientID = Patient.ID
	inner join DATAMIGRATION_DMA_SHARED_Attorney_List on DATAMIGRATION_DMA_SHARED_Attorney_List.[Attorney No] = DATAMIGRATION_DMA_SURGERY_DMA.[Attorney No]
	inner join InvoiceAttorney on InvoiceAttorney.Temp_InvoiceNumber = DATAMIGRATION_DMA_SURGERY_DMA.[Invoice Number]
	and InvoiceAttorney.Temp_AttorneyID = DATAMIGRATION_DMA_SURGERY_DMA.[Attorney No]
	inner join SurgeryInvoice on SurgeryInvoice.Temp_InvoiceID = DATAMIGRATION_DMA_SURGERY_DMA.[Invoice Number]
	LEFT Join DATAMIGRATION_DMA_Surgery_CalcTestListTemp 
	on DATAMIGRATION_DMA_SURGERY_DMA.[Invoice Number] = DATAMIGRATION_DMA_SUrgery_CalcTestListTemp.InvoiceNumber
	
	Where DATAMIGRATION_DMA_SURGERY_DMA.[DateScheduled] is not null 
--	and DATAMIGRATION_DMA_SURGERY_DMA.[Invoice Number] = 8024
	order by DATAMIGRATION_DMA_SURGERY_dma.[Invoice Number]
	

-- ENABLE TRIGGER t_Invoice_Insert_InvoiceNumber ON Invoice;
	PRINT '--SURGERY INVOICE INSERT COMPLETE--'



--------------------------INSERT INTO Invoice Table (Testing)


--DISABLE TRIGGER t_Invoice_Insert_InvoiceNumber ON Invoice; n

Insert Into Invoice (InvoiceNumber, CompanyID, DateOfAccident,InvoiceStatusTypeID, isComplete, InvoicePhysicianID,
InvoiceAttorneyID, InvoicePatientID, InvoiceTypeID, TestInvoiceID, InvoiceClosedDate,
DatePaid, ServiceFeeWaived, LossesAmount, YearlyInterest, LoanTermMonths, ServiceFeeWaivedMonths, 
CalculatedCumulativeIntrest, Active, DateAdded)

SELECT dbo.DATAMIGRATION_DMA_TEST_dma.[Invoice Number] AS InvoiceNumber,
    2 AS CompanyID, 
    
    'DateOfAccident' = 
		Case When [Date Of Accident] = '1899-12-30' THEN
		'1/1/1900'
		When [Date Of Accident] is null THEN
		'1/1/1900'
		WHen [Date Of Accident] <> '1899-12-30' THEN
		[Date Of Accident]
		End,
    
    'InvoiceStatusTypeID' =  
		Case WHEN [Invoice Closed] = 1  or DatePaid is not null THEN 
		2
		WHEN ([Invoice Closed] = 0 or [Invoice Closed] is null) AND [BalanceDue] = 0  THEN   
		2    
		
		WHEN ([Invoice Closed] = 0 or [Invoice Closed] IS NULL ) and [BalanceDue]  <> 0   and (GetDate() < [Invoice Date] + 390 or [Invoice Date] is null) THEN  
		1
	
		WHEN ([Invoice Closed] = 0 or [Invoice Closed] IS NULL ) and [BalanceDue]  <> 0  and GetDate() > [Invoice Date] + 390  THEN
		3    
	END,
        
	DATAMIGRATION_DMA_TEST_dma.CompleteFile AS isComplete,
	InvoicePhysician.ID as InvoicePhysicianID,
	InvoiceAttorney.ID AS InvoiceAttorneyID,
	InvoicePatient.ID as InvoicePatientID,
	1 as InvoiceTypeID, -- For TEST
	--0 as TestINvoiceID,
	TestInvoice.ID as TestInvoiceID,
	[Invoice Closed Date] as InvoiceClosedDate,
	DatePaid as DatePaid,
	ServiceFeeWaived as ServiceFeeWaived,
	LossesAmount as LossesAmount,
	.15 as YearlyInterest,  11 as LoanTermMonths, -- shouldbestatic per spec (normally pulls from admin pages)
isNull(DATEDIFF(Month, DATAMIGRATION_DMA_TEST_DMA.AmortizationDate, [dateservicefeebegins]), 0) as ServiceFeeWaivedMonths,-- should be static (pulls from admin page)

'CalculatedCumulativeIntrest' = 
	Case When [interestdue] is null Then
		IsNull((Select Sum(Amount) From DATAMIGRATION_DMA_TEST_Payments 
		WHERE  DATAMIGRATION_DMA_TEST_Payments.[Invoice No] = DATAMIGRATION_DMA_Test_DMA.[Invoice Number]
		and [Payment Type] = 'Interest'), 0) + ISNULL(ServiceFeeWaived,0)

		When [interestdue] = 0 Then
		IsNull((Select Sum(Amount) From DATAMIGRATION_DMA_TEST_Payments 
		WHERE  DATAMIGRATION_DMA_TEST_Payments.[Invoice No] = DATAMIGRATION_DMA_TEST_DMA.[Invoice Number]
		and [Payment Type] = 'Interest'), 0) + ISNULL(ServiceFeeWaived,0)
		WHEN [interestdue] > 0.01 Then
		isnull([InterestDue], 0) + IsNull((Select Sum(Amount) From DATAMIGRATION_DMA_TEST_Payments WHERE  
		DATAMIGRATION_DMA_TEST_Payments.[Invoice No]  = DATAMIGRATION_DMA_TEST_DMA.[Invoice Number]
		and [Payment Type] = 'Interest'), 0)  - IsNull(ServiceFeeWaived, 0)
	End,

--(Select Sum(Amount) From Payments Where Temp_InvoiceID = DATAMIGRATION_DMA_SURGERY_DMA.[Invoice Number]and PaymentTypeID = 2) as TotalInterestPaid, 
--Note:  Old Data for Surgeries does not appear to keep the cumulative interest once it has been paid.  Therefore for import, if the Cumulative value = 0, we have to backwards calculate what the total interest 'was' before it was paid off to keep the records in check

	'Active' = 1,
	@DateTimeVal as DateAdded  -- Should be DateScheduled but needs to pull from test detail [Test Date]]
	--Select *
	FROM dbo.DATAMIGRATION_DMA_TEST_dma 
	INNER JOIN
	dbo.Attorney ON 
	dbo.DATAMIGRATION_DMA_TEST_dma.[Attorney No] = dbo.Attorney.Temp_AttorneyID
	inner join Patient on Patient.Temp_InvoiceID = DATAMIGRATION_DMA_TEST_dma.[Invoice Number]
	inner join InvoicePatient on InvoicePatient.PatientID = Patient.ID
	inner join DATAMIGRATION_DMA_SHARED_Attorney_List on DATAMIGRATION_DMA_SHARED_Attorney_List.[Attorney No] 
	= DATAMIGRATION_DMA_TEST_DMA.[Attorney No]
	inner join InvoiceAttorney on InvoiceAttorney.Temp_InvoiceNumber = DATAMIGRATION_DMA_TEST_DMA.[Invoice Number] 
	and InvoiceAttorney.Temp_AttorneyID = DATAMIGRATION_DMA_TEST_DMA.[Attorney No]
	inner join InvoicePhysician on InvoicePhysician.Temp_InvoiceNumber = DATAMIGRATION_DMA_TEST_DMA.[Invoice Number]
	and InvoicePhysician.Temp_PhysicianID = DATAMIGRATION_DMA_TEST_DMA.[Physician No] 
	inner join TestInvoice on TestInvoice.Temp_InvoiceID = DATAMIGRATION_DMA_TEST_DMA.[Invoice Number]
	LEFT Join DATAMIGRATION_DMA_SURGERY_CalcTestListTemp 
	on DATAMIGRATION_DMA_TEST_DMA.[Invoice Number] = DATAMIGRATION_DMA_SURGERY_CalcTestListTemp.InvoiceNumber
	
-- ENABLE TRIGGER t_Invoice_Insert_InvoiceNumber ON Invoice;
	PRINT '--INVOICE INSERT TESTS COMPLETE--'



----------------------------------- insert into Payments (SURGERY)---------------

Insert Into Payments (InvoiceID, PaymentTypeID, DatePaid, Amount, CheckNumber, Active, DateAdded, Temp_CompanyID, Temp_InvoiceID)
Select Invoice.ID, PaymentType.ID, DATAMIGRATION_DMA_SURGERY_PaymentsByAttorney.DatePaid, amount, 
DATAMIGRATION_DMA_SURGERY_PAYMENTSBYAttorney.[check], 
1, @DateTimeVal , 2, [invoice number]  
From DATAMIGRATION_DMA_SURGERY_PaymentsByAttorney inner join PaymentType on DATAMIGRATION_DMA_SURGERY_PaymentsByAttorney.PaymentType = PaymentType.Name 
inner join Invoice on DATAMIGRATION_DMA_SURGERY_PaymentsByAttorney.[Invoice Number] = Invoice.InvoiceNumber

	PRINT '--PAYMENTS INSERT COMPLETE--'
		

----------------------------------- insert into Payments (TESTS)---------------

Insert Into Payments (InvoiceID, PaymentTypeID, DatePaid, Amount, CheckNumber, Active, DateAdded, Temp_CompanyID, Temp_InvoiceID)
Select Invoice.ID, PaymentType.ID, DATAMIGRATION_DMA_TEST_Payments.[Date Paid], amount, 
DATAMIGRATION_DMA_TEST_Payments.[check no], 
1, @DateTimeVal , 2, [invoice no]  
From DATAMIGRATION_DMA_TEST_Payments inner join PaymentType on DATAMIGRATION_DMA_TEST_Payments.[Payment Type] = PaymentType.Name 
inner join Invoice on DATAMIGRATION_DMA_TEST_Payments.[Invoice No] = Invoice.InvoiceNumber

	PRINT '--PAYMENTS INSERT COMPLETE--'


------------------------------------ insert into SurgeryInvoice_Provider_Payments

Insert into SurgeryInvoice_Provider_Payments (SurgeryInvoice_ProviderID, PaymentTypeID, DatePaid, Amount, CheckNumber, Active, DateAdded, Temp_CompanyID)
Select SurgeryInvoice_Providers.ID, Paymenttype.ID , DatePaid, Amount, isnull(DATAMIGRATION_DMA_SURGERY_PaymentsToProviders.[Check], '0000'),  
1, @DateTimeVal, 2 
From SurgeryInvoice_Providers inner join DATAMIGRATION_DMA_SURGERY_PaymentsToProviders 
on DATAMIGRATION_DMA_SURGERY_PaymentsToProviders.[Invoice Number] = SurgeryInvoice_Providers.Temp_InvoiceID and
DATAMIGRATION_DMA_SURGERY_PaymentsToProviders.provider = SurgeryInvoice_Providers.Temp_ProviderID
inner join PaymentType on DATAMIGRATION_DMA_SURGERY_PaymentsToProviders.PaymentType = PaymentType.Name 
Where DatePaid is not null

	PRINT '--SURGERYINVOICE_PROVIDER_PAYMENTS INSERT COMPLETE--'



--Select * From Invoice Where InvoiceNumber = 8024

-- WHERE IS TESTING Provider Payment Info???

------------------------------------ STARTS Patient Record Consolidation Process ----------------------------------------------
--Select * From Invoice

Update  Patient 
Set SSN = '000000000'
Where LEN(SSN) < 3

Update Patient
Set  SSN = REPLACE(ssn, '-', '')
Where SSN Like '%-%'

--- Complete Four Times:  Time 1 of 4

Delete From Temp_PatientrecordConsolidation

Insert Into Temp_PatientrecordConsolidation (Original_PatientID, Temp_InvoiceID, New_PatientID, FirstName, LastName, SSN)
Select Min(ID), Min(Temp_InvoiceID), Max(ID), FirstName, LastName, SSN From Patient
where Active = 1
Group By FirstName, LastName, SSN


Update InvoicePatient
Set PatientID = New_PatientID
From InvoicePatient Inner Join Temp_PatientRecordConsolidation on InvoicePatient.PatientID = Temp_PatientRecordConsolidation.Original_PatientID

Update Patient
Set Active = 0
From Patient inner join Temp_PatientRecordConsolidation On Patient.ID = Temp_PatientRecordConsolidation.Original_PatientID
Where Original_PatientID <> New_PatientID


--- Complete Four Times:  Time 2 of 4

Delete From Temp_PatientrecordConsolidation

Insert Into Temp_PatientrecordConsolidation (Original_PatientID, Temp_InvoiceID, New_PatientID, FirstName, LastName, SSN)
Select Min(ID), Min(Temp_InvoiceID), Max(ID), FirstName, LastName, SSN From Patient
where Active = 1
Group By FirstName, LastName, SSN


Update InvoicePatient
Set PatientID = New_PatientID
From InvoicePatient Inner Join Temp_PatientRecordConsolidation on InvoicePatient.PatientID = Temp_PatientRecordConsolidation.Original_PatientID

Update Patient
Set Active = 0
From Patient inner join Temp_PatientRecordConsolidation On Patient.ID = Temp_PatientRecordConsolidation.Original_PatientID
Where Original_PatientID <> New_PatientID


--- Complete Four Times:  Time 3 of 4

Delete From Temp_PatientrecordConsolidation

Insert Into Temp_PatientrecordConsolidation (Original_PatientID, Temp_InvoiceID, New_PatientID, FirstName, LastName, SSN)
Select Min(ID), Min(Temp_InvoiceID), Max(ID), FirstName, LastName, SSN From Patient
where Active = 1
Group By FirstName, LastName, SSN


Update InvoicePatient
Set PatientID = New_PatientID
From InvoicePatient Inner Join Temp_PatientRecordConsolidation on InvoicePatient.PatientID = Temp_PatientRecordConsolidation.Original_PatientID

Update Patient
Set Active = 0
From Patient inner join Temp_PatientRecordConsolidation On Patient.ID = Temp_PatientRecordConsolidation.Original_PatientID
Where Original_PatientID <> New_PatientID


--- Complete Four Times:  Time 4 of 4

Delete From Temp_PatientrecordConsolidation

Insert Into Temp_PatientrecordConsolidation (Original_PatientID, Temp_InvoiceID, New_PatientID, FirstName, LastName, SSN)
Select Min(ID), Min(Temp_InvoiceID), Max(ID), FirstName, LastName, SSN From Patient
where Active = 1
Group By FirstName, LastName, SSN


Update InvoicePatient
Set PatientID = New_PatientID
From InvoicePatient Inner Join Temp_PatientRecordConsolidation on InvoicePatient.PatientID = Temp_PatientRecordConsolidation.Original_PatientID

Update Patient
Set Active = 0
From Patient inner join Temp_PatientRecordConsolidation On Patient.ID = Temp_PatientRecordConsolidation.Original_PatientID
Where Original_PatientID <> New_PatientID



END
GO
PRINT N'Creating [dbo].[f_GetTestCountByType]'
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 6/18/2012
-- Description:	Gets test count for specific test type
-- =============================================
CREATE FUNCTION [dbo].[f_GetTestCountByType]
(
	@InvoiceID int,
	@TestTypeID int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result int

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = Count(T.ID)
	FROM Invoice I 
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
			LEFT JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1
			LEFT JOIN Test T ON T.ID=TIT.TestID AND T.Active=1
	WHERE I.ID = @InvoiceID AND TI.TestTypeID = @TestTypeID

	-- Return the result of the function
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[f_GetTestPaymentsToProvider]'
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 6/21/2012
-- Description:	Gets the sum of the payments to the provider for a specific invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetTestPaymentsToProvider] 
(
	-- Add the parameters for the function here
	@InvoiceID int
)
RETURNS decimal(18,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result decimal(18,2)

	SELECT @Result = (ISNULL(SUM(TIT.DepositToProvider), 0) + ISNULL(SUM(TIT.AmountPaidToProvider), 0))
	FROM Invoice I 
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
		JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1
	WHERE I.ID = @InvoiceID
	
	-- Return the result of the function
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[f_GetSurgeryPaymentsSummary]'
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/20/2012
-- Description:	Returns Surgery Invoice Payments Summary
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    03/20/2012   Aaron     Created function from stored proc
*******************************/
CREATE FUNCTION [dbo].[f_GetSurgeryPaymentsSummary] 
(
	@InvoiceID int,
	@InvoiceProviderID int,
	@StartDate datetime,
	@EndDate datetime
)
RETURNS 
@InvoicePaymentsSummary TABLE (AccountNumber varchar(100), DueDate varchar(1000), TotalEstimatedCost decimal(18,2), BilledAmount decimal(18,2),
								DepositToProvider decimal(18,2), DiscountAmount decimal(18,2), AmountDue decimal(18,2))
AS
BEGIN

DECLARE @AccountNumber varchar(100)
DECLARE @ProviderDueDate varchar(1000)

-- Get Account Number combined string
SELECT @AccountNumber = CASE WHEN SIPS.AccountNumber != '' OR SIPS.AccountNumber != NULL THEN COALESCE(@AccountNumber + ', ', '') + CONVERT(varchar, SIPS.AccountNumber, 1) END,
		@ProviderDueDate = COALESCE(@ProviderDueDate + ', ', '') + CONVERT(varchar, SIPS.DueDate, 1)
FROM Invoice AS I
INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
LEFT JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
JOIN SurgeryInvoice_Provider_Services SIPS ON SIPS.SurgeryInvoice_ProviderID=SIP.ID AND SIPS.Active=1
WHERE I.ID = @InvoiceID AND SIP.InvoiceProviderID = @InvoiceProviderID AND SIPS.DueDate BETWEEN @StartDate AND @EndDate
Order By SIPS.DueDate

-- Insert Account and Provider
INSERT INTO @InvoicePaymentsSummary (AccountNumber, DueDate)
	VALUES (@AccountNumber, @ProviderDueDate)	

UPDATE @InvoicePaymentsSummary 
	Set TotalEstimatedCost = (SELECT DISTINCT (SELECT SUM(EstimatedCost) FROM SurgeryInvoice_Provider_Services SIPS WHERE SIPS.SurgeryInvoice_ProviderID=SIP.ID AND SIPS.Active=1) as EstimatedCost
								FROM Invoice AS I
								INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
								LEFT JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
								JOIN SurgeryInvoice_Provider_Services SIPS ON SIPS.SurgeryInvoice_ProviderID=SIP.ID AND SIPS.Active=1
								WHERE I.ID = @InvoiceID AND SIP.InvoiceProviderID = @InvoiceProviderID AND SIPS.DueDate BETWEEN @StartDate AND @EndDate),
		
		BilledAmount = (SELECT DISTINCT (SELECT SUM(SIPSs.Cost) FROM SurgeryInvoice_Provider_Services SIPSs WHERE SIPSs.SurgeryInvoice_ProviderID=SIP.ID AND SIPSs.Active=1) as Cost
							FROM Invoice AS I
							INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
							LEFT JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
							JOIN SurgeryInvoice_Provider_Services SIPS ON SIPS.SurgeryInvoice_ProviderID=SIP.ID AND SIPS.Active=1
							WHERE I.ID = @InvoiceID AND SIP.InvoiceProviderID = @InvoiceProviderID AND SIPS.DueDate BETWEEN @StartDate AND @EndDate),
		
		DiscountAmount = (SELECT DISTINCT ISNULL((SELECT SUM(SIPSss.Cost) FROM SurgeryInvoice_Provider_Services SIPSss WHERE SIPSss.SurgeryInvoice_ProviderID=SIP.ID AND SIPSss.Active=1),0) - 
											ISNULL((SELECT SUM(SIPSsss.AmountDue) FROM SurgeryInvoice_Provider_Services SIPSsss WHERE SIPSsss.SurgeryInvoice_ProviderID=SIP.ID AND SIPSsss.Active=1),0) as DiscountAmount
							FROM Invoice AS I
							INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
							LEFT JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
							JOIN SurgeryInvoice_Provider_Services SIPS ON SIPS.SurgeryInvoice_ProviderID=SIP.ID AND SIPS.Active=1
							WHERE I.ID = @InvoiceID AND SIP.InvoiceProviderID = @InvoiceProviderID AND SIPS.DueDate BETWEEN @StartDate AND @EndDate),
		
		AmountDue = (SELECT DISTINCT ISNULL((SELECT SUM(ISNULL(SIPSsssa.AmountDue,0)) FROM SurgeryInvoice_Provider_Services SIPSsssa WHERE SIPSsssa.SurgeryInvoice_ProviderID=SIP.ID AND SIPSsssa.Active=1),0) -
									 ISNULL((SELECT SUM(ISNULL(SIPP.Amount, 0)) FROM SurgeryInvoice_Provider_Payments SIPP WHERE SIPP.SurgeryInvoice_ProviderID=SIP.ID AND SIPP.Active=1),0) as AmountDue	
							FROM Invoice AS I
							INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
							LEFT JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
							JOIN SurgeryInvoice_Provider_Services SIPS ON SIPS.SurgeryInvoice_ProviderID=SIP.ID AND SIPS.Active=1
							WHERE I.ID = @InvoiceID AND SIP.InvoiceProviderID = @InvoiceProviderID AND SIPS.DueDate BETWEEN @StartDate AND @EndDate),
							
		DepositToProvider = (SELECT DISTINCT ISNULL((SELECT SUM(ISNULL(SIPP.Amount, 0)) FROM SurgeryInvoice_Provider_Payments SIPP WHERE SIPP.SurgeryInvoice_ProviderID=SIP.ID AND SIPP.Active=1 AND SIPP.PaymentTypeID=3),0) as DepositAmount	
							FROM Invoice AS I
							INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
							LEFT JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
							JOIN SurgeryInvoice_Provider_Services SIPS ON SIPS.SurgeryInvoice_ProviderID=SIP.ID AND SIPS.Active=1
							WHERE I.ID = @InvoiceID AND SIP.InvoiceProviderID = @InvoiceProviderID AND SIPS.DueDate BETWEEN @StartDate AND @EndDate)

	RETURN 
END
GO
PRINT N'Creating [dbo].[procAccountsPayableReport]'
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/19/2012
-- Description:	Accounts Payable Report Data
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    03/19/2012   Aaron     Created proc
** 2	12/20/2012	 Czarina   Adjusted Testing Invoice AmountDue Calc because all amounts were duplicating the Deposit and giving a negative number on report
** 3	4/26/2013	 Brad Conley	Case 951802: Show both Open and Closed Invoices.
** 4	1/31/2014	Brad Conley		Case 1006403: Added the TestInvoice_Test ID parameter to the GetFirstTestDate function
*******************************/
CREATE PROCEDURE [dbo].[procAccountsPayableReport]
	@StartDate datetime = null, 
	@EndDate datetime = null,
	@CompanyId int = -1,
	@ProviderId int = -1
AS
BEGIN
	SET NOCOUNT ON;
	
DECLARE @ClosedStatusTypeID INT = 2
DECLARE @TestTypeID INT = 1
DECLARE @SurgeryTypeID INT = 2
(
	SELECT
		'Testing' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		--dbo.f_GetFirstTestDate(I.ID, TIT.ID) AS [ServiceDate],
		dbo.f_GetFirstTestDateAccountsPayableReport(I.ID, TIT.ID) AS [ServiceDate],
		IP.ProviderID AS ProviderID,
		IP.Name AS Provider,
		TIT.AccountNumber AS AccountNumber,
		Convert(varchar,TIT.ProviderDueDate,1) as ProviderDueDate, 
		InvP.FirstName AS PatientFirstName,
		InvP.LastName AS PatientLastName,
		InvP.LastName + ', ' + InvP.FirstName AS PatientDisplayName,
		0 AS TotalEstimatedCost,
		ISNULL(TIT.TestCost,0) AS BilledAmount,
		ISNULL(TIT.DepositToProvider,0) AS DepositToProvider,
---		(ISNULL(TIT.TestCost,0) - ISNULL(TIT.AmountToProvider, 0)) AS DiscountAmount,
----	(ISNULL(TIT.PPODiscount,0)) AS DiscountAmount, -- CCW:  12/20/12:  trying to get accurate discount amount
		ISNULL(TIT.TestCost,0) - ISNULL(TIT.AmountToProvider,0) AS DiscountAmount, -- CCW:  01/18/13:  trying to get accurate discount amount
---		(ISNULL(TIT.AmountToProvider,0) - ISNULL(TIT.DepositToProvider,0) - ISNULL(TIT.AmountPaidToProvider,0)) AS AmountDue,
--		ISNULL(TIT.TestCost,0) - ISNULL(TIT.DepositToProvider,0) - (ISNULL(TIT.PPODiscount,0))- ISNULL(TIT.AmountPaidToProvider,0) AS AmountDue,
--		ISNULL(TIT.AmountToProvider,0)- ISNULL(TIT.DepositToProvider,0) - ISNULL(TIT.AmountPaidToProvider,0) AS AmountDue, --CCW:  01/22/13 
		-- Updated line above to be BilledAmount - DepositToProvider - DiscountAmount - AmountPaidToProvider = AmountDue
		CASE
		when ISNULL(TIT.AmountToProvider,0)- ISNULL(TIT.DepositToProvider,0) - ISNULL(TIT.AmountPaidToProvider,0) = 1 THEN 0
		ELSE ISNULL(TIT.AmountToProvider,0)- ISNULL(TIT.DepositToProvider,0) - ISNULL(TIT.AmountPaidToProvider,0) END AS AmountDue,
		--CASE 993929 The above case statement turns the amountdue to 0 if it's equal to 1 because tests with $1 are 'closed'
		co.LongName as CompanyName,
		I.InvoiceStatusTypeID as StatusType
	FROM Invoice I
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
		LEFT JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1
		LEFT JOIN InvoiceProvider IP ON IP.ID=TIT.InvoiceProviderID AND IP.Active=1
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		LEFT JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		JOIN InvoicePatient InvP ON InvP.ID=I.InvoicePatientID AND InvP.Active=1
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @TestTypeID
	AND (@ProviderId = -1 or IP.ProviderID = @ProviderId)
		AND TIT.ProviderDueDate BETWEEN @StartDate AND @EndDate
		AND ISNULL(TIT.TestCost,0) > 1
		--AND I.InvoiceStatusTypeID != @ClosedStatusTypeID
		-- Case 951802: Display Open and Closed Invoices
)
UNION
(
	SELECT DISTINCT
		'Surgery' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		dbo.f_GetFirstSurgeryDate(I.ID) AS [ServiceDate],
		IP.ProviderID AS ProviderID,
		IP.Name AS Provider,
		sps.AccountNumber AS AccountNumber,
		sps.DueDate AS ProviderDueDate,
		InvP.FirstName AS PatientFirstName,
		InvP.LastName AS PatientLastName,
		InvP.LastName + ', ' + InvP.FirstName As PatientDisplayName,
		sps.TotalEstimatedCost AS TotalEstimatedCost,
		sps.BilledAmount AS BilledAmount,
		sps.DepositToProvider AS DepositToProvider,
		sps.DiscountAmount AS DiscountAmount,
		sps.AmountDue AS AmountDue,
		co.LongName as CompanyName,
		I.InvoiceStatusTypeID as StatusType
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		LEFT JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		JOIN InvoicePatient InvP ON InvP.ID=I.InvoicePatientID AND InvP.Active=1
		JOIN SurgeryInvoice SI ON SI.ID=I.SurgeryInvoiceID AND SI.Active=1
		JOIN SurgeryInvoice_Providers SIP ON SIP.SurgeryInvoiceID=SI.ID AND SIP.Active=1
		LEFT JOIN SurgeryInvoice_Provider_Services SIPS ON SIPS.SurgeryInvoice_ProviderID=SIP.ID AND SIPS.Active=1
		LEFT JOIN InvoiceProvider IP ON IP.ID=SIP.InvoiceProviderID AND IP.Active=1
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
		outer apply dbo.f_GetSurgeryPaymentsSummary(I.ID, SIP.InvoiceProviderID, @StartDate, @EndDate) sps
	WHERE I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @SurgeryTypeID
	AND (@ProviderId = -1 or IP.ProviderID = @ProviderId)
		AND SIPS.DueDate BETWEEN @StartDate AND @EndDate
		AND sps.BilledAmount > 0
		--AND I.InvoiceStatusTypeID != @ClosedStatusTypeID
		-- Case 951802 Display Open and Closed Invoices
)

END
GO
PRINT N'Creating [dbo].[procAttorneyLetter]'
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 6/18/2012
-- Description:	Attorney Letter Report
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    03/19/2012   Aaron     Created proc
*******************************/
CREATE PROCEDURE [dbo].[procAttorneyLetter]
	@CompanyId int = -1,
	@AttorneyId int = -1
AS
BEGIN
	SET NOCOUNT ON;
	
DECLARE @ClosedStatusTypeID INT = 2
DECLARE @PrinciplePaymentTypeID INT = 1
DECLARE @DepositPaymentTypeID INT = 3
DECLARE @CreditPaymentTypeID INT = 5
DECLARE @RefundPaymentTypeID INT = 4
DECLARE @TestTypeID INT = 1
DECLARE @SurgeryTypeID INT = 2
(
	SELECT
		'Test' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		A.FirstName AS AttorneyFirstName,
		A.LastName AS AttorneyLastName,
		A.LastName + ', ' + A.FirstName AS AttorneyDisplayName,
		A.Street1 AS AttorneyAddress1,
		A.Street2 AS AttorneyAddress2,
		A.City AS AttorneyCity,
		S.Abbreviation AS AttorneyState,
		A.ZipCode AS AttorneyZipCode,
		InvF.Name AS FirmName,
		I.isComplete AS InvoiceCompleted,
		co.LongName as CompanyName,
		I.InvoiceStatusTypeID as StatusType
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		JOIN Attorney A on IA.AttorneyID = A.ID
		JOIN States S ON IA.StateID = S.ID
		LEFT JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE I.InvoiceStatusTypeID != @ClosedStatusTypeID
		AND I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @TestTypeID
		AND (@AttorneyId = -1 or A.ID = @AttorneyId)
)
UNION
(
	SELECT
		'Procedure' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		A.FirstName AS AttorneyFirstName,
		A.LastName AS AttorneyLastName,
		A.LastName + ', ' + A.FirstName AS AttorneyDisplayName,
		A.Street1 AS AttorneyAddress1,
		A.Street2 AS AttorneyAddress2,
		A.City AS AttorneyCity,
		S.Abbreviation AS AttorneyState,
		A.ZipCode AS AttorneyZipCode,
		InvF.Name AS FirmName,
		I.isComplete AS InvoiceCompleted,
		co.LongName as CompanyName,
		I.InvoiceStatusTypeID as StatusType
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		JOIN Attorney A on IA.AttorneyID = A.ID
		JOIN States S ON IA.StateID = S.ID
		LEFT JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE I.InvoiceStatusTypeID != @ClosedStatusTypeID
		AND I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @SurgeryTypeID
		AND (@AttorneyId = -1 or A.ID = @AttorneyId)
)

END
GO
PRINT N'Creating [dbo].[procCashReport]'
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/19/2012
-- Description:	Cash Report Data
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    06/21/2012   Aaron     Created proc
** 2	06/27/2012	 Andy	   Select IA.AttorneyID as AttorneyID (instead of IA.ID as AttorneyID)
**							   f_GetFirstTestDate for Tests instead of f_GetFirstSurgeryDate
** 3    01/03/2013   Cherie    Removed criteria for Test 
** 4    01/04/2013   Cherie    Removed criteria for Surgery
*******************************/
CREATE PROCEDURE [dbo].[procCashReport]
	@StartDate datetime = null, 
	@EndDate datetime = null,
	@CompanyId int = -1
AS
BEGIN
	SET NOCOUNT ON;
	
DECLARE @ClosedStatusTypeID INT = 2
DECLARE @PrinciplePaymentTypeID INT = 1
DECLARE @DepositPaymentTypeID INT = 3
DECLARE @InterestPaymentTypeID INT = 2
DECLARE @RefundPaymentTypeID INT = 4
DECLARE @TestTypeID INT = 1
DECLARE @SurgeryTypeID INT = 2
(
	SELECT
		'Test' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		IA.AttorneyID AS AttorneyID,
		A.FirstName AS AttorneyFirstName,
		A.LastName AS AttorneyLastName,
		A.LastName + ', ' + A.FirstName AS AttorneyDisplayName,
		InvP.FirstName AS PatientFirstName,
		InvP.LastName AS PatientLastName,
		InvP.LastName + ', ' + InvP.FirstName AS PatientDisplayName,
		ISNULL(tis.TotalDeposits,0) AS DepositPayments,
	    ISNULL(tis.ServiceFeeReceived,0) AS InterestPayments,
	    ISNULL(tis.TotalPrincipal,0) AS PrinicipalPayments,
	    (ISNULL(tis.TotalDeposits,0) + ISNULL(tis.ServiceFeeReceived,0) + ISNULL(tis.TotalPrincipal,0)) AS NetRecieved,
	    ISNULL(dbo.f_GetTestPaymentsToProviderByDate(I.ID, @StartDate, @EndDate),0) AS PaymentsToProvider,
	    co.LongName as CompanyName,
		I.InvoiceStatusTypeID as StatusType
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		join Attorney A on IA.AttorneyID = A.ID 
		LEFT JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		JOIN InvoicePatient InvP ON InvP.ID=I.InvoicePatientID AND InvP.Active=1
		outer apply dbo.f_GetTestInvoiceSummaryTableByDate(I.ID, @StartDate, @EndDate) tis
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE --I.InvoiceStatusTypeID != @ClosedStatusTypeID AND --modified based on customer feedback cbw 1/3/2013
		I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @TestTypeID
		AND I.ID In (Select t.InvoiceID from dbo.f_GetTestInvoicesForCashReport(@CompanyId, @StartDate, @EndDate) t)

)
UNION
(
	SELECT
		'Procedure' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		IA.AttorneyID AS AttorneyID,
		A.FirstName AS AttorneyFirstName,
		A.LastName AS AttorneyLastName,
		A.LastName + ', ' + A.FirstName AS AttorneyDisplayName,
		InvP.FirstName AS PatientFirstName,
		InvP.LastName AS PatientLastName,
		InvP.LastName + ', ' + InvP.FirstName As PatientDisplayName,
		ISNULL(sisum.TotalDeposits,0) AS DepositPayments,
	    ISNULL(sisum.ServiceFeeReceived,0) AS InterestPayments,
	    ISNULL(sisum.TotalPrincipal,0) AS PrinicipalPayments,
	    (ISNULL(sisum.TotalDeposits,0) + ISNULL(sisum.ServiceFeeReceived,0) + ISNULL(sisum.TotalPrincipal,0)) AS NetRecieved,
	    ISNULL(dbo.f_GetSurgeryPaymentsToProviderByDate(I.ID, @StartDate, @EndDate),0) AS PaymentsToProvider,
	    co.LongName as CompanyName,
		I.InvoiceStatusTypeID as StatusType
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		join Attorney A on IA.AttorneyID = A.ID 
		LEFT JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		JOIN InvoicePatient InvP ON InvP.ID=I.InvoicePatientID AND InvP.Active=1
		outer apply dbo.f_GetSurgeryInvoiceSummaryTableByDate(I.ID, @StartDate, @EndDate) sisum
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE --I.InvoiceStatusTypeID != @ClosedStatusTypeID AND --modified based on customer feedback cbw 1/4/2013
	    I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @SurgeryTypeID
		AND I.ID In (select s.InvoiceID from dbo.f_GetSurgeryInvoicesForCashReport(@CompanyId, @StartDate, @EndDate) s)
)

END
GO
PRINT N'Creating [dbo].[procSearchInvoice_GetByFirstServiceDate]'
GO
CREATE PROCEDURE [dbo].[procSearchInvoice_GetByFirstServiceDate]


 @SearchDate datetime

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

declare @SearchDateStr varchar(10) = Convert(varchar(10),@SearchDate,101)
declare @TopDateTable table(InvID int, InvoicePatientID int, TopTestDate datetime, TopSurgeryDate datetime)

insert into @TopDateTable
select Inv.ID, Inv.InvoicePatientID, 
	(select top 1 TestDate
		from TestInvoice as TI
		inner join TestInvoice_Test as TIT on TI.ID = TIT.TestInvoiceID
		inner join Invoice as I on TI.ID = I.TestInvoiceID
		Where I.ID = Inv.ID
		and I.Active = 1
		and TI.Active = 1
		and TIT.Active = 1
		order by TestDate asc) as topTestDate,
	(select top 1 SISD.ScheduledDate
		from SurgeryInvoice as SI
		inner join SurgeryInvoice_Surgery as SIS on SI.ID = SIS.SurgeryInvoiceID
		inner join Invoice as I on SI.ID = I.SurgeryInvoiceID
		inner join SurgeryInvoice_SurgeryDates as SISD on SIS.ID = SISD.SurgeryInvoice_SurgeryID
		where I.ID = Inv.ID
		and I.Active = 1
		and SI.Active = 1
		and SIS.Active = 1
		and SISD.Active = 1
		order by SISD.ScheduledDate asc) as topSurgeryDate
from Invoice as Inv


select distinct P.ID
from @TopDateTable
inner join InvoicePatient as IP on InvoicePatientID = IP.ID
inner join Patient as P on PatientID = P.ID
where Convert(varchar(10),TopSurgeryDate,101) = @SearchDateStr
or Convert(varchar(10),TopTestDate,101) = @SearchDateStr

END
GO
PRINT N'Creating [dbo].[procTestsByAttorney]'
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 6/18/2012
-- Description:	Total Tests By Attorney
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    03/19/2012   Aaron     Created proc
*******************************/
CREATE PROCEDURE [dbo].[procTestsByAttorney]
	@StartDate datetime = null, 
	@EndDate datetime = null,
	@CompanyId int = -1
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TestTypeID INT = 1
	DECLARE @ClosedStatusTypeID INT = 2

    SELECT 
		I.InvoiceNumber AS InvoiceNumber,
		dbo.f_GetFirstTestDate(I.ID) AS [ServiceDate],
		IP.Name AS Provider,
		dbo.f_GetTestProcedures(I.ID) as ServiceName,
		IA.FirstName AS AttorneyFirstName,
		IA.LastName AS AttorneyLastName,
		IA.LastName + ', ' + IA.FirstName AS AttorneyDisplayName,
		dbo.f_GetTestCountByType(I.ID, 2) AS MRITests,
		dbo.f_GetTestCountByType(I.ID, 1) AS PainManagementTests,
		dbo.f_GetTestCountByType(I.ID, 3) AS OtherDiagnostics,
		co.LongName as CompanyName,
		I.InvoiceStatusTypeID as StatusType
	FROM Invoice I
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
		LEFT JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1
		LEFT JOIN InvoiceProvider IP ON IP.ID=TIT.InvoiceProviderID AND IP.Active=1
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		LEFT JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		JOIN InvoicePatient InvP ON InvP.ID=I.InvoicePatientID AND InvP.Active=1
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE I.InvoiceStatusTypeID != @ClosedStatusTypeID
		AND I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @TestTypeID
		AND dbo.f_GetFirstTestDate(I.ID) BETWEEN @StartDate AND @EndDate
	
END
GO
PRINT N'Creating [dbo].[StoredProcedure1]'
GO
CREATE Procedure [dbo].[StoredProcedure1]
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
As
Select * from InvoiceProvider where InvoiceProvider.Temp_CompanyID = 1 and InvoiceProvider.Temp_InvoiceID  = 3212
	return 

GO
PRINT N'Creating [dbo].[StoredProcedure2]'
GO
Create Procedure [dbo].[StoredProcedure2]
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
As
Select * From TestInvoice_Test where TestInvoice_Test.Temp_CompanyID = 1 and TestInvoice_Test.Temp_InvoiceID in (1535, 1513)
order by ID
	return 

GO
PRINT N'Creating [dbo].[StoredProcedure3]'
GO
Create Procedure [dbo].[StoredProcedure3]
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
As

Select * From Patient Where CompanyID = 1 and Patient.Temp_InvoiceID in (1513, 1535)
	/* set nocount on */
	return 

GO
PRINT N'Creating [dbo].[StoredProcedure4]'
GO
Create Procedure [dbo].[StoredProcedure4]
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
As

select I.ID as InvoiceID,I.InvoiceNumber,I.CompanyID,I.InvoicePatientID,IP.Active as [InvoicePatient.Active],IP.PatientID,P.Active as [Patient.Active] from Invoice as Iinner join InvoicePatient as IP on I.InvoicePatientID = IP.IDinner join Patient as P on IP.PatientID = P.IDwhere InvoiceNumber in (1535,1827,1883,1885,1886,1956,2105)and I.CompanyID = 1


	return 

GO
PRINT N'Creating [dbo].[StoredProcedure5]'
GO
Create Procedure [dbo].[StoredProcedure5]
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
As


Select * From InvoicePatient Where DateAdded > '3/25/2014'
	return 

GO
PRINT N'Creating [dbo].[StoredProcedure6]'
GO
CREATE Procedure [dbo].[StoredProcedure6]
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
As
Select * From Patient  
Where Temp_InvoiceID in (2135,2136,2198,2315,2344 
)
and CompanyID = 1


	return 

GO
PRINT N'Creating [dbo].[f_GetAccountNumbers]'
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 7/13/2012
-- Description:	Returns all account numbers for specified criteria
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    07/13/2012   Aaron     Created function
*******************************/
CREATE FUNCTION [dbo].[f_GetAccountNumbers] 
(
	-- Add the parameters for the function here
	@InvoiceID int,
	@InvoiceProviderID int,
	@StartDate datetime,
	@EndDate datetime
)
RETURNS varchar(1000)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(1000)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = COALESCE(@Result + ', ', '') + CONVERT(varchar, SIPS.AccountNumber, 1)
	FROM Invoice AS I
	INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
	LEFT JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
	JOIN SurgeryInvoice_Provider_Services SIPS ON SIPS.SurgeryInvoice_ProviderID=SIP.ID AND SIPS.Active=1
	WHERE I.ID = @InvoiceID AND SIP.InvoiceProviderID = @InvoiceProviderID AND SIPS.DueDate BETWEEN @StartDate AND @EndDate
	
	-- Return the result of the function
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[procAttorneyStatments]'
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 7/12/2012
-- Description:	Attorney Statements Report Data
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    03/19/2012   Aaron     Created proc
*******************************/
CREATE PROCEDURE [dbo].[procAttorneyStatments]
	@StartDate datetime = null, 
	@EndDate datetime = null,
	@CompanyId int = -1
AS
BEGIN
	SET NOCOUNT ON;
	
DECLARE @ClosedStatusTypeID INT = 2
DECLARE @PrinciplePaymentTypeID INT = 1
DECLARE @DepositPaymentTypeID INT = 3
DECLARE @CreditPaymentTypeID INT = 5
DECLARE @RefundPaymentTypeID INT = 4
DECLARE @TestTypeID INT = 1
DECLARE @SurgeryTypeID INT = 2
(
	SELECT
		'Test' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		dbo.f_GetTestDates(I.ID) AS [ServiceDate],
		dbo.f_GetTestProvidersAbbrByInvoice(I.ID) AS Provider,
		dbo.f_GetTestProcedures(I.ID) as ServiceName,
		IA.FirstName AS AttorneyFirstName,
		IA.LastName AS AttorneyLastName,
		IA.LastName + ', ' + IA.FirstName AS AttorneyDisplayName,
		InvF.Name AS FirmName,
		InvP.FirstName AS PatientFirstName,
		InvP.LastName AS PatientLastName,
		InvP.LastName + ', ' + InvP.FirstName AS PatientDisplayName,
		dbo.f_GetTestCostTotal(I.ID) AS TotalCost,
		dbo.f_GetInvoicePaymentTotal(I.ID) AS PaymentAmount,
		dbo.f_GetTestPPODiscountTotal(I.ID) AS PPODiscount,
		tis.BalanceDue as BalanceDue,
		tis.CumulativeServiceFeeDue as ServiceFeeDue,
		tis.EndingBalance as EndingBalance,
		dbo.f_GetLastCommentFromInvoice(I.ID) As Comment,
		I.isComplete AS InvoiceCompleted,
		tis.MaturityDate As DueDate,
		co.LongName as CompanyName,
		dbo.f_GetFirstTestDate(I.ID) as SortServiceDate,
		I.InvoiceStatusTypeID as StatusType
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		LEFT JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		JOIN InvoicePatient InvP ON InvP.ID=I.InvoicePatientID AND InvP.Active=1
		outer apply dbo.f_GetTestInvoiceSummaryTableMinified(I.ID, null) tis
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE I.InvoiceStatusTypeID != @ClosedStatusTypeID AND I.isComplete = 1
		AND I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @TestTypeID
)
UNION
(
	SELECT
		'Procedure' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		CONVERT(varchar(1000),dbo.f_GetSurgeryDates(I.ID),1) AS [ServiceDate],
		dbo.f_GetSurgeryProvidersAbbrByInvoice(I.ID) AS Provider,
		dbo.f_GetSurgeryProcedures(I.ID) as ServiceName,
		IA.FirstName AS AttorneyFirstName,
		IA.LastName AS AttorneyLastName,
		IA.LastName + ', ' + IA.FirstName AS AttorneyName,
		InvF.Name AS FirmName,
		InvP.FirstName AS PatientFirstName,
		InvP.LastName AS PatientLastName,
		InvP.LastName + ', ' + InvP.FirstName As PatientName,
		dbo.f_GetSurgeryCostTotal(I.ID) AS TotalCost,
		dbo.f_GetInvoicePaymentTotal(I.ID) AS PaymentAmount,
		dbo.f_GetSurgeryPPODiscountTotal(I.ID) AS PPODiscount,
		sisum.BalanceDue as BalanceDue,
		sisum.CumulativeServiceFeeDue as ServiceFeeDue,
		sisum.EndingBalance as EndingBalance,
		dbo.f_GetLastCommentFromInvoice(I.ID) As Comment,
		I.isComplete AS InvoiceCompleted,
		sisum.MaturityDate As DueDate,
		co.LongName as CompanyName,
		dbo.f_GetFirstSurgeryDate(I.ID) as SortServiceDate,
		I.InvoiceStatusTypeID as StatusType
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		LEFT JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		JOIN InvoicePatient InvP ON InvP.ID=I.InvoicePatientID AND InvP.Active=1
		outer apply dbo.f_GetSurgeryInvoiceSummaryTableMinified(I.ID, null) sisum
		LEFT JOIN Comments c ON I.ID = c.InvoiceID AND c.Active=1 AND c.isIncludedOnReports = 1
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE I.InvoiceStatusTypeID != @ClosedStatusTypeID AND I.isComplete = 1
		AND I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @SurgeryTypeID
)

END
GO
PRINT N'Creating [dbo].[StoredProcedure7]'
GO
CREATE Procedure [dbo].[StoredProcedure7]
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
As

Select * From InvoiceINterestCalculationLog Where INvoiceID = 212564

--Select * From Invoice Where CompanYID = 1 and InvoiceNumber = 3514

	return 

GO
PRINT N'Creating [dbo].[procDiscountReport]'
GO
-- =============================================
-- Author:		Durel Hoover
-- Create date: 4/3/2014
-- Description:	Retrieves the Discount Report's data.
-- =============================================
CREATE PROCEDURE [dbo].[procDiscountReport] 
	-- Add the parameters for the stored procedure here
	@CompanyID INT,
	@StartDate DATE,
	@EndDate DATE,
	@AttorneyID INT = -1,
	@StatementDate datetime = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @TestTypeID INT = 1,
			@SurgeryTypeID INT = 2
			
	SELECT tblinv.CompanyID,
		   c.LongName							  AS "CompanyName",
		   tblInv.FirmID, 
		   f.Name                                 AS "FirmName", 
		   tblInv.AttorneyID, 
		   att.LastName                           AS "AttLastName", 
		   att.FirstName                          AS "AttFirstName", 
		   SUM(tblInv.BalanceDue)                 AS "TotalPrincipalDue", 
		   SUM(ISNULL(tblInv.LossesAmount, 0))    AS "PrincipalWaived", 
		   SUM(tblInv.CumulativeServiceFeeDue)    AS "TotalServiceFeeDue", 
		   SUM(ISNULL(tblInv.ServiceFeeWaived, 0))AS "ServiceFeeWaived" 
	FROM   ((SELECT inv.ID, 
					inv.InvoiceNumber,
					inv.CompanyID, 
					att.FirmID, 
					invAtt.AttorneyID, 
					tis.BalanceDue, 
					inv.LossesAmount, 
					tis.CumulativeServiceFeeDue, 
					inv.ServiceFeeWaived 
			 FROM   Invoice inv 
					INNER JOIN InvoiceAttorney invAtt 
							ON inv.InvoiceAttorneyID = invAtt.ID 
					INNER JOIN Attorney att 
							ON invAtt.AttorneyID = att.ID
					OUTER apply f_GetTestInvoiceSummaryTableMinified(inv.id, @StatementDate) tis 
			 WHERE  ( @AttorneyID <= 0 
					   OR invAtt.AttorneyID = @AttorneyID )
					AND @CompanyID = inv.CompanyID
					AND inv.InvoiceTypeID = @TestTypeID 
					AND inv.Active = 1 
					AND tis.BalanceDue > 0 
					AND @StartDate <= tis.FirstTestDate
					AND tis.FirstTestDate <= @EndDate) 
			UNION 
			(SELECT inv.ID, 
					inv.InvoiceNumber,
					inv.CompanyID, 
					att.FirmID, 
					invAtt.AttorneyID, 
					sis.BalanceDue, 
					inv.LossesAmount, 
					sis.CumulativeServiceFeeDue, 
					inv.ServiceFeeWaived 
			 FROM   Invoice inv 
					INNER JOIN InvoiceAttorney invAtt 
							ON inv.InvoiceAttorneyID = invAtt.ID 
					INNER JOIN Attorney att 
							ON invAtt.AttorneyID = att.ID
					OUTER apply f_GetSurgeryInvoiceSummaryTableMinified(inv.id, @StatementDate) sis 
			 WHERE  ( @AttorneyID <= 0 
					   OR invAtt.AttorneyID = @AttorneyID )
					AND @CompanyID = inv.CompanyID 
					AND inv.InvoiceTypeID = @SurgeryTypeID 
					AND inv.Active = 1 
					AND sis.BalanceDue > 0 
					AND @StartDate <= sis.FirstSurgeryDate 
					AND sis.FirstSurgeryDate <= @EndDate)) tblInv 
		   INNER JOIN Attorney att 
				   ON tblInv.AttorneyID = att.ID
		   INNER JOIN Company c
				   ON tblInv.CompanyID = c.ID 
		   LEFT JOIN Firm f 
				  ON tblInv.FirmID = f.ID 
	GROUP  BY tblInv.CompanyID,
			  c.LongName,
			  f.Name, 
			  tblInv.FirmID, 
			  att.LastName, 
			  att.FirstName, 
			  tblInv.AttorneyID 
END
GO
PRINT N'Creating [dbo].[procGetAllTestsAndProceduresReport]'
GO
/******************************
-- =============================================
-- Author:		John D'Antonio
-- Create date: 4/2/2014
-- Description:	Total Tests and SUrgeries Report
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    04/3/2014    John      Created proc
*******************************/
CREATE PROCEDURE [dbo].[procGetAllTestsAndProceduresReport]
	@Year int = -1,
	@CompanyID int = -1,
	@AttorneyId int = -1
AS
BEGIN
	SET NOCOUNT ON;
	
declare @tempTable table (AttorneyName varchar(200), AttorneyID int, ProviderName varchar(500), ProviderID int, [Month] int, TestCount int, SurgeryCount int, UniqueSurgeryCount int, UniqueTotalSurgeryCount int, CompanyName varchar(500))

--Get the test information
insert into @tempTable
select A.LastName + ' ' + A.FirstName as AttorneyName,
	A.ID,
	P.Name as ProviderName,
	P.ID,
	MONTH(TIT.TestDate) as [Month],
	SUM(TIT.NumberOfTests) as TestCount,
	0,
	0,
	0,
	C.LongName
from Attorney as A
inner join InvoiceAttorney as IA on A.ID = IA.AttorneyID
inner join Invoice as I on I.InvoiceAttorneyID = IA.ID
inner join TestInvoice as TI on I.TestInvoiceID = TI.ID
inner join TestInvoice_Test as TIT on TI.ID = TIT.TestInvoiceID
inner join InvoiceProvider as IP on TIT.InvoiceProviderID = IP.ID
inner join Provider as P on IP.ProviderID = P.ID
inner join Company as C on I.CompanyID = C.ID
where I.InvoiceTypeID = 1 --tests
and A.CompanyID = @CompanyID
AND (@AttorneyId = -1 or A.ID = @AttorneyId)
and YEAR(TIT.TestDate) = @Year
and TIT.NumberOfTests > 0
group by A.LastName, A.FirstName, P.Name, A.ID, P.ID, Month(TIT.TestDate), C.LongName
order by A.LastName, A.FirstName, Month(TIT.TestDate)

--Get the surgery information
insert into @tempTable
select A.LastName + ' ' + A.FirstName as AttorneyName,
	A.ID,
	P.Name as ProviderName,
	P.ID,
	MONTH(SISDs.ScheduledDate) as [Month],
	0,
	COUNT(SIS.ID) as SurgeryCount,
	COUNT(distinct sisds.ID) as UniqueSurgeryCount,
	(select COUNT(distinct I.ID)
		from Attorney as A2
		inner join InvoiceAttorney as IA on A2.ID = IA.AttorneyID
		inner join Invoice as I on I.InvoiceAttorneyID = IA.ID
		inner join SurgeryInvoice as SI on I.SurgeryInvoiceID = SI.ID
		inner join SurgeryInvoice_Providers as SIPs on SI.ID = SIPs.SurgeryInvoiceID
		inner join SurgeryInvoice_Surgery as SIS on SI.ID = SIS.SurgeryInvoiceID
		inner join SurgeryInvoice_SurgeryDates as SISDs on SIS.ID = SISDs.SurgeryInvoice_SurgeryID 
		where I.InvoiceTypeID = 2 -- surgery
		and A2.CompanyID = @CompanyID
		AND (@AttorneyId = -1 or A2.ID = @AttorneyId)
		and YEAR(SISDs.ScheduledDate) = @Year
		and A.ID = A2.ID) as UniqueTotalSurgeryCount,
	C.LongName
from Attorney as A
inner join InvoiceAttorney as IA on A.ID = IA.AttorneyID
inner join Invoice as I on I.InvoiceAttorneyID = IA.ID
inner join SurgeryInvoice as SI on I.SurgeryInvoiceID = SI.ID
inner join SurgeryInvoice_Providers as SIPs on SI.ID = SIPs.SurgeryInvoiceID
inner join SurgeryInvoice_Surgery as SIS on SI.ID = SIS.SurgeryInvoiceID
inner join InvoiceProvider as IP on SIPs.InvoiceProviderID = IP.ID
inner join Provider as P on IP.ProviderID = P.ID
inner join SurgeryInvoice_SurgeryDates as SISDs on SIS.ID = SISDs.SurgeryInvoice_SurgeryID 
inner join Company as C on I.CompanyID = C.ID
where I.InvoiceTypeID = 2 -- surgery
and A.CompanyID = @CompanyID
AND (@AttorneyId = -1 or A.ID = @AttorneyId)
and YEAR(SISDs.ScheduledDate) = @Year
group by A.LastName, A.FirstName, P.Name, A.ID, P.ID, Month(SISDs.ScheduledDate), C.LongName
order by A.LastName, A.FirstName, Month(SISDs.ScheduledDate)

----FIND DUPLICATES IF THERE IS A PROBLEM
--select AttorneyID, ProviderID, Month, COUNT(SurgeryCount) as cc
--from @tempTable
--group by AttorneyID, ProviderID, Month

--select *
--from @tempTable
--where AttorneyID = 33143
--and ProviderID = 40602
--and Month = 4

--Put the information together and return for the report
select tt.CompanyName,
	tt.AttorneyName,
	tt.AttorneyID,
	tt.ProviderName,
	tt.ProviderID,
	isnull((select TestCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0 and tt2.Month = 1),0) as JanTestCount,
	isnull((select TestCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0 and tt2.Month = 2),0) as FebTestCount,
	isnull((select TestCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0 and tt2.Month = 3),0) as MarTestCount,
	isnull((select TestCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0 and tt2.Month = 4),0) as AprTestCount,
	isnull((select TestCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0 and tt2.Month = 5),0) as MayTestCount,
	isnull((select TestCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0 and tt2.Month = 6),0) as JunTestCount,
	isnull((select TestCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0 and tt2.Month = 7),0) as JulTestCount,
	isnull((select TestCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0 and tt2.Month = 8),0) as AugTestCount,
	isnull((select TestCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0 and tt2.Month = 9),0) as SepTestCount,
	isnull((select TestCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0 and tt2.Month = 10),0) as OctTestCount,
	isnull((select TestCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0 and tt2.Month = 11),0) as NovTestCount,
	isnull((select TestCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0 and tt2.Month = 12),0) as DecTestCount,
	isnull((select sum(TestCount) from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0),0) as TotalTestCount,
	
	isnull((select SurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0 and tt2.Month = 1),0) as JanSurgeryCount,
	isnull((select SurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0 and tt2.Month = 2),0) as FebSurgeryCount,
	isnull((select SurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0 and tt2.Month = 3),0) as MarSurgeryCount,
	isnull((select SurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0 and tt2.Month = 4),0) as AprSurgeryCount,
	isnull((select SurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0 and tt2.Month = 5),0) as MaySurgeryCount,
	isnull((select SurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0 and tt2.Month = 6),0) as JunSurgeryCount,
	isnull((select SurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0 and tt2.Month = 7),0) as JulSurgeryCount,
	isnull((select SurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0 and tt2.Month = 8),0) as AugSurgeryCount,
	isnull((select SurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0 and tt2.Month = 9),0) as SepSurgeryCount,
	isnull((select SurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0 and tt2.Month = 10),0) as OctSurgeryCount,
	isnull((select SurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0 and tt2.Month = 11),0) as NovSurgeryCount,
	isnull((select SurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0 and tt2.Month = 12),0) as DecSurgeryCount,
	isnull((select Sum(SurgeryCount) from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0),0) as TotalSurgeryCount,
	
	isnull((select UniqueSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0 and tt2.Month = 1),0) as JanUniqueSurgeryCount,
	isnull((select UniqueSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0 and tt2.Month = 2),0) as FebUniqueSurgeryCount,
	isnull((select UniqueSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0 and tt2.Month = 3),0) as MarUniqueSurgeryCount,
	isnull((select UniqueSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0 and tt2.Month = 4),0) as AprUniqueSurgeryCount,
	isnull((select UniqueSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0 and tt2.Month = 5),0) as MayUniqueSurgeryCount,
	isnull((select UniqueSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0 and tt2.Month = 6),0) as JunUniqueSurgeryCount,
	isnull((select UniqueSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0 and tt2.Month = 7),0) as JulUniqueSurgeryCount,
	isnull((select UniqueSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0 and tt2.Month = 8),0) as AugUniqueSurgeryCount,
	isnull((select UniqueSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0 and tt2.Month = 9),0) as SepUniqueSurgeryCount,
	isnull((select UniqueSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0 and tt2.Month = 10),0) as OctUniqueSurgeryCount,
	isnull((select UniqueSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0 and tt2.Month = 11),0) as NovUniqueSurgeryCount,
	isnull((select UniqueSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0 and tt2.Month = 12),0) as DecUniqueSurgeryCount,
	isnull((select top 1 UniqueTotalSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0),0) as TotalUniqueSurgeryCount
	
from @tempTable as tt
group by tt.AttorneyName, tt.AttorneyID, tt.ProviderID, tt.ProviderName,tt.CompanyName

END
GO
PRINT N'Creating [dbo].[procGetAllTestsAndProceduresReport_GrandTotals]'
GO
/******************************
-- =============================================
-- Author:		John D'Antonio
-- Create date: 4/2/2014
-- Description:	Total Tests and SUrgeries Report
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    04/3/2014    John      Created proc
*******************************/
CREATE PROCEDURE [dbo].[procGetAllTestsAndProceduresReport_GrandTotals]
	@Year int = -1,
	@CompanyID int = -1,
	@AttorneyId int = -1
AS
BEGIN
	SET NOCOUNT ON;

declare @tempTable as table(janSurgery int, febSurgery int, marSurgery int, aprSurgery int, maySurgery int, junSurgery int, julSurgery int, augSurgery int, sepSurgery int, octSurgery int,novSurgery int, [decSurgery] int, totalSurgery int,
							janTest int, febTest int, marTest int, aprTest int, mayTest int, junTest int, julTest int, augTest int, sepTest int, octTest int,novTest int, [decTest] int, totalTest int)

declare @SurgeryStuffs as table(attorneyID int, attorneyName varchar(500), invoiceID int, month int)
declare @TestStuffs as table(attorneyID int, attorneyName varchar(500), invoiceID int, month int, testCount int)

--Get surgery totals
insert into @SurgeryStuffs
select A.ID as AttorneyID, 
			A.FirstName + ' ' + A.LastName as AttorneyName, 
			I.ID as InvoiceID, 
			MONTH(SISDs.ScheduledDate) as [Month]
		from Attorney as A
		inner join InvoiceAttorney as IA on A.ID = IA.AttorneyID
		inner join Invoice as I on I.InvoiceAttorneyID = IA.ID
		inner join SurgeryInvoice as SI on I.SurgeryInvoiceID = SI.ID
		inner join SurgeryInvoice_Providers as SIPs on SI.ID = SIPs.SurgeryInvoiceID
		inner join SurgeryInvoice_Surgery as SIS on SI.ID = SIS.SurgeryInvoiceID
		inner join SurgeryInvoice_SurgeryDates as SISDs on SIS.ID = SISDs.SurgeryInvoice_SurgeryID 
		where I.InvoiceTypeID = 2 -- surgery
		and A.CompanyID = @CompanyID
		AND (@AttorneyId = -1 or A.ID = @AttorneyId)
		and YEAR(SISDs.ScheduledDate) = @Year
		group by I.ID, A.FirstName, A.LastName, A.ID, SISDs.ScheduledDate, MONTH(sisds.ScheduledDate)
		
--Get test stuff
insert into @TestStuffs
select A.ID as AttorneyID, 
			A.FirstName + ' ' + A.LastName as AttorneyName, 
			I.ID as InvoiceID, 
			MONTH(TIT.TestDate) as [Month],
			TIT.NumberOfTests as TestCount
from Attorney as A
inner join InvoiceAttorney as IA on A.ID = IA.AttorneyID
inner join Invoice as I on I.InvoiceAttorneyID = IA.ID
inner join TestInvoice as TI on I.TestInvoiceID = TI.ID
inner join TestInvoice_Test as TIT on TI.ID = TIT.TestInvoiceID
where I.InvoiceTypeID = 1 --tests
and A.CompanyID = @CompanyID
AND (@AttorneyId = -1 or A.ID = @AttorneyId)
and YEAR(TIT.TestDate) = @Year
group by I.ID, A.LastName, A.FirstName,A.ID,  Month(TIT.TestDate), TIT.NumberOfTests
order by A.LastName, A.FirstName, Month(TIT.TestDate)		
		
--combine everything and return it
insert into @tempTable
select 
	isnull((select COUNT(attorneyid) from @SurgeryStuffs where month = 1),0),
	isnull((select COUNT(attorneyid) from @SurgeryStuffs where month = 2),0),
	isnull((select COUNT(attorneyid) from @SurgeryStuffs where month = 3),0),
	isnull((select COUNT(attorneyid) from @SurgeryStuffs where month = 4),0),
	isnull((select COUNT(attorneyid) from @SurgeryStuffs where month = 5),0),
	isnull((select COUNT(attorneyid) from @SurgeryStuffs where month = 6),0),
	isnull((select COUNT(attorneyid) from @SurgeryStuffs where month = 7),0),
	isnull((select COUNT(attorneyid) from @SurgeryStuffs where month = 8),0),
	isnull((select COUNT(attorneyid) from @SurgeryStuffs where month = 9),0),
	isnull((select COUNT(attorneyid) from @SurgeryStuffs where month = 10),0),
	isnull((select COUNT(attorneyid) from @SurgeryStuffs where month = 11) ,0),
	isnull((select COUNT(attorneyid) from @SurgeryStuffs where month = 12) ,0),
	isnull((select COUNT(attorneyid) from @SurgeryStuffs),	0),
	isnull((select SUM(testCount) from @TestStuffs where month = 1),0),
	isnull((select SUM(testCount) from @TestStuffs where month = 2),0),
	isnull((select SUM(testCount) from @TestStuffs where month = 3),0),
	isnull((select SUM(testCount) from @TestStuffs where month = 4),0),
	isnull((select SUM(testCount) from @TestStuffs where month = 5),0),
	isnull((select SUM(testCount) from @TestStuffs where month = 6),0),
	isnull((select SUM(testCount) from @TestStuffs where month = 7),0),
	isnull((select SUM(testCount) from @TestStuffs where month = 8),0),
	isnull((select SUM(testCount) from @TestStuffs where month = 9),0),
	isnull((select SUM(testCount) from @TestStuffs where month = 10),0),
	isnull((select SUM(testCount) from @TestStuffs where month = 11) ,0),
	isnull((select SUM(testCount) from @TestStuffs where month = 12) ,0),
	isnull((select SUM(testCount) from @TestStuffs), 0)
	
select * from @tempTable

END
GO
PRINT N'Creating [dbo].[procGetPercentCash-LossCollectedReport]'
GO
-- =============================================
-- Author:		D'Oriocourt, John
-- Create date: 04/04/2014
-- Description:	Data for Percent Cash/Loss
-- Collected by Days report.
-- =============================================
CREATE PROCEDURE [dbo].[procGetPercentCash-LossCollectedReport] 
	-- Add the parameters for the stored procedure here
	@EndDate DATETIME,
    @AttorneyID INT,
    @CompanyID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT c.ID                                            AS CompanyID,
           c.LongName                                      AS CompanyName,
           a.ID                                            AS AttorneyID,
           a.FirstName                                     AS FirstName,
           a.LastName                                      AS LastName,
           i.ID                                            AS InvoiceID,
           i.LossesAmount                                  AS InvoiceLossesAmount,
           (SELECT SUM(p.Amount)
                        FROM   Payments p
                        WHERE  p.Active = 1
                               AND p.PaymentTypeID = 1
                               AND p.InvoiceID = i.ID
                               AND p.DatePaid <= @EndDate) AS InvoiceTotalPrincipal,
           CASE i.InvoiceTypeID
             WHEN 1 THEN [dbo].[f_GetFirstTestDate](i.ID)
             WHEN 2 THEN [dbo].[f_GetFirstSurgeryDate](i.ID)
           END                                             AS InvoiceFirstDate,
           (SELECT SUM(p.Amount)
                        FROM   Payments p
                        WHERE  p.Active = 1
                               AND p.InvoiceID = i.ID
                               AND p.DatePaid <= @EndDate) AS TotalAttorneyPayments,
           -- Payments during each cycle
           (SELECT SUM(p.Amount) 
            FROM   Payments p 
            WHERE  p.Active = 1 
                   AND p.InvoiceID = i.ID 
                   AND ( p.DatePaid <= @EndDate 
                         -- Payments before DateServiceFeeBegins AND Payments no more than 60 days out from EndDate 
                         AND ( ( ( i.InvoiceTypeID = 1 AND p.DatePaid >= DATEADD(m, i.ServiceFeeWaivedMonths, [dbo].[f_GetFirstTestDate](i.ID)) ) 
                              OR ( i.InvoiceTypeID = 2 AND p.DatePaid >= DATEADD(m, i.ServiceFeeWaivedMonths, [dbo].[f_GetFirstSurgeryDate](i.ID)) ) ) 
                            OR ( p.DatePaid >= DATEADD(d, -60, @EndDate) 
                                 AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m, i.ServiceFeeWaivedMonths, [dbo].[f_GetFirstTestDate](i.ID)) ) 
                                    OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m, i.ServiceFeeWaivedMonths, [dbo].[f_GetFirstSurgeryDate](i.ID)) ) ) ) ) )) 
                                                           AS 'Cash_<60',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -120, @EndDate) AND DATEADD(d, -61, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_60-120',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -180, @EndDate) AND DATEADD(d, -121, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_120-180',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -240, @EndDate) AND DATEADD(d, -181, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_180-240',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -300, @EndDate) AND DATEADD(d, -241, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_240-300',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -360, @EndDate) AND DATEADD(d, -301, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_300-360',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -420, @EndDate) AND DATEADD(d, -361, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_360-420',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -480, @EndDate) AND DATEADD(d, -421, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_420-480',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -540, @EndDate) AND DATEADD(d, -481, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_480-540',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -600, @EndDate) AND DATEADD(d, -541, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_540-600',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -660, @EndDate) AND DATEADD(d, -601, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_600-660',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -720, @EndDate) AND DATEADD(d, -661, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_660-720',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -780, @EndDate) AND DATEADD(d, -721, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_720-780',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -840, @EndDate) AND DATEADD(d, -781, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_780-840',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid BETWEEN DATEADD(d, -900, @EndDate) AND DATEADD(d, -841, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_840-900',
           (SELECT SUM(p.Amount)
            FROM   Payments p
            WHERE  p.Active = 1
                   AND p.InvoiceID = i.ID
                   AND p.DatePaid <= DATEADD(d, -901, @EndDate)
                   AND ( ( i.InvoiceTypeID = 1 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstTestDate](i.ID)) ) 
                          OR ( i.InvoiceTypeID = 2 AND p.DatePaid < DATEADD(m,i.ServiceFeeWaivedMonths,[dbo].[f_GetFirstSurgeryDate](i.ID)) ) ))
                                                           AS 'Cash_>900'
    FROM   Attorney a
           INNER JOIN InvoiceAttorney ia ON a.ID = ia.AttorneyID
           INNER JOIN Invoice i ON ia.ID = i.InvoiceAttorneyID
           INNER JOIN Company c ON a.CompanyID = c.ID
    WHERE  a.Active = 1
           AND ia.Active = 1
           AND i.Active = 1
           AND a.CompanyID = @CompanyID
           AND (-1 = @AttorneyID
                OR a.ID = @AttorneyID)
           AND ( ( i.InvoiceTypeID = 1 AND [dbo].[f_GetFirstTestDate](i.ID) <= @EndDate ) 
              OR ( i.InvoiceTypeID = 2 AND [dbo].[f_GetFirstSurgeryDate](i.ID) <= @EndDate ) )
END
GO
PRINT N'Creating [dbo].[procProviderPaymentsReport]'
GO
/******************************
-- =============================================
-- Author:		John D'Antonio
-- Create date: 4/2/2014
-- Description:	Provider Payments Report
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    04/2/2014    John      Created proc
*******************************/
CREATE PROCEDURE [dbo].[procProviderPaymentsReport]
	@StartDate datetime = null, 
	@EndDate datetime = null,
	@CompanyId int = -1
AS
BEGIN
	SET NOCOUNT ON;
	
	select *
	from (
(
	select P.ID, REPLACE(P.Name,'&','&amp;') as Name, SUM(SIPP.Amount) as Amount, C.LongName as CompanyName
	from Provider as P
	inner join InvoiceProvider as IP on P.ID = IP.ProviderID
	inner join SurgeryInvoice_Providers as SIP on IP.ID = SIP.InvoiceProviderID
	inner join SurgeryInvoice_Provider_Payments as SIPP on SIP.ID = SIPP.SurgeryInvoice_ProviderID
	inner join Company as C on P.CompanyID = C.ID
	where SIPP.DatePaid >= @StartDate 
	and SIPP.DateAdded <= @EndDate
	and P.CompanyID = @CompanyID
	group by P.ID, P.Name, C.LongName
)
union
(
	select P.ID, REPLACE(P.Name,'&','&amp;') as Name, SUM(isnull(TIT.AmountPaidToProvider,0) + isnull(TIT.DepositToProvider, 0)) as Amount, C.LongName as CompanyName
	from Provider as P
	inner join InvoiceProvider as IP on P.ID = IP.ProviderID
	inner join TestInvoice_Test as TIT on IP.ID = TIT.InvoiceProviderID
	inner join Company as C on P.CompanyID = C.ID
	where TIT.Date >= @StartDate 
	and TIT.Date <= @EndDate
	and P.CompanyID = @CompanyID
	group by P.ID, P.Name, C.LongName
)) as res
where res.amount > 0
order by res.Name

END
GO
PRINT N'Creating [dbo].[Contacts1]'
GO
CREATE TABLE [dbo].[Contacts1]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ContactListID] [int] NULL,
[Name] [nvarchar] (100) NULL,
[Position] [nvarchar] (50) NULL,
[Phone] [nvarchar] (50) NULL,
[Email] [nvarchar] (50) NULL,
[Active] [bit] NULL,
[DateAdded] [datetime] NULL,
[Temp_CompanyID] [int] NULL
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_BMM_CPT]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_BMM_CPT]
(
[cptcode] [nvarchar] (5) NULL,
[suffix] [nvarchar] (2) NULL,
[descript] [nvarchar] (75) NULL
)
GO
PRINT N'Creating [dbo].[DATAMIGRATION_BMM_ImportOfMissingInvoices]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_BMM_ImportOfMissingInvoices]
(
[InvoiceNumber] [nvarchar] (50) NOT NULL
)
GO
PRINT N'Creating primary key [PK_DATAMIGRATION_BMM_ImportOfMissingInvoices] on [dbo].[DATAMIGRATION_BMM_ImportOfMissingInvoices]'
GO
ALTER TABLE [dbo].[DATAMIGRATION_BMM_ImportOfMissingInvoices] ADD CONSTRAINT [PK_DATAMIGRATION_BMM_ImportOfMissingInvoices] PRIMARY KEY CLUSTERED  ([InvoiceNumber])
GO
PRINT N'Creating [dbo].[DATAMIGRATION_DMA_CPT]'
GO
CREATE TABLE [dbo].[DATAMIGRATION_DMA_CPT]
(
[cptcode] [nvarchar] (5) NULL,
[suffix] [nvarchar] (2) NULL,
[descript] [nvarchar] (75) NULL
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_BMM_CPT]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_BMM_CPT]
(
[cptcode] [nvarchar] (5) NULL,
[suffix] [nvarchar] (2) NULL,
[descript] [nvarchar] (75) NULL
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_BMM_SHARED_ATTORNEY_LIST]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_BMM_SHARED_ATTORNEY_LIST]
(
[Attorney No] [int] NOT NULL IDENTITY(1, 1),
[Attorney First Name] [nvarchar] (50) NULL,
[Attorney Last Name] [nvarchar] (50) NULL,
[Attorney Address] [nvarchar] (50) NULL,
[Attorney City] [nvarchar] (50) NULL,
[Attorney State] [nvarchar] (50) NULL,
[Attorney Zip] [nvarchar] (50) NULL,
[Attorney Phone] [nvarchar] (50) NULL,
[Attorney Fax] [nvarchar] (50) NULL,
[Attorney Seceretary] [nvarchar] (50) NULL,
[Memo] [ntext] NULL,
[Months] [int] NULL,
[Discount Plan] [int] NULL,
[Deposit Amount Required] [int] NULL,
[test] [bit] NULL
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_BMM_SURGERY_BMM]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_BMM_SURGERY_BMM]
(
[Invoice Number] [int] NULL,
[Invoice Date] [datetime] NULL,
[Client Name] [nvarchar] (50) NULL,
[Client Last Name] [nvarchar] (50) NULL,
[Client Address] [nvarchar] (50) NULL,
[Client City] [nvarchar] (50) NULL,
[Client State] [nvarchar] (50) NULL,
[Client Zip] [nvarchar] (50) NULL,
[Client Phone] [nvarchar] (50) NULL,
[Client WorkPhone] [nvarchar] (50) NULL,
[Client Date of Birth] [datetime] NULL,
[SSN] [nvarchar] (50) NULL,
[Date Of Accident] [datetime] NULL,
[Attorney No] [int] NULL,
[Physician No] [int] NULL,
[Provider No] [int] NULL,
[Invoice Closed] [bit] NULL,
[Notes] [ntext] NULL,
[Invoice Closed Date] [datetime] NULL,
[TotalCost] [float] NULL,
[MaturityDate] [datetime] NULL,
[DepositReceived] [float] NULL,
[DatePaid] [datetime] NULL,
[DueDate] [datetime] NULL,
[ServiceFeeWaived] [float] NULL,
[AmountPaid] [float] NULL,
[BalanceDue] [float] NULL,
[DateServiceFeeBegins] [datetime] NULL,
[LossesAmount] [float] NULL,
[Cumulative] [float] NULL,
[CostOfGoodsSold] [float] NULL,
[EndingBalance] [float] NULL,
[Revenue] [float] NULL,
[AmortizationDate] [datetime] NULL,
[Months] [int] NULL,
[TotalPayments] [float] NULL,
[TotalPPO] [float] NULL,
[TotalPrincipal] [int] NULL,
[CompleteFile] [bit] NULL,
[SurgeryType] [nvarchar] (64) NULL,
[DateScheduled] [datetime] NULL,
[inpatient] [bit] NULL,
[outpatient] [bit] NULL,
[cancelled] [bit] NULL,
[icd9] [nvarchar] (8) NULL,
[drgcode] [nvarchar] (3) NULL,
[company] [nvarchar] (50) NULL,
[transferred] [bit] NULL
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_BMM_SURGERY_CPTCHARGES]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_BMM_SURGERY_CPTCHARGES]
(
[Invoice Number] [int] NULL,
[provider] [int] NULL,
[cptcode] [nvarchar] (5) NULL,
[amount] [decimal] (10, 2) NULL,
[description] [nvarchar] (75) NULL,
[ProviderbyInvoice] [int] NULL
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_BMM_SURGERY_CalcTestListTemp]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_BMM_SURGERY_CalcTestListTemp]
(
[InvoiceNumber] [int] NULL,
[TestCosts] [float] NULL,
[TestCostsNet] [float] NULL,
[PPODisc] [float] NULL,
[InterestByDate] [float] NULL,
[DateScheduled] [datetime] NULL,
[InterestDue] [float] NULL,
[Name] [nvarchar] (255) NULL,
[Client Name] [nvarchar] (50) NULL,
[Client Last Name] [nvarchar] (50) NULL,
[Notes] [ntext] NULL,
[attorneyName] [nvarchar] (255) NULL,
[abbrev] [nvarchar] (10) NULL,
[EndingBalance] [float] NULL,
[Balance] [float] NULL,
[Attorney No] [int] NULL,
[PaymentTotals] [float] NULL,
[Company] [nvarchar] (50) NULL,
[Company2] [nvarchar] (50) NULL,
[amortization] [datetime] NULL,
[TestType] [nvarchar] (50) NULL,
[FirstTestDate] [datetime] NULL,
[COGS] [float] NULL,
[Revenue] [float] NULL,
[ContractRevenue] [float] NULL,
[TotalRevenue] [float] NULL,
[maturity] [datetime] NULL,
[amortyear] [nvarchar] (50) NULL
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney]
(
[Invoice Number] [int] NULL,
[DatePaid] [datetime] NULL,
[amount] [float] NULL,
[PaymentType] [nvarchar] (10) NULL,
[check] [nvarchar] (10) NULL
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_BMM_SURGERY_PaymentsToProviders]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_BMM_SURGERY_PaymentsToProviders]
(
[Invoice Number] [int] NULL,
[Provider] [int] NULL,
[DatePaid] [datetime] NULL,
[Amount] [decimal] (10, 2) NULL,
[PaymentType] [nvarchar] (10) NULL,
[Check] [nvarchar] (10) NULL,
[ProviderByInvoice] [int] NULL,
[PAYMENTID] [int] NOT NULL IDENTITY(1, 1)
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_BMM_SURGERY_Providers]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_BMM_SURGERY_Providers]
(
[provider] [int] NULL,
[date] [datetime] NULL,
[name] [nvarchar] (50) NULL,
[address] [nvarchar] (35) NULL,
[city] [nvarchar] (20) NULL,
[state] [nvarchar] (2) NULL,
[zip] [nvarchar] (10) NULL,
[phone] [nvarchar] (12) NULL,
[contact] [nvarchar] (25) NULL,
[abbrev] [nvarchar] (10) NULL,
[discount] [decimal] (7, 2) NULL,
[fax] [nvarchar] (12) NULL
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_BMM_SURGERY_SERVICES]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_BMM_SURGERY_SERVICES]
(
[InvoiceNumber] [int] NULL,
[provider] [int] NULL,
[DueDate] [datetime] NULL,
[AmountDue] [float] NULL,
[cost] [float] NULL,
[discount] [float] NULL,
[PPODiscount] [float] NULL,
[ProviderByInvoice] [int] NULL,
[AmountWaived] [float] NULL,
[SERVICEID] [int] NOT NULL IDENTITY(1, 1)
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_BMM_TEST_BMM]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_BMM_TEST_BMM]
(
[Invoice Number] [int] NULL,
[Invoice Date] [datetime] NULL,
[Client Name] [nvarchar] (50) NULL,
[Client Last Name] [nvarchar] (50) NULL,
[Client Address] [nvarchar] (50) NULL,
[Client City] [nvarchar] (50) NULL,
[Client State] [nvarchar] (50) NULL,
[Client Zip] [nvarchar] (50) NULL,
[Client Phone] [nvarchar] (50) NULL,
[Client WorkPhone] [nvarchar] (50) NULL,
[Client Date of Birth] [datetime] NULL,
[SSN] [nvarchar] (50) NULL,
[Date Of Accident] [datetime] NULL,
[Attorney No] [int] NULL,
[Physician No] [int] NULL,
[Provider No] [int] NULL,
[Invoice Closed] [bit] NULL,
[Notes] [ntext] NULL,
[Invoice Closed Date] [datetime] NULL,
[TotalCost] [float] NULL,
[MaturityDate] [datetime] NULL,
[DepositReceived] [float] NULL,
[DatePaid] [datetime] NULL,
[DueDate] [datetime] NULL,
[ServiceFeeWaived] [float] NULL,
[AmountPaid] [float] NULL,
[BalanceDue] [float] NULL,
[DateServiceFeeBegins] [datetime] NULL,
[LossesAmount] [float] NULL,
[Cumulative] [float] NULL,
[CostOfGoodsSold] [float] NULL,
[EndingBalance] [float] NULL,
[Revenue] [float] NULL,
[AmortizationDate] [datetime] NULL,
[Months] [int] NULL,
[TotalPayments] [float] NULL,
[TotalPPO] [float] NULL,
[TotalPrincipal] [float] NULL,
[CompleteFile] [bit] NULL,
[company] [nvarchar] (50) NULL,
[TotalInterestPaid] [float] NULL,
[GrossCumulative] [float] NULL,
[transferred] [bit] NULL
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_BMM_TEST_Payments]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_BMM_TEST_Payments]
(
[PaymentID] [int] NOT NULL IDENTITY(1, 1),
[Invoice No] [int] NULL,
[Date Paid] [datetime] NULL,
[Amount] [float] NULL,
[Payment Type] [nvarchar] (10) NULL,
[Check No] [nvarchar] (10) NULL
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_BMM_TEST_Physician_List]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_BMM_TEST_Physician_List]
(
[Physician No] [int] NOT NULL IDENTITY(1, 1),
[Physician First Name] [nvarchar] (50) NULL,
[Physician Last Name] [nvarchar] (50) NULL,
[Physician Address] [nvarchar] (50) NULL,
[Physician Address2] [nvarchar] (50) NULL,
[Physician City] [nvarchar] (50) NULL,
[Physician State] [nvarchar] (50) NULL,
[Physician Zip] [nvarchar] (50) NULL,
[Physician Phone] [nvarchar] (50) NULL,
[Physician Fax] [nvarchar] (50) NULL,
[Memo] [ntext] NULL,
[Contact] [nvarchar] (50) NULL
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_BMM_TEST_Provider_List]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_BMM_TEST_Provider_List]
(
[Facility No] [int] NOT NULL IDENTITY(1, 1),
[Facility Name] [nvarchar] (50) NULL,
[Facility Address] [nvarchar] (50) NULL,
[Facility City] [nvarchar] (50) NULL,
[Facility State] [nvarchar] (50) NULL,
[Facility Zip] [nvarchar] (50) NULL,
[Facility Phone] [nvarchar] (50) NULL,
[Facility Fax] [nvarchar] (50) NULL,
[Contact] [nvarchar] (50) NULL,
[Memo] [ntext] NULL,
[Discount] [float] NULL,
[PPO deposit] [int] NULL,
[FacilityAbbrev] [nvarchar] (50) NULL
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_BMM_TEST_Test_List]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_BMM_TEST_Test_List]
(
[Test No] [int] NOT NULL IDENTITY(1, 1),
[Invoice No] [int] NULL,
[Test Name] [nvarchar] (100) NULL,
[Test Date] [datetime] NULL,
[Test Time] [nvarchar] (5) NULL,
[Test Results] [nvarchar] (50) NULL,
[Test Deposit] [float] NULL,
[Interest Waived] [float] NULL,
[Losses Amount] [float] NULL,
[Payment Plan] [int] NULL,
[Canceled] [bit] NULL,
[Test Cost] [float] NULL,
[Provider No] [int] NULL,
[Deposit From Attorney] [float] NULL,
[Amount Due To Provider Due Date] [datetime] NULL,
[Amount Paid To Provider] [float] NULL,
[Amount Paid To Provider Date] [datetime] NULL,
[Amount Paid To Provider Check No] [nvarchar] (50) NULL,
[Number of Tests] [int] NULL,
[MRI] [int] NULL,
[PPO Discount] [float] NULL,
[AmountDueToFacility] [float] NULL
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_DMA_CPT]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_DMA_CPT]
(
[cptcode] [nvarchar] (5) NULL,
[suffix] [nvarchar] (2) NULL,
[descript] [nvarchar] (75) NULL
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_DMA_SHARED_Attorney_List]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_DMA_SHARED_Attorney_List]
(
[Attorney No] [int] NULL,
[Attorney First Name] [nvarchar] (50) NULL,
[Attorney Last Name] [nvarchar] (50) NULL,
[Attorney Address] [nvarchar] (50) NULL,
[Attorney City] [nvarchar] (50) NULL,
[Attorney State] [nvarchar] (50) NULL,
[Attorney Zip] [nvarchar] (50) NULL,
[Attorney Phone] [nvarchar] (50) NULL,
[Attorney Fax] [nvarchar] (50) NULL,
[Attorney Seceretary] [nvarchar] (50) NULL,
[Memo] [ntext] NULL,
[Months] [int] NULL,
[Discount Plan] [int] NULL,
[Deposit Amount Required] [int] NULL,
[test] [bit] NULL
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_DMA_SURGERY_CPTCharges]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_DMA_SURGERY_CPTCharges]
(
[Invoice Number] [int] NULL,
[provider] [int] NULL,
[cptcode] [nvarchar] (5) NULL,
[amount] [decimal] (10, 2) NULL,
[description] [nvarchar] (75) NULL,
[ProviderbyInvoice] [int] NULL
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_DMA_SURGERY_CalcTestListTemp]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_DMA_SURGERY_CalcTestListTemp]
(
[InvoiceNumber] [int] NULL,
[TestCosts] [float] NULL,
[TestCostsNet] [float] NULL,
[PPODisc] [float] NULL,
[InterestByDate] [float] NULL,
[DateScheduled] [datetime] NULL,
[InterestDue] [float] NULL,
[Name] [nvarchar] (255) NULL,
[Client Name] [nvarchar] (50) NULL,
[Client Last Name] [nvarchar] (50) NULL,
[Notes] [ntext] NULL,
[attorneyName] [nvarchar] (255) NULL,
[abbrev] [nvarchar] (10) NULL,
[EndingBalance] [float] NULL,
[Balance] [float] NULL,
[Attorney No] [int] NULL,
[PaymentTotals] [float] NULL,
[Company] [nvarchar] (50) NULL,
[Company2] [nvarchar] (50) NULL,
[amortization] [datetime] NULL,
[TestType] [nvarchar] (50) NULL,
[FirstTestDate] [datetime] NULL,
[COGS] [float] NULL,
[Revenue] [float] NULL,
[ContractRevenue] [float] NULL,
[TotalRevenue] [float] NULL,
[maturity] [datetime] NULL,
[amortyear] [nvarchar] (50) NULL
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_DMA_SURGERY_DMA]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_DMA_SURGERY_DMA]
(
[Invoice Number] [int] NULL,
[Invoice Date] [datetime] NULL,
[Client Name] [nvarchar] (50) NULL,
[Client Last Name] [nvarchar] (50) NULL,
[Client Address] [nvarchar] (50) NULL,
[Client City] [nvarchar] (50) NULL,
[Client State] [nvarchar] (50) NULL,
[Client Zip] [nvarchar] (50) NULL,
[Client Phone] [nvarchar] (50) NULL,
[Client WorkPhone] [nvarchar] (50) NULL,
[Client Date of Birth] [datetime] NULL,
[SSN] [nvarchar] (50) NULL,
[Date Of Accident] [datetime] NULL,
[Attorney No] [int] NULL,
[Physician No] [int] NULL,
[Provider No] [int] NULL,
[Invoice Closed] [bit] NULL,
[Notes] [ntext] NULL,
[Invoice Closed Date] [datetime] NULL,
[TotalCost] [float] NULL,
[MaturityDate] [datetime] NULL,
[DepositReceived] [float] NULL,
[DatePaid] [datetime] NULL,
[DueDate] [datetime] NULL,
[ServiceFeeWaived] [float] NULL,
[AmountPaid] [float] NULL,
[BalanceDue] [float] NULL,
[DateServiceFeeBegins] [datetime] NULL,
[LossesAmount] [float] NULL,
[Cumulative] [float] NULL,
[CostOfGoodsSold] [float] NULL,
[EndingBalance] [float] NULL,
[Revenue] [float] NULL,
[AmortizationDate] [datetime] NULL,
[Months] [int] NULL,
[TotalPayments] [float] NULL,
[TotalPPO] [float] NULL,
[TotalPrincipal] [int] NULL,
[CompleteFile] [bit] NULL,
[SurgeryType] [nvarchar] (64) NULL,
[DateScheduled] [datetime] NULL,
[inpatient] [bit] NULL,
[outpatient] [bit] NULL,
[cancelled] [bit] NULL,
[icd9] [nvarchar] (8) NULL,
[drgcode] [nvarchar] (3) NULL,
[company] [nvarchar] (50) NULL,
[transferred] [bit] NULL
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_DMA_SURGERY_PaymentsByAttorney]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_DMA_SURGERY_PaymentsByAttorney]
(
[Invoice Number] [int] NULL,
[DatePaid] [datetime] NULL,
[amount] [float] NULL,
[PaymentType] [nvarchar] (10) NULL,
[check] [nvarchar] (10) NULL
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_DMA_SURGERY_PaymentsToProviders]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_DMA_SURGERY_PaymentsToProviders]
(
[Invoice Number] [int] NULL,
[Provider] [int] NULL,
[DatePaid] [datetime] NULL,
[Amount] [decimal] (10, 2) NULL,
[PaymentType] [nvarchar] (10) NULL,
[Check] [nvarchar] (10) NULL,
[ProviderByInvoice] [int] NULL,
[PAYMENTID] [int] NOT NULL IDENTITY(1, 1)
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_DMA_SURGERY_Providers]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_DMA_SURGERY_Providers]
(
[provider] [int] NULL,
[date] [datetime] NULL,
[name] [nvarchar] (50) NULL,
[address] [nvarchar] (35) NULL,
[city] [nvarchar] (20) NULL,
[state] [nvarchar] (2) NULL,
[zip] [nvarchar] (10) NULL,
[phone] [nvarchar] (12) NULL,
[contact] [nvarchar] (25) NULL,
[abbrev] [nvarchar] (10) NULL,
[discount] [decimal] (7, 2) NULL,
[fax] [nvarchar] (12) NULL
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_DMA_SURGERY_Services]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_DMA_SURGERY_Services]
(
[InvoiceNumber] [int] NULL,
[provider] [int] NULL,
[DueDate] [datetime] NULL,
[AmountDue] [float] NULL,
[cost] [float] NULL,
[discount] [float] NULL,
[PPODiscount] [float] NULL,
[ProviderByInvoice] [int] NULL,
[AmountWaived] [float] NULL,
[SERVICEID] [int] NOT NULL IDENTITY(1, 1)
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_DMA_TEST_DMA]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_DMA_TEST_DMA]
(
[Invoice Number] [int] NULL,
[Invoice Date] [datetime] NULL,
[Client Name] [nvarchar] (50) NULL,
[Client Last Name] [nvarchar] (50) NULL,
[Client Address] [nvarchar] (50) NULL,
[Client City] [nvarchar] (50) NULL,
[Client State] [nvarchar] (50) NULL,
[Client Zip] [nvarchar] (50) NULL,
[Client Phone] [nvarchar] (50) NULL,
[Client WorkPhone] [nvarchar] (50) NULL,
[Client Date of Birth] [datetime] NULL,
[SSN] [nvarchar] (50) NULL,
[Date Of Accident] [datetime] NULL,
[Attorney No] [int] NULL,
[Physician No] [int] NULL,
[Provider No] [int] NULL,
[Invoice Closed] [bit] NULL,
[Notes] [ntext] NULL,
[Invoice Closed Date] [datetime] NULL,
[TotalCost] [float] NULL,
[MaturityDate] [datetime] NULL,
[DepositReceived] [float] NULL,
[DatePaid] [datetime] NULL,
[DueDate] [datetime] NULL,
[ServiceFeeWaived] [float] NULL,
[AmountPaid] [float] NULL,
[BalanceDue] [float] NULL,
[DateServiceFeeBegins] [datetime] NULL,
[LossesAmount] [float] NULL,
[Cumulative] [float] NULL,
[CostOfGoodsSold] [float] NULL,
[EndingBalance] [float] NULL,
[Revenue] [float] NULL,
[AmortizationDate] [datetime] NULL,
[Months] [int] NULL,
[TotalPayments] [float] NULL,
[TotalPPO] [float] NULL,
[TotalPrincipal] [float] NULL,
[CompleteFile] [bit] NULL,
[company] [nvarchar] (50) NULL,
[TotalInterestPaid] [float] NULL,
[GrossCumulative] [float] NULL,
[transferred] [bit] NULL
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_DMA_TEST_Payments]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_DMA_TEST_Payments]
(
[Invoice No] [int] NULL,
[Date Paid] [datetime] NULL,
[Amount] [float] NULL,
[Payment Type] [nvarchar] (10) NULL,
[Check No] [nvarchar] (10) NULL
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_DMA_TEST_Physician_List]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_DMA_TEST_Physician_List]
(
[Physician No] [int] NULL,
[Physician First Name] [nvarchar] (50) NULL,
[Physician Last Name] [nvarchar] (50) NULL,
[Physician Address] [nvarchar] (50) NULL,
[Physician Address2] [nvarchar] (50) NULL,
[Physician City] [nvarchar] (50) NULL,
[Physician State] [nvarchar] (50) NULL,
[Physician Zip] [nvarchar] (50) NULL,
[Physician Phone] [nvarchar] (50) NULL,
[Physician Fax] [nvarchar] (50) NULL,
[Memo] [ntext] NULL,
[Contact] [nvarchar] (50) NULL
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_DMA_TEST_Provider_List]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_DMA_TEST_Provider_List]
(
[Facility No] [int] NULL,
[Facility Name] [nvarchar] (50) NULL,
[Facility Address] [nvarchar] (50) NULL,
[Facility City] [nvarchar] (50) NULL,
[Facility State] [nvarchar] (50) NULL,
[Facility Zip] [nvarchar] (50) NULL,
[Facility Phone] [nvarchar] (50) NULL,
[Facility Fax] [nvarchar] (50) NULL,
[Contact] [nvarchar] (50) NULL,
[Memo] [ntext] NULL,
[Discount] [float] NULL,
[PPO deposit] [int] NULL,
[FacilityAbbrev] [nvarchar] (50) NULL
)
GO
PRINT N'Creating [dbo].[OLD_DATAMIGRATION_DMA_TEST_TEST_List]'
GO
CREATE TABLE [dbo].[OLD_DATAMIGRATION_DMA_TEST_TEST_List]
(
[Test No] [int] NOT NULL IDENTITY(1, 1),
[Invoice No] [int] NULL,
[Test Name] [nvarchar] (100) NULL,
[Test Date] [datetime] NULL,
[Test Time] [nvarchar] (5) NULL,
[Test Results] [nvarchar] (50) NULL,
[Test Deposit] [float] NULL,
[Interest Waived] [float] NULL,
[Losses Amount] [float] NULL,
[Payment Plan] [int] NULL,
[Canceled] [bit] NULL,
[Test Cost] [float] NULL,
[Provider No] [int] NULL,
[Deposit From Attorney] [float] NULL,
[Amount Due To Provider Due Date] [datetime] NULL,
[Amount Paid To Provider] [float] NULL,
[Amount Paid To Provider Date] [datetime] NULL,
[Amount Paid To Provider Check No] [nvarchar] (50) NULL,
[Number of Tests] [int] NULL,
[MRI] [int] NULL,
[PPO Discount] [float] NULL,
[AmountDueToFacility] [float] NULL
)
GO
PRINT N'Creating [dbo].[Physician_Backup03262014]'
GO
CREATE TABLE [dbo].[Physician_Backup03262014]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CompanyID] [int] NULL,
[ContactListID] [int] NULL,
[isActiveStatus] [bit] NULL,
[FirstName] [nvarchar] (50) NULL,
[LastName] [nvarchar] (50) NULL,
[Street1] [ntext] NULL,
[Street2] [ntext] NULL,
[City] [ntext] NULL,
[StateID] [int] NULL,
[ZipCode] [ntext] NULL,
[Phone] [nvarchar] (50) NULL,
[Fax] [nvarchar] (50) NULL,
[EmailAddress] [nvarchar] (100) NULL,
[Notes] [ntext] NULL,
[Active] [bit] NULL,
[DateAdded] [datetime] NULL,
[Temp_PhysicianID] [int] NULL
)
GO
PRINT N'Creating [dbo].[IndexFragmentationCleanup]'
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[IndexFragmentationCleanup]
AS
DECLARE @reIndexRequest VARCHAR(1000)

DECLARE reIndexList CURSOR
FOR
SELECT INDEX_PROCESS
FROM (
    SELECT CASE 
            WHEN avg_fragmentation_in_percent BETWEEN 5
                    AND 30
                THEN 'ALTER INDEX [' + i.NAME + '] ON [' + t.NAME + '] REORGANIZE;'
            WHEN avg_fragmentation_in_percent > 30
                THEN 'ALTER INDEX [' + i.NAME + '] ON [' + t.NAME + '] REBUILD with(ONLINE=ON);'
            END AS INDEX_PROCESS
        ,avg_fragmentation_in_percent
        ,t.NAME
    FROM sys.dm_db_index_physical_stats(NULL, NULL, NULL, NULL, NULL) AS a
    INNER JOIN sys.indexes AS i ON a.object_id = i.object_id
        AND a.index_id = i.index_id
    INNER JOIN sys.tables t ON t.object_id = i.object_id
    WHERE i.NAME IS NOT NULL
    ) PROCESS
WHERE PROCESS.INDEX_PROCESS IS NOT NULL
ORDER BY avg_fragmentation_in_percent DESC

OPEN reIndexList

FETCH NEXT
FROM reIndexList
INTO @reIndexRequest

WHILE @@FETCH_STATUS = 0
BEGIN
    BEGIN TRY

        PRINT @reIndexRequest;

        EXEC (@reIndexRequest);

    END TRY

    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT @ErrorMessage = 'UNABLE TO CLEAN UP INDEX WITH: ' + @reIndexRequest + ': MESSAGE GIVEN: ' + ERROR_MESSAGE()
            ,@ErrorSeverity = 9 
            ,@ErrorState = ERROR_STATE();

    END CATCH;

    FETCH NEXT
    FROM reIndexList
    INTO @reIndexRequest
END

CLOSE reIndexList;

DEALLOCATE reIndexList;

RETURN 0

GO
PRINT N'Creating [dbo].[SVC_ClearCache]'
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SVC_ClearCache] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DBCC freeproccache

DBCC DROPCLEANBUFFERS
END
GO
PRINT N'Adding foreign keys to [dbo].[InvoiceAttorney]'
GO
ALTER TABLE [dbo].[InvoiceAttorney] ADD CONSTRAINT [FK_InvoiceAttorneyLog_Attorney] FOREIGN KEY ([AttorneyID]) REFERENCES [dbo].[Attorney] ([ID])
GO
ALTER TABLE [dbo].[InvoiceAttorney] ADD CONSTRAINT [FK_InvoiceAttorney_InvoiceContactList] FOREIGN KEY ([InvoiceContactListID]) REFERENCES [dbo].[InvoiceContactList] ([ID])
GO
ALTER TABLE [dbo].[InvoiceAttorney] ADD CONSTRAINT [FK_InvoiceAttorney_InvoiceFirm] FOREIGN KEY ([InvoiceFirmID]) REFERENCES [dbo].[InvoiceFirm] ([ID])
GO
ALTER TABLE [dbo].[InvoiceAttorney] ADD CONSTRAINT [FK_InvoiceAttorney_States] FOREIGN KEY ([StateID]) REFERENCES [dbo].[States] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[Attorney]'
GO
ALTER TABLE [dbo].[Attorney] ADD CONSTRAINT [FK_Attorney_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Company] ([ID])
GO
ALTER TABLE [dbo].[Attorney] ADD CONSTRAINT [FK_Attorney_ResourceInfo] FOREIGN KEY ([ContactListID]) REFERENCES [dbo].[ContactList] ([ID])
GO
ALTER TABLE [dbo].[Attorney] ADD CONSTRAINT [FK_Attorney_Firm] FOREIGN KEY ([FirmID]) REFERENCES [dbo].[Firm] ([ID])
GO
ALTER TABLE [dbo].[Attorney] ADD CONSTRAINT [FK_Attorney_States] FOREIGN KEY ([StateID]) REFERENCES [dbo].[States] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[SurgeryInvoice_Provider_CPTCodes]'
GO
ALTER TABLE [dbo].[SurgeryInvoice_Provider_CPTCodes] ADD CONSTRAINT [FK_Provider_CPTCodes_CPTCodes] FOREIGN KEY ([CPTCodeID]) REFERENCES [dbo].[CPTCodes_BAD] ([ID])
GO
ALTER TABLE [dbo].[SurgeryInvoice_Provider_CPTCodes] ADD CONSTRAINT [FK_SurgeryInvoice_Provider_CPTCodes_SurgeryInvoice_Providers] FOREIGN KEY ([SurgeryInvoice_ProviderID]) REFERENCES [dbo].[SurgeryInvoice_Providers] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[CPTCodes_BAD]'
GO
ALTER TABLE [dbo].[CPTCodes_BAD] ADD CONSTRAINT [FK_CPTCodes_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Company] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[Comments]'
GO
ALTER TABLE [dbo].[Comments] ADD CONSTRAINT [FK_Comments_CommentType] FOREIGN KEY ([CommentTypeID]) REFERENCES [dbo].[CommentType] ([ID])
GO
ALTER TABLE [dbo].[Comments] ADD CONSTRAINT [FK_Comments_Invoice] FOREIGN KEY ([InvoiceID]) REFERENCES [dbo].[Invoice] ([ID])
GO
ALTER TABLE [dbo].[Comments] ADD CONSTRAINT [FK_Comments_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[Firm]'
GO
ALTER TABLE [dbo].[Firm] ADD CONSTRAINT [FK_Firm_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Company] ([ID])
GO
ALTER TABLE [dbo].[Firm] ADD CONSTRAINT [FK_Firm_ResourceInfo] FOREIGN KEY ([ContactListID]) REFERENCES [dbo].[ContactList] ([ID])
GO
ALTER TABLE [dbo].[Firm] ADD CONSTRAINT [FK_Firm_States] FOREIGN KEY ([StateID]) REFERENCES [dbo].[States] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[Invoice]'
GO
ALTER TABLE [dbo].[Invoice] ADD CONSTRAINT [FK_Invoice_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Company] ([ID])
GO
ALTER TABLE [dbo].[Invoice] ADD CONSTRAINT [FK_Invoice_Attorney] FOREIGN KEY ([InvoiceAttorneyID]) REFERENCES [dbo].[InvoiceAttorney] ([ID])
GO
ALTER TABLE [dbo].[Invoice] ADD CONSTRAINT [FK_Invoice_Patient] FOREIGN KEY ([InvoicePatientID]) REFERENCES [dbo].[InvoicePatient] ([ID])
GO
ALTER TABLE [dbo].[Invoice] ADD CONSTRAINT [FK_Invoice_Physicians] FOREIGN KEY ([InvoicePhysicianID]) REFERENCES [dbo].[InvoicePhysician] ([ID])
GO
ALTER TABLE [dbo].[Invoice] ADD CONSTRAINT [FK_Invoice_InvoiceStatusType] FOREIGN KEY ([InvoiceStatusTypeID]) REFERENCES [dbo].[InvoiceStatusType] ([ID])
GO
ALTER TABLE [dbo].[Invoice] ADD CONSTRAINT [FK_Invoice_InvoiceType] FOREIGN KEY ([InvoiceTypeID]) REFERENCES [dbo].[InvoiceType] ([ID])
GO
ALTER TABLE [dbo].[Invoice] ADD CONSTRAINT [FK_Invoice_TestInvoice] FOREIGN KEY ([TestInvoiceID]) REFERENCES [dbo].[TestInvoice] ([ID])
GO
ALTER TABLE [dbo].[Invoice] ADD CONSTRAINT [FK_Invoice_SurgeryInvoice] FOREIGN KEY ([SurgeryInvoiceID]) REFERENCES [dbo].[SurgeryInvoice] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[LoanTerms]'
GO
ALTER TABLE [dbo].[LoanTerms] ADD CONSTRAINT [FK_LoanTerms_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Company] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[Patient]'
GO
ALTER TABLE [dbo].[Patient] ADD CONSTRAINT [FK_Patient_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Company] ([ID])
GO
ALTER TABLE [dbo].[Patient] ADD CONSTRAINT [FK_Patient_States] FOREIGN KEY ([StateID]) REFERENCES [dbo].[States] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[Physician]'
GO
ALTER TABLE [dbo].[Physician] ADD CONSTRAINT [FK_Physician_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Company] ([ID])
GO
ALTER TABLE [dbo].[Physician] ADD CONSTRAINT [FK_Physicians_ResourceInfo] FOREIGN KEY ([ContactListID]) REFERENCES [dbo].[ContactList] ([ID])
GO
ALTER TABLE [dbo].[Physician] ADD CONSTRAINT [FK_Physician_States] FOREIGN KEY ([StateID]) REFERENCES [dbo].[States] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[Provider]'
GO
ALTER TABLE [dbo].[Provider] ADD CONSTRAINT [FK_Provider_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Company] ([ID])
GO
ALTER TABLE [dbo].[Provider] ADD CONSTRAINT [FK_Provider_ContactList] FOREIGN KEY ([ContactListID]) REFERENCES [dbo].[ContactList] ([ID])
GO
ALTER TABLE [dbo].[Provider] ADD CONSTRAINT [FK_Provider_MRICostType] FOREIGN KEY ([MRICostTypeID]) REFERENCES [dbo].[MRICostType] ([ID])
GO
ALTER TABLE [dbo].[Provider] ADD CONSTRAINT [FK_Provider_States] FOREIGN KEY ([StateID]) REFERENCES [dbo].[States] ([ID])
GO
ALTER TABLE [dbo].[Provider] ADD CONSTRAINT [FK_Provider_States_Billing] FOREIGN KEY ([StateID_Billing]) REFERENCES [dbo].[States] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[Surgery]'
GO
ALTER TABLE [dbo].[Surgery] ADD CONSTRAINT [FK_Surgery_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Company] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[Test]'
GO
ALTER TABLE [dbo].[Test] ADD CONSTRAINT [FK_Test_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Company] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[Users]'
GO
ALTER TABLE [dbo].[Users] ADD CONSTRAINT [FK_Users_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Company] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[Contacts]'
GO
ALTER TABLE [dbo].[Contacts] ADD CONSTRAINT [FK_Contacts_ContactList] FOREIGN KEY ([ContactListID]) REFERENCES [dbo].[ContactList] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[InvoiceFirm]'
GO
ALTER TABLE [dbo].[InvoiceFirm] ADD CONSTRAINT [FK_InvoiceFirm_Firm] FOREIGN KEY ([FirmID]) REFERENCES [dbo].[Firm] ([ID])
GO
ALTER TABLE [dbo].[InvoiceFirm] ADD CONSTRAINT [FK_InvoiceFirm_InvoiceContactList] FOREIGN KEY ([InvoiceContactListID]) REFERENCES [dbo].[InvoiceContactList] ([ID])
GO
ALTER TABLE [dbo].[InvoiceFirm] ADD CONSTRAINT [FK_InvoiceFirm_States] FOREIGN KEY ([StateID]) REFERENCES [dbo].[States] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[SurgeryInvoice_Surgery_ICDCodes]'
GO
ALTER TABLE [dbo].[SurgeryInvoice_Surgery_ICDCodes] ADD CONSTRAINT [FK_SurgeryInvoice_Surgery_ICDCodes_ICDCodes] FOREIGN KEY ([ICDCodeID]) REFERENCES [dbo].[ICDCodes] ([ID])
GO
ALTER TABLE [dbo].[SurgeryInvoice_Surgery_ICDCodes] ADD CONSTRAINT [FK_SurgeryInvoice_Surgery_ICDCodes_SurgeryInvoice_Surgery] FOREIGN KEY ([SurgeryInvoice_SurgeryID]) REFERENCES [dbo].[SurgeryInvoice_Surgery] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[InvoiceChangeLog]'
GO
ALTER TABLE [dbo].[InvoiceChangeLog] ADD CONSTRAINT [FK_InvoiceChangeLog_InvoiceChangeLogType] FOREIGN KEY ([InvoiceChangeLogTypeID]) REFERENCES [dbo].[InvoiceChangeLogType] ([ID])
GO
ALTER TABLE [dbo].[InvoiceChangeLog] ADD CONSTRAINT [FK_InvoiceChangeLog_Invoice] FOREIGN KEY ([InvoiceID]) REFERENCES [dbo].[Invoice] ([ID])
GO
ALTER TABLE [dbo].[InvoiceChangeLog] ADD CONSTRAINT [FK_InvoiceChangeLog_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[InvoiceContacts]'
GO
ALTER TABLE [dbo].[InvoiceContacts] ADD CONSTRAINT [FK_InvoiceContacts_InvoiceContactList] FOREIGN KEY ([InvoiceContactListID]) REFERENCES [dbo].[InvoiceContactList] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[InvoicePhysician]'
GO
ALTER TABLE [dbo].[InvoicePhysician] ADD CONSTRAINT [FK_InvoicePhysician_InvoiceContactList] FOREIGN KEY ([InvoiceContactListID]) REFERENCES [dbo].[InvoiceContactList] ([ID])
GO
ALTER TABLE [dbo].[InvoicePhysician] ADD CONSTRAINT [FK_InvoicePhysician_Physician] FOREIGN KEY ([PhysicianID]) REFERENCES [dbo].[Physician] ([ID])
GO
ALTER TABLE [dbo].[InvoicePhysician] ADD CONSTRAINT [FK_InvoicePhysician_States] FOREIGN KEY ([StateID]) REFERENCES [dbo].[States] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[InvoiceProvider]'
GO
ALTER TABLE [dbo].[InvoiceProvider] ADD CONSTRAINT [FK_InvoiceProvider_InvoiceContactList] FOREIGN KEY ([InvoiceContactListID]) REFERENCES [dbo].[InvoiceContactList] ([ID])
GO
ALTER TABLE [dbo].[InvoiceProvider] ADD CONSTRAINT [FK_InvoiceProvider_Provider] FOREIGN KEY ([ProviderID]) REFERENCES [dbo].[Provider] ([ID])
GO
ALTER TABLE [dbo].[InvoiceProvider] ADD CONSTRAINT [FK_InvoiceProvider_States] FOREIGN KEY ([StateID]) REFERENCES [dbo].[States] ([ID])
GO
ALTER TABLE [dbo].[InvoiceProvider] ADD CONSTRAINT [FK_InvoiceProvider_MRICostType] FOREIGN KEY ([MRICostTypeID]) REFERENCES [dbo].[MRICostType] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[InvoiceInterestCalculationLog]'
GO
ALTER TABLE [dbo].[InvoiceInterestCalculationLog] ADD CONSTRAINT [FK_InvoiceInterestCalculationLog_Invoice] FOREIGN KEY ([InvoiceID]) REFERENCES [dbo].[Invoice] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[InvoicePatient]'
GO
ALTER TABLE [dbo].[InvoicePatient] ADD CONSTRAINT [FK_InvoicePatient_Patient] FOREIGN KEY ([PatientID]) REFERENCES [dbo].[Patient] ([ID])
GO
ALTER TABLE [dbo].[InvoicePatient] ADD CONSTRAINT [FK_InvoicePatient_States] FOREIGN KEY ([StateID]) REFERENCES [dbo].[States] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[SurgeryInvoice_Providers]'
GO
ALTER TABLE [dbo].[SurgeryInvoice_Providers] ADD CONSTRAINT [FK_SurgeryInvoice_Providers_Provider] FOREIGN KEY ([InvoiceProviderID]) REFERENCES [dbo].[InvoiceProvider] ([ID])
GO
ALTER TABLE [dbo].[SurgeryInvoice_Providers] ADD CONSTRAINT [FK_SurgeryInvoice_Providers_SurgeryInvoice] FOREIGN KEY ([SurgeryInvoiceID]) REFERENCES [dbo].[SurgeryInvoice] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[TestInvoice_Test]'
GO
ALTER TABLE [dbo].[TestInvoice_Test] ADD CONSTRAINT [FK_TestInvoice_Test_Provider] FOREIGN KEY ([InvoiceProviderID]) REFERENCES [dbo].[InvoiceProvider] ([ID])
GO
ALTER TABLE [dbo].[TestInvoice_Test] ADD CONSTRAINT [FK_TestInvoice_Test_TestInvoice] FOREIGN KEY ([TestInvoiceID]) REFERENCES [dbo].[TestInvoice] ([ID])
GO
ALTER TABLE [dbo].[TestInvoice_Test] ADD CONSTRAINT [FK_TestInvoice_Test_Test] FOREIGN KEY ([TestID]) REFERENCES [dbo].[Test] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[Payments]'
GO
ALTER TABLE [dbo].[Payments] ADD CONSTRAINT [FK_Payments_Invoice] FOREIGN KEY ([InvoiceID]) REFERENCES [dbo].[Invoice] ([ID])
GO
ALTER TABLE [dbo].[Payments] ADD CONSTRAINT [FK_Payments_PaymentType] FOREIGN KEY ([PaymentTypeID]) REFERENCES [dbo].[PaymentType] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[PatientChangeLog]'
GO
ALTER TABLE [dbo].[PatientChangeLog] ADD CONSTRAINT [FK_PatientChangeLog_Patient] FOREIGN KEY ([PatientID]) REFERENCES [dbo].[Patient] ([ID])
GO
ALTER TABLE [dbo].[PatientChangeLog] ADD CONSTRAINT [FK_PatientChangeLog_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[SurgeryInvoice_Provider_Payments]'
GO
ALTER TABLE [dbo].[SurgeryInvoice_Provider_Payments] ADD CONSTRAINT [FK_SurgeryInvoice_Provider_Payments_PaymentType] FOREIGN KEY ([PaymentTypeID]) REFERENCES [dbo].[PaymentType] ([ID])
GO
ALTER TABLE [dbo].[SurgeryInvoice_Provider_Payments] ADD CONSTRAINT [FK_SurgeryInvoice_Provider_Payments_SurgeryInvoice_Providers] FOREIGN KEY ([SurgeryInvoice_ProviderID]) REFERENCES [dbo].[SurgeryInvoice_Providers] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[UserPermissions]'
GO
ALTER TABLE [dbo].[UserPermissions] ADD CONSTRAINT [FK_UserPermissions_Permissions] FOREIGN KEY ([PermissionID]) REFERENCES [dbo].[Permissions] ([ID])
GO
ALTER TABLE [dbo].[UserPermissions] ADD CONSTRAINT [FK_UserPermissions_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[SurgeryInvoice_Surgery]'
GO
ALTER TABLE [dbo].[SurgeryInvoice_Surgery] ADD CONSTRAINT [FK_SurgeryInvoice_Surgery_SurgeryInvoice] FOREIGN KEY ([SurgeryInvoiceID]) REFERENCES [dbo].[SurgeryInvoice] ([ID])
GO
ALTER TABLE [dbo].[SurgeryInvoice_Surgery] ADD CONSTRAINT [FK_SurgeryInvoice_Surgery_Surgery] FOREIGN KEY ([SurgeryID]) REFERENCES [dbo].[Surgery] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[SurgeryInvoice_Provider_Services]'
GO
ALTER TABLE [dbo].[SurgeryInvoice_Provider_Services] ADD CONSTRAINT [FK_SurgeryInvoice_Provider_Services_SurgeryInvoice_Providers] FOREIGN KEY ([SurgeryInvoice_ProviderID]) REFERENCES [dbo].[SurgeryInvoice_Providers] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[SurgeryInvoice_SurgeryDates]'
GO
ALTER TABLE [dbo].[SurgeryInvoice_SurgeryDates] ADD CONSTRAINT [FK_SurgeryInvoice_Dates_SurgeryInvoice] FOREIGN KEY ([SurgeryInvoice_SurgeryID]) REFERENCES [dbo].[SurgeryInvoice_Surgery] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[TestInvoice]'
GO
ALTER TABLE [dbo].[TestInvoice] ADD CONSTRAINT [FK_TestInvoice_TestType] FOREIGN KEY ([TestTypeID]) REFERENCES [dbo].[TestType] ([ID])
GO
PRINT N'Adding foreign keys to [dbo].[TestInvoice_Test_CPTCodes]'
GO
ALTER TABLE [dbo].[TestInvoice_Test_CPTCodes] ADD CONSTRAINT [FK_TestInvoice_Test_CPTCodes_TestInvoice_Test] FOREIGN KEY ([TestInvoice_TestID]) REFERENCES [dbo].[TestInvoice_Test] ([ID])
GO
