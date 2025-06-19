SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[f_GetSurgeryInvoiceSummaryTableMinified] 
(
	@InvoiceID int,
	@StatementDate datetime
)
RETURNS 
@InvoiceSummary TABLE (InvoiceID int, MaturityDate date, BalanceDue decimal(18,2), CumulativeServiceFeeDue decimal(18,2), EndingBalance decimal(18,2), FirstSurgeryDate datetime, InvoicePaymentTotal decimal(18,2))
AS
BEGIN

-------------------------Intial Load
----- Insert into Invoice Summary initially with basic table data	
INSERT INTO @InvoiceSummary
	SELECT @InvoiceID, null, 0, 0, 0, null, 0
	
-------------------------Amortization Date
----- Update the Invoice Summary table with the amortization date
----- The Amortization Date will be the earliest date scheduled. //From Spec
DECLARE @AmortizationDate datetime = dbo.f_GetFirstSurgeryDate(@InvoiceID)

UPDATE @InvoiceSummary
SET FirstSurgeryDate = @AmortizationDate
						
-------------------------Date Service Fee Begins and Maturity Date
----- Get the months the service fee is waived for
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
								WHERE P.Active = 1
								AND P.InvoiceID = @InvoiceID
								AND (@StatementDate is null OR P.DatePaid <= @StatementDate)
								AND P.PaymentTypeID in (1,3))
DECLARE @ServiceFeeReceived decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active = 1
								AND P.InvoiceID = @InvoiceID
								AND (@StatementDate is null OR P.DatePaid <= @StatementDate)
								AND P.PaymentTypeID = 2)
DECLARE @AdditionalDeductions decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active = 1
								AND P.InvoiceID = @InvoiceID
								AND (@StatementDate is null OR P.DatePaid <= @StatementDate)
								AND P.PaymentTypeID in (4,5))
DECLARE @TotalPrincipal decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active = 1
								AND P.InvoiceID = @InvoiceID
								AND (@StatementDate is null OR P.DatePaid <= @StatementDate)
								AND P.PaymentTypeID = 1)
DECLARE @TotalDeposits decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active = 1
								AND P.InvoiceID = @InvoiceID
								AND (@StatementDate is null OR P.DatePaid <= @StatementDate)
								AND P.PaymentTypeID = 3)

DECLARE @TotalCost_Minus_PPODiscount decimal(18,2) = (SELECT (SUM(SIPS.Cost) - SUM(SIPS.PPODiscount))
														FROM Invoice AS I
														INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
														INNER JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
														INNER JOIN SurgeryInvoice_Provider_Services AS SIPS ON SIP.ID = SIPS.SurgeryInvoice_ProviderID AND SIPS.Active = 1
														WHERE I.ID = @InvoiceID)

-------------------------Balance Due and Cumulative Service Fee Due
----- Update the invoice summary
----- Balance Due equals The total test cost minus the ppo discount minus the principal deposits made and minus any additional deductions 
UPDATE @InvoiceSummary
SET BalanceDue = ISNULL(@TotalCost_Minus_PPODiscount, 0) - ISNULL(@Principal_Deposits_Paid, 0) - ISNULL(@AdditionalDeductions, 0),
	CumulativeServiceFeeDue = (SELECT I.CalculatedCumulativeIntrest FROM Invoice AS I WHERE ID = @InvoiceID),
	InvoicePaymentTotal = ISNULL(@Principal_Deposits_Paid, 0) + ISNULL(@ServiceFeeReceived, 0) + ISNULL(@AdditionalDeductions, 0)

UPDATE @InvoiceSummary
SET CumulativeServiceFeeDue = (ISNULL(CumulativeServiceFeeDue,0) - ISNULL(@ServiceFeeReceived,0) - (ISNULL(@ServiceFeeWaived,0)))

-------------------------Ending Balance
----- Update the invoice summary setting the ending balance
----- Ending Balance equals the balance due plus the cumulative service fee due, minus losses amount
UPDATE @InvoiceSummary
SET EndingBalance = (BalanceDue + CumulativeServiceFeeDue) - (SELECT ISNULL(LossesAmount, 0) FROM Invoice WHERE ID=@InvoiceID)
	
	RETURN 
END
GO
