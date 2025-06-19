CREATE TABLE [dbo].[InvoiceChangeLog]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[InvoiceID] [int] NOT NULL,
[InvoiceChangeLogTypeID] [int] NOT NULL,
[Amount] [decimal] (18, 2) NOT NULL,
[UserID] [int] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_InvoiceChangeLog_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_InvoiceChangeLog_DateAdded] DEFAULT (getdate()),
[Temp_CompanyID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InvoiceChangeLog] ADD CONSTRAINT [PK_InvoiceChangeLog] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InvoiceChangeLog] ADD CONSTRAINT [FK_InvoiceChangeLog_Invoice] FOREIGN KEY ([InvoiceID]) REFERENCES [dbo].[Invoice] ([ID])
GO
ALTER TABLE [dbo].[InvoiceChangeLog] ADD CONSTRAINT [FK_InvoiceChangeLog_InvoiceChangeLogType] FOREIGN KEY ([InvoiceChangeLogTypeID]) REFERENCES [dbo].[InvoiceChangeLogType] ([ID])
GO
ALTER TABLE [dbo].[InvoiceChangeLog] ADD CONSTRAINT [FK_InvoiceChangeLog_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([ID])
GO
