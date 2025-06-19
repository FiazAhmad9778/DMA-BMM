CREATE TABLE [dbo].[TestInvoice]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[TestTypeID] [int] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_TestInvoice_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_TestInvoice_DateAdded] DEFAULT (getdate()),
[Temp_TestNo] [int] NULL,
[Temp_InvoiceID] [int] NULL,
[Temp_CompanyID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TestInvoice] ADD CONSTRAINT [PK_TestInvoice] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TestInvoice] ADD CONSTRAINT [FK_TestInvoice_TestType] FOREIGN KEY ([TestTypeID]) REFERENCES [dbo].[TestType] ([ID])
GO
