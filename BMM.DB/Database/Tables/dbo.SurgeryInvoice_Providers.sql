CREATE TABLE [dbo].[SurgeryInvoice_Providers]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SurgeryInvoiceID] [int] NOT NULL,
[InvoiceProviderID] [int] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Providers_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Providers_DateAdded] DEFAULT (getdate()),
[Temp_InvoiceID] [int] NULL,
[Temp_ProviderID] [int] NULL,
[Temp_ServiceID] [int] NULL,
[Temp_CompanyID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SurgeryInvoice_Providers] ADD CONSTRAINT [PK_SurgeryInvoice_Providers] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SurgeryInvoice_Providers] ON [dbo].[SurgeryInvoice_Providers] ([ID], [InvoiceProviderID], [SurgeryInvoiceID], [Active]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IS_SurgeryInvoiceID] ON [dbo].[SurgeryInvoice_Providers] ([SurgeryInvoiceID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SurgeryInvoice_Providers] ADD CONSTRAINT [FK_SurgeryInvoice_Providers_Provider] FOREIGN KEY ([InvoiceProviderID]) REFERENCES [dbo].[InvoiceProvider] ([ID])
GO
ALTER TABLE [dbo].[SurgeryInvoice_Providers] ADD CONSTRAINT [FK_SurgeryInvoice_Providers_SurgeryInvoice] FOREIGN KEY ([SurgeryInvoiceID]) REFERENCES [dbo].[SurgeryInvoice] ([ID])
GO
