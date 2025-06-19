CREATE TABLE [dbo].[InvoiceFirm]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[FirmID] [int] NOT NULL,
[InvoiceContactListID] [int] NOT NULL,
[isActiveStatus] [bit] NOT NULL CONSTRAINT [DF_InvoiceFirm_isActiveStatus] DEFAULT ((1)),
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Street1] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Street2] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StateID] [int] NOT NULL,
[ZipCode] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Phone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Fax] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_InvoiceFirm_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_InvoiceFirm_DateAdded] DEFAULT (getdate()),
[Temp_CompanyID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InvoiceFirm] ADD CONSTRAINT [PK_InvoiceFirm] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InvoiceFirm] ADD CONSTRAINT [FK_InvoiceFirm_Firm] FOREIGN KEY ([FirmID]) REFERENCES [dbo].[Firm] ([ID])
GO
ALTER TABLE [dbo].[InvoiceFirm] ADD CONSTRAINT [FK_InvoiceFirm_InvoiceContactList] FOREIGN KEY ([InvoiceContactListID]) REFERENCES [dbo].[InvoiceContactList] ([ID])
GO
ALTER TABLE [dbo].[InvoiceFirm] ADD CONSTRAINT [FK_InvoiceFirm_States] FOREIGN KEY ([StateID]) REFERENCES [dbo].[States] ([ID])
GO
