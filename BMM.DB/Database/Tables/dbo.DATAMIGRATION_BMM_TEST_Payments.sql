CREATE TABLE [dbo].[DATAMIGRATION_BMM_TEST_Payments]
(
[PaymentID] [int] NOT NULL IDENTITY(1, 1),
[Invoice No] [int] NULL,
[Date Paid] [datetime] NULL,
[Amount] [float] NULL,
[Payment Type] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Check No] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
