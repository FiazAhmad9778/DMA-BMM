CREATE TABLE [dbo].[OLD_DATAMIGRATION_DMA_SURGERY_CPTCharges]
(
[Invoice Number] [int] NULL,
[provider] [int] NULL,
[cptcode] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[amount] [decimal] (10, 2) NULL,
[description] [nvarchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProviderbyInvoice] [int] NULL
) ON [PRIMARY]
GO
