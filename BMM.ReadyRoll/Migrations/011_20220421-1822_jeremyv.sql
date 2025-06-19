-- <Migration ID="b6843988-0a88-4459-b7cb-68f818ea2619" />
GO

PRINT N'Altering [dbo].[procAccountsReceivableAgingReport]'
GO
-- =============================================
-- Author:		Brad Conley
-- Create date: 6/20/2013
-- Description:	Accounts Receivable Aging Report
-- This Stored Procedure is based on procAccountsReceivableReport.  For tests, we use invoices with a balance due greater than 1 because
-- Customer does not mark testing invoices as complete, instead placeholder value of $1.00 is updated to signify that this invoice needs to appear on receivables report
-- However, we do not want these $1.00 charge amounts effecting the dollar amounts of the report, so we only use balances greate than $1.00
-- The inner select statement and union return individual results that need to be grouped, achieved by the outer select and group by.
-- Case 1007530:  Added @DateAtEndOfMonth in order to filter out all future tests/surgeries.
-- =============================================
--procAccountsReceivableAgingReport 1,  '1/1/1900', '10/14/2016'
ALTER PROCEDURE [dbo].[procAccountsReceivableAgingReport]
	-- Add the parameters for the stored procedure here
	@CompanyID int = -1,
	@StartDate datetime,
	@EndDate datetime,
	@AttorneyId int = -1,
	@StatementDate datetime = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
DECLARE @ClosedStatusTypeID INT = 2
DECLARE @TestTypeID INT = 1
DECLARE @SurgeryTypeID INT = 2
DECLARE @DateAtEndOfMonth DATE = dateadd(month,1+datediff(month,0,getdate()),-1)

select t.AttorneyId, t.AttorneyDisplayName, SUM(t.Less_Than_60) as Less_Than_60, SUM(t.BT_120_180) as BT_120_180, SUM(t.BT_180_240) as BT_180_240,
 SUM(t.BT_240_300) as BT_240_300, SUM(t.BT_300_360) as BT_300_360, SUM(t.BT_360_420) as BT_360_420, SUM(t.BT_420_480) as BT_420_480,
 SUM(t.BT_480_540) as BT_480_540, SUM(t.BT_540_600) as BT_540_600, SUM(t.BT_60_120) as BT_60_120, SUM(t.BT_600_660) as BT_600_660, 
 SUM(t.BT_660_720) as BT_660_720, SUM(t.BT_720_780) as BT_720_780, SUM(t.BT_780_840) as BT_780_840, SUM(t.BT_840_900) as BT_840_900,
 SUM(t.GT_900) as GT_900, t.CompanyName, SUM(t.TotalDue) as TotalDue
from
(
(
	SELECT													
		I.InvoiceNumber as InvoiceNumber,
		IA.AttorneyID as AttorneyId,	
		A.LastName + ', ' + A.FirstName AS AttorneyDisplayName,
												
		tis.BalanceDue + tis.CumulativeServiceFeeDue as TotalDue,			
		co.LongName as CompanyName,
		
		case when dbo.f_ConvertDate(dateadd("d", -60, GetDate())) <= dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as Less_Than_60,
		
		case when dbo.f_ConvertDate(dateadd("d", -120, GetDate())) <= dbo.f_GetFirstTestDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -61, GETDATE())) >= dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_60_120,
		
		case when dbo.f_ConvertDate(dateadd("d", -180, GetDate())) <= dbo.f_GetFirstTestDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -121, GETDATE())) >= dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_120_180,
		
		case when dbo.f_ConvertDate(dateadd("d", -240, GetDate())) <= dbo.f_GetFirstTestDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -181, GETDATE())) >= dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_180_240,
		
		case when dbo.f_ConvertDate(dateadd("d", -300, GetDate())) <= dbo.f_GetFirstTestDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -241, GETDATE())) >= dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_240_300,
		
		case when dbo.f_ConvertDate(dateadd("d", -360, GetDate())) <= dbo.f_GetFirstTestDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -301, GETDATE())) >= dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_300_360,
		
		case when dbo.f_ConvertDate(dateadd("d", -420, GetDate())) <= dbo.f_GetFirstTestDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -361, GETDATE())) >= dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_360_420,
		
		case when dbo.f_ConvertDate(dateadd("d", -480, GetDate())) <= dbo.f_GetFirstTestDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -421, GETDATE())) >= dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_420_480,
		
		case when dbo.f_ConvertDate(dateadd("d", -540, GetDate())) <= dbo.f_GetFirstTestDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -481, GETDATE())) >= dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_480_540,
		
		case when dbo.f_ConvertDate(dateadd("d", -600, GetDate())) <= dbo.f_GetFirstTestDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -541, GETDATE())) >= dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_540_600,
		
		case when dbo.f_ConvertDate(dateadd("d", -660, GetDate())) <= dbo.f_GetFirstTestDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -601, GETDATE())) >= dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_600_660,
		
		case when dbo.f_ConvertDate(dateadd("d", -720, GetDate())) <= dbo.f_GetFirstTestDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -661, GETDATE())) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_660_720,
		
		case when dbo.f_ConvertDate(dateadd("d", -780, GetDate())) <= dbo.f_GetFirstTestDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -721, GETDATE())) >= dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_720_780,
		
		case when dbo.f_ConvertDate(dateadd("d", -840, GetDate())) <= dbo.f_GetFirstTestDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -781, GETDATE())) >= dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_780_840,
		
		case when dbo.f_ConvertDate(dateadd("d", -900, GetDate())) <= dbo.f_GetFirstTestDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -841, GETDATE())) >= dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_840_900,
		
		case when dbo.f_ConvertDate(DATEADD("d", -901, getdate())) >= dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as GT_900
				
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		join Attorney A on IA.AttorneyID = A.ID 
		outer apply dbo.f_GetTestInvoiceSummaryTableMinified(I.ID, @StatementDate) tis
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE I.InvoiceStatusTypeID != @ClosedStatusTypeID		
		AND tis.BalanceDue > 0 -- Taken From procAccountsReceivableReport - CCW:  12/20/2012  Customer does not mark testing invoices as complete, instead placeholder value of $1.00 is updated to signify that this invoice needs to appear on receivables report
		AND I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @TestTypeID	
		AND (@AttorneyId = -1 or A.ID = @AttorneyId)	
		--and cast(tis.FirstTestDate as date) <= @DateAtEndOfMonth
		AND tis.FirstTestDate BETWEEN @StartDate AND @EndDate	
)
UNION
(
	SELECT
		I.InvoiceNumber as InvoiceNumber,							
		IA.AttorneyID as AttorneyId,
		A.LastName + ', ' + A.FirstName AS AttorneyName,				
		sisum.BalanceDue + sisum.CumulativeServiceFeeDue as TotalDue,		
		co.LongName as CompanyName,
		
		case when dbo.f_ConvertDate(dateadd("d", -60, GetDate())) <= dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as Less_Than_60,
		
		case when dbo.f_ConvertDate(dateadd("d", -120, GetDate())) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -61, GETDATE())) >= dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_60_120,
		
		case when dbo.f_ConvertDate(dateadd("d", -180, GetDate())) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -121, GETDATE())) >= dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_120_180,
		
		case when dbo.f_ConvertDate(dateadd("d", -240, GetDate())) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -181, GETDATE())) >= dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_180_240,
		
		case when dbo.f_ConvertDate(dateadd("d", -300, GetDate())) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -241, GETDATE())) >= dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_240_300,
		
		case when dbo.f_ConvertDate(dateadd("d", -360, GetDate())) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -301, GETDATE())) >= dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_300_360,
		
		case when dbo.f_ConvertDate(dateadd("d", -420, GetDate())) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -361, GETDATE())) >= dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_360_420,
		
		case when dbo.f_ConvertDate(dateadd("d", -480, GetDate())) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -421, GETDATE())) >= dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_420_480,
		
		case when dbo.f_ConvertDate(dateadd("d", -540, GetDate())) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -481, GETDATE())) >= dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_480_540,
		
		case when dbo.f_ConvertDate(dateadd("d", -600, GetDate())) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -541, GETDATE())) >= dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_540_600,
		
		case when dbo.f_ConvertDate(dateadd("d", -660, GetDate())) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -601, GETDATE())) >= dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_600_660,
		
		case when dbo.f_ConvertDate(dateadd("d", -720, GetDate())) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -661, GETDATE())) >= dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_660_720,
		
		case when dbo.f_ConvertDate(dateadd("d", -780, GetDate())) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -721, GETDATE())) >= dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_720_780,
		
		case when dbo.f_ConvertDate(dateadd("d", -840, GetDate())) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -781, GETDATE())) >= dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_780_840,
		
		case when dbo.f_ConvertDate(dateadd("d", -900, GetDate())) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND dbo.f_ConvertDate(DATEADD("d", -841, GETDATE())) >= dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_840_900,
		
		case when dbo.f_ConvertDate(DATEADD("d", -901, getdate())) >= dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as GT_900
	
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		join Attorney A on IA.AttorneyID = A.ID 
		outer apply dbo.f_GetSurgeryInvoiceSummaryTableMinified(I.ID, @StatementDate) sisum	
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE I.InvoiceStatusTypeID != @ClosedStatusTypeID AND I.isComplete = 1		
		AND I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @SurgeryTypeID
		AND (@AttorneyId = -1 or A.ID = @AttorneyId)
		AND sisum.FirstSurgeryDate BETWEEN @StartDate AND @EndDate
			
)) t

group by t.AttorneyId, t.AttorneyDisplayName, t.CompanyName
order by AttorneyDisplayName 
END
GO
PRINT N'Altering [dbo].[procAccountsReceivableReport]'
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/19/2012
-- Description:	Accounts Receivable Report Data
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    03/19/2012   Aaron     Created proc
** 2	03/22/2012	 Aaron	   Commented and verified function calcs 
** 2	03/23/2012	 Aaron	   Fixed duplicate records, added UDFs for total calculations
** 3	10/17/2012	 Aaron	   Made query faster by 40 seconds
** 4	12/20/2012	 Czarina   Made modifications to the criteria to include test invoices because users do not mark as complete 		
** 5    01/03/2013   Cherie    Made modification to the criteria to include all Balance Due > 0
** 6	05/01/2017   Jason A   Added IsPastDue column, fixed PastDue logic
*******************************/
ALTER PROCEDURE [dbo].[procAccountsReceivableReport]
	@StartDate datetime = null, 
	@EndDate datetime = null,
	@CompanyId int = -1,
	@AttorneyId int = -1,
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
if @CompanyId = 1
begin
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
		IsPastDue = case when DateAdd(Month, I.LoanTermMonths, dbo.f_GetFirstTestDate(I.ID)) <= Cast(@StatementDate as date) then 1 else 0 end
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
		--AND @StartDate <= tis.FirstTestDate AND tis.FirstTestDate <= @EndDate
		--AND @StartDate <= tis.MaturityDate AND tis.MaturityDate <= @EndDate
)
UNION
(
	SELECT
		'Procedure' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		CONVERT(varchar(1000),dbo.f_GetSurgeryDates(I.ID),1) AS [ServiceDate],
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
		-- Change the DueDate(Maturity Date) to the first of the following month.
		-- This is done to match the maturity date of the invoice on the EditInvoice.aspx
	 	DateAdd(Month, 1, DateAdd(Month, DateDiff(Month, 0, sisum.MaturityDate), 0)) As DueDate,
		co.LongName as CompanyName,
		sisum.FirstSurgeryDate as SortServiceDate,
		I.InvoiceStatusTypeID as StatusType,
		IsPastDue = case when DateAdd(Month, I.LoanTermMonths, dbo.f_GetFirstSurgeryDate(I.ID)) <= Cast(@StatementDate as date) then 1 else 0 end
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
		--AND @StartDate <= sisum.FirstSurgeryDate AND sisum.FirstSurgeryDate <= @EndDate
		--AND @StartDate <= sisum.MaturityDate AND sisum.MaturityDate <= @EndDate
)

order by AttorneyDisplayName
end
else if @CompanyId = 2
begin
(
	SELECT
		'Test' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		dbo.f_GetTestDates(I.ID) AS [ServiceDate],
		(dbo.f_GetFirstTestDate(I.ID) + I.ServiceFeeWaivedMonths) AS DateServiceFeeBegins,
		dbo.f_GetTestProvidersAbbrByInvoice(I.ID) AS Provider,
		dbo.f_GetTestProcedures(I.ID) as ServiceName,
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
		tis.BalanceDue + tis.CumulativeServiceFeeDue as EndingBalance,
		tis.BalanceDue + tis.CumulativeServiceFeeDue AS TotalDue,
		dbo.f_GetLastCommentFromInvoice(I.ID) As Comment,
		I.isComplete AS InvoiceCompleted,
		tis.MaturityDate As DueDate,
		co.LongName as CompanyName,
		tis.FirstTestDate as SortServiceDate,
		I.InvoiceStatusTypeID as StatusType,
		IsPastDue = case when tis.MaturityDate < Cast(getdate() as date) and i.InvoiceStatusTypeID != 1 then 1 else 0 end
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
		--AND @StartDate <= tis.FirstTestDate AND tis.FirstTestDate <= @EndDate
		AND tis.FirstTestDate BETWEEN @StartDate AND @EndDate	
)
UNION
(
	SELECT
		'Procedure' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		CONVERT(varchar(1000),dbo.f_GetSurgeryDates(I.ID),1) AS [ServiceDate],
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
		sisum.BalanceDue + sisum.CumulativeServiceFeeDue as EndingBalance,
		sisum.BalanceDue + sisum.CumulativeServiceFeeDue as TotalDue,		
		dbo.f_GetLastCommentFromInvoice(I.ID) As Comment,
		I.isComplete AS InvoiceCompleted,
		sisum.MaturityDate As DueDate,
		co.LongName as CompanyName,
		sisum.FirstSurgeryDate as SortServiceDate,
		I.InvoiceStatusTypeID as StatusType,
		IsPastDue = case when sisum.MaturityDate < Cast(getdate() as date) and i.InvoiceStatusTypeID != 1 then 1 else 0 end
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
		--AND @StartDate <= sisum.FirstSurgeryDate AND sisum.FirstSurgeryDate <= @EndDate
		AND sisum.FirstSurgeryDate BETWEEN @StartDate AND @EndDate
)
order by AttorneyDisplayName
end

END
GO
