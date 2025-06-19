SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Bursavich, Andy
-- Create date: 2012.04.12
-- Description:	Gets the total of Non-Interest Paymenrs for an Invoice
-- =============================================
CREATE FUNCTION [dbo].[f_GetInvoiceNonInterestPaymentsTotal]
(
	@InvoiceID int
)
RETURNS DECIMAL(18,2)
AS
BEGIN

	DECLARE @Payments DECIMAL(18,2)
	
	DECLARE @InterestPaymentTypeID INT = 2

	SELECT @Payments = ISNULL(SUM(P.Amount), 0)
		FROM Payments P
		WHERE P.InvoiceID=@InvoiceID
			AND P.PaymentTypeID!=@InterestPaymentTypeID
			AND P.Active=1

	RETURN @Payments

END
GO
