CREATE TABLE [dbo].[Contacts1]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ContactListID] [int] NULL,
[Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Position] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NULL,
[DateAdded] [datetime] NULL,
[Temp_CompanyID] [int] NULL
) ON [PRIMARY]
GO
