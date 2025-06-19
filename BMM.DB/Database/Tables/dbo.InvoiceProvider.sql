CREATE TABLE [dbo].[InvoiceProvider]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[InvoiceContactListID] [int] NOT NULL,
[ProviderID] [int] NOT NULL,
[isActiveStatus] [bit] NOT NULL CONSTRAINT [DF_InvoiceProvider_isActiveStatus] DEFAULT ((1)),
[Name] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Street1] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Street2] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StateID] [int] NOT NULL,
[ZipCode] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Phone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Fax] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FacilityAbbreviation] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[InvoiceProvider] ADD CONSTRAINT [PK_InvoiceProvider] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_InvoiceProvider] ON [dbo].[InvoiceProvider] ([ID], [MRICostFlatRate], [MRICostPercentage], [MRICostTypeID], [ProviderID], [Deposits], [Active]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InvoiceProvider] ADD CONSTRAINT [FK_InvoiceProvider_InvoiceContactList] FOREIGN KEY ([InvoiceContactListID]) REFERENCES [dbo].[InvoiceContactList] ([ID])
GO
ALTER TABLE [dbo].[InvoiceProvider] ADD CONSTRAINT [FK_InvoiceProvider_MRICostType] FOREIGN KEY ([MRICostTypeID]) REFERENCES [dbo].[MRICostType] ([ID])
GO
ALTER TABLE [dbo].[InvoiceProvider] ADD CONSTRAINT [FK_InvoiceProvider_Provider] FOREIGN KEY ([ProviderID]) REFERENCES [dbo].[Provider] ([ID])
GO
ALTER TABLE [dbo].[InvoiceProvider] ADD CONSTRAINT [FK_InvoiceProvider_States] FOREIGN KEY ([StateID]) REFERENCES [dbo].[States] ([ID])
GO
