SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[procGetSurgeryInvoiceSummary]

 @InvoiceID int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
--declare @InvoiceSummary table (InvoiceID int, DateServiceFeeBegins date, MaturityDate date, AmortizationDate date,
--								TotalCost_Minus_PPODiscount decimal(18,2), TotalPPODiscount decimal(18,2), Cost_Before_PPODiscount decimal(18,2),
--								Principal_Deposits_Paid decimal(18,2), ServiceFeeReceived decimal(18,2), AdditionalDeductions decimal(18,2),
--								BalanceDue decimal(18,2), CumulativeServiceFeeDue decimal(18,2), EndingBalance decimal(18,2),
--								CostOfGoodsSold decimal(18,2), TotalRevenue decimal(18,2), TotalCPTs decimal(18,2),
--								TotalPrincipal decimal(18,2), TotalDeposits decimal(18,2))
--insert into @InvoiceSummary
--select @InvoiceID,
--	null,
--	null,
--	null,
--	(SUM(SIPS.Cost) - SUM(SIPS.PPODiscount)),
--	(SUM(SIPS.PPODiscount)),
--	(SUM(SIPS.Cost)),
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
--	from Invoice as I
--	inner join SurgeryInvoice as SI on I.SurgeryInvoiceID = SI.ID
--	inner join SurgeryInvoice_Providers as SIP on SI.ID = SIP.SurgeryInvoiceID and SIP.Active = 1
--	inner join SurgeryInvoice_Provider_Services as SIPS on SIP.ID = SIPS.SurgeryInvoice_ProviderID and SIPS.Active = 1
--	where I.ID = @InvoiceID

---------------------------AmortizationDate

--update @InvoiceSummary
--set AmortizationDate = (select top 1 SISD.ScheduledDate
--						from Invoice as I
--						inner join SurgeryInvoice as SI on I.SurgeryInvoiceID = SI.ID
--						inner join SurgeryInvoice_Surgery as SIS on SI.ID = SIS.SurgeryInvoiceID and SIS.Active = 1
--						inner join SurgeryInvoice_SurgeryDates as SISD on SIS.ID = SISD.SurgeryInvoice_SurgeryID and SISD.Active = 1
--						where I.ID = @InvoiceID
--						order by SISD.ScheduledDate desc)
						
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
--								where P.Active = 1
--								and P.InvoiceID = @InvoiceID
--								and P.PaymentTypeID in (1,3)),
--ServiceFeeReceived = (select SUM (Amount)
--								from Payments as P
--								where P.Active = 1
--								and P.InvoiceID = @InvoiceID
--								and P.PaymentTypeID = 2),
--AdditionalDeductions = (select SUM (Amount)
--								from Payments as P
--								where P.Active = 1
--								and P.InvoiceID = @InvoiceID
--								and P.PaymentTypeID in (4,5)),
--TotalPrincipal = (select SUM (Amount)
--								from Payments as P
--								where P.Active = 1
--								and P.InvoiceID = @InvoiceID
--								and P.PaymentTypeID = 1),
--TotalDeposits = (select SUM (Amount)
--								from Payments as P
--								where P.Active = 1
--								and P.InvoiceID = @InvoiceID
--								and P.PaymentTypeID = 3)

-------------BalanceDue and CumulativeServiceFeeDue

--update @InvoiceSummary
--set BalanceDue = TotalCost_Minus_PPODiscount - Principal_Deposits_Paid - AdditionalDeductions,
--	CumulativeServiceFeeDue = (select I.CalculatedCumulativeIntrest from Invoice as I where ID = @InvoiceID)


--------------EndingBalance

--update @InvoiceSummary
--set EndingBalance = BalanceDue + CumulativeServiceFeeDue - @LossesAmount

--------------CostOfGoodsSold

--update @InvoiceSummary
--set CostOfGoodsSold = (select SUM(SIPS.Cost)
--						from Invoice as I
--						inner join SurgeryInvoice as SI on I.SurgeryInvoiceID = SI.ID
--						inner join SurgeryInvoice_Providers as SIP on SI.ID = SIP.SurgeryInvoiceID and SIP.Active = 1
--						inner join SurgeryInvoice_Provider_Services as SIPS on SIP.ID = SIPS.SurgeryInvoice_ProviderID and SIPS.Active = 1
--						where I.ID = @InvoiceID)
				
---------------TotalRevenue and TotalCPTs
						
--update @InvoiceSummary
--set TotalRevenue = (Cost_Before_PPODiscount - CostOfGoodsSold - TotalPPODiscount),
--TotalCPTs = (select SUM(SIPCPT.Amount)
--				from Invoice as I
--				inner join SurgeryInvoice as SI on I.SurgeryInvoiceID = SI.ID
--				inner join SurgeryInvoice_Providers as SIP on SI.ID = SIP.SurgeryInvoiceID and SIP.Active = 1
--				inner join SurgeryInvoice_Provider_CPTCodes as SIPCPT on SIP.ID = SIPCPT.SurgeryInvoice_ProviderID and SIPCPT.Active = 1
--				where I.ID = @InvoiceID)

--select *
--from @InvoiceSummary

SELECT * FROM dbo.f_GetSurgeryInvoiceSummaryTable(@InvoiceID)

END
GO
