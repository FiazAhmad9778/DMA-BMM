CREATE TABLE [dbo].[InvoicePatient]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[PatientID] [int] NOT NULL,
[isActiveStatus] [bit] NOT NULL CONSTRAINT [DF_InvoicePatient_isActiveStatus] DEFAULT ((1)),
[FirstName] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastName] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSN] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Street1] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Street2] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StateID] [int] NOT NULL,
[ZipCode] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Phone] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WorkPhone] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateOfBirth] [date] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_InvoicePatient_Active] DEFAULT ((1)),
[DateAdded] [datetime] NULL CONSTRAINT [DF_InvoicePatient_DateAdded] DEFAULT (getdate()),
[Temp_CompanyID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InvoicePatient] ADD CONSTRAINT [PK_InvoicePatient] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_InvoicePatient_missing_15] ON [dbo].[InvoicePatient] ([PatientID], [Active]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InvoicePatient] ADD CONSTRAINT [FK_InvoicePatient_Patient] FOREIGN KEY ([PatientID]) REFERENCES [dbo].[Patient] ([ID])
GO
ALTER TABLE [dbo].[InvoicePatient] ADD CONSTRAINT [FK_InvoicePatient_States] FOREIGN KEY ([StateID]) REFERENCES [dbo].[States] ([ID])
GO
