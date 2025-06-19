-- <Migration ID="9de4880d-0279-449d-a4c2-1a4e8cf8aa93" />
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
	AmountDue = ISNULL(@TotalTestPrincipalDue, 0) - ISNULL(@ServiceFeeReceived, 0) - ISNULL(@AdditionalDeductions, 0)

UPDATE @InvoiceSummary
SET
-- CCW:  12/20/2012:  ADDED LINE BELOW to provide EndingBalance (the sum of BalanceDue + CumulativeServiceFeeDue)
	EndingBalance = (ISNULL(@TotalTestCost_Minus_PPODiscount, 0) - ISNULL(@Principal_Deposits_Paid, 0) - ISNULL(@AdditionalDeductions, 0)) + (ISNULL(CumulativeServiceFeeDue,0))

	RETURN 
END

GO
PRINT N'Creating [dbo].[f_GetInvoiceIntertestPayoffTable]'
GO

CREATE FUNCTION [dbo].[f_GetInvoiceIntertestPayoffTable] 
(
	@InvoiceID int,
	@PayoffDate datetime
)

RETURNS  
@TempInterestLog TABLE 
	(
		Invoice_ID int, YearlyInterest DECIMAL(18, 2),
		ServiceFeeWaivedMonths INT,
		AmortizationDate DATE,
		DateInterestBegins DATE,
		TotalCost DECIMAL(18, 2),
		TotalPPODiscount DECIMAL(18, 2),
		TotalAppliedPayments DECIMAL(18, 2),
		BalanceDue DECIMAL(18, 2),
		CalculatedInterest DECIMAL(18, 2),
		PreviousCumulativeInterest DECIMAL(18, 2),
		NewCumulativeInterest DECIMAL(18, 2)
	)

AS
BEGIN
	
	IF @PayoffDate IS NULL
	SET @PayoffDate = GETDATE()

	DECLARE @Month DATE = CONVERT(DATE, CONVERT(CHAR(2), DATEPART(MONTH, @PayoffDate)) + '/1/' + CONVERT(CHAR(4), DATEPART(YEAR, @PayoffDate)))
	DECLARE @ClosedStatusTypeID INT = 2
	DECLARE @TestingInvoiceTypeID INT = 1
	DECLARE @InterestPaymentTypeID INT = 2
	DECLARE @NumMonths INT = DATEDIFF(MONTH, getdate(), @PayoffDate)

	-- create temporary table to store intermediate values and calculations
	--DECLARE @TempInterestLog TABLE
	--(
	--	Invoice_ID INT,
	--	YearlyInterest DECIMAL(18, 2),
	--	ServiceFeeWaivedMonths INT,
	--	AmortizationDate DATE,
	--	DateInterestBegins DATE,
	--	TotalCost DECIMAL(18, 2),
	--	TotalPPODiscount DECIMAL(18, 2),
	--	TotalAppliedPayments DECIMAL(18, 2),
	--	BalanceDue DECIMAL(18, 2),
	--	CalculatedInterest DECIMAL(18, 2),
	--	PreviousCumulativeInterest DECIMAL(18, 2),
	--	NewCumulativeInterest DECIMAL(18, 2)
	--)

	-- insert records into the temp table for non-closed invoices that do not have interest calculation logs for the current month (or, technically, future months)
	INSERT INTO @TempInterestLog
		SELECT i.ID,
			i.YearlyInterest,
			i.ServiceFeeWaivedMonths,
			CASE WHEN i.InvoiceTypeID = @TestingInvoiceTypeID THEN dbo.f_GetFirstTestDate(i.ID) ELSE dbo.f_GetFirstSurgeryDate(i.ID) END, -- AmortizationDate
			NULL, -- DateInterestBegins
			ISNULL(CASE WHEN i.InvoiceTypeID = @TestingInvoiceTypeID THEN dbo.f_GetTestCostTotal(i.ID) ELSE dbo.f_GetSurgeryCostTotal(i.ID) END, 0), -- TotalCost
			ISNULL(CASE WHEN i.InvoiceTypeID = @TestingInvoiceTypeID THEN dbo.f_GetTestPPODiscountTotal(i.ID) ELSE dbo.f_GetSurgeryPPODiscountTotal(i.ID) END, 0), -- TotalPPODiscount
			0, -- TotalAppliedPayments
			0, -- BalanceDue
			0, -- CalculatedInterest
			i.CalculatedCumulativeIntrest, -- PreviousCumulativeInterest
			0 -- NewCumulativeInterest
		FROM 
			Invoice i
		WHERE 
			i.Active = 1
			AND i.InvoiceStatusTypeID != @ClosedStatusTypeID -- skip closed invoices
			AND NOT EXISTS (SELECT ID FROM InvoiceInterestCalculationLog l WHERE l.InvoiceID = i.ID AND L.DateAdded >= @Month)
			AND i.ID = @InvoiceID
	ORDER BY i.ID ASC
	
	--DELETE FROM @TempInterestLog
	--WHERE AmortizationDate IS NULL
	
	-- calculate the date that interest calculations begin for the invoices
	-- sum all of the payments applicable to the principal balance of the loan
	UPDATE @TempInterestLog
	SET DateInterestBegins = dbo.f_ServiceFeeBegins(AmortizationDate, ServiceFeeWaivedMonths),
		TotalAppliedPayments = ISNULL((SELECT SUM(p.Amount) FROM Payments p WHERE p.InvoiceID = Invoice_ID AND p.Active = 1 AND p.PaymentTypeID != @InterestPaymentTypeID AND p.DatePaid < @Month), 0)
	
	-- calculate the balance due
	UPDATE @TempInterestLog
	SET BalanceDue = TotalCost - TotalPPODiscount - TotalAppliedPayments
	
	WHILE (@NumMonths > 0)
	BEGIN
		-- calculate the interest accrued in the previous month
		UPDATE @TempInterestLog
		SET 
			CalculatedInterest = CalculatedInterest + (BalanceDue * YearlyInterest / 12)
		WHERE 
			DateInterestBegins <= @Month -- we passed the date where interest calculations begin for this invoice
			AND BalanceDue > 0 -- the invoice has a positive balance

		SET @NumMonths = @NumMonths - 1
	END
	
	-- calculate the new cumulative interest
	UPDATE @TempInterestLog
	SET NewCumulativeInterest = PreviousCumulativeInterest + CalculatedInterest

	RETURN
END

GO
PRINT N'Altering [dbo].[procClientPayoffQuotationReport]'
GO

ALTER PROCEDURE [dbo].[procClientPayoffQuotationReport]
	@PatientId int = -1,
	@PayoffDate datetime = null
AS

BEGIN

	SET NOCOUNT ON;

	select
		InvoiceNumber = 'DMA PPO LLC # ' + convert(varchar, i.InvoiceNumber),
		PatientName = trim(p.FirstName) + ' ' + trim(p.LastName),
		Principal = tis.BalanceDue,
		Interest = isnull(iip.NewCumulativeInterest, tis.CumulativeServiceFeeDue),
		BalanceDue = iif(iip.NewCumulativeInterest is null, tis.EndingBalance, iip.BalanceDue + iip.NewCumulativeInterest),
		PayoffThroughDate = eomonth(getdate()),
		Attorney = a.LastName + ', ' + a.FirstName
	from
		Invoice i
		inner join InvoiceAttorney ia
			on ia.ID = i.InvoiceAttorneyID
		inner join Attorney a
			on a.ID = ia.AttorneyID
		inner join InvoicePatient invPatient
			on invPatient.ID = i.InvoicePatientID
		inner join Patient p
			on p.ID = invPatient.PatientID
		outer apply dbo.f_GetTestInvoiceSummaryTableMinified(i.ID, null) tis
		outer apply dbo.f_GetInvoiceIntertestPayoffTable(i.ID, @PayoffDate) iip 
	where
		i.Active = 1
		and i.CompanyID = 2
		and i.InvoiceTypeID = 1
		and ia.Active = 1
		and invPatient.Active = 1
		and p.ID = @PatientId	

	union

	select
		InvoiceNumber = 'DMA PPO LLC # ' + convert(varchar, i.InvoiceNumber),
		PatientName = trim(p.FirstName) + ' ' + trim(p.LastName),
		Principal = sis.BalanceDue - isnull(i.LossesAmount, 0),
		Interest = isnull(iip.NewCumulativeInterest, sis.CumulativeServiceFeeDue),
		BalanceDue = iif(iip.NewCumulativeInterest is null, sis.EndingBalance, iip.BalanceDue + iip.NewCumulativeInterest),
		PayoffThroughDate = eomonth(getdate()),
		Attorney = a.LastName + ', ' + a.FirstName
	from
		Invoice i
		inner join InvoiceAttorney ia
			on ia.ID = i.InvoiceAttorneyID
		inner join Attorney a
			on a.ID = ia.AttorneyID
		inner join InvoicePatient invPatient
			on invPatient.ID = i.InvoicePatientID
		inner join Patient p
			on p.ID = invPatient.PatientID
		outer apply dbo.f_GetSurgeryInvoiceSummaryTableMinified(i.ID, null) sis
		outer apply dbo.f_GetInvoiceIntertestPayoffTable(i.ID, @PayoffDate) iip 
	where
		i.Active = 1
		and i.CompanyID = 2
		and i.InvoiceTypeID = 2
		and invPatient.Active = 1
		and p.ID = @PatientId

END
GO
