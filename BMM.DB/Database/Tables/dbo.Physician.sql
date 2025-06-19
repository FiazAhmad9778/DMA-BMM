CREATE TABLE [dbo].[Physician]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CompanyID] [int] NOT NULL,
[ContactListID] [int] NOT NULL,
[isActiveStatus] [bit] NOT NULL CONSTRAINT [DF_Physician_isActiveStatus] DEFAULT ((1)),
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
[Active] [bit] NOT NULL CONSTRAINT [DF_Physicians_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_Physicians_DateAdded] DEFAULT (getdate()),
[Temp_PhysicianID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Physician] ADD CONSTRAINT [PK_Physicians] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Physician] ADD CONSTRAINT [FK_Physician_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Company] ([ID])
GO
ALTER TABLE [dbo].[Physician] ADD CONSTRAINT [FK_Physician_States] FOREIGN KEY ([StateID]) REFERENCES [dbo].[States] ([ID])
GO
ALTER TABLE [dbo].[Physician] ADD CONSTRAINT [FK_Physicians_ResourceInfo] FOREIGN KEY ([ContactListID]) REFERENCES [dbo].[ContactList] ([ID])
GO
