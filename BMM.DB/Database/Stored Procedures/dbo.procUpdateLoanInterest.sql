SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================================================================
-- Author:		Andy Bursavich
-- Create date: 4.2.2012
-- Description:	Calculates monthly interest for invoices, logs basic information about their
-- states, and updates cumulative interest values
--
-- Updated: 9.27.2012 by Andy Bursavich
--          Added DateServiceFeeBeginsOverride
-- =============================================================================================
CREATE PROCEDURE [dbo].[procUpdateLoanInterest]
	@RunTime DATETIME = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @RunTime IS NULL
	SET @RunTime = GETDATE()

	DECLARE @Month DATE = CONVERT(DATE, CONVERT(CHAR(2), DATEPART(MONTH, @RunTime)) + '/1/' + CONVERT(CHAR(4), DATEPART(YEAR, @RunTime)))
	DECLARE @ClosedStatusTypeID INT = 2
	DECLARE @TestingInvoiceTypeID INT = 1
	DECLARE @InterestPaymentTypeID INT = 2

	-- create temporary table to store intermediate values and calculations
	DECLARE @TempInterestLog TABLE
	(
		Invoice_ID INT,
		YearlyInterest DECIMAL(18, 2),
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

	-- insert records into the temp table for non-closed invoices that do not have interest calculation logs for the current month (or, technically, future months)
	INSERT INTO @TempInterestLog
		SELECT I.ID,
			I.YearlyInterest,
			I.ServiceFeeWaivedMonths,
			CASE WHEN I.InvoiceTypeID=@TestingInvoiceTypeID THEN dbo.f_GetFirstTestDate(I.ID) ELSE dbo.f_GetFirstSurgeryDate(I.ID) END, -- AmortizationDate
			NULL, -- DateInterestBegins
			ISNULL(CASE WHEN I.InvoiceTypeID=@TestingInvoiceTypeID THEN dbo.f_GetTestCostTotal(I.ID) ELSE dbo.f_GetSurgeryCostTotal(I.ID) END, 0), -- TotalCost
			ISNULL(CASE WHEN I.InvoiceTypeID=@TestingInvoiceTypeID THEN dbo.f_GetTestPPODiscountTotal(I.ID) ELSE dbo.f_GetSurgeryPPODiscountTotal(I.ID) END, 0), -- TotalPPODiscount
			0, -- TotalAppliedPayments
			0, -- BalanceDue
			0, -- CalculatedInterest
			I.CalculatedCumulativeIntrest, -- PreviousCumulativeInterest
			0 -- NewCumulativeInterest
		FROM Invoice I
		WHERE I.Active=1
			AND I.InvoiceStatusTypeID!=@ClosedStatusTypeID -- skip closed invoices
			AND NOT EXISTS (SELECT ID FROM InvoiceInterestCalculationLog L WHERE L.InvoiceID=I.ID AND L.DateAdded>=@Month)
	ORDER BY I.ID ASC
	
	--DELETE FROM @TempInterestLog
	--WHERE AmortizationDate IS NULL
	
	-- calculate the date that interest calculations begin for the invoices
	-- sum all of the payments applicable to the principal balance of the loan
	UPDATE @TempInterestLog
	SET DateInterestBegins = dbo.f_ServiceFeeBegins(AmortizationDate, ServiceFeeWaivedMonths),
		TotalAppliedPayments = ISNULL((SELECT SUM(P.Amount) FROM Payments P WHERE P.InvoiceID=Invoice_ID AND P.Active=1 AND P.PaymentTypeID!=@InterestPaymentTypeID AND P.DatePaid<@Month), 0)
	
	-- calculate the balance due
	UPDATE @TempInterestLog
	SET BalanceDue = TotalCost-TotalPPODiscount-TotalAppliedPayments
	
	-- calculate the interest accrued in the previous month
	UPDATE @TempInterestLog
	SET CalculatedInterest=BalanceDue*YearlyInterest/12
	WHERE DateInterestBegins<=@Month -- we passed the date where interest calculations begin for this invoice
		AND BalanceDue>0 -- the invoice has a positive balance
	
	-- calculate the new cumulative interest
	UPDATE @TempInterestLog
	SET NewCumulativeInterest=PreviousCumulativeInterest+CalculatedInterest
	
	-- update the Invoice table with the new cumulative interest values
	UPDATE Invoice
	SET CalculatedCumulativeIntrest=(SELECT T.NewCumulativeInterest FROM @TempInterestLog T WHERE ID=Invoice_ID)
	WHERE EXISTS (SELECT T.NewCumulativeInterest FROM @TempInterestLog T WHERE ID=Invoice_ID)

	-- log the calculations and updates
	INSERT INTO InvoiceInterestCalculationLog ( InvoiceID, YearlyInterest, ServiceFeeWaivedMOnths, AmortizationDate, DateInterestBegins, TotalCost, TotalPPODiscount, TotalAppliedPayments, BalanceDue, CalculatedInterest, PreviousCumulativeInterest, NewCumulativeInterest, DateAdded )
	SELECT T.Invoice_ID, T.YearlyInterest, T.ServiceFeeWaivedMonths, T.AmortizationDate, T.DateInterestBegins, T.TotalCost, T.TotalPPODiscount, T.TotalAppliedPayments, T.BalanceDue, T.CalculatedInterest, T.PreviousCumulativeInterest, T.NewCumulativeInterest, @RunTime
	FROM @TempInterestLog T

END
GO
