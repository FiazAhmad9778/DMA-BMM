SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[procICDCodeReport]
	-- Add the parameters for the stored procedure here
	@ICDCodeID int,
	@CompanyID int,
	@StartDate DateTime,
	@EndDate DateTime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		i.InvoiceNumber as InvoiceNumber,
		[dbo].[f_GetFirstSurgeryDate](i.ID)  as ServiceDate,
		s.Name as SurgeryType,
		[dbo].[f_GetInvoicePhysicianName](i.ID) as Physician,
		[dbo].[f_GetInvoiceCostTotal](i.ID,i.InvoiceTypeID) as TotalCost,
		co.LongName as CompanyName
	
	FROM Invoice i
	inner join SurgeryInvoice si on i.SurgeryInvoiceID = si.ID
	inner join SurgeryInvoice_Surgery sis on si.ID = sis.SurgeryInvoiceID
	inner join Surgery s on sis.SurgeryID = s.ID
	inner join SurgeryInvoice_SurgeryDates sisd on sis.ID = sisd.SurgeryInvoice_SurgeryID
	inner join SurgeryInvoice_Surgery_ICDCodes sisi on sis.ID = sisi.SurgeryInvoice_SurgeryID
	INNER JOIN Company co ON i.CompanyID = co.ID AND co.Active = 1
	WHERE i.CompanyID = @CompanyID 
	AND sisi.ICDCodeID = @ICDCodeID
	AND [dbo].[f_GetFirstSurgeryDate](i.ID) >= @StartDate AND [dbo].[f_GetFirstSurgeryDate](i.ID) <= @EndDate
	order by TotalCost desc
END

GO
