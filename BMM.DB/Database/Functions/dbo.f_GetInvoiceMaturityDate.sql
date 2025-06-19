SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************
-- =============================================
-- Author:		Bursavich, Andy
-- Create date: 2012.04.12
-- Description:	Returns the Maturity Date of an Invoice
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    2012.04.12   Andy      Created function
** 1    2013.02.19   John      Fixed calculation so that DateServiceFeeBegins is used 
** 1	2013.03.12   Brad	   Fixed Amortization Date to calculate for Test or Surgery. Case 948277		
*******************************/
CREATE FUNCTION [dbo].[f_GetInvoiceMaturityDate]
(
	-- Add the parameters for the function here
	@InvoiceID INT,
	@InvoiceTypeID INT = NULL,
	@LoanTermMonths INT = NULL
)
RETURNS DATE
AS
BEGIN

	DECLARE @MaturityDate DATE
	DECLARE @ServiceFeeWaivedMonths int = (SELECT ServiceFeeWaivedMonths FROM Invoice WHERE ID = @InvoiceID)
	--DECLARE @AmortizationDate DATE = dbo.f_GetFirstTestDate(@InvoiceID)
	DECLARE @InvoiceTestID int = (SELECT TestInvoiceID from Invoice where ID = @InvoiceID)
	DECLARE @AmortizationDate DATE
	
	IF @InvoiceTestID IS NULL
	SET @AmortizationDate = dbo.f_GetFirstSurgeryDate(@InvoiceID)
	ELSE
	SET @AmortizationDate = dbo.f_GetFirstTestDate(@InvoiceID)
	
	DECLARE @DateServiceFeeBegins DATE = dbo.f_ServiceFeeBegins(@AmortizationDate, @ServiceFeeWaivedMonths)
			

	IF @InvoiceTypeID IS NULL
	SELECT @InvoiceTypeID = Invoice.InvoiceTypeID FROM Invoice WHERE Invoice.ID=@InvoiceID
	
	IF @LoanTermMonths IS NULL
	SELECT @LoanTermMonths = Invoice.LoanTermMonths FROM Invoice WHERE Invoice.ID=@InvoiceID
	
	DECLARE @TestingInvoiceTypeID INT = 1
	--DECLARE @SurgeryInvoiceTypeID INT = 2

	SET @MaturityDate = DATEADD(MONTH, @LoanTermMonths, @DateServiceFeeBegins)
	
	RETURN @MaturityDate

END
GO
