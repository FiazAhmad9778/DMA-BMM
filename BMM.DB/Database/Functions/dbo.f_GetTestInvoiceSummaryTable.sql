SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/20/2012
-- Description:	Returns Test Invoice Summary Table
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    03/20/2012   Aaron     Created function from stored proc
** 2	03/21/2012	 Aaron	   Commented and verified function calcs
*******************************/
CREATE FUNCTION [dbo].[f_GetTestInvoiceSummaryTable] 
(
	@InvoiceID int
)
RETURNS  
@InvoiceSummary TABLE (InvoiceID int, DateServiceFeeBegins date, MaturityDate date, AmortizationDate date,
						TotalTestCost_Minus_PPODiscount decimal(18,2), TotalPPODiscount decimal(18,2), CostOfTests_Before_PPODiscount decimal(18,2),
						Principal_Deposits_Paid decimal(18,2), ServiceFeeReceived decimal(18,2), AdditionalDeductions decimal(18,2),
						BalanceDue decimal(18,2), CumulativeServiceFeeDue decimal(18,2), EndingBalance decimal(18,2),
						CostOfGoodsSold decimal(18,2), TotalRevenue decimal(18,2), TotalCPTs decimal(18,2),
						TotalPrincipal decimal(18,2), TotalDeposits decimal(18,2))
AS
BEGIN
	
-------------------------Intial Load
----- Insert into Invoice Summary initially with basic table data
INSERT INTO @InvoiceSummary 
	SELECT @InvoiceID,
	NULL,
	NULL,
	NULL,
	(SUM(TestCost) - SUM(TIT.PPODiscount)) AS TotalTestCost_Minus_PPODiscount,	
	(SUM(TIT.PPODiscount)) AS TotalPPODiscount,
	(SUM(TIT.TestCost)) AS TotalTestCost,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0	
FROM Invoice AS I
INNER JOIN TestInvoice AS TI ON I.TestInvoiceID = TI.ID AND TI.Active = 1
INNER JOIN TestInvoice_Test AS TIT ON TI.ID = TIT.TestInvoiceID AND TIT.Active = 1
WHERE I.ID = @InvoiceID

-------------------------Amortization Date
----- Update the Invoice Summary table with the amortization date
----- The Amortization Date will be the date of the earliest test. //From Spec
UPDATE @InvoiceSummary
SET AmortizationDate = dbo.f_GetFirstTestDate(@InvoiceID)

-------------------------Date Service Fee Begins and Maturity Date
----- Get the months the service fee is waived for
DECLARE @ServiceFeeWaivedMonths int = (SELECT ServiceFeeWaivedMonths FROM Invoice WHERE ID = @InvoiceID)
----- Get the service fee waived amount
DECLARE @ServiceFeeWaived decimal(18,2) = (SELECT ServiceFeeWaived FROM Invoice WHERE ID = @InvoiceID)
----- Get the loan term months
DECLARE @LoanTermMonths int = (SELECT LoanTermMonths FROM Invoice WHERE ID = @InvoiceID)
----- Update the invoice summary with the date service fee begins and the maturity date calculated from the amortization date
----- The Date Service Fee Begins will be determined by the Service Fee Waived Time Period after the Amortization Date. //From Spec
UPDATE @InvoiceSummary
SET DateServiceFeeBegins = dbo.f_ServiceFeeBegins(AmortizationDate, @ServiceFeeWaivedMonths)
----- The Maturity Date will be determined by the time period entered in the Loan Term (in months) after the Date Service Fee Begins. //From Spec
UPDATE @InvoiceSummary
SET MaturityDate = DATEADD(M, @LoanTermMonths, DateServiceFeeBegins)


-------------------------Principal_Deposits_Paid, ServiceFeeReceived and AdditionalDeductions
----- Update invoice summary with different payment type totals
UPDATE @InvoiceSummary
SET Principal_Deposits_Paid = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID in (1,3)),
ServiceFeeReceived = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID = 2),
AdditionalDeductions = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID in (4,5)),
TotalPrincipal = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID = 1),
TotalDeposits = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID = 3)

-------------------------Balance Due and Cumulative Service Fee Due
----- Update the invoice summary
----- Balance Due equals The total test cost minus the ppo discount minus the principal deposits made and minus any additional deductions 
UPDATE @InvoiceSummary
SET BalanceDue = ISNULL(TotalTestCost_Minus_PPODiscount, 0) - ISNULL(Principal_Deposits_Paid, 0) - ISNULL(AdditionalDeductions, 0),
	CumulativeServiceFeeDue = (SELECT I.CalculatedCumulativeIntrest FROM Invoice AS I WHERE ID = @InvoiceID)

UPDATE @InvoiceSummary
SET CumulativeServiceFeeDue = (ISNULL(CumulativeServiceFeeDue,0) - ISNULL(ServiceFeeReceived,0) - (ISNULL(@ServiceFeeWaived,0)))
	
-------------------------Ending Balance
----- Update the invoice summary setting the ending balance
----- Ending Balance equals the balance due plus the cumulative service fee due, minus losses amount
UPDATE @InvoiceSummary
SET EndingBalance = (BalanceDue + CumulativeServiceFeeDue) - (SELECT ISNULL(LossesAmount, 0) FROM Invoice WHERE ID=@InvoiceID)

-------------------------Cost Of Goods Sold
----- Update the invoice summary setting the cost of the goods sold
----- Call the provider cost function passing in the provider id and the mri count
UPDATE @InvoiceSummary
SET CostOfGoodsSold = (SELECT SUM(dbo.f_GetTestInvoiceProviderCost(TIT.InvoiceProviderID,TIT.MRI))
						FROM Invoice I
						INNER JOIN TestInvoice AS TI ON I.TestInvoiceID = TI.ID AND Ti.Active = 1
						INNER JOIN TestInvoice_Test AS TIT ON TI.ID = TIT.TestInvoiceID AND TIT.Active = 1
						WHERE I.ID = @InvoiceID)
				
-------------------------Total Revenue and Total CPTs
----- Update the invoice summary total revenue and total cpts				
UPDATE @InvoiceSummary
SET TotalRevenue = (CostOfTests_Before_PPODiscount - CostOfGoodsSold - TotalPPODiscount),
TotalCPTs = (SELECT SUM(TITCPT.Amount) 
				FROM Invoice I
				INNER JOIN TestInvoice AS TI ON I.TestInvoiceID = TI.ID AND TI.Active = 1
				INNER JOIN TestInvoice_Test AS TIT ON TI.ID = TIT.TestInvoiceID AND TIT.Active=1
				INNER JOIN TestInvoice_Test_CPTCodes AS TITCPT ON TIT.ID = TITCPT.TestInvoice_TestID AND TITCPT.Active = 1
				WHERE I.ID = @InvoiceID)

	RETURN 
END
GO
