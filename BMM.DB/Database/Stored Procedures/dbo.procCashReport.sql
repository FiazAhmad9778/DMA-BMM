SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/19/2012
-- Description:	Cash Report Data
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    06/21/2012   Aaron     Created proc
** 2	06/27/2012	 Andy	   Select IA.AttorneyID as AttorneyID (instead of IA.ID as AttorneyID)
**							   f_GetFirstTestDate for Tests instead of f_GetFirstSurgeryDate
** 3    01/03/2013   Cherie    Removed criteria for Test 
** 4    01/04/2013   Cherie    Removed criteria for Surgery
*******************************/
CREATE PROCEDURE [dbo].[procCashReport]
	@StartDate datetime = null, 
	@EndDate datetime = null,
	@CompanyId int = -1
AS
BEGIN
	SET NOCOUNT ON;
	
DECLARE @ClosedStatusTypeID INT = 2
DECLARE @PrinciplePaymentTypeID INT = 1
DECLARE @DepositPaymentTypeID INT = 3
DECLARE @InterestPaymentTypeID INT = 2
DECLARE @RefundPaymentTypeID INT = 4
DECLARE @TestTypeID INT = 1
DECLARE @SurgeryTypeID INT = 2
(
	SELECT
		'Test' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		IA.AttorneyID AS AttorneyID,
		A.FirstName AS AttorneyFirstName,
		A.LastName AS AttorneyLastName,
		A.LastName + ', ' + A.FirstName AS AttorneyDisplayName,
		InvP.FirstName AS PatientFirstName,
		InvP.LastName AS PatientLastName,
		InvP.LastName + ', ' + InvP.FirstName AS PatientDisplayName,
		ISNULL(tis.TotalDeposits,0) AS DepositPayments,
	    ISNULL(tis.ServiceFeeReceived,0) AS InterestPayments,
	    ISNULL(tis.TotalPrincipal,0) AS PrinicipalPayments,
	    (ISNULL(tis.TotalDeposits,0) + ISNULL(tis.ServiceFeeReceived,0) + ISNULL(tis.TotalPrincipal,0)) AS NetRecieved,
	    ISNULL(dbo.f_GetTestPaymentsToProviderByDate(I.ID, @StartDate, @EndDate),0) AS PaymentsToProvider,
	    co.LongName as CompanyName,
		I.InvoiceStatusTypeID as StatusType
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		join Attorney A on IA.AttorneyID = A.ID 
		LEFT JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		JOIN InvoicePatient InvP ON InvP.ID=I.InvoicePatientID AND InvP.Active=1
		outer apply dbo.f_GetTestInvoiceSummaryTableByDate(I.ID, @StartDate, @EndDate) tis
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE --I.InvoiceStatusTypeID != @ClosedStatusTypeID AND --modified based on customer feedback cbw 1/3/2013
		I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @TestTypeID
		AND I.ID In (Select t.InvoiceID from dbo.f_GetTestInvoicesForCashReport(@CompanyId, @StartDate, @EndDate) t)

)
UNION
(
	SELECT
		'Procedure' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		IA.AttorneyID AS AttorneyID,
		A.FirstName AS AttorneyFirstName,
		A.LastName AS AttorneyLastName,
		A.LastName + ', ' + A.FirstName AS AttorneyDisplayName,
		InvP.FirstName AS PatientFirstName,
		InvP.LastName AS PatientLastName,
		InvP.LastName + ', ' + InvP.FirstName As PatientDisplayName,
		ISNULL(sisum.TotalDeposits,0) AS DepositPayments,
	    ISNULL(sisum.ServiceFeeReceived,0) AS InterestPayments,
	    ISNULL(sisum.TotalPrincipal,0) AS PrinicipalPayments,
	    (ISNULL(sisum.TotalDeposits,0) + ISNULL(sisum.ServiceFeeReceived,0) + ISNULL(sisum.TotalPrincipal,0)) AS NetRecieved,
	    ISNULL(dbo.f_GetSurgeryPaymentsToProviderByDate(I.ID, @StartDate, @EndDate),0) AS PaymentsToProvider,
	    co.LongName as CompanyName,
		I.InvoiceStatusTypeID as StatusType
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		join Attorney A on IA.AttorneyID = A.ID 
		LEFT JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		JOIN InvoicePatient InvP ON InvP.ID=I.InvoicePatientID AND InvP.Active=1
		outer apply dbo.f_GetSurgeryInvoiceSummaryTableByDate(I.ID, @StartDate, @EndDate) sisum
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
	WHERE --I.InvoiceStatusTypeID != @ClosedStatusTypeID AND --modified based on customer feedback cbw 1/4/2013
	    I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @SurgeryTypeID
		AND I.ID In (select s.InvoiceID from dbo.f_GetSurgeryInvoicesForCashReport(@CompanyId, @StartDate, @EndDate) s)
)

END
GO
