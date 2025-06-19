CREATE TABLE [dbo].[DATAMIGRATION_BMM_ImportOfMissingInvoices]
(
[InvoiceNumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DATAMIGRATION_BMM_ImportOfMissingInvoices] ADD CONSTRAINT [PK_DATAMIGRATION_BMM_ImportOfMissingInvoices] PRIMARY KEY CLUSTERED  ([InvoiceNumber]) ON [PRIMARY]
GO
