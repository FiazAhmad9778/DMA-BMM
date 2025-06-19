SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Bursavich, Andy
-- Create date: 2012.04.12
-- Description:	Gets the Ending Balance of an Invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetInvoiceEndingBalance]
(
	@InvoiceID INT,
	-- FROM INVOICE
	@InvoiceTypeID INT = NULL,
	@InvoiceCalculatedCumulativeIntrest DECIMAL(18,2) = NULL,
	@InvoiceServiceFeeWaived DECIMAL(18,2) = NULL,
	@InvoiceLossesAmount DECIMAL(18,2) = NULL,
	-- FOR BALANCE DUE
	@InvoiceCostTotal DECIMAL(18,2) = NULL,
	@InvoicePPODiscountTotal DECIMAL(18,2) = NULL,
	@InvoiceNonInterestPaymentsTotal DECIMAL(18,2) = NULL,
	@InvoiceBalanceDue DECIMAL(18,2) = NULL,
	-- FOR CUMULATIVE SERVICE FEE DUE
	@InvoiceInterestPaymentsTotal DECIMAL(18, 2) = NULL,
	@InvoiceCumServiceFeeDue DECIMAL(18,2) = NULL
)
RETURNS DECIMAL(18,2)
AS
BEGIN

	DECLARE @EndingBalance DECIMAL(18,2)
	
	IF @InvoiceTypeID IS NULL
	SELECT @InvoiceTypeID = Invoice.InvoiceTypeID FROM Invoice WHERE Invoice.ID=@InvoiceID
	
	IF @InvoiceLossesAmount IS NULL
	SELECT @InvoiceLossesAmount = ISNULL(Invoice.LossesAmount, 0) FROM Invoice WHERE Invoice.ID=@InvoiceID
	
	IF @InvoiceBalanceDue IS NULL
	SELECT @InvoiceBalanceDue = dbo.f_GetInvoiceBalanceDue(@InvoiceID, @InvoiceTypeID, @InvoiceCostTotal, @InvoicePPODiscountTotal, @InvoiceNonInterestPaymentsTotal)
	
	IF @InvoiceCumServiceFeeDue IS NULL
	SELECT @InvoiceCumServiceFeeDue = dbo.f_GetInvoiceCumulativeServiceFeeDue(@InvoiceID, @InvoiceCalculatedCumulativeIntrest, @InvoiceServiceFeeWaived, @InvoiceInterestPaymentsTotal)

	SELECT @EndingBalance = @InvoiceBalanceDue + @InvoiceCumServiceFeeDue - @InvoiceLossesAmount

	RETURN @EndingBalance

END
GO
