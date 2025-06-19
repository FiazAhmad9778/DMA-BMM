SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Gets the sum of the cost of tests for an invoice
-- UPDATED 2012.04.12 by BURSAVICH, ANDY
-- =============================================
CREATE FUNCTION [dbo].[f_GetTestCostTotal] 
(
	-- Add the parameters for the function here
	@InvoiceID int
)
RETURNS decimal(18,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result decimal(18,2)

	-- Add the T-SQL statements to compute the return value here
	--SELECT @Result = COALESCE(@Result,0) + Sum(TIT.TestCost)
	--FROM Invoice I 
	--	JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
	--	LEFT JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1
	--WHERE I.ID = @InvoiceID
	SELECT @Result = ISNULL(SUM(TIT.TestCost), 0)
	FROM Invoice I 
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
		JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1 AND TIT.isCanceled = 0
	WHERE I.ID = @InvoiceID
	
	-- Return the result of the function
	RETURN @Result

END
GO
