CREATE TABLE [dbo].[PatientChangeLog]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[PatientID] [int] NOT NULL,
[UserID] [int] NOT NULL,
[InformationUpdated] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_PatientChangeLog_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_PatientChangeLog_DateAdded] DEFAULT (getdate()),
[Temp_CompanyID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PatientChangeLog] ADD CONSTRAINT [PK_PatientChangeLog] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PatientChangeLog] ADD CONSTRAINT [FK_PatientChangeLog_Patient] FOREIGN KEY ([PatientID]) REFERENCES [dbo].[Patient] ([ID])
GO
ALTER TABLE [dbo].[PatientChangeLog] ADD CONSTRAINT [FK_PatientChangeLog_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([ID])
GO
