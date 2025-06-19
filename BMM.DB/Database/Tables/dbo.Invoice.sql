CREATE TABLE [dbo].[Invoice]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[InvoiceNumber] [int] NOT NULL,
[CompanyID] [int] NOT NULL,
[DateOfAccident] [datetime] NULL,
[InvoiceStatusTypeID] [int] NOT NULL,
[isComplete] [bit] NOT NULL CONSTRAINT [DF_Invoice_isComplete] DEFAULT ((0)),
[InvoicePhysicianID] [int] NULL,
[InvoiceAttorneyID] [int] NOT NULL,
[InvoicePatientID] [int] NOT NULL,
[InvoiceTypeID] [int] NOT NULL,
[TestInvoiceID] [int] NULL,
[SurgeryInvoiceID] [int] NULL,
[InvoiceClosedDate] [datetime] NULL,
[DatePaid] [datetime] NULL,
[ServiceFeeWaived] [decimal] (18, 2) NULL,
[LossesAmount] [decimal] (18, 2) NULL,
[YearlyInterest] [decimal] (18, 4) NOT NULL,
[LoanTermMonths] [int] NOT NULL,
[ServiceFeeWaivedMonths] [int] NOT NULL,
[CalculatedCumulativeIntrest] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_Invoice_CalculatedCumulativeIntrest] DEFAULT ((0)),
[Active] [bit] NOT NULL CONSTRAINT [DF_Invoice_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_Invoice_DateAdded] DEFAULT (getdate()),
[UseAttorneyTerms] [bit] NULL,
[CustomTerms] [bit] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[t_Invoice_Insert_InvoiceNumber]
   ON  [dbo].[Invoice]
   AFTER Insert
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @CompanyID int = (select top 1 CompanyID from inserted )
	declare @ID int = (select top 1 ID from inserted )
	

    -- Insert statements for trigger here
    declare @NewInvoiceNumber int = (select top 1 InvoiceNumber + 1
									from Invoice as I
									where CompanyID = @CompanyID
									order by InvoiceNumber desc)
									
	update invoice 
	set InvoiceNumber = @NewInvoiceNumber
	where ID = @ID

END
GO
ALTER TABLE [dbo].[Invoice] ADD CONSTRAINT [PK_Invoice] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [2] ON [dbo].[Invoice] ([CompanyID], [InvoiceAttorneyID], [InvoiceTypeID], [Active]) INCLUDE ([ID], [InvoiceNumber], [InvoicePatientID], [InvoiceStatusTypeID], [isComplete], [ServiceFeeWaivedMonths]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Invoice_missing_3] ON [dbo].[Invoice] ([CompanyID], [InvoiceTypeID], [Active]) INCLUDE ([ID], [InvoiceAttorneyID], [InvoiceNumber], [InvoicePatientID], [InvoiceStatusTypeID], [SurgeryInvoiceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>] ON [dbo].[Invoice] ([CompanyID], [InvoiceTypeID], [Active], [InvoiceStatusTypeID]) INCLUDE ([ID], [InvoiceAttorneyID], [InvoiceNumber], [InvoicePatientID], [isComplete], [ServiceFeeWaivedMonths]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Invoice] ON [dbo].[Invoice] ([ID], [InvoiceAttorneyID], [InvoiceTypeID], [InvoicePatientID], [LossesAmount], [InvoiceStatusTypeID], [SurgeryInvoiceID], [TestInvoiceID], [LoanTermMonths], [ServiceFeeWaived], [ServiceFeeWaivedMonths], [Active]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Invoice] ADD CONSTRAINT [FK_Invoice_Attorney] FOREIGN KEY ([InvoiceAttorneyID]) REFERENCES [dbo].[InvoiceAttorney] ([ID])
GO
ALTER TABLE [dbo].[Invoice] ADD CONSTRAINT [FK_Invoice_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Company] ([ID])
GO
ALTER TABLE [dbo].[Invoice] ADD CONSTRAINT [FK_Invoice_InvoiceStatusType] FOREIGN KEY ([InvoiceStatusTypeID]) REFERENCES [dbo].[InvoiceStatusType] ([ID])
GO
ALTER TABLE [dbo].[Invoice] ADD CONSTRAINT [FK_Invoice_InvoiceType] FOREIGN KEY ([InvoiceTypeID]) REFERENCES [dbo].[InvoiceType] ([ID])
GO
ALTER TABLE [dbo].[Invoice] ADD CONSTRAINT [FK_Invoice_Patient] FOREIGN KEY ([InvoicePatientID]) REFERENCES [dbo].[InvoicePatient] ([ID])
GO
ALTER TABLE [dbo].[Invoice] ADD CONSTRAINT [FK_Invoice_Physicians] FOREIGN KEY ([InvoicePhysicianID]) REFERENCES [dbo].[InvoicePhysician] ([ID])
GO
ALTER TABLE [dbo].[Invoice] ADD CONSTRAINT [FK_Invoice_SurgeryInvoice] FOREIGN KEY ([SurgeryInvoiceID]) REFERENCES [dbo].[SurgeryInvoice] ([ID])
GO
ALTER TABLE [dbo].[Invoice] ADD CONSTRAINT [FK_Invoice_TestInvoice] FOREIGN KEY ([TestInvoiceID]) REFERENCES [dbo].[TestInvoice] ([ID])
GO
