CREATE TABLE [dbo].[Attorney]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CompanyID] [int] NOT NULL,
[ContactListID] [int] NOT NULL,
[FirmID] [int] NULL,
[isActiveStatus] [bit] NOT NULL CONSTRAINT [DF_Attorney_isActiveStatus] DEFAULT ((1)),
[FirstName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Street1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Street2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StateID] [int] NOT NULL,
[ZipCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Phone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Fax] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DiscountNotes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepositAmountRequired] [decimal] (18, 4) NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Attorney_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_Attorney_DateAdded] DEFAULT (getdate()),
[Temp_AttorneyID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attorney] ADD CONSTRAINT [PK_Attorney] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attorney] ADD CONSTRAINT [FK_Attorney_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Company] ([ID])
GO
ALTER TABLE [dbo].[Attorney] ADD CONSTRAINT [FK_Attorney_Firm] FOREIGN KEY ([FirmID]) REFERENCES [dbo].[Firm] ([ID])
GO
ALTER TABLE [dbo].[Attorney] ADD CONSTRAINT [FK_Attorney_ResourceInfo] FOREIGN KEY ([ContactListID]) REFERENCES [dbo].[ContactList] ([ID])
GO
ALTER TABLE [dbo].[Attorney] ADD CONSTRAINT [FK_Attorney_States] FOREIGN KEY ([StateID]) REFERENCES [dbo].[States] ([ID])
GO
