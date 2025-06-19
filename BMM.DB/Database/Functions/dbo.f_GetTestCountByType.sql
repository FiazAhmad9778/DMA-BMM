SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 6/18/2012
-- Description:	Gets test count for specific test type
-- =============================================
CREATE FUNCTION [dbo].[f_GetTestCountByType]
(
	@InvoiceID int,
	@TestTypeID int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result int

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = Count(T.ID)
	FROM Invoice I 
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
			LEFT JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1
			LEFT JOIN Test T ON T.ID=TIT.TestID AND T.Active=1
	WHERE I.ID = @InvoiceID AND TI.TestTypeID = @TestTypeID

	-- Return the result of the function
	RETURN @Result

END
GO
