CREATE TABLE [dbo].[ICDCodes]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ShortDescription] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LongDescription] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ICDVersion] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_ICDCodes_Active] DEFAULT ((1)),
[CompanyID] [int] NOT NULL,
[Code] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ICDCodes] ADD CONSTRAINT [PK_ICDCodes] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
