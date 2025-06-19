SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Gets all test dates as string for an invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetTestDates] 
(
	-- Add the parameters for the function here
	@InvoiceID int
)
RETURNS varchar(1000)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(1000)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = COALESCE(@Result + ', ', '') + CONVERT(varchar, TIT.TestDate, 1)
	FROM Invoice I
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
		LEFT JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1
	WHERE I.ID = @InvoiceID
	Order By TIT.TestDate ASC

	-- Return the result of the function
	RETURN @Result

END
GO
