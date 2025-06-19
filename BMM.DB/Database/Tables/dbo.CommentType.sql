CREATE TABLE [dbo].[CommentType]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_ContactType_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_ContactType_DateAdded] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CommentType] ADD CONSTRAINT [PK_ContactType] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
