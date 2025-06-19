CREATE TABLE [dbo].[SurgeryInvoice_Surgery]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SurgeryInvoiceID] [int] NOT NULL,
[SurgeryID] [int] NOT NULL,
[isInpatient] [bit] NOT NULL,
[Notes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isCanceled] [bit] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Surgery_isCanceled] DEFAULT ((0)),
[Active] [bit] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Surgery_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Surgery_DateAdded] DEFAULT (getdate()),
[Temp_InvoiceID] [int] NULL,
[Temp_CompanyID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SurgeryInvoice_Surgery] ADD CONSTRAINT [PK_SurgeryInvoice_Surgery] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SurgeryInvoice_Surgery] ON [dbo].[SurgeryInvoice_Surgery] ([ID], [SurgeryInvoiceID], [SurgeryID], [Active]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SurgeryInvoice_Surgery_ID] ON [dbo].[SurgeryInvoice_Surgery] ([SurgeryInvoiceID], [SurgeryID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SurgeryInvoice_Surgery] ADD CONSTRAINT [FK_SurgeryInvoice_Surgery_Surgery] FOREIGN KEY ([SurgeryID]) REFERENCES [dbo].[Surgery] ([ID])
GO
ALTER TABLE [dbo].[SurgeryInvoice_Surgery] ADD CONSTRAINT [FK_SurgeryInvoice_Surgery_SurgeryInvoice] FOREIGN KEY ([SurgeryInvoiceID]) REFERENCES [dbo].[SurgeryInvoice] ([ID])
GO
