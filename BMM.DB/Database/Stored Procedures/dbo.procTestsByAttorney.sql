SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 6/18/2012
-- Description:	Total Tests By Attorney
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    03/19/2012   Aaron     Created proc
*******************************/
CREATE PROCEDURE [dbo].[procTestsByAttorney]
	@StartDate datetime = null, 
	@EndDate datetime = null,
	@CompanyId int = -1
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TestTypeID INT = 1
	DECLARE @ClosedStatusTypeID INT = 2

    SELECT 
		I.InvoiceNumber AS InvoiceNumber,
		dbo.f_GetFirstTestDate(I.ID) AS [ServiceDate],
		IP.Name AS Provider,
		dbo.f_GetTestProcedures(I.ID) as ServiceName,
		IA.FirstName AS AttorneyFirstName,
		IA.LastName AS AttorneyLastName,
		IA.LastName + ', ' + IA.FirstName AS AttorneyDisplayName,
		dbo.f_GetTestCountByType(I.ID, 2) AS MRITests,
		dbo.f_GetTestCountByType(I.ID, 1) AS PainManagementTests,
		dbo.f_GetTestCountByType(I.ID, 3) AS OtherDiagnostics,
		co.LongName as CompanyName,
		I.InvoiceStatusTypeID as StatusType
	FROM Invoice I
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
		LEFT JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1
		LEFT JOIN InvoiceProvider IP ON IP.ID=TIT.InvoiceProviderID AND IP.Active=1
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		LEFT JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		JOIN InvoicePatient InvP ON InvP.ID=I.InvoicePatientID AND InvP.Active=1
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE I.InvoiceStatusTypeID != @ClosedStatusTypeID
		AND I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @TestTypeID
		AND dbo.f_GetFirstTestDate(I.ID) BETWEEN @StartDate AND @EndDate
	
END
GO
