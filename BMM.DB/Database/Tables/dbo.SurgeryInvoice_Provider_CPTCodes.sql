CREATE TABLE [dbo].[SurgeryInvoice_Provider_CPTCodes]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SurgeryInvoice_ProviderID] [int] NOT NULL,
[CPTCodeID] [int] NOT NULL,
[Amount] [decimal] (18, 2) NOT NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Invoice_CPTCodes_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_Invoice_CPTCodes_DateAdded] DEFAULT (getdate()),
[Temp_CompanyID] [int] NULL,
[Temp_InvoiceID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SurgeryInvoice_Provider_CPTCodes] ADD CONSTRAINT [PK_Provider_CPTCodes] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SurgeryInvoice_Provider_CPTCodes_missing_27] ON [dbo].[SurgeryInvoice_Provider_CPTCodes] ([SurgeryInvoice_ProviderID], [Active]) INCLUDE ([Amount]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SurgeryInvoice_Provider_CPTCodes] ADD CONSTRAINT [FK_Provider_CPTCodes_CPTCodes] FOREIGN KEY ([CPTCodeID]) REFERENCES [dbo].[CPTCodes_BAD] ([ID])
GO
ALTER TABLE [dbo].[SurgeryInvoice_Provider_CPTCodes] ADD CONSTRAINT [FK_SurgeryInvoice_Provider_CPTCodes_SurgeryInvoice_Providers] FOREIGN KEY ([SurgeryInvoice_ProviderID]) REFERENCES [dbo].[SurgeryInvoice_Providers] ([ID])
GO
