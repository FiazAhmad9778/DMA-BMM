SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Bursavich, Andy
-- Create date: 2012.04.12
-- Description:	Gets the Total Cost of an Invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetInvoiceCostTotal]
(
	@InvoiceID INT,
	@InvoiceTypeID INT = NULL
)
RETURNS DECIMAL(18,2)
AS
BEGIN

	DECLARE @TotalCost DECIMAL(18,2)

	IF @InvoiceTypeID IS NULL
	SELECT @InvoiceTypeID = Invoice.InvoiceTypeID FROM Invoice WHERE Invoice.ID=@InvoiceID
	
	DECLARE @TestingInvoiceTypeID INT = 1

	SET @TotalCost = CASE WHEN @InvoiceTypeID=@TestingInvoiceTypeID THEN dbo.f_GetTestCostTotal(@InvoiceID) ELSE dbo.f_GetSurgeryCostTotal(@InvoiceID) END

	RETURN @TotalCost

END
GO
