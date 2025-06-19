SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/20/2012
-- Description:	Returns Surgery Invoice Payments Summary
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    03/20/2012   Aaron     Created function from stored proc
*******************************/
CREATE FUNCTION [dbo].[f_GetSurgeryPaymentsSummary] 
(
	@InvoiceID int,
	@InvoiceProviderID int,
	@StartDate datetime,
	@EndDate datetime
)
RETURNS 
@InvoicePaymentsSummary TABLE (AccountNumber varchar(100), DueDate varchar(1000), TotalEstimatedCost decimal(18,2), BilledAmount decimal(18,2),
								DepositToProvider decimal(18,2), DiscountAmount decimal(18,2), AmountDue decimal(18,2))
AS
BEGIN

DECLARE @AccountNumber varchar(100)
DECLARE @ProviderDueDate varchar(1000)

-- Get Account Number combined string
SELECT @AccountNumber = CASE WHEN SIPS.AccountNumber != '' OR SIPS.AccountNumber != NULL THEN COALESCE(@AccountNumber + ', ', '') + CONVERT(varchar, SIPS.AccountNumber, 1) END,
		@ProviderDueDate = COALESCE(@ProviderDueDate + ', ', '') + CONVERT(varchar, SIPS.DueDate, 1)
FROM Invoice AS I
INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
LEFT JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
JOIN SurgeryInvoice_Provider_Services SIPS ON SIPS.SurgeryInvoice_ProviderID=SIP.ID AND SIPS.Active=1
WHERE I.ID = @InvoiceID AND SIP.InvoiceProviderID = @InvoiceProviderID AND SIPS.DueDate BETWEEN @StartDate AND @EndDate
Order By SIPS.DueDate

-- Insert Account and Provider
INSERT INTO @InvoicePaymentsSummary (AccountNumber, DueDate)
	VALUES (@AccountNumber, @ProviderDueDate)	

UPDATE @InvoicePaymentsSummary 
	Set TotalEstimatedCost = (SELECT DISTINCT (SELECT SUM(EstimatedCost) FROM SurgeryInvoice_Provider_Services SIPS WHERE SIPS.SurgeryInvoice_ProviderID=SIP.ID AND SIPS.Active=1) as EstimatedCost
								FROM Invoice AS I
								INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
								LEFT JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
								JOIN SurgeryInvoice_Provider_Services SIPS ON SIPS.SurgeryInvoice_ProviderID=SIP.ID AND SIPS.Active=1
								WHERE I.ID = @InvoiceID AND SIP.InvoiceProviderID = @InvoiceProviderID AND SIPS.DueDate BETWEEN @StartDate AND @EndDate),
		
		BilledAmount = (SELECT DISTINCT (SELECT SUM(SIPSs.Cost) FROM SurgeryInvoice_Provider_Services SIPSs WHERE SIPSs.SurgeryInvoice_ProviderID=SIP.ID AND SIPSs.Active=1) as Cost
							FROM Invoice AS I
							INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
							LEFT JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
							JOIN SurgeryInvoice_Provider_Services SIPS ON SIPS.SurgeryInvoice_ProviderID=SIP.ID AND SIPS.Active=1
							WHERE I.ID = @InvoiceID AND SIP.InvoiceProviderID = @InvoiceProviderID AND SIPS.DueDate BETWEEN @StartDate AND @EndDate),
		
		DiscountAmount = (SELECT DISTINCT ISNULL((SELECT SUM(SIPSss.Cost) FROM SurgeryInvoice_Provider_Services SIPSss WHERE SIPSss.SurgeryInvoice_ProviderID=SIP.ID AND SIPSss.Active=1),0) - 
											ISNULL((SELECT SUM(SIPSsss.AmountDue) FROM SurgeryInvoice_Provider_Services SIPSsss WHERE SIPSsss.SurgeryInvoice_ProviderID=SIP.ID AND SIPSsss.Active=1),0) as DiscountAmount
							FROM Invoice AS I
							INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
							LEFT JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
							JOIN SurgeryInvoice_Provider_Services SIPS ON SIPS.SurgeryInvoice_ProviderID=SIP.ID AND SIPS.Active=1
							WHERE I.ID = @InvoiceID AND SIP.InvoiceProviderID = @InvoiceProviderID AND SIPS.DueDate BETWEEN @StartDate AND @EndDate),
		
		AmountDue = (SELECT DISTINCT ISNULL((SELECT SUM(ISNULL(SIPSsssa.AmountDue,0)) FROM SurgeryInvoice_Provider_Services SIPSsssa WHERE SIPSsssa.SurgeryInvoice_ProviderID=SIP.ID AND SIPSsssa.Active=1),0) -
									 ISNULL((SELECT SUM(ISNULL(SIPP.Amount, 0)) FROM SurgeryInvoice_Provider_Payments SIPP WHERE SIPP.SurgeryInvoice_ProviderID=SIP.ID AND SIPP.Active=1),0) as AmountDue	
							FROM Invoice AS I
							INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
							LEFT JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
							JOIN SurgeryInvoice_Provider_Services SIPS ON SIPS.SurgeryInvoice_ProviderID=SIP.ID AND SIPS.Active=1
							WHERE I.ID = @InvoiceID AND SIP.InvoiceProviderID = @InvoiceProviderID AND SIPS.DueDate BETWEEN @StartDate AND @EndDate),
							
		DepositToProvider = (SELECT DISTINCT ISNULL((SELECT SUM(ISNULL(SIPP.Amount, 0)) FROM SurgeryInvoice_Provider_Payments SIPP WHERE SIPP.SurgeryInvoice_ProviderID=SIP.ID AND SIPP.Active=1 AND SIPP.PaymentTypeID=3),0) as DepositAmount	
							FROM Invoice AS I
							INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
							LEFT JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
							JOIN SurgeryInvoice_Provider_Services SIPS ON SIPS.SurgeryInvoice_ProviderID=SIP.ID AND SIPS.Active=1
							WHERE I.ID = @InvoiceID AND SIP.InvoiceProviderID = @InvoiceProviderID AND SIPS.DueDate BETWEEN @StartDate AND @EndDate)

	RETURN 
END
GO
