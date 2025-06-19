SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Gets all test procedure names associated with an invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetTestProcedure] 
(
	@InvoiceID int,
	@Date datetime
)
RETURNS varchar(1000)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(1000)

	-- Add the T-SQL statements to compute the return value here
	SELECT distinct @Result = COALESCE(@Result + ', ', '') + CONVERT(varchar, T.Name, 1)
	FROM Invoice I 
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
			LEFT JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1
			LEFT JOIN Test T ON T.ID=TIT.TestID AND T.Active=1
	WHERE I.ID = @InvoiceID and Convert(date, tit.TestDate) = Convert(date, @Date)

	-- Return the result of the function
	RETURN @Result

END
GO
