SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		John D'Oriocourt
-- Create date: 09/12/2013
-- Description:	Gets the information needed for
-- the Patient Report.
-- 09/12/2013: 983473 - Created procedure.
-- =============================================
CREATE PROCEDURE [dbo].[procGetPatientReport] 
	-- Add the parameters for the stored procedure here
	@CompanyID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT c.Name      AS CompanyName, 
           p.ID        AS PatID, 
           p.FirstName AS PatFirstName, 
           p.LastName  AS PatLastName, 
           i.InvoiceNumber, 
           i.isComplete, 
           a.FirstName AS AttFirstName, 
           a.LastName  AS AttLastName, 
           it.Name     AS InvoiceType, 
           CASE it.ID 
             WHEN 1 THEN (SELECT EndingBalance 
                          FROM   dbo.f_GetTestInvoiceSummaryTable(i.ID)) 
             WHEN 2 THEN (SELECT EndingBalance 
                          FROM   dbo.f_GetSurgeryInvoiceSummaryTable(i.ID)) 
             ELSE 0 
           END         AS EndingBalance 
    FROM   Invoice i 
           INNER JOIN Company c 
                   ON i.CompanyID = c.ID 
           INNER JOIN InvoicePatient ip 
                   ON i.InvoicePatientID = ip.ID 
           INNER JOIN Patient p 
                   ON ip.PatientID = p.ID 
           INNER JOIN InvoiceAttorney ia 
                   ON i.InvoiceAttorneyID = ia.ID 
           INNER JOIN Attorney a 
                   ON ia.AttorneyID = a.ID 
           INNER JOIN InvoiceType it 
                   ON i.InvoiceTypeID = it.ID 
    WHERE  i.Active = 1 
           AND p.Active = 1 
           AND i.InvoiceStatusTypeID IN (1, 3) 
           AND i.CompanyID = @CompanyID
END
GO
