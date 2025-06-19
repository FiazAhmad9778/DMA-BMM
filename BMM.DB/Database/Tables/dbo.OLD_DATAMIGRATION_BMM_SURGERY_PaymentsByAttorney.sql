CREATE TABLE [dbo].[OLD_DATAMIGRATION_BMM_SURGERY_PaymentsByAttorney]
(
[Invoice Number] [int] NULL,
[DatePaid] [datetime] NULL,
[amount] [float] NULL,
[PaymentType] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[check] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
