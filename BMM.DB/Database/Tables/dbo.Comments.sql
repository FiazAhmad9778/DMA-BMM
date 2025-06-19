CREATE TABLE [dbo].[Comments]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[InvoiceID] [int] NOT NULL,
[UserID] [int] NOT NULL,
[CommentTypeID] [int] NOT NULL,
[Text] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[isIncludedOnReports] [bit] NOT NULL CONSTRAINT [DF_Comments_isIncludedOnReports] DEFAULT ((1)),
[Active] [bit] NOT NULL CONSTRAINT [DF_Comment_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_Comment_DateAdded] DEFAULT (getdate()),
[Temp_CompanyID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Comments] ADD CONSTRAINT [PK_Comment] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Comments] ON [dbo].[Comments] ([ID], [InvoiceID], [CommentTypeID], [isIncludedOnReports], [Active]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_InvoiceID] ON [dbo].[Comments] ([InvoiceID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Comments] ADD CONSTRAINT [FK_Comments_CommentType] FOREIGN KEY ([CommentTypeID]) REFERENCES [dbo].[CommentType] ([ID])
GO
ALTER TABLE [dbo].[Comments] ADD CONSTRAINT [FK_Comments_Invoice] FOREIGN KEY ([InvoiceID]) REFERENCES [dbo].[Invoice] ([ID])
GO
ALTER TABLE [dbo].[Comments] ADD CONSTRAINT [FK_Comments_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([ID])
GO
