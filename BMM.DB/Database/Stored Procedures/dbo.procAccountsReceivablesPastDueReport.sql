SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brad Conley
-- Create date: 4/30/2014
-- Description:	Data Set for Acounts Receivables Past Due Report
--				4/3/2017 - JA -- Added IsPastDue column
-- =============================================
CREATE PROCEDURE [dbo].[procAccountsReceivablesPastDueReport]
	@StartDate datetime = null, 
	@EndDate datetime = '1/1/1900',
	@CompanyId int = null,
	@AttorneyId int = null,
	@StatementDate datetime = null
AS
BEGIN
	SET NOCOUNT ON;
	
DECLARE @ClosedStatusTypeID INT = 2
DECLARE @PrinciplePaymentTypeID INT = 1
DECLARE @DepositPaymentTypeID INT = 3
DECLARE @CreditPaymentTypeID INT = 5
DECLARE @RefundPaymentTypeID INT = 4
DECLARE @TestTypeID INT = 1
DECLARE @SurgeryTypeID INT = 2
(
	SELECT
		'Test' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		CONVERT(varchar, dbo.f_GetFirstTestDate(I.ID), 1) AS [ServiceDate],
		(dbo.f_GetFirstTestDate(I.ID) + I.ServiceFeeWaivedMonths) AS DateServiceFeeBegins,
		dbo.f_GetTestProvidersAbbrByInvoiceAndDate(I.ID, dbo.f_GetFirstTestDate(I.ID)) AS Provider,
		dbo.f_GetTestProcedure(I.ID, dbo.f_GetFirstTestDate(I.ID)) as ServiceName,
		A.FirstName AS AttorneyFirstName,
		A.LastName AS AttorneyLastName,
		A.LastName + ', ' + A.FirstName AS AttorneyDisplayName,
		InvF.Name AS FirmName,
		InvP.FirstName AS PatientFirstName,
		InvP.LastName AS PatientLastName,
		InvP.LastName + ', ' + InvP.FirstName AS PatientDisplayName,
		dbo.f_GetTestCostTotal(I.ID) AS TotalCost,
		tis.InvoicePaymentTotal AS PaymentAmount,
	    dbo.f_GetTestPPODiscountTotal(I.ID) AS PPODiscount,
		tis.BalanceDue as BalanceDue,
		tis.CumulativeServiceFeeDue as ServiceFeeDue,
		tis.EndingBalance as EndingBalance,
		tis.BalanceDue + tis.CumulativeServiceFeeDue AS TotalDue,
		dbo.f_GetLastCommentFromInvoice(I.ID) As Comment,
		I.isComplete AS InvoiceCompleted,
		-- Change the DueDate(Maturity Date) to the first of the following month.
		-- This is done to match the maturity date of the invoice on the EditInvoice.aspx
	 	DateAdd(Month, 1, DateAdd(Month, DateDiff(Month, 0, tis.MaturityDate), 0)) As DueDate,
		co.LongName as CompanyName,
		tis.FirstTestDate as SortServiceDate,
		I.InvoiceStatusTypeID as StatusType,
		IsPastDue = case when DateAdd(Month, I.LoanTermMonths, dbo.f_GetFirstTestDate(I.ID)) <= Cast(@EndDate as date) then 1 else 0 end
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		join Attorney A on IA.AttorneyID = A.ID 
		LEFT JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		JOIN InvoicePatient InvP ON InvP.ID=I.InvoicePatientID AND InvP.Active=1
		outer apply dbo.f_GetTestInvoiceSummaryTableMinified(I.ID, @StatementDate) tis
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE I.InvoiceStatusTypeID != @ClosedStatusTypeID 
		--AND I.isComplete = 1
		AND tis.BalanceDue > 0 -- CCW:  12/20/2012  Customer does not mark testing invoices as complete, instead placeholder value of $1.00 is updated to signify that this invoice needs to appear on receivables report
		AND I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @TestTypeID
		AND (@AttorneyId = -1 or A.ID = @AttorneyId)
		--AND @StartDate <= tis.MaturityDate AND tis.MaturityDate <= @EndDate
)
UNION
(
	SELECT
		'Procedure' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		CONVERT(varchar, dbo.f_GetFirstSurgeryDate(I.ID), 1) AS [ServiceDate],
		(dbo.f_GetFirstSurgeryDate(I.ID) + I.ServiceFeeWaivedMonths) As DateServiceFeeBegins,
		dbo.f_GetSurgeryProvidersAbbrByInvoice(I.ID) AS Provider,
		dbo.f_GetSurgeryProcedures(I.ID) as ServiceName,
		A.FirstName AS AttorneyFirstName,
		A.LastName AS AttorneyLastName,
		A.LastName + ', ' + A.FirstName AS AttorneyName,
		InvF.Name AS FirmName,
		InvP.FirstName AS PatientFirstName,
		InvP.LastName AS PatientLastName,
		InvP.LastName + ', ' + InvP.FirstName As PatientName,
		dbo.f_GetSurgeryCostTotal(I.ID) AS TotalCost,
		sisum.InvoicePaymentTotal AS PaymentAmount,
		dbo.f_GetSurgeryPPODiscountTotal(I.ID) AS PPODiscount,
		sisum.BalanceDue as BalanceDue,
		sisum.CumulativeServiceFeeDue as ServiceFeeDue,
		sisum.BalanceDue + sisum.CumulativeServiceFeeDue as TotalDue,
		sisum.EndingBalance as EndingBalance,
		dbo.f_GetLastCommentFromInvoice(I.ID) As Comment,
		I.isComplete AS InvoiceCompleted,
		--sisum.MaturityDate As DueDate,
		-- Change the DueDate(Maturity Date) to the first of the following month.
		-- This is done to match the maturity date of the invoice on the EditInvoice.aspx
	 	DateAdd(Month, 1, DateAdd(Month, DateDiff(Month, 0, sisum.MaturityDate), 0)) As DueDate,
		co.LongName as CompanyName,
		sisum.FirstSurgeryDate as SortServiceDate,
		I.InvoiceStatusTypeID as StatusType,
		
		IsPastDue = case when DateAdd(Month, I.LoanTermMonths, dbo.f_GetFirstSurgeryDate(I.ID)) <= Cast(@EndDate as date) then 1 else 0 end
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		join Attorney A on IA.AttorneyID = A.ID 
		LEFT JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		JOIN InvoicePatient InvP ON InvP.ID=I.InvoicePatientID AND InvP.Active=1
		outer apply dbo.f_GetSurgeryInvoiceSummaryTableMinified(I.ID, @StatementDate) sisum
		LEFT JOIN Comments c ON I.ID = c.InvoiceID AND c.Active=1 AND c.isIncludedOnReports = 1
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE I.InvoiceStatusTypeID != @ClosedStatusTypeID AND I.isComplete = 1
		AND I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @SurgeryTypeID
		AND (@AttorneyId = -1 or A.ID = @AttorneyId)
		--AND @StartDate <= sisum.MaturityDate AND sisum.MaturityDate <= @EndDate
)
order by AttorneyDisplayName, InvoiceNumber

END
GO
