CREATE TABLE [dbo].[InvoiceAttorney]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AttorneyID] [int] NOT NULL,
[InvoiceContactListID] [int] NOT NULL,
[InvoiceFirmID] [int] NULL,
[isActiveStatus] [bit] NOT NULL CONSTRAINT [DF_InvoiceAttorneyLog_isActiveStatus] DEFAULT ((1)),
[FirstName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Street1] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Street2] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StateID] [int] NOT NULL,
[ZipCode] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Phone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Fax] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DiscountNotes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepositAmountRequired] [decimal] (18, 2) NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_InvoiceAttorneyLog_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_InvoiceAttorneyLog_DateAdded] DEFAULT (getdate()),
[Temp_InvoiceNumber] [int] NULL,
[Temp_AttorneyID] [int] NULL,
[Temp_CompanyID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[InvoiceAttorney] ADD CONSTRAINT [PK_InvoiceAttorneyLog] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_InvoiceAttorney_missing_43] ON [dbo].[InvoiceAttorney] ([Active]) INCLUDE ([AttorneyID], [ID], [InvoiceFirmID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>] ON [dbo].[InvoiceAttorney] ([AttorneyID], [Active]) INCLUDE ([ID], [InvoiceFirmID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [1] ON [dbo].[InvoiceAttorney] ([AttorneyID], [Active]) INCLUDE ([ID], [InvoiceFirmID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InvoiceAttorney] ADD CONSTRAINT [FK_InvoiceAttorney_InvoiceContactList] FOREIGN KEY ([InvoiceContactListID]) REFERENCES [dbo].[InvoiceContactList] ([ID])
GO
ALTER TABLE [dbo].[InvoiceAttorney] ADD CONSTRAINT [FK_InvoiceAttorney_InvoiceFirm] FOREIGN KEY ([InvoiceFirmID]) REFERENCES [dbo].[InvoiceFirm] ([ID])
GO
ALTER TABLE [dbo].[InvoiceAttorney] ADD CONSTRAINT [FK_InvoiceAttorney_States] FOREIGN KEY ([StateID]) REFERENCES [dbo].[States] ([ID])
GO
ALTER TABLE [dbo].[InvoiceAttorney] ADD CONSTRAINT [FK_InvoiceAttorneyLog_Attorney] FOREIGN KEY ([AttorneyID]) REFERENCES [dbo].[Attorney] ([ID])
GO
