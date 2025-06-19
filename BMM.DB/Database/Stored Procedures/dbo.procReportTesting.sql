SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Bursavich, Andrew
-- Create date: 2011.01.04
-- Description:	For Testing SSRS
-- =============================================
CREATE PROCEDURE [dbo].[procReportTesting]
AS
BEGIN

	SET NOCOUNT ON;


DECLARE @OpenStatusTypeID INT = 1
DECLARE @PrinciplePaymentTypeID INT = 1
DECLARE @DepositPaymentTypeID INT = 3
DECLARE @CreditPaymentTypeID INT = 5
DECLARE @RefundPaymentTypeID INT = 4
(
	SELECT
		--I.ID As [InvoiceID], TI.ID AS [TestInvoiceID],
		--TIT.ID AS [TestInvoice_TestID], T.ID AS [TestID], IP.ID AS [InvoiceProviderID],
		------------------------------
		IA.AttorneyID AS AttorneyID,
		I.ID AS InvoiceID,
		TIT.ID AS ServiceID,
		TIT.ID AS DateID,
		TIT.ID AS CostID,
		P.ID AS PaymentID,
		------------------------------
		'Test' AS [Type],
		I.ID AS InvoiceNumber,
		TIT.TestDate AS [ServiceDate],
		CASE WHEN TIT.TestDate IS NULL THEN 0 ELSE 1 END AS isPrimaryDate,
		T.Name as ServiceName,
		IA.LastName + ', ' + IA.FirstName AS AttorneyName,
		InvF.Name AS FirmName,
		InvP.LastName + ', ' + InvP.FirstName As PatientName,
		IP.Name AS Provider,
		TIT.TestCost AS ServiceCost,
		CASE WHEN P.Amount IS NULL THEN 0 ELSE P.Amount END AS PaymentAmount,
		TIT.PPODiscount AS PPODiscount
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		JOIN InvoicePatient InvP ON InvP.ID=I.InvoicePatientID AND InvP.Active=1
		JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.Active=1
			LEFT JOIN TestInvoice_Test TIT ON TIT.TestInvoiceID=TI.ID AND TIT.Active=1
				LEFT JOIN InvoiceProvider IP ON IP.ID=TIT.InvoiceProviderID AND IP.Active=1
				LEFT JOIN Test T ON T.ID=TIT.TestID AND T.Active=1
		LEFT JOIN Payments P ON P.InvoiceID=I.ID AND (P.PaymentTypeID=@PrinciplePaymentTypeID OR P.PaymentTypeID=@DepositPaymentTypeID OR P.PaymentTypeID=@CreditPaymentTypeID OR P.PaymentTypeID=@RefundPaymentTypeID) AND P.Active=1
	WHERE I.InvoiceStatusTypeID=@OpenStatusTypeID
		AND I.Active = 1
)
UNION
(
	SELECT
		------------------------------
		IA.AttorneyID AS AttorneyID,
		I.ID AS InvoiceID,
		SIS.ID AS ServiceID,
		SISD.ID AS DateID,
		SIPS.ID AS CostID,
		P.ID AS PaymentID,
		------------------------------
		'Procedure' AS [Type],
		I.ID AS InvoiceNumber,
		SISD.ScheduledDate AS [ServiceDate],
		SISD.isPrimaryDate,
		S.Name as ServiceName,
		IA.LastName + ', ' + IA.FirstName AS AttorneyName,
		InvF.Name AS FirmName,
		InvP.LastName + ', ' + InvP.FirstName As PatientName,
		IP.Name AS Provider,
		SIPS.Cost AS ServiceCost,
		CASE WHEN P.Amount IS NULL THEN 0 ELSE P.Amount END AS PaymentAmount,
		SIPS.PPODiscount AS PPODiscount
	FROM Invoice I
		JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
		JOIN InvoiceFirm InvF ON InvF.ID=IA.InvoiceFirmID AND InvF.Active=1
		JOIN InvoicePatient InvP ON InvP.ID=I.InvoicePatientID AND InvP.Active=1
		JOIN SurgeryInvoice SI ON SI.ID=I.SurgeryInvoiceID AND SI.Active=1
			LEFT JOIN SurgeryInvoice_Surgery SIS ON SIS.SurgeryInvoiceID=SI.ID AND SIS.Active=1
				LEFT JOIN Surgery S ON S.ID=SIS.SurgeryID AND S.Active=1
				LEFT JOIN SurgeryInvoice_SurgeryDates SISD ON SISD.SurgeryInvoice_SurgeryID=SIS.ID AND SISD.Active=1
			LEFT JOIN SurgeryInvoice_Providers SIP ON SIP.SurgeryInvoiceID=SI.ID AND SIP.Active=1
				LEFT JOIN InvoiceProvider IP ON IP.ID=SIP.InvoiceProviderID AND IP.Active=1
				LEFT JOIN SurgeryInvoice_Provider_Services SIPS ON SIPS.SurgeryInvoice_ProviderID=SIP.ID
		LEFT JOIN Payments P ON P.InvoiceID=I.ID AND (P.PaymentTypeID=@PrinciplePaymentTypeID OR P.PaymentTypeID=@DepositPaymentTypeID OR P.PaymentTypeID=@CreditPaymentTypeID OR P.PaymentTypeID=@RefundPaymentTypeID) AND P.Active=1
	WHERE I.InvoiceStatusTypeID=@OpenStatusTypeID
		AND I.Active = 1
)
ORDER BY AttorneyName ASC, InvoiceNumber ASC, isPrimaryDate DESC


END
GO
