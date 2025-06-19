CREATE TABLE [dbo].[Surgery]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CompanyID] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Surgery_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_Surgery_DateAdded] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Surgery] ADD CONSTRAINT [PK_Surgery] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Surgery] ON [dbo].[Surgery] ([ID], [Active]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Surgery] ADD CONSTRAINT [FK_Surgery_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Company] ([ID])
GO
