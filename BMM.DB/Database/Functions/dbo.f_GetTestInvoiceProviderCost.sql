SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************
-- =============================================
-- Author:		John D'Antonio
-- Create date: 12/27/2011
-- Description:	Gets the provider cost based on the test invoice provider
--				and MRI Count passed in.
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    12/27/2011   John      Created function
** 2	03/21/2012	 Aaron	   Commented and verified function 
*******************************/
CREATE FUNCTION [dbo].[f_GetTestInvoiceProviderCost]
(
		@InvoiceProviderID int,
		@MRICount int
)
RETURNS decimal(18,2)
AS
BEGIN

----- Get the MRI Cost Type Id, the Cost Flat Rate and the Cost Percentage for the specified provider
DECLARE @MRICostTypeID int = (SELECT MRICostTypeID FROM InvoiceProvider WHERE ID = @InvoiceProviderID) -- flat rate or percentage
DECLARE @MRICostFlatRate decimal(18,2) = (SELECT MRICostFlatRate FROM InvoiceProvider WHERE ID = @InvoiceProviderID)
DECLARE @MRICostPercentage decimal(18,2) = (SELECT MRICostPercentage FROM InvoiceProvider WHERE ID = @InvoiceProviderID)

DECLARE @retval decimal(18,2) = 0

IF (@MRICount IS NULL)
BEGIN
	----- If the mri count is null, the amount to the provider is
	----- the test cost minus the test cost multiplied by the providers discount percentage
	SET @retval =
		(SELECT (TIT.TestCost - (TIT.TestCost * IP.DiscountPercentage)) AS AmountToProvider
		FROM TestInvoice_Test AS TIT
		INNER JOIN InvoiceProvider AS IP ON TIT.InvoiceProviderID = IP.ID AND IP.Active = 1
		WHERE TIT.InvoiceProviderID = @InvoiceProviderID AND TIT.Active = 1)
END
ELSE IF (@MRICount IS NOT NULL AND @MRICostTypeID = 1) --flat rate
BEGIN
	----- If the mri count is not null and the type is flat rate, the amount to the provider is
	----- the mri count multiplied by the providers mri cost flat rate
	SET @retval = (SELECT (@MRICount * @MRICostFlatRate) AS AmountToProvider)
END
ELSE IF (@MRICount IS NOT NULL AND @MRICostTypeID = 2) --percentage
BEGIN
	----- If the mri count is not null and the type is percentage, the amount to the provider is
	----- the test cost multiplied by the providers mri cost percentage
	SET @retval =
		(SELECT (TIT.TestCost * @MRICostPercentage) AS AmountToProvider
		FROM TestInvoice_Test AS TIT
		INNER JOIN InvoiceProvider AS IP ON TIT.InvoiceProviderID = IP.ID AND IP.Active = 1
		WHERE TIT.InvoiceProviderID = @InvoiceProviderID AND TIT.Active = 1)
END

return @retval

END
GO
