CREATE TABLE [dbo].[Test]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CompanyID] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Test_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_Test_DateAdded] DEFAULT (getdate()),
[Temp_TestTypeID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Test] ADD CONSTRAINT [PK_Test] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Test] ADD CONSTRAINT [FK_Test_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Company] ([ID])
GO
