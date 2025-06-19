SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Returns all surgery dates in string format
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    03/23/2012   Aaron     Created function
** 2	07/10/2012	 Aaron	   Added 'Order By' for Scheduled Date
*******************************/
CREATE FUNCTION [dbo].[f_GetSurgeryDates] 
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
	SELECT @Result = COALESCE(@Result + ', ', '') + CONVERT(varchar, SISD.ScheduledDate, 1)
	FROM Invoice I
		JOIN SurgeryInvoice SI ON SI.ID=I.SurgeryInvoiceID AND SI.Active=1
		LEFT JOIN SurgeryInvoice_Surgery SIS ON SIS.SurgeryInvoiceID=SI.ID AND SIS.Active=1
			LEFT JOIN Surgery S ON S.ID=SIS.SurgeryID AND S.Active=1
			LEFT JOIN SurgeryInvoice_SurgeryDates SISD ON SISD.SurgeryInvoice_SurgeryID = SIS.ID AND SISD.Active=1
	WHERE I.ID = @InvoiceID 
	Order BY SISD.ScheduledDate ASC
	
	-- Return the result of the function
	RETURN @Result

END
GO
