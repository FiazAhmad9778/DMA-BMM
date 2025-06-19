CREATE TABLE [dbo].[SurgeryInvoice_Provider_Payments]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SurgeryInvoice_ProviderID] [int] NOT NULL,
[PaymentTypeID] [int] NOT NULL,
[DatePaid] [datetime] NOT NULL,
[Amount] [decimal] (18, 2) NOT NULL,
[CheckNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Provider_Payments_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Provider_Payments_DateAdded] DEFAULT (getdate()),
[Temp_CompanyID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SurgeryInvoice_Provider_Payments] ADD CONSTRAINT [PK_SurgeryInvoice_Provider_Payments] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SurgeryInvoice_Provider_Payments] ON [dbo].[SurgeryInvoice_Provider_Payments] ([ID], [Amount], [DatePaid], [PaymentTypeID], [SurgeryInvoice_ProviderID], [Active]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SurgeryInvoice_Provider_Payments_missing_88] ON [dbo].[SurgeryInvoice_Provider_Payments] ([SurgeryInvoice_ProviderID], [Active]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SurgeryInvoice_Provider_Payments] ADD CONSTRAINT [FK_SurgeryInvoice_Provider_Payments_PaymentType] FOREIGN KEY ([PaymentTypeID]) REFERENCES [dbo].[PaymentType] ([ID])
GO
ALTER TABLE [dbo].[SurgeryInvoice_Provider_Payments] ADD CONSTRAINT [FK_SurgeryInvoice_Provider_Payments_SurgeryInvoice_Providers] FOREIGN KEY ([SurgeryInvoice_ProviderID]) REFERENCES [dbo].[SurgeryInvoice_Providers] ([ID])
GO
