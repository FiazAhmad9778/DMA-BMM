CREATE TABLE [dbo].[InvoiceChangeLogType]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_InvoiceChangeLogType_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_InvoiceChangeLogType_DateAdded] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InvoiceChangeLogType] ADD CONSTRAINT [PK_InvoiceChangeLogType] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
