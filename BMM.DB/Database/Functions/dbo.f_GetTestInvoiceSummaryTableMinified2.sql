SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/19/2012
-- Description:	Testing Invoice Summary Data
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    03/19/2012   Aaron     Created proc
** 2	12/20/2012	 Czarina   Made modifications to populate endingbalance (was showing as 0 for everyone)		  
*******************************/

CREATE FUNCTION [dbo].[f_GetTestInvoiceSummaryTableMinified2] 
(
	@InvoiceID int,
	@StatementDate datetime
)
RETURNS  
@InvoiceSummary TABLE (InvoiceID int, MaturityDate date, BalanceDue decimal(18,2), CumulativeServiceFeeDue decimal(18,2), EndingBalance decimal(18,2), FirstTestDate datetime, InvoicePaymentTotal decimal(18,2))
AS
BEGIN
	
-------------------------Intial Load
----- Insert into Invoice Summary initially with basic table data
INSERT INTO @InvoiceSummary
	SELECT @InvoiceID, null, 0, 0, 0, null, 0

-------------------------Amortization Date
----- Update the Invoice Summary table with the amortization date
----- The Amortization Date will be the date of the earliest test. //From Spec
DECLARE @AmortizationDate datetime = dbo.f_GetFirstTestDate(@InvoiceID)

UPDATE @InvoiceSummary
SET FirstTestDate = @AmortizationDate

DECLARE @ServiceFeeWaivedMonths int
DECLARE @ServiceFeeWaived decimal(18,2)
DECLARE @LoanTermMonths int

SELECT @ServiceFeeWaivedMonths = ServiceFeeWaivedMonths, 
		@ServiceFeeWaived = ServiceFeeWaived, 
		@LoanTermMonths = LoanTermMonths 
		FROM Invoice WHERE ID = @InvoiceID
----- Update the invoice summary with the date service fee begins and the maturity date calculated from the amortization date
----- The Date Service Fee Begins will be determined by the Service Fee Waived Time Period after the Amortization Date. //From Spec
----- The Maturity Date will be determined by the time period entered in the Loan Term (in months) after the Date Service Fee Begins. //From Spec
UPDATE @InvoiceSummary
SET MaturityDate = DATEADD(M,@ServiceFeeWaivedMonths + @LoanTermMonths, @AmortizationDate)

-------------------------Principal_Deposits_Paid, ServiceFeeReceived and AdditionalDeductions
----- Update invoice summary with different payment type totals

DECLARE @Principal_Deposits_Paid decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.DatePaid <= @StatementDate
								AND P.PaymentTypeID in (1,3))
DECLARE @ServiceFeeReceived decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.DatePaid <= @StatementDate
								AND P.PaymentTypeID = 2)
DECLARE @AdditionalDeductions decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.DatePaid <= @StatementDate
								AND P.PaymentTypeID in (4,5))
DECLARE @TotalPrincipal decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.DatePaid <= @StatementDate
								AND P.PaymentTypeID = 1)
DECLARE @TotalDeposits decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.DatePaid <= @StatementDate
								AND P.PaymentTypeID = 3)

DECLARE @TotalTestCost_Minus_PPODiscount decimal(18,2) =  (SELECT (SUM(TestCost) - SUM(TIT.PPODiscount))	
														FROM Invoice AS I
														INNER JOIN TestInvoice AS TI ON I.TestInvoiceID = TI.ID AND TI.Active = 1
														INNER JOIN TestInvoice_Test AS TIT ON TI.ID = TIT.TestInvoiceID AND TIT.Active = 1
														WHERE I.ID = @InvoiceID)

-------------------------Balance Due and Cumulative Service Fee Due
----- Update the invoice summary
----- Balance Due equals The total test cost minus the ppo discount minus the principal deposits made and minus any additional deductions 
UPDATE @InvoiceSummary
SET BalanceDue = ISNULL(@TotalTestCost_Minus_PPODiscount, 0) - ISNULL(@Principal_Deposits_Paid, 0) - ISNULL(@AdditionalDeductions, 0),
	CumulativeServiceFeeDue = (SELECT I.CalculatedCumulativeIntrest FROM Invoice AS I WHERE ID = @InvoiceID),
	InvoicePaymentTotal = ISNULL(@Principal_Deposits_Paid, 0) + ISNULL(@ServiceFeeReceived, 0) + ISNULL(@AdditionalDeductions, 0)

UPDATE @InvoiceSummary
SET CumulativeServiceFeeDue = (ISNULL(CumulativeServiceFeeDue,0) - ISNULL(@ServiceFeeReceived,0) - (ISNULL(@ServiceFeeWaived,0))),
-- CCW:  12/20/2012:  ADDED LINE BELOW to provide EndingBalance (the sum of BalanceDue + CumulativeServiceFeeDue)
	EndingBalance = (ISNULL(@TotalTestCost_Minus_PPODiscount, 0) - ISNULL(@Principal_Deposits_Paid, 0) - ISNULL(@AdditionalDeductions, 0)) + (ISNULL(CumulativeServiceFeeDue,0) - ISNULL(@ServiceFeeReceived,0) - (ISNULL(@ServiceFeeWaived,0)))

	RETURN 
END

GO
