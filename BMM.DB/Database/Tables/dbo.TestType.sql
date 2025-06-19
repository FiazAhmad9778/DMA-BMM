CREATE TABLE [dbo].[TestType]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_TestType_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_TestType_DateAdded] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TestType] ADD CONSTRAINT [PK_TestType] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
