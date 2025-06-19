SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 6/21/2012
-- Description:	Gets the sum of the payments to the provider for a specific invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetTestPaymentsToProviderByDate] 
(
	-- Add the parameters for the function here
	@InvoiceID int,
	@StartDate datetime = null, 
	@EndDate datetime = null
)
RETURNS decimal(18,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result decimal(18,2)

	SELECT @Result = (ISNULL(SUM(TIT.DepositToProvider), 0) + ISNULL(SUM(TIT.AmountPaidToProvider), 0))
	FROM Invoice I 
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
		JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1
	WHERE I.ID = @InvoiceID AND TIT.[Date] BETWEEN @StartDate AND @EndDate
	
	-- Return the result of the function
	RETURN @Result

END
GO
