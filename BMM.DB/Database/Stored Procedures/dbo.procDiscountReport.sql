SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Durel Hoover
-- Create date: 4/3/2014
-- Description:	Retrieves the Discount Report's data.
-- =============================================
CREATE PROCEDURE [dbo].[procDiscountReport] 
	-- Add the parameters for the stored procedure here
	@CompanyID INT,
	@StartDate DATE,
	@EndDate DATE,
	@AttorneyID INT = -1,
	@StatementDate datetime = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @TestTypeID INT = 1,
			@SurgeryTypeID INT = 2
			
	SELECT tblinv.CompanyID,
		   c.LongName							  AS "CompanyName",
		   tblInv.FirmID, 
		   f.Name                                 AS "FirmName", 
		   tblInv.AttorneyID, 
		   att.LastName                           AS "AttLastName", 
		   att.FirstName                          AS "AttFirstName", 
		   SUM(tblInv.BalanceDue)                 AS "TotalPrincipalDue", 
		   SUM(ISNULL(tblInv.LossesAmount, 0))    AS "PrincipalWaived", 
		   SUM(tblInv.CumulativeServiceFeeDue)    AS "TotalServiceFeeDue", 
		   SUM(ISNULL(tblInv.ServiceFeeWaived, 0))AS "ServiceFeeWaived" 
	FROM   ((SELECT inv.ID, 
					inv.InvoiceNumber,
					inv.CompanyID, 
					att.FirmID, 
					invAtt.AttorneyID, 
					tis.BalanceDue, 
					inv.LossesAmount, 
					tis.CumulativeServiceFeeDue, 
					inv.ServiceFeeWaived 
			 FROM   Invoice inv 
					INNER JOIN InvoiceAttorney invAtt 
							ON inv.InvoiceAttorneyID = invAtt.ID 
					INNER JOIN Attorney att 
							ON invAtt.AttorneyID = att.ID
					OUTER apply f_GetTestInvoiceSummaryTableMinified(inv.id, @StatementDate) tis 
			 WHERE  ( @AttorneyID <= 0 
					   OR invAtt.AttorneyID = @AttorneyID )
					AND @CompanyID = inv.CompanyID
					AND inv.InvoiceTypeID = @TestTypeID 
					AND inv.Active = 1 
					AND tis.BalanceDue > 0 
					AND @StartDate <= tis.FirstTestDate
					AND tis.FirstTestDate <= @EndDate) 
			UNION 
			(SELECT inv.ID, 
					inv.InvoiceNumber,
					inv.CompanyID, 
					att.FirmID, 
					invAtt.AttorneyID, 
					sis.BalanceDue, 
					inv.LossesAmount, 
					sis.CumulativeServiceFeeDue, 
					inv.ServiceFeeWaived 
			 FROM   Invoice inv 
					INNER JOIN InvoiceAttorney invAtt 
							ON inv.InvoiceAttorneyID = invAtt.ID 
					INNER JOIN Attorney att 
							ON invAtt.AttorneyID = att.ID
					OUTER apply f_GetSurgeryInvoiceSummaryTableMinified(inv.id, @StatementDate) sis 
			 WHERE  ( @AttorneyID <= 0 
					   OR invAtt.AttorneyID = @AttorneyID )
					AND @CompanyID = inv.CompanyID 
					AND inv.InvoiceTypeID = @SurgeryTypeID 
					AND inv.Active = 1 
					AND sis.BalanceDue > 0 
					AND @StartDate <= sis.FirstSurgeryDate 
					AND sis.FirstSurgeryDate <= @EndDate)) tblInv 
		   INNER JOIN Attorney att 
				   ON tblInv.AttorneyID = att.ID
		   INNER JOIN Company c
				   ON tblInv.CompanyID = c.ID 
		   LEFT JOIN Firm f 
				  ON tblInv.FirmID = f.ID 
	GROUP  BY tblInv.CompanyID,
			  c.LongName,
			  f.Name, 
			  tblInv.FirmID, 
			  att.LastName, 
			  att.FirstName, 
			  tblInv.AttorneyID 
END
GO
