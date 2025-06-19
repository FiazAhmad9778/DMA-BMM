SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 6/21/2012
-- Description:	Gets the sum of the payments to provider for an invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetSurgeryPaymentsToProvider] 
(
	-- Add the parameters for the function here
	@InvoiceID int
)
RETURNS decimal(18,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result decimal(18,2)

	SELECT @Result = ISNULL(SUM(SIPP.Amount), 0)
		FROM Invoice I 
			JOIN SurgeryInvoice SI ON SI.ID=I.SurgeryInvoiceID AND SI.Active=1
				JOIN SurgeryInvoice_Providers SIP ON SIP.SurgeryInvoiceID=SI.ID AND SIP.Active=1
					JOIN SurgeryInvoice_Provider_Payments SIPP ON SIPP.SurgeryInvoice_ProviderID=SIP.ID
		WHERE I.ID = @InvoiceID
	
	-- Return the result of the function
	RETURN @Result

END
GO
