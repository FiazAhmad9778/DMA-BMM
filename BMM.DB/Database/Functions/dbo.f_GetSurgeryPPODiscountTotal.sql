SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Gets the sum of the ppo cost of surgeries for an invoice
-- UPDATED 2012.04.12 by BURSAVICH, ANDY
-- =============================================
CREATE FUNCTION [dbo].[f_GetSurgeryPPODiscountTotal] 
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
	--SELECT @Result = COALESCE(@Result,0) + Sum(SIPS.PPODiscount)
	--FROM Invoice I 
	--	JOIN SurgeryInvoice SI ON SI.ID=I.SurgeryInvoiceID AND SI.Active=1
	--		LEFT JOIN SurgeryInvoice_Providers SIP ON SIP.SurgeryInvoiceID=SI.ID AND SIP.Active=1
	--		LEFT JOIN SurgeryInvoice_Provider_Services SIPS ON SIPS.SurgeryInvoice_ProviderID=SIP.ID
	--WHERE I.ID = @InvoiceID
	SELECT @Result = ISNULL(SUM(SIPS.PPODiscount), 0)
		FROM Invoice I 
			JOIN SurgeryInvoice SI ON SI.ID=I.SurgeryInvoiceID AND SI.Active=1
				JOIN SurgeryInvoice_Providers SIP ON SIP.SurgeryInvoiceID=SI.ID AND SIP.Active=1
					JOIN SurgeryInvoice_Provider_Services SIPS ON SIPS.SurgeryInvoice_ProviderID=SIP.ID
		WHERE I.ID = @InvoiceID
	
	-- Return the result of the function
	RETURN @Result

END
GO
