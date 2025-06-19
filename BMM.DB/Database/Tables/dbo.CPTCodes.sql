CREATE TABLE [dbo].[CPTCodes]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CompanyID] [int] NULL,
[Code] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NULL,
[DateAdded] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_CPTCodes_missing_41] ON [dbo].[CPTCodes] ([ID]) ON [PRIMARY]
GO
