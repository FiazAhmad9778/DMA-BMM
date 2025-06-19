SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Gets all surgery procedure names associated with an invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetSurgeryProcedures] 
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
	SELECT @Result = COALESCE(@Result + ', ', '') + CONVERT(varchar, S.Name, 1)
	FROM Invoice I 
		JOIN SurgeryInvoice SI ON SI.ID=I.SurgeryInvoiceID AND SI.Active=1
		LEFT JOIN SurgeryInvoice_Surgery SIS ON SIS.SurgeryInvoiceID=SI.ID AND SIS.Active=1
		LEFT JOIN Surgery S ON S.ID=SIS.SurgeryID AND S.Active=1
	WHERE I.ID = @InvoiceID

	-- Return the result of the function
	RETURN @Result

END
GO
