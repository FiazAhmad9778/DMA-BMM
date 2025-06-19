CREATE TABLE [dbo].[InvoiceInterestCalculationLog]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[InvoiceID] [int] NOT NULL,
[YearlyInterest] [decimal] (18, 4) NOT NULL,
[ServiceFeeWaivedMonths] [int] NOT NULL,
[AmortizationDate] [date] NULL,
[DateInterestBegins] [date] NULL,
[TotalCost] [decimal] (18, 2) NOT NULL,
[TotalPPODiscount] [decimal] (18, 2) NOT NULL,
[TotalAppliedPayments] [decimal] (18, 2) NOT NULL,
[BalanceDue] [decimal] (18, 2) NOT NULL,
[CalculatedInterest] [decimal] (18, 2) NOT NULL,
[PreviousCumulativeInterest] [decimal] (18, 2) NOT NULL,
[NewCumulativeInterest] [decimal] (18, 2) NOT NULL,
[DateAdded] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InvoiceInterestCalculationLog] ADD CONSTRAINT [PK_InvoiceInterestCalculationLog] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_InvoiceInterestCalculationLog_missing_5] ON [dbo].[InvoiceInterestCalculationLog] ([DateAdded]) INCLUDE ([InvoiceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_InvoiceInterestCalculationLog] ON [dbo].[InvoiceInterestCalculationLog] ([InvoiceID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InvoiceInterestCalculationLog] ADD CONSTRAINT [FK_InvoiceInterestCalculationLog_Invoice] FOREIGN KEY ([InvoiceID]) REFERENCES [dbo].[Invoice] ([ID])
GO
