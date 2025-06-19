CREATE TABLE [dbo].[OLD_DATAMIGRATION_DMA_SURGERY_Services]
(
[InvoiceNumber] [int] NULL,
[provider] [int] NULL,
[DueDate] [datetime] NULL,
[AmountDue] [float] NULL,
[cost] [float] NULL,
[discount] [float] NULL,
[PPODiscount] [float] NULL,
[ProviderByInvoice] [int] NULL,
[AmountWaived] [float] NULL,
[SERVICEID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
