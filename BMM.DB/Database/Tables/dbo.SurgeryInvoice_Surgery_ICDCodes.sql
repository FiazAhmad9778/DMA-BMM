CREATE TABLE [dbo].[SurgeryInvoice_Surgery_ICDCodes]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SurgeryInvoice_SurgeryID] [int] NOT NULL,
[ICDCodeID] [int] NOT NULL,
[Amount] [decimal] (18, 2) NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Provider_ICDCodes_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL,
[Temp_CompanyID] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SurgeryInvoice_Surgery_ICDCodes] ADD CONSTRAINT [PK_SurgeryInvoice_Provider_ICDCodes] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SurgeryInvoice_Surgery_ICDCodes] ADD CONSTRAINT [FK_SurgeryInvoice_Surgery_ICDCodes_ICDCodes] FOREIGN KEY ([ICDCodeID]) REFERENCES [dbo].[ICDCodes] ([ID])
GO
ALTER TABLE [dbo].[SurgeryInvoice_Surgery_ICDCodes] ADD CONSTRAINT [FK_SurgeryInvoice_Surgery_ICDCodes_SurgeryInvoice_Surgery] FOREIGN KEY ([SurgeryInvoice_SurgeryID]) REFERENCES [dbo].[SurgeryInvoice_Surgery] ([ID])
GO
