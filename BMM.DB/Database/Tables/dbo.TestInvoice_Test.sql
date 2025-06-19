CREATE TABLE [dbo].[TestInvoice_Test]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[TestInvoiceID] [int] NOT NULL,
[TestID] [int] NOT NULL,
[InvoiceProviderID] [int] NOT NULL,
[Notes] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TestDate] [datetime] NOT NULL,
[TestTime] [time] (0) NULL,
[NumberOfTests] [int] NULL,
[MRI] [int] NOT NULL,
[IsPositive] [bit] NULL,
[isCanceled] [bit] NOT NULL,
[TestCost] [decimal] (18, 2) NOT NULL,
[PPODiscount] [decimal] (18, 2) NOT NULL,
[AmountToProvider] [decimal] (18, 2) NOT NULL,
[CalculateAmountToProvider] [bit] NOT NULL CONSTRAINT [DF_TestInvoice_Test_CalculateAmountToProvider] DEFAULT ((1)),
[ProviderDueDate] [datetime] NOT NULL,
[DepositToProvider] [decimal] (18, 2) NULL,
[AmountPaidToProvider] [decimal] (18, 2) NULL,
[Date] [datetime] NULL,
[CheckNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountNumber] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_TestInvoice_Test_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_TestInvoice_Test_DateAdded] DEFAULT (getdate()),
[Temp_InvoiceID] [int] NULL,
[Temp_CompanyID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TestInvoice_Test] ADD CONSTRAINT [PK_TestInvoice_Test] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_TestInvoice_Test_missing_303] ON [dbo].[TestInvoice_Test] ([Active], [Date]) INCLUDE ([AmountPaidToProvider], [DepositToProvider], [TestID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_TestInvoice_Test_missing_55] ON [dbo].[TestInvoice_Test] ([Active], [Date]) INCLUDE ([TestInvoiceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_TestInvoice_Test] ON [dbo].[TestInvoice_Test] ([ID], [AmountPaidToProvider], [DepositToProvider], [PPODiscount], [ProviderDueDate], [TestCost], [TestDate], [CheckNumber], [Active]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_TestInvoice_Test_missing_37] ON [dbo].[TestInvoice_Test] ([InvoiceProviderID], [Active]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_TestInvoice_Test_missing_35] ON [dbo].[TestInvoice_Test] ([InvoiceProviderID], [Active]) INCLUDE ([TestCost]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_TestInvoice_Test_missing_301] ON [dbo].[TestInvoice_Test] ([isCanceled], [Active], [TestDate]) INCLUDE ([NumberOfTests], [TestID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_TestInvoice_Test_ID] ON [dbo].[TestInvoice_Test] ([TestInvoiceID], [TestID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TestInvoice_Test] ADD CONSTRAINT [FK_TestInvoice_Test_Provider] FOREIGN KEY ([InvoiceProviderID]) REFERENCES [dbo].[InvoiceProvider] ([ID])
GO
ALTER TABLE [dbo].[TestInvoice_Test] ADD CONSTRAINT [FK_TestInvoice_Test_Test] FOREIGN KEY ([TestID]) REFERENCES [dbo].[Test] ([ID])
GO
ALTER TABLE [dbo].[TestInvoice_Test] ADD CONSTRAINT [FK_TestInvoice_Test_TestInvoice] FOREIGN KEY ([TestInvoiceID]) REFERENCES [dbo].[TestInvoice] ([ID])
GO
