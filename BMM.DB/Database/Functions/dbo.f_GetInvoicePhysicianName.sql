SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[f_GetInvoicePhysicianName]
(
	-- Add the parameters for the function here
	@InvoiceID int
)
RETURNS varchar(250)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(250)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = ip.LastName + ', ' + ip.FirstName
	FROM Invoice i
	inner join InvoicePhysician ip on i.InvoicePhysicianID = ip.ID
	WHERE i.ID = @InvoiceID

	-- Return the result of the function
	RETURN @Result

END

GO
