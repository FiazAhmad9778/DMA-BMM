SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[procGetTestInvoiceSummary]

 @InvoiceID int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
--declare @InvoiceSummary table (InvoiceID int, DateServiceFeeBegins date, MaturityDate date, AmortizationDate date,
--								TotalTestCost_Minus_PPODiscount decimal(18,2), TotalPPODiscount decimal(18,2), CostOfTests_Before_PPODiscount decimal(18,2),
--								Principal_Deposits_Paid decimal(18,2), ServiceFeeReceived decimal(18,2), AdditionalDeductions decimal(18,2),
--								BalanceDue decimal(18,2), CumulativeServiceFeeDue decimal(18,2), EndingBalance decimal(18,2),
--								CostOfGoodsSold decimal(18,2), TotalRevenue decimal(18,2), TotalCPTs decimal(18,2),
--								TotalPrincipal decimal(18,2), TotalDeposits decimal(18,2))
--insert into @InvoiceSummary
--select @InvoiceID,
--	null,
--	null,
--	null,
--	(SUM(TestCost) - SUM(TIT.PPODiscount)) as TotalTestCost_Minus_PPODiscount,	
--	(SUM(TIT.PPODiscount)) as TotalPPODiscount,
--	(SUM(TIT.TestCost)) as TotalTestCost,
--	0,
--	0,
--	0,
--	0,
--	0,
--	0,
--	0,
--	0,
--	0,
--	0,
--	0
	
--from Invoice as I
--inner join TestInvoice as TI on I.TestInvoiceID = TI.ID
--inner join TestInvoice_Test as TIT on TI.ID = TIT.TestInvoiceID
--where I.ID = @InvoiceID

---------------------------AmortizationDate

--update @InvoiceSummary
--set AmortizationDate = (select top 1 TIT.TestDate
--						from Invoice as I
--						inner join TestInvoice as TI on I.TestInvoiceID = TI.ID
--						inner join TestInvoice_Test as TIT on TI.ID = TIT.TestInvoiceID
--						where I.ID = @InvoiceID
--						order by TestDate desc)


--------------DateServiceFeeBegins and MaturityDate

--declare @ServiceFeeWaivedMonths int = (select ServiceFeeWaivedMonths from Invoice where ID = @InvoiceID)
--declare @LoanTermMonths int = (select LoanTermMonths from Invoice where ID = @InvoiceID)

--update @InvoiceSummary
--set DateServiceFeeBegins =  DATEADD(M,@ServiceFeeWaivedMonths, AmortizationDate),
--	MaturityDate = DATEADD(M,@ServiceFeeWaivedMonths + @LoanTermMonths, AmortizationDate)


--------------Principal_Deposits_Paid, ServiceFeeReceived and AdditionalDeductions

--update @InvoiceSummary
--set Principal_Deposits_Paid = (select SUM (Amount)
--								from Payments as P
--								where P.Active=1
--								and P.InvoiceID = @InvoiceID
--								and P.PaymentTypeID in (1,3)),
--ServiceFeeReceived = (select SUM (Amount)
--								from Payments as P
--								where P.Active=1
--								and P.InvoiceID = @InvoiceID
--								and P.PaymentTypeID = 2),
--AdditionalDeductions = (select SUM (Amount)
--								from Payments as P
--								where P.Active=1
--								and P.InvoiceID = @InvoiceID
--								and P.PaymentTypeID in (4,5)),
--TotalPrincipal = (select SUM (Amount)
--								from Payments as P
--								where P.Active=1
--								and P.InvoiceID = @InvoiceID
--								and P.PaymentTypeID = 1),
--TotalDeposits = (select SUM (Amount)
--								from Payments as P
--								where P.Active=1
--								and P.InvoiceID = @InvoiceID
--								and P.PaymentTypeID = 3)

-------------BalanceDue and CumulativeServiceFeeDue

--update @InvoiceSummary
--set BalanceDue = TotalTestCost_Minus_PPODiscount - Principal_Deposits_Paid - AdditionalDeductions,
--	CumulativeServiceFeeDue = (select I.CalculatedCumulativeIntrest from Invoice as I where ID = @InvoiceID)


--------------EndingBalance

--update @InvoiceSummary
--set EndingBalance = BalanceDue + CumulativeServiceFeeDue - @LossesAmount

--------------CostOfGoodsSold

--update @InvoiceSummary
--set CostOfGoodsSold = (select SUM(dbo.f_GetTestInvoiceProviderCost(TIT.InvoiceProviderID,TIT.MRI))
--						from Invoice I
--						inner join TestInvoice as TI on I.TestInvoiceID = TI.ID
--						inner join TestInvoice_Test as TIT on TI.ID = TIT.TestInvoiceID and TIT.Active = 1
--						where I.ID = @InvoiceID)
				
---------------TotalRevenue and TotalCPTs
						
--update @InvoiceSummary
--set TotalRevenue = (CostOfTests_Before_PPODiscount - CostOfGoodsSold - TotalPPODiscount),
--TotalCPTs = (select SUM(TITCPT.Amount) 
--				from Invoice I
--				inner join TestInvoice as TI on I.TestInvoiceID = TI.ID
--				inner join TestInvoice_Test as TIT on TI.ID = TIT.TestInvoiceID and TIT.Active=1
--				inner join TestInvoice_Test_CPTCodes as TITCPT on TIT.ID = TITCPT.TestInvoice_TestID and TITCPT.Active = 1
--				where I.ID = @InvoiceID)

--select *
--from @InvoiceSummary

SELECT * FROM dbo.f_GetTestInvoiceSummaryTable(@InvoiceID)

END
GO
