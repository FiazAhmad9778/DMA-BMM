-- <Migration ID="1bdcf96f-751c-4193-9555-b5aa36a168e9" />
GO

PRINT N'Altering [dbo].[f_GetTestInvoiceSummaryTableMinified]'
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

ALTER FUNCTION [dbo].[f_GetTestInvoiceSummaryTableMinified] 
(
	@InvoiceID int,
	@StatementDate datetime
)
RETURNS  
@InvoiceSummary TABLE (InvoiceID int, MaturityDate date, AmountDue decimal(18,2), PrincipalDue decimal(18,2), BalanceDue decimal(18,2), CumulativeServiceFeeDue decimal(18,2), EndingBalance decimal(18,2), FirstTestDate datetime, InvoicePaymentTotal decimal(18,2), InterestPaymentTotal decimal(18,2), Deductions decimal(18,2))
AS
BEGIN
	
-------------------------Intial Load
----- Insert into Invoice Summary initially with basic table data
INSERT INTO @InvoiceSummary
	SELECT @InvoiceID, null, 0, 0, 0, 0, 0, null, 0, 0, 0

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
								AND (@StatementDate is null OR P.DatePaid <= @StatementDate)
								AND P.PaymentTypeID in (1,3))
DECLARE @ServiceFeeReceived decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND (@StatementDate is null OR P.DatePaid <= @StatementDate)
								AND P.PaymentTypeID = 2)
DECLARE @AdditionalDeductions decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND (@StatementDate is null OR P.DatePaid <= @StatementDate)
								AND P.PaymentTypeID in (4,5))
DECLARE @TotalPrincipal decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND (@StatementDate is null OR P.DatePaid <= @StatementDate)
								AND P.PaymentTypeID = 1)
DECLARE @TotalDeposits decimal(18,2) = (SELECT SUM (Amount)
								FROM Payments AS P
								WHERE P.Active=1
								AND P.InvoiceID = @InvoiceID
								AND (@StatementDate is null OR P.DatePaid <= @StatementDate)
								AND P.PaymentTypeID = 3)

DECLARE @TotalTestCost_Minus_PPODiscount decimal(18,2) =  (SELECT (SUM(TestCost) - SUM(TIT.PPODiscount))	
														FROM Invoice AS I
														INNER JOIN TestInvoice AS TI ON I.TestInvoiceID = TI.ID AND TI.Active = 1
														INNER JOIN TestInvoice_Test AS TIT ON TI.ID = TIT.TestInvoiceID AND TIT.Active = 1
														WHERE I.ID = @InvoiceID)

DECLARE @TotalTestPrincipalDue decimal(18,2) =  (@TotalTestCost_Minus_PPODiscount - ISNULL(@Principal_Deposits_Paid, 0))

-------------------------Balance Due and Cumulative Service Fee Due
----- Update the invoice summary
----- Balance Due equals The total test cost minus the ppo discount minus the principal deposits made and minus any additional deductions 
UPDATE @InvoiceSummary
SET PrincipalDue = ISNULL(@TotalTestPrincipalDue, 0),
	BalanceDue = ISNULL(@TotalTestCost_Minus_PPODiscount, 0) - ISNULL(@Principal_Deposits_Paid, 0) - ISNULL(@AdditionalDeductions, 0),
	CumulativeServiceFeeDue = (SELECT I.CalculatedCumulativeIntrest FROM Invoice AS I WHERE ID = @InvoiceID),
	InvoicePaymentTotal = ISNULL(@Principal_Deposits_Paid, 0) + ISNULL(@ServiceFeeReceived, 0) + ISNULL(@AdditionalDeductions, 0),
	InterestPaymentTotal = ISNULL(@ServiceFeeReceived, 0),
	Deductions = @AdditionalDeductions

UPDATE @InvoiceSummary
SET CumulativeServiceFeeDue = (ISNULL(CumulativeServiceFeeDue,0) - ISNULL(@ServiceFeeReceived,0) - (ISNULL(@ServiceFeeWaived,0))),
	AmountDue = ISNULL(@TotalTestPrincipalDue, 0) - ISNULL(@ServiceFeeReceived, 0) - ISNULL(@AdditionalDeductions, 0),
-- CCW:  12/20/2012:  ADDED LINE BELOW to provide EndingBalance (the sum of BalanceDue + CumulativeServiceFeeDue)
	EndingBalance = (ISNULL(@TotalTestCost_Minus_PPODiscount, 0) - ISNULL(@Principal_Deposits_Paid, 0) - ISNULL(@AdditionalDeductions, 0)) + (ISNULL(CumulativeServiceFeeDue,0))

	RETURN 
END

GO
PRINT N'Altering [dbo].[procTotalRevenueReport]'
GO
-- =============================================
-- Author:		Brad Conley
-- Create date: 4/2/14
-- Description:	Return information for the Total Revenue Report
-- Modified date: 07/27/2015 by Cherie Walker to only show active surgery and test dates
-- Modified columns: 08/17/2015 by Cherie Walker based on user's feedback
-- =============================================
ALTER PROCEDURE [dbo].[procTotalRevenueReport] 
	@StartYear Date = '1/1/1901', 
	@EndYear Date = GETDATE,
	@CompanyId int = -1
AS
BEGIN
	
	SET NOCOUNT ON;
(
   select
    A.ID as AttorneyID,
    A.FirstName as AttorneyFirstName,
    A.LastName as AttorneyLastName,
    YEAR(SISD.ScheduledDate) as YearPaid,
    SIS.isCanceled as Canceled,
    --SIPS.ID as ID,
    sum(SIPS.Cost) as TotalCostBeforePPODiscount,
    sum(SIPS.PPODiscount) as PPODiscount,
    sum(SIPS.Cost - SIPS.PPODiscount) as TotalCostLessPPODiscount,
    sum(SIPS.AmountDue) as LessCostOfGoodsSold,
    sum((SIPS.Cost - SIPS.PPODiscount) - SIPS.AmountDue + sisum.CumulativeServiceFeeDue) as TotalRevenue,
    C.LongName as CompanyName,
	sisum.CumulativeServiceFeeDue
  
    from Invoice I
    JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
	JOIN Attorney A on IA.AttorneyID = A.ID
	JOIN SurgeryInvoice SI on SI.ID = I.SurgeryInvoiceID
	JOIN SurgeryInvoice_Surgery SIS on SI.ID = SIS.SurgeryInvoiceID
	JOIN SurgeryInvoice_SurgeryDates SISD on SIS.ID = SISD.SurgeryInvoice_SurgeryID
	JOIN SurgeryInvoice_Providers SIP on SIP.SurgeryInvoiceID = SI.ID
	JOIN SurgeryInvoice_Provider_Services SIPS on SIPS.SurgeryInvoice_ProviderID = SIP.ID
	JOIN Company C on C.ID = I.CompanyID
	outer apply dbo.f_GetTestInvoiceSummaryTableMinified(I.ID, null) sisum
	
    WHERE I.Active = 1 
    AND SIS.isCanceled = 0 
    AND I.CompanyID = @CompanyId
    and SISD.ScheduledDate BETWEEN @StartYear AND @EndYear

	GROUP BY
	A.ID,
	A.FirstName,
	A.LastName,
	SISD.ScheduledDate,
	SIS.isCanceled,
	--SIPS.ID,
	c.LongName,
	sisum.CumulativeServiceFeeDue
)
UNION ALL
(
	select
	A.ID as AttorneyID,
    A.FirstName as AttorneyFirstName,
    A.LastName as AttorneyLastName,
    YEAR(TIT.TestDate) as YearPaid,
    TIT.isCanceled as Canceled,
    --TIT.ID as ID,
    sum(TIT.TestCost) as TotalCostBeforePPODiscount,
    sum(TIT.PPODiscount) as PPODiscount,
    sum(TIT.TestCost - TIT.PPODiscount) AS TotalCostLessPPODiscount,
    sum(TIT.AmountToProvider) as LessCostOfGoodsSold,
    sum((TIT.TestCost - TIT.PPODiscount) - TIT.AmountToProvider) as TotalRevenue,
    C.LongName as CompanyName,
	tisum.CumulativeServiceFeeDue
	
	from Invoice I
	JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
	JOIN Attorney A on IA.AttorneyID = A.ID
	JOIN TestInvoice TI on TI.ID = I.TestInvoiceID
	JOIN TestInvoice_Test TIT on TIT.TestInvoiceID = TI.ID
	JOIN Company C on C.ID = I.CompanyID
	outer apply dbo.f_GetTestInvoiceSummaryTableMinified(I.ID, null) tisum
	
	where I.Active = 1 
	AND TIT.isCanceled = 0 
	AND I.CompanyID = @CompanyId
    and TIT.TestDate BETWEEN @StartYear AND @EndYear

	GROUP BY
	A.ID,
	A.FirstName,
	A.LastName,
	TIT.TestDate,
	TIT.isCanceled,
	--TIT.ID,
	c.LongName,
	tisum.CumulativeServiceFeeDue
)

ORDER BY A.ID

END
GO
PRINT N'Altering [dbo].[f_GetSurgeryInvoiceSummaryTableMinified]'
GO

ALTER FUNCTION [dbo].[f_GetSurgeryInvoiceSummaryTableMinified] 
(
	@InvoiceID int,
	@StatementDate datetime
)
RETURNS 
@InvoiceSummary TABLE (InvoiceID int, MaturityDate date, AmountDue decimal(18,2), PrincipalDue decimal(18,2), BalanceDue decimal(18,2), CumulativeServiceFeeDue decimal(18,2), EndingBalance decimal(18,2), FirstSurgeryDate datetime, InvoicePaymentTotal decimal(18,2), InterestPaymentTotal decimal(18,2), Deductions decimal(18,2))
AS
BEGIN

-------------------------Intial Load
----- Insert into Invoice Summary initially with basic table data	
INSERT INTO @InvoiceSummary
	SELECT @InvoiceID, null, 0, 0, 0, 0, 0, null, 0, 0, 0
	
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

DECLARE @TotalPrincipalDue decimal(18,2) = (@TotalCost_Minus_PPODiscount - ISNULL(@Principal_Deposits_Paid, 0))
														

-------------------------Balance Due and Cumulative Service Fee Due
----- Update the invoice summary
----- Balance Due equals The total test cost minus the ppo discount minus the principal deposits made and minus any additional deductions 
UPDATE @InvoiceSummary
SET PrincipalDue = ISNULL(@TotalPrincipalDue, 0),
	BalanceDue = ISNULL(@TotalCost_Minus_PPODiscount, 0) - ISNULL(@Principal_Deposits_Paid, 0) - ISNULL(@AdditionalDeductions, 0),
	CumulativeServiceFeeDue = (SELECT I.CalculatedCumulativeIntrest FROM Invoice AS I WHERE ID = @InvoiceID),
	InvoicePaymentTotal = ISNULL(@Principal_Deposits_Paid, 0) + ISNULL(@ServiceFeeReceived, 0) + ISNULL(@AdditionalDeductions, 0),
	InterestPaymentTotal = ISNULL(@ServiceFeeReceived, 0),
	Deductions = @AdditionalDeductions

UPDATE @InvoiceSummary
SET CumulativeServiceFeeDue = (ISNULL(CumulativeServiceFeeDue,0) - ISNULL(@ServiceFeeReceived,0) - (ISNULL(@ServiceFeeWaived,0)))

-------------------------Ending Balance
----- Update the invoice summary setting the ending balance
----- Ending Balance equals the balance due plus the cumulative service fee due, minus losses amount
UPDATE @InvoiceSummary
SET AmountDue = ISNULL(@TotalCost_Minus_PPODiscount, 0),
	EndingBalance = (BalanceDue + CumulativeServiceFeeDue) - (SELECT ISNULL(LossesAmount, 0) FROM Invoice WHERE ID=@InvoiceID)
	
	RETURN 
END

GO
PRINT N'Creating [dbo].[f_ConvertDate]'
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Gets all test dates as string for an invoice
-- =============================================
CREATE FUNCTION [dbo].[f_ConvertDate] 
(
	-- Add the parameters for the function here
	@Date datetime	
)
RETURNS datetime
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result datetime = convert(varchar, @Date, 1)
	
	RETURN @Result

END

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
												
		tis.EndingBalance as TotalDue,			
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
		sisum.EndingBalance as TotalDue,		
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
		tis.EndingBalance as EndingBalance,
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
		AND @StartDate <= tis.FirstTestDate AND tis.FirstTestDate <= @EndDate
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
		AND @StartDate <= sisum.FirstSurgeryDate AND sisum.FirstSurgeryDate <= @EndDate
)
order by AttorneyDisplayName
end

END
GO
PRINT N'Altering [dbo].[procDiscountReport]'
GO
-- =============================================
-- Author:		Durel Hoover
-- Create date: 4/3/2014
-- Description:	Retrieves the Discount Report's data.
-- =============================================
ALTER PROCEDURE [dbo].[procDiscountReport] 
	-- Add the parameters for the stored procedure here
	@CompanyID INT,
	@StartDate DATE,
	@EndDate DATE,
	@AttorneyID INT = -1,
	@StatementDate datetime = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @TestTypeID INT = 1,
			@SurgeryTypeID INT = 2
			
	SELECT tblinv.CompanyID,
		   c.LongName							  AS "CompanyName",
		   tblInv.FirmID, 
		   f.Name                                 AS "FirmName", 
		   tblInv.AttorneyID, 
		   att.LastName                           AS "AttLastName", 
		   att.FirstName                          AS "AttFirstName", 
		   SUM(tblInv.PrincipalDue)                 AS "TotalPrincipalDue", 
		   SUM(ISNULL(tblInv.LossesAmount, 0))    AS "PrincipalWaived", 
		   SUM(tblInv.CalculatedCumulativeIntrest)    AS "TotalServiceFeeDue", 
		   SUM(ISNULL(tblInv.ServiceFeeWaived, 0)) AS "ServiceFeeWaived",
		   SUM(ISNULL(tblInv.ServiceFeeWaived, 0)) AS "ServiceFeeWaived",
		   SUM(ISNULL(tblInv.InvoicePaymentTotal, 0)) AS "TotalPayments",
		   SUM(ISNULL(tblInv.InterestPaymentTotal, 0)) AS "InterestPayments",
		   SUM(ISNULL(tblInv.Deductions, 0)) AS Deductions,
		   SUM(ISNULL(tblInv.AmountDue, 0)) AS "AmountDue"
	FROM   ((SELECT inv.ID, 
					inv.InvoiceNumber,
					inv.CompanyID, 
					att.FirmID, 
					invAtt.AttorneyID, 
					tis.PrincipalDue, 
					inv.LossesAmount,
					inv.CalculatedCumulativeIntrest,
					--tis.CumulativeServiceFeeDue, 
					inv.ServiceFeeWaived,
					tis.AmountDue,
					tis.InvoicePaymentTotal,
					tis.InterestPaymentTotal,
					tis.Deductions
			 FROM   Invoice inv 
					INNER JOIN InvoiceAttorney invAtt 
							ON inv.InvoiceAttorneyID = invAtt.ID 
					INNER JOIN Attorney att 
							ON invAtt.AttorneyID = att.ID
					OUTER apply f_GetTestInvoiceSummaryTableMinified(inv.id, @StatementDate) tis 
			 WHERE  ( @AttorneyID <= 0 
					   OR invAtt.AttorneyID = @AttorneyID )
					AND @CompanyID = inv.CompanyID
					AND inv.InvoiceTypeID = @TestTypeID 
					AND inv.Active = 1 
					--AND tis.BalanceDue > 0
					AND (inv.LossesAmount > 0 or inv.ServiceFeeWaived > 0)
					AND inv.DatePaid between @StartDate and @EndDate)
					--AND @StartDate <= tis.FirstTestDate
					--AND tis.FirstTestDate <= @EndDate) 
			UNION 
			(SELECT inv.ID, 
					inv.InvoiceNumber,
					inv.CompanyID, 
					att.FirmID, 
					invAtt.AttorneyID, 
					sis.PrincipalDue, 
					inv.LossesAmount, 
					inv.CalculatedCumulativeIntrest,
					--sis.CumulativeServiceFeeDue,
					inv.ServiceFeeWaived,
					sis.AmountDue,
					sis.InvoicePaymentTotal,
					sis.InterestPaymentTotal,
					sis.Deductions
			 FROM   Invoice inv 
					INNER JOIN InvoiceAttorney invAtt 
							ON inv.InvoiceAttorneyID = invAtt.ID 
					INNER JOIN Attorney att 
							ON invAtt.AttorneyID = att.ID
					OUTER apply f_GetSurgeryInvoiceSummaryTableMinified(inv.id, @StatementDate) sis 
			 WHERE  ( @AttorneyID <= 0 
					   OR invAtt.AttorneyID = @AttorneyID )
					AND @CompanyID = inv.CompanyID 
					AND inv.InvoiceTypeID = @SurgeryTypeID 
					AND inv.Active = 1 
					--AND sis.BalanceDue > 0 
					AND (inv.LossesAmount > 0 or inv.ServiceFeeWaived > 0)
					AND inv.DatePaid between @StartDate and @EndDate))tblInv
					--AND @StartDate <= sis.FirstSurgeryDate 
					--AND sis.FirstSurgeryDate <= @EndDate)) tblInv 
		   INNER JOIN Attorney att 
				   ON tblInv.AttorneyID = att.ID
		   INNER JOIN Company c
				   ON tblInv.CompanyID = c.ID 
		   LEFT JOIN Firm f 
				  ON tblInv.FirmID = f.ID 
	GROUP  BY tblInv.CompanyID,
			  c.LongName,
			  f.Name, 
			  tblInv.FirmID, 
			  att.LastName, 
			  att.FirstName, 
			  tblInv.AttorneyID 
END
GO
