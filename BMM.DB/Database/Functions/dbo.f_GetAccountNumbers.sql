SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 7/13/2012
-- Description:	Returns all account numbers for specified criteria
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    07/13/2012   Aaron     Created function
*******************************/
CREATE FUNCTION [dbo].[f_GetAccountNumbers] 
(
	-- Add the parameters for the function here
	@InvoiceID int,
	@InvoiceProviderID int,
	@StartDate datetime,
	@EndDate datetime
)
RETURNS varchar(1000)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(1000)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = COALESCE(@Result + ', ', '') + CONVERT(varchar, SIPS.AccountNumber, 1)
	FROM Invoice AS I
	INNER JOIN SurgeryInvoice AS SI ON I.SurgeryInvoiceID = SI.ID AND SI.Active = 1
	LEFT JOIN SurgeryInvoice_Providers AS SIP ON SI.ID = SIP.SurgeryInvoiceID AND SIP.Active = 1
	JOIN SurgeryInvoice_Provider_Services SIPS ON SIPS.SurgeryInvoice_ProviderID=SIP.ID AND SIPS.Active=1
	WHERE I.ID = @InvoiceID AND SIP.InvoiceProviderID = @InvoiceProviderID AND SIPS.DueDate BETWEEN @StartDate AND @EndDate
	
	-- Return the result of the function
	RETURN @Result

END
GO
