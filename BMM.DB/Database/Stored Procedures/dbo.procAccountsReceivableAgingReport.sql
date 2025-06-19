SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
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
CREATE PROCEDURE [dbo].[procAccountsReceivableAgingReport]
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
												
		tis.EndingBalance as TotalDue,			
		co.LongName as CompanyName,
		
		case when dateadd("d", -60, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as Less_Than_60,
		
		case when dateadd("d", -120, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -61, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_60_120,
		
		case when dateadd("d", -180, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -121, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_120_180,
		
		case when dateadd("d", -240, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -181, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_180_240,
		
		case when dateadd("d", -300, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -241, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_240_300,
		
		case when dateadd("d", -360, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -301, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_300_360,
		
		case when dateadd("d", -420, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -361, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_360_420,
		
		case when dateadd("d", -480, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -421, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_420_480,
		
		case when dateadd("d", -540, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -481, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_480_540,
		
		case when dateadd("d", -600, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -541, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_540_600,
		
		case when dateadd("d", -660, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -601, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_600_660,
		
		case when dateadd("d", -720, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -661, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_660_720,
		
		case when dateadd("d", -780, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -721, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_720_780,
		
		case when dateadd("d", -840, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -781, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_780_840,
		
		case when dateadd("d", -900, GetDate()) <= dbo.f_GetFirstTestDate(I.ID)
		AND DATEADD("d", -841, GETDATE()) > dbo.f_GetFirstTestDate(I.ID)
		then tis.EndingBalance
		else 0 end as BT_840_900,
		
		case when DATEADD("d", -901, getdate()) >= dbo.f_GetFirstTestDate(I.ID)
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
		sisum.EndingBalance as TotalDue,		
		co.LongName as CompanyName,
		
		case when dateadd("d", -60, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as Less_Than_60,
		
		case when dateadd("d", -120, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -61, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_60_120,
		
		case when dateadd("d", -180, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -121, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_120_180,
		
		case when dateadd("d", -240, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -181, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_180_240,
		
		case when dateadd("d", -300, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -241, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_240_300,
		
		case when dateadd("d", -360, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -301, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_300_360,
		
		case when dateadd("d", -420, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -361, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_360_420,
		
		case when dateadd("d", -480, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -421, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_420_480,
		
		case when dateadd("d", -540, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -481, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_480_540,
		
		case when dateadd("d", -600, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -541, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_540_600,
		
		case when dateadd("d", -660, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -601, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_600_660,
		
		case when dateadd("d", -720, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -661, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_660_720,
		
		case when dateadd("d", -780, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -721, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_720_780,
		
		case when dateadd("d", -840, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -781, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_780_840,
		
		case when dateadd("d", -900, GetDate()) <= dbo.f_GetFirstSurgeryDate(I.ID)
		AND DATEADD("d", -841, GETDATE()) > dbo.f_GetFirstSurgeryDate(I.ID)
		then sisum.EndingBalance
		else 0 end as BT_840_900,
		
		case when DATEADD("d", -901, getdate()) >= dbo.f_GetFirstSurgeryDate(I.ID)
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
