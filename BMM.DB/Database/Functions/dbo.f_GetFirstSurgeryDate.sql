SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Returns first instance of a surgery date
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    03/23/2012   Aaron     Created function
** 2    03/30/2012   Andy      Restricted to primary dates only
*******************************/
CREATE FUNCTION [dbo].[f_GetFirstSurgeryDate] 
(
	-- Add the parameters for the function here
	@InvoiceID int
)
RETURNS datetime
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result datetime

	-- Add the T-SQL statements to compute the return value here
	SELECT TOP 1 @Result = SISD.ScheduledDate
	FROM Invoice I
		JOIN SurgeryInvoice SI ON SI.ID=I.SurgeryInvoiceID AND SI.Active=1
		LEFT JOIN SurgeryInvoice_Surgery SIS ON SIS.SurgeryInvoiceID=SI.ID AND SIS.Active=1
			LEFT JOIN Surgery S ON S.ID=SIS.SurgeryID AND S.Active=1
			LEFT JOIN SurgeryInvoice_SurgeryDates SISD ON SISD.SurgeryInvoice_SurgeryID = SIS.ID AND SISD.Active=1
	WHERE I.ID = @InvoiceID AND SISD.isPrimaryDate = 1
	ORDER BY SISD.ScheduledDate Asc 
	
	-- Return the result of the function
	RETURN @Result

END
GO
