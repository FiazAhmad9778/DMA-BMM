CREATE TABLE [dbo].[InvoiceStatusType]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_InvoiceStatusType_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_InvoiceStatusType_DateAdded] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InvoiceStatusType] ADD CONSTRAINT [PK_InvoiceStatusType] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
