CREATE TABLE [dbo].[Firm]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CompanyID] [int] NOT NULL,
[ContactListID] [int] NOT NULL,
[isActiveStatus] [bit] NOT NULL CONSTRAINT [DF_Firm_isActiveStatus] DEFAULT ((1)),
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Street1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Street2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StateID] [int] NOT NULL,
[ZipCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Phone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Fax] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Firm_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_Firm_DateAdded] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Firm] ADD CONSTRAINT [PK_Firm] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Firm] ADD CONSTRAINT [FK_Firm_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Company] ([ID])
GO
ALTER TABLE [dbo].[Firm] ADD CONSTRAINT [FK_Firm_ResourceInfo] FOREIGN KEY ([ContactListID]) REFERENCES [dbo].[ContactList] ([ID])
GO
ALTER TABLE [dbo].[Firm] ADD CONSTRAINT [FK_Firm_States] FOREIGN KEY ([StateID]) REFERENCES [dbo].[States] ([ID])
GO
