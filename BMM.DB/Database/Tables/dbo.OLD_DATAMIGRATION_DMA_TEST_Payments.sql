CREATE TABLE [dbo].[OLD_DATAMIGRATION_DMA_TEST_Payments]
(
[Invoice No] [int] NULL,
[Date Paid] [datetime] NULL,
[Amount] [float] NULL,
[Payment Type] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Check No] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
