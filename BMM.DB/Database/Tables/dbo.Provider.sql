CREATE TABLE [dbo].[Provider]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CompanyID] [int] NOT NULL,
[ContactListID] [int] NOT NULL,
[isActiveStatus] [bit] NOT NULL CONSTRAINT [DF_Providers_isActiveStatus] DEFAULT ((1)),
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
[Active] [bit] NOT NULL CONSTRAINT [DF_Providers_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_Providers_DateAdded] DEFAULT (getdate()),
[Temp_ProviderID] [int] NULL,
[Temp_Type] [nchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Provider] ADD CONSTRAINT [PK_Providers] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Provider] ON [dbo].[Provider] ([ID], [DiscountPercentage], [MRICostFlatRate], [MRICostTypeID], [MRICostPercentage], [Active]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Provider] ADD CONSTRAINT [FK_Provider_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Company] ([ID])
GO
ALTER TABLE [dbo].[Provider] ADD CONSTRAINT [FK_Provider_ContactList] FOREIGN KEY ([ContactListID]) REFERENCES [dbo].[ContactList] ([ID])
GO
ALTER TABLE [dbo].[Provider] ADD CONSTRAINT [FK_Provider_MRICostType] FOREIGN KEY ([MRICostTypeID]) REFERENCES [dbo].[MRICostType] ([ID])
GO
ALTER TABLE [dbo].[Provider] ADD CONSTRAINT [FK_Provider_States] FOREIGN KEY ([StateID]) REFERENCES [dbo].[States] ([ID])
GO
