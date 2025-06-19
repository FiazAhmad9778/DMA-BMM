CREATE TABLE [dbo].[SurgeryInvoice]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Active] [bit] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_SurgeryInvoice_DateAdded] DEFAULT (getdate()),
[Temp_InvoiceID] [int] NULL,
[Temp_CompanyID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SurgeryInvoice] ADD CONSTRAINT [PK_SurgeryInvoice] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
