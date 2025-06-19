SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[f_GetSurgeryInvoiceStrings] 
(
	@InvoiceID int
)
RETURNS 
@InvoiceSummary TABLE (ServiceDates varchar(1000), Providers varchar(1000), ServiceNames varchar(1000))
AS
BEGIN

-- Declare the return variable here
	DECLARE @Result varchar(1000)

-------------------------Intial Load
INSERT INTO @InvoiceSummary
	SELECT CONVERT(varchar(1000),'',1),
	dbo.f_GetSurgeryProvidersByInvoice(@InvoiceID),
	dbo.f_GetSurgeryProcedures(@InvoiceID)

	RETURN 
END
GO
