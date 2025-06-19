SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brad Conley
-- Create date: 2/17/2014
-- Description:	-- case 1006403 Added the TestInvoice_Test ID parameter to allow for multiple tests on the same invoice with different test dates
-- =============================================
CREATE FUNCTION [dbo].[f_GetFirstTestDateAccountsPayableReport] 
(
	-- Add the parameters for the function here
	@InvoiceID int,
	@TestInvoiceID int
)
RETURNS datetime
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result datetime

	-- Add the T-SQL statements to compute the return value here
	SELECT TOP 1 @Result = TIT.TestDate
	FROM Invoice I
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
		LEFT JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1 AND TIT.ID = @TestInvoiceID			
	WHERE I.ID = @InvoiceID
	ORDER BY TIT.TestDate Asc

	-- Return the result of the function
	RETURN @Result

END
GO
