SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/23/2012
-- Description:	Gets a total of payments for a specific invoice
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    03/23/2012   Aaron     Created function
*******************************/
CREATE FUNCTION [dbo].[f_GetInvoicePaymentTotal] 
(
	-- Add the parameters for the function here
	@InvoiceID int
)
RETURNS decimal(18,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result decimal(18,2)
	DECLARE @PrinciplePaymentTypeID INT = 1
	DECLARE @DepositPaymentTypeID INT = 3
	DECLARE @CreditPaymentTypeID INT = 5
	DECLARE @RefundPaymentTypeID INT = 4

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = SUM(P.Amount)
	FROM Payments P
	WHERE P.InvoiceID = @InvoiceID AND (P.PaymentTypeID=@PrinciplePaymentTypeID OR P.PaymentTypeID=@DepositPaymentTypeID OR P.PaymentTypeID=@CreditPaymentTypeID OR P.PaymentTypeID=@RefundPaymentTypeID) AND P.Active=1

	-- Return the result of the function
	RETURN @Result

END
GO
