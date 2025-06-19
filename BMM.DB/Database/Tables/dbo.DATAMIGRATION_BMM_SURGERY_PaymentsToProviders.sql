CREATE TABLE [dbo].[DATAMIGRATION_BMM_SURGERY_PaymentsToProviders]
(
[Invoice Number] [int] NULL,
[Provider] [int] NULL,
[DatePaid] [datetime] NULL,
[Amount] [decimal] (10, 2) NULL,
[PaymentType] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Check] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProviderByInvoice] [int] NULL,
[PAYMENTID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
