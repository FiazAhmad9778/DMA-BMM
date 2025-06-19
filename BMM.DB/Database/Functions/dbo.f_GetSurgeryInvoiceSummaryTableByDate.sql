SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[f_GetSurgeryInvoiceSummaryTableByDate] 
(
	@InvoiceID int,
	@StartDate datetime = null, 
	@EndDate datetime = null
)
RETURNS 
@InvoiceSummary TABLE (InvoiceID int, DateServiceFeeBegins date, MaturityDate date, AmortizationDate date,
								TotalCost_Minus_PPODiscount decimal(18,2), TotalPPODiscount decimal(18,2), Cost_Before_PPODiscount decimal(18,2),
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
	null,
	null,
	null,
	(SUM(SIPS.Cost) - SUM(SIPS.PPODiscount)),
	(SUM(SIPS.PPODiscount)),
	(SUM(SIPS.Cost)),
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
	INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
	INNER JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
	INNER JOIN SurgeryInvoice_Provider_Services AS SIPS ON SIP.ID = SIPS.SurgeryInvoice_ProviderID AND SIPS.Active = 1
	WHERE I.ID = @InvoiceID

-------------------------Amortization Date
----- Update the Invoice Summary table with the amortization date
----- The Amortization Date will be the earliest date scheduled. //From Spec
UPDATE @InvoiceSummary
SET AmortizationDate = dbo.f_GetFirstSurgeryDate(@InvoiceID)
					 --(SELECT TOP 1 SISD.ScheduledDate
						--FROM Invoice AS I
						--INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
						--INNER JOIN SurgeryInvoice_Surgery AS SIS ON SI.ID = SIS.SurgeryInvoiceID AND SIS.Active = 1
						--INNER JOIN SurgeryInvoice_SurgeryDates AS SISD ON SIS.ID = SISD.SurgeryInvoice_SurgeryID AND SISD.Active = 1
						--WHERE I.ID = @InvoiceID
						--ORDER BY SISD.ScheduledDate ASC)
						
-------------------------Date Service Fee Begins and Maturity Date
----- Get the months the service fee is waived for
DECLARE @ServiceFeeWaivedMonths int = (SELECT ServiceFeeWaivedMonths FROM Invoice WHERE ID = @InvoiceID)
----- Get the service fee waived amount
DECLARE @ServiceFeeWaived decimal(18,2) = (SELECT ServiceFeeWaived FROM Invoice WHERE ID = @InvoiceID)
----- Get the loan term months
DECLARE @LoanTermMonths int = (SELECT LoanTermMonths FROM Invoice WHERE ID = @InvoiceID)
----- Update the invoice summary with the date service fee begins and the maturity date calculated from the amortization date
----- The Date Service Fee Begins will be determined by the Service Fee Waived Time Period after the Amortization Date. //From Spec
----- The Maturity Date will be determined by the time period entered in the Loan Term (in months) after the Date Service Fee Begins. //From Spec
UPDATE @InvoiceSummary
SET DateServiceFeeBegins =  DATEADD(M,@ServiceFeeWaivedMonths, AmortizationDate),
	MaturityDate = DATEADD(M,@ServiceFeeWaivedMonths + @LoanTermMonths, AmortizationDate)


-------------------------Principal_Deposits_Paid, ServiceFeeReceived and AdditionalDeductions
----- Update invoice summary with different payment type totals
UPDATE @InvoiceSummary						
SET Principal_Deposits_Paid = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID in (1,3)
								AND P.DatePaid BETWEEN @StartDate AND @EndDate),
ServiceFeeReceived = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID = 2
								AND P.DatePaid BETWEEN @StartDate AND @EndDate),
AdditionalDeductions = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID in (4,5)
								AND P.DatePaid BETWEEN @StartDate AND @EndDate),
TotalPrincipal = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID = 1
								AND P.DatePaid BETWEEN @StartDate AND @EndDate),
TotalDeposits = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND P.PaymentTypeID = 3
								AND P.DatePaid BETWEEN @StartDate AND @EndDate)								

-------------------------Balance Due and Cumulative Service Fee Due
----- Update the invoice summary
----- Balance Due equals The total test cost minus the ppo discount minus the principal deposits made and minus any additional deductions 
UPDATE @InvoiceSummary
SET BalanceDue = ISNULL(TotalCost_Minus_PPODiscount, 0) - ISNULL(Principal_Deposits_Paid, 0) - ISNULL(AdditionalDeductions, 0),
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
----- This field will display the total of the Amount Due fields on the Provider Information pages under the Provider Services for the invoice. //From Spec
UPDATE @InvoiceSummary
SET CostOfGoodsSold = (SELECT SUM(SIPS.AmountDue)
						FROM Invoice AS I
						INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
						INNER JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
						INNER JOIN SurgeryInvoice_Provider_Services AS SIPS ON SIP.ID = SIPS.SurgeryInvoice_ProviderID AND SIPS.Active = 1
						WHERE I.ID = @InvoiceID)
				
-------------------------Total Revenue and Total CPTs
----- Update the invoice summary total revenue and total cpts
UPDATE @InvoiceSummary
SET TotalRevenue = (Cost_Before_PPODiscount - CostOfGoodsSold - TotalPPODiscount),
TotalCPTs = (SELECT SUM(SIPCPT.Amount)
				FROM Invoice AS I
				INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
				INNER JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
				INNER JOIN SurgeryInvoice_Provider_CPTCodes AS SIPCPT ON SIP.ID = SIPCPT.SurgeryInvoice_ProviderID AND SIPCPT.Active = 1
				WHERE I.ID = @InvoiceID)
	
	RETURN 
END
GO
