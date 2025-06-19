CREATE TABLE [dbo].[OLD_DATAMIGRATION_BMM_SURGERY_Providers]
(
[provider] [int] NULL,
[date] [datetime] NULL,
[name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[city] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[state] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zip] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contact] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[abbrev] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[discount] [decimal] (7, 2) NULL,
[fax] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
