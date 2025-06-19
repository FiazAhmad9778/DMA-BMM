CREATE TABLE [dbo].[DATAMIGRATION_DMA_SHARED_Attorney_List]
(
[Attorney No] [int] NULL,
[Attorney First Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Attorney Last Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Attorney Address] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Attorney City] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Attorney State] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Attorney Zip] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Attorney Phone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Attorney Fax] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Attorney Seceretary] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Memo] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Months] [int] NULL,
[Discount Plan] [int] NULL,
[Deposit Amount Required] [int] NULL,
[test] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
