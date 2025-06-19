CREATE TABLE [dbo].[Payments]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[InvoiceID] [int] NOT NULL,
[PaymentTypeID] [int] NOT NULL,
[DatePaid] [datetime] NOT NULL,
[Amount] [decimal] (18, 2) NOT NULL,
[CheckNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Payments_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_Payments_DateAdded] DEFAULT (getdate()),
[Temp_CompanyID] [int] NULL,
[Temp_InvoiceID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Payments] ADD CONSTRAINT [PK_Payments] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Payments_missing_305] ON [dbo].[Payments] ([Active], [DatePaid]) INCLUDE ([Amount], [InvoiceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Payments] ON [dbo].[Payments] ([ID], [Amount], [DatePaid], [InvoiceID], [CheckNumber], [PaymentTypeID], [Active]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_InvoiceID] ON [dbo].[Payments] ([InvoiceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Payments_missing_50] ON [dbo].[Payments] ([PaymentTypeID], [DatePaid]) INCLUDE ([InvoiceID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Payments] ADD CONSTRAINT [FK_Payments_Invoice] FOREIGN KEY ([InvoiceID]) REFERENCES [dbo].[Invoice] ([ID])
GO
ALTER TABLE [dbo].[Payments] ADD CONSTRAINT [FK_Payments_PaymentType] FOREIGN KEY ([PaymentTypeID]) REFERENCES [dbo].[PaymentType] ([ID])
GO
