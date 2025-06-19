SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[procCPTReportTest] 
	-- Add the parameters for the stored procedure here
	@CPTCodeID int,
	@CompanyID int,
	@StartDate DateTime,
	@EndDate DateTime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	(SELECT 
	i.InvoiceNumber as InvoiceNumber,
	CASE
		WHEN i.InvoiceTypeID = 1 THEN 'Test'
		ELSE 'Surgery'
	END as InvoiceTypeID,
	[dbo].[f_GetFirstTestDate](i.ID) as ServiceDate,
	p.Name as ProviderName,
	titc.Amount as Cost,
	co.LongName as CompanyName

	FROM Invoice i
	inner join TestInvoice ti on i.TestInvoiceID = ti.ID
	inner join TestInvoice_Test ti_t on ti.ID = ti_t.TestInvoiceID
	inner join TestInvoice_Test_CPTCodes titc on ti_t.ID = titc.TestInvoice_TestID
	inner join CPTCodes c on titc.CPTCodeID = c.ID
	inner join InvoiceProvider ip on ti_t.InvoiceProviderID = ip.ID
	inner join Provider p on ip.ProviderID = p.ID
	INNER JOIN Company co ON i.CompanyID = co.ID AND co.Active = 1
	WHERE i.CompanyID = @CompanyID
	AND titc.CPTCodeID = @CPTCodeID
	AND [dbo].[f_GetFirstTestDate](i.ID) >= @StartDate AND [dbo].[f_GetFirstTestDate](i.ID) <= @EndDate
	)
	UNION
	(
	SELECT 
		i.InvoiceNumber as InvoiceNumber,
		CASE
		WHEN i.InvoiceTypeID = 1 THEN 'Test'
		ELSE 'Surgery'
	END as InvoiceTypeID,
		[dbo].[f_GetFirstSurgeryDate](i.ID)  as ServiceDate,
		p.Name as ProviderName,
		sipc.Amount as Cost,
		co.LongName as CompanyName

	FROM Invoice i
	inner join SurgeryInvoice si on i.SurgeryInvoiceID = si.ID
	inner join SurgeryInvoice_Providers sip on si.ID = sip.SurgeryInvoiceID
	inner join InvoiceProvider ip on sip.InvoiceProviderID = ip.ID
	inner join Provider p on ip.ProviderID = p.ID
	left outer join SurgeryInvoice_Provider_CPTCodes sipc on sip.ID = sipc.SurgeryInvoice_ProviderID
	inner join CPTCodes c on sipc.CPTCodeID = c.ID
	INNER JOIN Company co ON i.CompanyID = co.ID AND co.Active = 1
	WHERE i.CompanyID = @CompanyID 
	AND sipc.CPTCodeID = @CPTCodeID
	AND [dbo].[f_GetFirstSurgeryDate](i.ID) >= @StartDate AND [dbo].[f_GetFirstSurgeryDate](i.ID) <= @EndDate
	)
	order by Cost desc

END

GO
