CREATE TABLE [dbo].[DATAMIGRATION_DMA_TEST_Provider_List]
(
[Facility No] [int] NULL,
[Facility Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Facility Address] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Facility City] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Facility State] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Facility Zip] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Facility Phone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Facility Fax] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Contact] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Memo] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Discount] [float] NULL,
[PPO deposit] [int] NULL,
[FacilityAbbrev] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
