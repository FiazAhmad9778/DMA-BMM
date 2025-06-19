-- <Migration ID="839d1c13-8397-48da-94d7-15cc36dfd7a4" />
GO

PRINT N'Creating index [InvoicePatient_Active] on [dbo].[InvoicePatient]'
GO
CREATE NONCLUSTERED INDEX [InvoicePatient_Active] ON [dbo].[InvoicePatient] ([Active]) INCLUDE ([FirstName], [LastName])
GO
PRINT N'Creating index [IX_Invoice_AccountsReceivable] on [dbo].[Invoice]'
GO
CREATE NONCLUSTERED INDEX [IX_Invoice_AccountsReceivable] ON [dbo].[Invoice] ([CompanyID], [isComplete], [InvoiceTypeID], [Active], [InvoiceStatusTypeID]) INCLUDE ([InvoiceAttorneyID], [InvoiceNumber], [InvoicePatientID], [ServiceFeeWaivedMonths])
GO
