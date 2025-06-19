SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 2/14/2013
-- Description:	Returns Test Invoice ID For Cash Report
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    02/14/2013   Aaron     Created function from stored proc
*******************************/
CREATE FUNCTION [dbo].[f_GetTestInvoicesForCashReport] 
(
	@CompanyId int,
	@StartDate datetime,
	@EndDate datetime
)
RETURNS 
@InvoiceCashReport TABLE (InvoiceID int)
AS
BEGIN

DECLARE @ClosedStatusTypeID INT = 2
DECLARE @PrinciplePaymentTypeID INT = 1
DECLARE @DepositPaymentTypeID INT = 3
DECLARE @InterestPaymentTypeID INT = 2
DECLARE @RefundPaymentTypeID INT = 4

-- Insert Account and Provider
INSERT INTO @InvoiceCashReport (InvoiceID)
	Select InvoiceID from (	
	(Select Distinct InvoiceID as InvoiceID 
	from Payments P
	Inner join Company c on c.ID = @CompanyId AND c.Active = 1
	Where (P.DatePaid IS NULL OR P.DatePaid BETWEEN @StartDate AND @EndDate)
			AND (P.PaymentTypeID IS NULL OR P.PaymentTypeID in (@PrinciplePaymentTypeID,@DepositPaymentTypeID,@InterestPaymentTypeID))
	)
	Union
	(
	Select Distinct I.ID AS InvoiceID
	FROM Invoice I 
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
		JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1
	WHERE TIT.[Date] BETWEEN @StartDate AND @EndDate)) as tmp

	RETURN 
END
GO
