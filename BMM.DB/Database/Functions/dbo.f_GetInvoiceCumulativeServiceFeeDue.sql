SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Bursavich, Andy
-- Create date: 2012.04.12
-- Description:	Gets the Cumulative Service Fee Due for an Invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetInvoiceCumulativeServiceFeeDue]
(
	@InvoiceID INT,
	@InvoiceCalculatedCumulativeIntrest DECIMAL(18,2) = NULL,
	@InvoiceServiceFeeWaived DECIMAL(18,2) = NULL,
	@InvoiceInterestPaymentsTotal DECIMAL(18,2) = NULL
)
RETURNS DECIMAL(18,2)
AS
BEGIN

	DECLARE @CumulativeServiceFeeDue DECIMAL(18,2)

	IF @InvoiceCalculatedCumulativeIntrest IS NULL
	SELECT @InvoiceCalculatedCumulativeIntrest = Invoice.CalculatedCumulativeIntrest FROM Invoice WHERE Invoice.ID=@InvoiceID
	
	IF @InvoiceServiceFeeWaived IS NULL
	SELECT @InvoiceServiceFeeWaived = Invoice.ServiceFeeWaived FROM Invoice WHERE Invoice.ID=@InvoiceID
	
	IF @InvoiceInterestPaymentsTotal IS NULL
	SET @InvoiceInterestPaymentsTotal = dbo.f_GetInvoiceInterestPaymentsTotal(@InvoiceID)

	SET @CumulativeServiceFeeDue = @InvoiceCalculatedCumulativeIntrest - @InvoiceServiceFeeWaived - @InvoiceInterestPaymentsTotal

	RETURN @CumulativeServiceFeeDue

END
GO
