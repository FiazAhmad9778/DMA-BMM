CREATE TABLE [dbo].[InvoiceType]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_InvoiceType_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_InvoiceType_DateAdded] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InvoiceType] ADD CONSTRAINT [PK_InvoiceType] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
