CREATE TABLE [dbo].[Physician_Backup03262014]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CompanyID] [int] NULL,
[ContactListID] [int] NULL,
[isActiveStatus] [bit] NULL,
[FirstName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StateID] [int] NULL,
[ZipCode] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NULL,
[DateAdded] [datetime] NULL,
[Temp_PhysicianID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
