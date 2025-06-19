CREATE TABLE [dbo].[InvoicePhysician]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[InvoiceContactListID] [int] NOT NULL,
[PhysicianID] [int] NOT NULL,
[isActiveStatus] [bit] NOT NULL CONSTRAINT [DF_InvoicePhysician_isActiveStatus] DEFAULT ((1)),
[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Street1] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Street2] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StateID] [int] NOT NULL,
[ZipCode] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Phone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Fax] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_InvoicePhysician_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_InvoicePhysician_DateAdded] DEFAULT (getdate()),
[Temp_InvoiceNumber] [int] NULL,
[Temp_PhysicianID] [int] NULL,
[Temp_CompanyID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[InvoicePhysician] ADD CONSTRAINT [PK_InvoicePhysician] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InvoicePhysician] ADD CONSTRAINT [FK_InvoicePhysician_InvoiceContactList] FOREIGN KEY ([InvoiceContactListID]) REFERENCES [dbo].[InvoiceContactList] ([ID])
GO
ALTER TABLE [dbo].[InvoicePhysician] ADD CONSTRAINT [FK_InvoicePhysician_Physician] FOREIGN KEY ([PhysicianID]) REFERENCES [dbo].[Physician] ([ID])
GO
ALTER TABLE [dbo].[InvoicePhysician] ADD CONSTRAINT [FK_InvoicePhysician_States] FOREIGN KEY ([StateID]) REFERENCES [dbo].[States] ([ID])
GO
