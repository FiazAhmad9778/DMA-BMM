SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 6/18/2012
-- Description:	Attorney Letter Report
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    03/19/2012   Aaron     Created proc
*******************************/
CREATE PROCEDURE [dbo].[procAttorneyLetter]
	@CompanyId int = -1,
	@AttorneyId int = -1
AS
BEGIN
	SET NOCOUNT ON;
	
DECLARE @ClosedStatusTypeID INT = 2
DECLARE @PrinciplePaymentTypeID INT = 1
DECLARE @DepositPaymentTypeID INT = 3
DECLARE @CreditPaymentTypeID INT = 5
DECLARE @RefundPaymentTypeID INT = 4
DECLARE @TestTypeID INT = 1
DECLARE @SurgeryTypeID INT = 2
(
	SELECT
		'Test' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		A.FirstName AS AttorneyFirstName,
		A.LastName AS AttorneyLastName,
		A.LastName + ', ' + A.FirstName AS AttorneyDisplayName,
		A.Street1 AS AttorneyAddress1,
		A.Street2 AS AttorneyAddress2,
		A.City AS AttorneyCity,
		S.Abbreviation AS AttorneyState,
		A.ZipCode AS AttorneyZipCode,
		InvF.Name AS FirmName,
		I.isComplete AS InvoiceCompleted,
		co.LongName as CompanyName,
		I.InvoiceStatusTypeID as StatusType
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		JOIN Attorney A on IA.AttorneyID = A.ID
		JOIN States S ON IA.StateID = S.ID
		LEFT JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE I.InvoiceStatusTypeID != @ClosedStatusTypeID
		AND I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @TestTypeID
		AND (@AttorneyId = -1 or A.ID = @AttorneyId)
)
UNION
(
	SELECT
		'Procedure' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		A.FirstName AS AttorneyFirstName,
		A.LastName AS AttorneyLastName,
		A.LastName + ', ' + A.FirstName AS AttorneyDisplayName,
		A.Street1 AS AttorneyAddress1,
		A.Street2 AS AttorneyAddress2,
		A.City AS AttorneyCity,
		S.Abbreviation AS AttorneyState,
		A.ZipCode AS AttorneyZipCode,
		InvF.Name AS FirmName,
		I.isComplete AS InvoiceCompleted,
		co.LongName as CompanyName,
		I.InvoiceStatusTypeID as StatusType
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		JOIN Attorney A on IA.AttorneyID = A.ID
		JOIN States S ON IA.StateID = S.ID
		LEFT JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE I.InvoiceStatusTypeID != @ClosedStatusTypeID
		AND I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @SurgeryTypeID
		AND (@AttorneyId = -1 or A.ID = @AttorneyId)
)

END
GO
