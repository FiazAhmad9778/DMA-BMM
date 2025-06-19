-- <Migration ID="fa3521fe-5609-45e8-86e9-b0291b298486" />
GO

PRINT N'Creating index [IX_InvoiceProvider_ProviderID] on [dbo].[InvoiceProvider]'
GO
CREATE NONCLUSTERED INDEX [IX_InvoiceProvider_ProviderID] ON [dbo].[InvoiceProvider] ([ProviderID])
GO
PRINT N'Creating index [IX_Invoice_SurgeryInvoice] on [dbo].[Invoice]'
GO
CREATE NONCLUSTERED INDEX [IX_Invoice_SurgeryInvoice] ON [dbo].[Invoice] ([SurgeryInvoiceID]) INCLUDE ([InvoiceAttorneyID], [InvoiceNumber], [InvoicePatientID])
GO
PRINT N'Creating index [IX_Invoice_TestInvoice] on [dbo].[Invoice]'
GO
CREATE NONCLUSTERED INDEX [IX_Invoice_TestInvoice] ON [dbo].[Invoice] ([TestInvoiceID]) INCLUDE ([InvoiceAttorneyID], [InvoiceNumber], [InvoicePatientID])
GO
PRINT N'Creating index [Ix_SurgeryInvoice_Providers_InvoiceProvider] on [dbo].[SurgeryInvoice_Providers]'
GO
CREATE NONCLUSTERED INDEX [Ix_SurgeryInvoice_Providers_InvoiceProvider] ON [dbo].[SurgeryInvoice_Providers] ([InvoiceProviderID]) INCLUDE ([SurgeryInvoiceID])
GO
