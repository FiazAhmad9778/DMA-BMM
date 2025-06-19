CREATE TABLE [dbo].[Temp_PatientRecordConsolidation]
(
[Original_PatientID] [int] NOT NULL,
[Temp_InvoiceID] [int] NULL,
[New_PatientID] [int] NULL,
[FirstName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Temp_PatientRecordConsolidation] ADD CONSTRAINT [PK_Temp_PatientRecordConsolidation] PRIMARY KEY CLUSTERED  ([Original_PatientID]) ON [PRIMARY]
GO
