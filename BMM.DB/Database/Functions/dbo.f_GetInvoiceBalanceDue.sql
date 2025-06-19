SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Bursavich, Andy
-- Create date: 2012.04.12
-- Description:	Gets the Balance Due for an Invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetInvoiceBalanceDue]
(
	@InvoiceID INT,
	@InvoiceTypeID INT = NULL,
	@InvoiceCostTotal DECIMAL(18,2) = NULL,
	@InvoicePPODiscountTotal DECIMAL(18,2) = NULL,
	@InvoiceNonInterestPaymentsTotal DECIMAL(18,2) = NULL
)
RETURNS DECIMAL(18,2)
AS
BEGIN
	
	DECLARE @BalanceDue DECIMAL(18,2)
	
	IF @InvoiceTypeID IS NULL
	SELECT @InvoiceTypeID = Invoice.InvoiceTypeID FROM Invoice WHERE Invoice.ID=@InvoiceID
	
	IF @InvoiceCostTotal IS NULL
	SET @InvoiceCostTotal = dbo.f_GetInvoiceCostTotal(@InvoiceID, @InvoiceTypeID)
	
	IF @InvoicePPODiscountTotal IS NULL
	SET @InvoicePPODiscountTotal = dbo.f_GetInvoicePPODiscountTotal(@InvoiceID, @InvoiceTypeID)
	
	IF @InvoiceNonInterestPaymentsTotal IS NULL
	SET @InvoiceNonInterestPaymentsTotal = dbo.f_GetInvoiceNonInterestPaymentsTotal(@InvoiceID)
	
	SET @BalanceDue = @InvoiceCostTotal - @InvoicePPODiscountTotal - @InvoiceNonInterestPaymentsTotal

	RETURN @BalanceDue

END
GO
