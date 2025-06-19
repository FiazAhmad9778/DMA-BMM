-- <Migration ID="cad3b67a-1c3d-43e9-bb64-dc870d306c14" />
GO

PRINT N'Dropping foreign keys from [dbo].[SurgeryInvoice_Provider_CPTCodes]'
GO
ALTER TABLE [dbo].[SurgeryInvoice_Provider_CPTCodes] DROP CONSTRAINT [FK_Provider_CPTCodes_CPTCodes]
GO
PRINT N'Altering [dbo].[f_GetFirstTestDate]'
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Gets all test dates as string for an invoice
-- =============================================
ALTER FUNCTION [dbo].[f_GetFirstTestDate] 
(
	-- Add the parameters for the function here
	@InvoiceID int	
)
RETURNS datetime
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result datetime

	-- Add the T-SQL statements to compute the return value here
	SELECT TOP 1 @Result = CONVERT(varchar, TIT.TestDate, 1)
	FROM Invoice I
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
		LEFT JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1		
	WHERE I.ID = @InvoiceID
	ORDER BY TIT.TestDate Asc

	-- Return the result of the function
	RETURN @Result

END

GO
PRINT N'Creating [dbo].[_InvoiceIDs]'
GO
CREATE TABLE [dbo].[_InvoiceIDs]
(
[RecID] [int] NOT NULL IDENTITY(1, 1),
[ID] [int] NULL,
[EndDate] [date] NULL
)
GO
PRINT N'Creating primary key [PK__InvoiceIDs] on [dbo].[_InvoiceIDs]'
GO
ALTER TABLE [dbo].[_InvoiceIDs] ADD CONSTRAINT [PK__InvoiceIDs] PRIMARY KEY CLUSTERED  ([RecID])
GO
PRINT N'Creating [dbo].[procUpdateLoanInterest_tek_upd]'
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
--procUpdateLoanInterest_tek_upd '2012-04-01'
CREATE PROCEDURE [dbo].[procUpdateLoanInterest_tek_upd]
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
	--DECLARE @EndDate datetime

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

	--Select @EndDate = case when i.InvoiceClosedDate is not null then i.InvoiceClosedDate else getdate() end From Invoice i

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
			
		FROM Invoice I inner join _InvoiceIDs ti on i.id = ti.ID
		WHERE 
			--I.Active=1
			--AND I.InvoiceStatusTypeID!=@ClosedStatusTypeID -- skip closed invoices
			NOT EXISTS (SELECT ID FROM InvoiceInterestCalculationLog L WHERE L.InvoiceID=I.ID AND L.DateAdded>=@Month)
		and	I.CompanyID = 2
		and (I.InvoiceClosedDate <= ti.EndDate or I.InvoiceClosedDate is null)
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
	--UPDATE Invoice
	--SET CalculatedCumulativeIntrest=(SELECT T.NewCumulativeInterest FROM @TempInterestLog T WHERE ID=Invoice_ID)
	--WHERE EXISTS (SELECT T.NewCumulativeInterest FROM @TempInterestLog T WHERE ID=Invoice_ID)

	update i
	set
		CalculatedCumulativeIntrest = t.NewCumulativeInterest
	from
		@TempInterestLog t
		inner join Invoice i
			on t.Invoice_ID = i.ID

	-- log the calculations and updates
	INSERT INTO InvoiceInterestCalculationLog ( InvoiceID, YearlyInterest, ServiceFeeWaivedMOnths, AmortizationDate, DateInterestBegins, TotalCost, TotalPPODiscount, TotalAppliedPayments, BalanceDue, CalculatedInterest, PreviousCumulativeInterest, NewCumulativeInterest, DateAdded )
	SELECT T.Invoice_ID, T.YearlyInterest, T.ServiceFeeWaivedMonths, T.AmortizationDate, T.DateInterestBegins, T.TotalCost, T.TotalPPODiscount, T.TotalAppliedPayments, T.BalanceDue, T.CalculatedInterest, T.PreviousCumulativeInterest, T.NewCumulativeInterest, @RunTime
	FROM @TempInterestLog T

END
GO
PRINT N'Creating [dbo].[Sheet1$]'
GO
CREATE TABLE [dbo].[Sheet1$]
(
[ID] [float] NULL,
[Active] [float] NULL,
[FirstName] [nvarchar] (255) NULL,
[LastName] [nvarchar] (255) NULL,
[New Date] [datetime] NULL,
[New Loan Term] [float] NULL,
[New Service Term] [float] NULL
)
GO
