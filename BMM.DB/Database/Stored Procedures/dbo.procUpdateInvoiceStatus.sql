SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Bursavich, Andy
-- Create date: 2012.04.12
-- Description:	Sets Open Invoices that have passed their Maturity Date to Overdue
-- =============================================
CREATE PROCEDURE [dbo].[procUpdateInvoiceStatus]
	@RunDate DATE = null
AS
BEGIN

	SET NOCOUNT ON;

	IF @RunDate IS NULL
	SET @RunDate = GETDATE()
	
	DECLARE @OpenStatusTypeID INT = 1
	DECLARE @OverdueStatusTypeID INT = 3
	
	UPDATE Invoice
		SET Invoice.InvoiceStatusTypeID=@OverdueStatusTypeID
		WHERE Invoice.Active = 1
			AND Invoice.InvoiceStatusTypeID = @OpenStatusTypeID
			AND dbo.f_GetInvoiceMaturityDate(Invoice.ID, Invoice.InvoiceTypeID, Invoice.LoanTermMonths) < @RunDate
			AND dbo.f_GetInvoiceEndingBalance(Invoice.ID, Invoice.InvoiceTypeID, ISNULL(Invoice.CalculatedCumulativeIntrest, 0), ISNULL(Invoice.ServiceFeeWaived, 0), ISNULL(Invoice.LossesAmount, 0), NULL, NULL, NULL, NULL, NULL, NULL) > 0

END
GO
