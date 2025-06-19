CREATE TABLE [dbo].[SurgeryInvoice_SurgeryDates]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SurgeryInvoice_SurgeryID] [int] NOT NULL,
[ScheduledDate] [datetime] NOT NULL,
[isPrimaryDate] [bit] NOT NULL CONSTRAINT [DF_SurgeryInvoice_SurgeryDates_isPrimaryDate] DEFAULT ((0)),
[Active] [bit] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Dates_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_SurgeryInvoice_Dates_DateAdded] DEFAULT (getdate()),
[Temp_CompanyID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SurgeryInvoice_SurgeryDates] ADD CONSTRAINT [PK_SurgeryInvoice_Dates] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SurgeryInvoice_SurgeryDates] ON [dbo].[SurgeryInvoice_SurgeryDates] ([ID], [ScheduledDate], [SurgeryInvoice_SurgeryID], [isPrimaryDate], [Active]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SurgeryInvoice_SurgeryDates] ADD CONSTRAINT [FK_SurgeryInvoice_Dates_SurgeryInvoice] FOREIGN KEY ([SurgeryInvoice_SurgeryID]) REFERENCES [dbo].[SurgeryInvoice_Surgery] ([ID])
GO
