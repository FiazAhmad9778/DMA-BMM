-- <Migration ID="0950cad8-1c5d-40df-a254-2f469abd2371" />
GO

PRINT N'Dropping [dbo].[f_GetInvoiceIntertestPayoffTable]'
GO
DROP FUNCTION [dbo].[f_GetInvoiceIntertestPayoffTable]
GO
PRINT N'Creating [dbo].[f_GetInvoiceInterestPayoffTable]'
GO
CREATE FUNCTION [dbo].[f_GetInvoiceInterestPayoffTable] 
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
		TotalInterestPayments DECIMAL(18, 2),
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
			0, -- TotalInterestPayments
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
		TotalAppliedPayments = ISNULL((SELECT SUM(p.Amount) FROM Payments p WHERE p.InvoiceID = Invoice_ID AND p.Active = 1 AND p.PaymentTypeID != @InterestPaymentTypeID AND p.DatePaid < @Month), 0),
		TotalInterestPayments = ISNULL((SELECT SUM(p.Amount) FROM Payments p WHERE p.InvoiceID = Invoice_ID AND p.Active = 1 AND p.PaymentTypeID = @InterestPaymentTypeID AND p.DatePaid < @Month), 0)
	
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
			DateInterestBegins <= dateadd(month, (@NumMonths * -1) + 1, @Month) -- we passed the date where interest calculations begin for this invoice
			AND BalanceDue > 0 -- the invoice has a positive balance

		SET @NumMonths = @NumMonths - 1
	END
	
	-- calculate the new cumulative interest
	UPDATE @TempInterestLog
	SET NewCumulativeInterest = PreviousCumulativeInterest + CalculatedInterest - TotalInterestPayments

	RETURN
END
GO
PRINT N'Altering [dbo].[procClientPayoffQuotationReport]'
GO

ALTER PROCEDURE [dbo].[procClientPayoffQuotationReport]
	@PatientId int = -1,
	@PayoffDate datetime = null,
	@DateOfAccident datetime = null
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
		outer apply dbo.f_GetInvoiceInterestPayoffTable(i.ID, @PayoffDate) iip 
	where
		i.Active = 1
		and i.CompanyID = 2
		and i.InvoiceTypeID = 1
		and (i.DateOfAccident = @DateOfAccident or @DateOfAccident is null)
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
		outer apply dbo.f_GetInvoiceInterestPayoffTable(i.ID, @PayoffDate) iip 
	where
		i.Active = 1
		and i.CompanyID = 2
		and i.InvoiceTypeID = 2
		and (i.DateOfAccident = @DateOfAccident or @DateOfAccident is null)
		and invPatient.Active = 1
		and p.ID = @PatientId

END
GO
