-- <Migration ID="310eb2c6-d36b-4ce9-8cc8-a3ee64ef5cab" />
GO

PRINT N'Altering [dbo].[f_GetInvoiceIntertestPayoffTable]'
GO
ALTER FUNCTION [dbo].[f_GetInvoiceIntertestPayoffTable] 
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
			DateInterestBegins <= @Month -- we passed the date where interest calculations begin for this invoice
			AND BalanceDue > 0 -- the invoice has a positive balance

		SET @NumMonths = @NumMonths - 1
	END
	
	-- calculate the new cumulative interest
	UPDATE @TempInterestLog
	SET NewCumulativeInterest = PreviousCumulativeInterest + CalculatedInterest - TotalInterestPayments

	RETURN
END
GO
PRINT N'Altering [dbo].[procSearchInvoice_GetByFirstServiceDate]'
GO
ALTER PROCEDURE [dbo].[procSearchInvoice_GetByFirstServiceDate]


 @SearchDate datetime

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

declare @SearchDateStr varchar(10) = Convert(varchar(10),@SearchDate,101)
declare @TopDateTable table(InvID int, InvoicePatientID int, TopTestDate datetime, TopSurgeryDate datetime)

insert into @TopDateTable
select Inv.ID, Inv.InvoicePatientID, 
	(select top 1 TestDate
		from TestInvoice as TI
		inner join TestInvoice_Test as TIT on TI.ID = TIT.TestInvoiceID
		inner join Invoice as I on TI.ID = I.TestInvoiceID
		Where I.ID = Inv.ID
		and I.Active = 1
		and TI.Active = 1
		and TIT.Active = 1
		and TIT.isCanceled = 0
		order by TestDate asc) as topTestDate,
	(select top 1 SISD.ScheduledDate
		from SurgeryInvoice as SI
		inner join SurgeryInvoice_Surgery as SIS on SI.ID = SIS.SurgeryInvoiceID
		inner join Invoice as I on SI.ID = I.SurgeryInvoiceID
		inner join SurgeryInvoice_SurgeryDates as SISD on SIS.ID = SISD.SurgeryInvoice_SurgeryID
		where I.ID = Inv.ID
		and I.Active = 1
		and SI.Active = 1
		and SIS.Active = 1
		and SIS.isCanceled = 0
		and SISD.Active = 1
		order by SISD.ScheduledDate asc) as topSurgeryDate
from Invoice as Inv


select distinct P.ID
from @TopDateTable
inner join InvoicePatient as IP on InvoicePatientID = IP.ID
inner join Patient as P on PatientID = P.ID
where Convert(varchar(10),TopSurgeryDate,101) = @SearchDateStr
or Convert(varchar(10),TopTestDate,101) = @SearchDateStr

END
GO
