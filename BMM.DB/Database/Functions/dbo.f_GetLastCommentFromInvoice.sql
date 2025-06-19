SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Return Last Comment on an Invoice with the date as string
-- Modified:  Czarina Walker:  1/15/2013:  Customer is trying to use the payment comments for this report and isIncludedOnReports is not a property of the PaymentComments
-- =============================================
CREATE FUNCTION [dbo].[f_GetLastCommentFromInvoice] 
(
	-- Add the parameters for the function here
	@InvoiceID int
)
RETURNS varchar(2000)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(2000)
	DECLARE @LastCommentID int
	
	SELECT @LastCommentID = MAX(c.ID)
	FROM Comments c 
	WHERE c.InvoiceID = @InvoiceID AND c.Active = 1 --AND c.isIncludedOnReports = 1

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = CONVERT(varchar(30), c.DateAdded, 1) + '  ' + CONVERT(varchar(2000),c.[Text], 1)
	FROM Comments c 
	WHERE c.ID = @LastCommentID

	-- Return the result of the function
	RETURN @Result

END
GO
