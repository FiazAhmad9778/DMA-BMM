SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Gets multiple providers for a surgery invoice as string
-- =============================================
CREATE FUNCTION [dbo].[f_GetSurgeryProvidersByInvoice] 
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
	SELECT @Result = COALESCE(@Result + ', ', '') + CONVERT(varchar, IP.Name, 1)
	FROM Invoice I
		JOIN SurgeryInvoice SI ON SI.ID=I.SurgeryInvoiceID AND SI.Active=1
		LEFT JOIN SurgeryInvoice_Providers SIP ON SIP.SurgeryInvoiceID=SI.ID AND SIP.Active=1
		LEFT JOIN InvoiceProvider IP ON IP.ID=SIP.InvoiceProviderID AND IP.Active=1
	WHERE I.ID = @InvoiceID 

	-- Return the result of the function
	RETURN @Result

END
GO
