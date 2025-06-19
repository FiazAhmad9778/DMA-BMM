CREATE TABLE [dbo].[SurgeryInvoice_Provider_Services]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SurgeryInvoice_ProviderID] [int] NOT NULL,
[EstimatedCost] [decimal] (18, 2) NULL,
[Cost] [decimal] (18, 2) NOT NULL,
[Discount] [decimal] (18, 2) NOT NULL,
[PPODiscount] [decimal] (18, 2) NOT NULL,
[DueDate] [datetime] NOT NULL,
[AmountDue] [decimal] (18, 2) NOT NULL,
[CalculateAmountDue] [bit] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Provider_Services_CalculateAmountDue] DEFAULT ((1)),
[AccountNumber] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Provider_Services_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Provider_Services_DateAdded] DEFAULT (getdate()),
[Temp_ServiceID] [int] NULL,
[Temp_CompanyID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SurgeryInvoice_Provider_Services] ADD CONSTRAINT [PK_SurgeryInvoice_Provider_Services] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SurgeryInvoice_Provider_Services_missing_21] ON [dbo].[SurgeryInvoice_Provider_Services] ([Active]) INCLUDE ([Cost], [PPODiscount], [SurgeryInvoice_ProviderID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SurgeryInvoice_Provider_Services] ON [dbo].[SurgeryInvoice_Provider_Services] ([ID], [AmountDue], [Cost], [PPODiscount], [EstimatedCost], [DueDate], [SurgeryInvoice_ProviderID], [Active]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SurgeryInvoice_Provider_Services_missing_7] ON [dbo].[SurgeryInvoice_Provider_Services] ([SurgeryInvoice_ProviderID]) INCLUDE ([Cost]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SurgeryInvoice_Provider_Services_missing_9] ON [dbo].[SurgeryInvoice_Provider_Services] ([SurgeryInvoice_ProviderID]) INCLUDE ([PPODiscount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SurgeryInvoice_Provider_Services_missing_19] ON [dbo].[SurgeryInvoice_Provider_Services] ([SurgeryInvoice_ProviderID], [Active]) INCLUDE ([Cost], [PPODiscount]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SurgeryInvoice_Provider_Services] ADD CONSTRAINT [FK_SurgeryInvoice_Provider_Services_SurgeryInvoice_Providers] FOREIGN KEY ([SurgeryInvoice_ProviderID]) REFERENCES [dbo].[SurgeryInvoice_Providers] ([ID])
GO
