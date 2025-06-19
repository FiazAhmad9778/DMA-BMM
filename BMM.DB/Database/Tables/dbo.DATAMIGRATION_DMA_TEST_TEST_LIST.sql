CREATE TABLE [dbo].[DATAMIGRATION_DMA_TEST_TEST_LIST]
(
[Test No] [int] NOT NULL IDENTITY(1, 1),
[Invoice No] [int] NULL,
[Test Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Test Date] [datetime] NULL,
[Test Time] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Test Results] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Test Deposit] [float] NULL,
[Interest Waived] [float] NULL,
[Losses Amount] [float] NULL,
[Payment Plan] [int] NULL,
[Canceled] [bit] NULL,
[Test Cost] [float] NULL,
[Provider No] [int] NULL,
[Deposit From Attorney] [float] NULL,
[Amount Due To Provider Due Date] [datetime] NULL,
[Amount Paid To Provider] [float] NULL,
[Amount Paid To Provider Date] [datetime] NULL,
[Amount Paid To Provider Check No] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Number of Tests] [int] NULL,
[MRI] [int] NULL,
[PPO Discount] [float] NULL,
[AmountDueToFacility] [float] NULL
) ON [PRIMARY]
GO
