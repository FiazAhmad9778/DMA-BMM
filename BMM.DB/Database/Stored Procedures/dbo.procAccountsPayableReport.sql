SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************
-- =============================================
-- Author:		Aaron Jandle
-- Create date: 3/19/2012
-- Description:	Accounts Payable Report Data
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    03/19/2012   Aaron     Created proc
** 2	12/20/2012	 Czarina   Adjusted Testing Invoice AmountDue Calc because all amounts were duplicating the Deposit and giving a negative number on report
** 3	4/26/2013	 Brad Conley	Case 951802: Show both Open and Closed Invoices.
** 4	1/31/2014	Brad Conley		Case 1006403: Added the TestInvoice_Test ID parameter to the GetFirstTestDate function
*******************************/
CREATE PROCEDURE [dbo].[procAccountsPayableReport]
	@StartDate datetime = null, 
	@EndDate datetime = null,
	@CompanyId int = -1,
	@ProviderId int = -1
AS
BEGIN
	SET NOCOUNT ON;
	
DECLARE @ClosedStatusTypeID INT = 2
DECLARE @TestTypeID INT = 1
DECLARE @SurgeryTypeID INT = 2
(
	SELECT
		'Testing' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		--dbo.f_GetFirstTestDate(I.ID, TIT.ID) AS [ServiceDate],
		dbo.f_GetFirstTestDateAccountsPayableReport(I.ID, TIT.ID) AS [ServiceDate],
		IP.ProviderID AS ProviderID,
		IP.Name AS Provider,
		TIT.AccountNumber AS AccountNumber,
		Convert(varchar,TIT.ProviderDueDate,1) as ProviderDueDate, 
		InvP.FirstName AS PatientFirstName,
		InvP.LastName AS PatientLastName,
		InvP.LastName + ', ' + InvP.FirstName AS PatientDisplayName,
		0 AS TotalEstimatedCost,
		ISNULL(TIT.TestCost,0) AS BilledAmount,
		ISNULL(TIT.DepositToProvider,0) AS DepositToProvider,
---		(ISNULL(TIT.TestCost,0) - ISNULL(TIT.AmountToProvider, 0)) AS DiscountAmount,
----	(ISNULL(TIT.PPODiscount,0)) AS DiscountAmount, -- CCW:  12/20/12:  trying to get accurate discount amount
		ISNULL(TIT.TestCost,0) - ISNULL(TIT.AmountToProvider,0) AS DiscountAmount, -- CCW:  01/18/13:  trying to get accurate discount amount
---		(ISNULL(TIT.AmountToProvider,0) - ISNULL(TIT.DepositToProvider,0) - ISNULL(TIT.AmountPaidToProvider,0)) AS AmountDue,
--		ISNULL(TIT.TestCost,0) - ISNULL(TIT.DepositToProvider,0) - (ISNULL(TIT.PPODiscount,0))- ISNULL(TIT.AmountPaidToProvider,0) AS AmountDue,
--		ISNULL(TIT.AmountToProvider,0)- ISNULL(TIT.DepositToProvider,0) - ISNULL(TIT.AmountPaidToProvider,0) AS AmountDue, --CCW:  01/22/13 
		-- Updated line above to be BilledAmount - DepositToProvider - DiscountAmount - AmountPaidToProvider = AmountDue
		CASE
		when ISNULL(TIT.AmountToProvider,0)- ISNULL(TIT.DepositToProvider,0) - ISNULL(TIT.AmountPaidToProvider,0) = 1 THEN 0
		ELSE ISNULL(TIT.AmountToProvider,0)- ISNULL(TIT.DepositToProvider,0) - ISNULL(TIT.AmountPaidToProvider,0) END AS AmountDue,
		--CASE 993929 The above case statement turns the amountdue to 0 if it's equal to 1 because tests with $1 are 'closed'
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
	WHERE I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @TestTypeID
	AND (@ProviderId = -1 or IP.ProviderID = @ProviderId)
		AND TIT.ProviderDueDate BETWEEN @StartDate AND @EndDate
		AND ISNULL(TIT.TestCost,0) > 1
		--AND I.InvoiceStatusTypeID != @ClosedStatusTypeID
		-- Case 951802: Display Open and Closed Invoices
)
UNION
(
	SELECT DISTINCT
		'Surgery' AS [Type],
		I.InvoiceNumber AS InvoiceNumber,
		dbo.f_GetFirstSurgeryDate(I.ID) AS [ServiceDate],
		IP.ProviderID AS ProviderID,
		IP.Name AS Provider,
		sps.AccountNumber AS AccountNumber,
		sps.DueDate AS ProviderDueDate,
		InvP.FirstName AS PatientFirstName,
		InvP.LastName AS PatientLastName,
		InvP.LastName + ', ' + InvP.FirstName As PatientDisplayName,
		sps.TotalEstimatedCost AS TotalEstimatedCost,
		sps.BilledAmount AS BilledAmount,
		sps.DepositToProvider AS DepositToProvider,
		sps.DiscountAmount AS DiscountAmount,
		sps.AmountDue AS AmountDue,
		co.LongName as CompanyName,
		I.InvoiceStatusTypeID as StatusType
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		LEFT JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		JOIN InvoicePatient InvP ON InvP.ID=I.InvoicePatientID AND InvP.Active=1
		JOIN SurgeryInvoice SI ON SI.ID=I.SurgeryInvoiceID AND SI.Active=1
		JOIN SurgeryInvoice_Providers SIP ON SIP.SurgeryInvoiceID=SI.ID AND SIP.Active=1
		LEFT JOIN SurgeryInvoice_Provider_Services SIPS ON SIPS.SurgeryInvoice_ProviderID=SIP.ID AND SIPS.Active=1
		LEFT JOIN InvoiceProvider IP ON IP.ID=SIP.InvoiceProviderID AND IP.Active=1
		INNER JOIN Company co ON I.CompanyID = co.ID AND co.Active = 1
		outer apply dbo.f_GetSurgeryPaymentsSummary(I.ID, SIP.InvoiceProviderID, @StartDate, @EndDate) sps
	WHERE I.Active = 1 AND I.CompanyID = @CompanyId AND I.InvoiceTypeID = @SurgeryTypeID
	AND (@ProviderId = -1 or IP.ProviderID = @ProviderId)
		AND SIPS.DueDate BETWEEN @StartDate AND @EndDate
		AND sps.BilledAmount > 0
		--AND I.InvoiceStatusTypeID != @ClosedStatusTypeID
		-- Case 951802 Display Open and Closed Invoices
)

END
GO
