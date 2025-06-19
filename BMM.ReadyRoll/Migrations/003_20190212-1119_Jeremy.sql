-- <Migration ID="5fd285ed-5c57-4a69-9d7f-16f7bf2c44fe" />
GO

PRINT N'Altering [dbo].[procTotalRevenueReport]'
GO
-- =============================================
-- Author:		Brad Conley
-- Create date: 4/2/14
-- Description:	Return information for the Total Revenue Report
-- Modified date: 07/27/2015 by Cherie Walker to only show active surgery and test dates
-- Modified columns: 08/17/2015 by Cherie Walker based on user's feedback
-- =============================================
ALTER PROCEDURE [dbo].[procTotalRevenueReport] 
	@StartYear Date = '1/1/1901', 
	@EndYear Date = GETDATE,
	@CompanyId int = -1
AS
BEGIN
	
	SET NOCOUNT ON;
(
   select
    A.ID as AttorneyID,
    A.FirstName as AttorneyFirstName,
    A.LastName as AttorneyLastName,
    YEAR(SISD.ScheduledDate) as YearPaid,
    SIS.isCanceled as Canceled,
    SIPS.ID as ID,
    SIPS.Cost as TotalCostBeforePPODiscount,
    SIPS.PPODiscount as PPODiscount,
    SIPS.Cost - SIPS.PPODiscount as TotalCostLessPPODiscount,
    SIPS.AmountDue as LessCostOfGoodsSold,
    (SIPS.Cost - SIPS.PPODiscount) - SIPS.AmountDue as TotalRevenue,
    C.LongName as CompanyName
  
    from Invoice I
    JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
	JOIN Attorney A on IA.AttorneyID = A.ID
	JOIN SurgeryInvoice SI on SI.ID = I.SurgeryInvoiceID
	JOIN SurgeryInvoice_Surgery SIS on SI.ID = SIS.SurgeryInvoiceID
	JOIN SurgeryInvoice_SurgeryDates SISD on SIS.ID = SISD.SurgeryInvoice_SurgeryID
	JOIN SurgeryInvoice_Providers SIP on SIP.SurgeryInvoiceID = SI.ID
	JOIN SurgeryInvoice_Provider_Services SIPS on SIPS.SurgeryInvoice_ProviderID = SIP.ID
	JOIN Company C on C.ID = I.CompanyID
	
    WHERE I.Active = 1 
    AND SIS.isCanceled = 0 
    AND I.CompanyID = @CompanyId
    and SISD.ScheduledDate BETWEEN @StartYear AND @EndYear
)
UNION ALL
(
	select
	A.ID as AttorneyID,
    A.FirstName as AttorneyFirstName,
    A.LastName as AttorneyLastName,
    YEAR(TIT.TestDate) as YearPaid,
    TIT.isCanceled as Canceled,
    TIT.ID as ID,
    TIT.TestCost as TotalCostBeforePPODiscount,
    TIT.PPODiscount as PPODiscount,
    TIT.TestCost - TIT.PPODiscount AS TotalCostLessPPODiscount,
    TIT.AmountToProvider as LessCostOfGoodsSold,
    (TIT.TestCost - TIT.PPODiscount) - TIT.AmountToProvider as TotalRevenue,
    C.LongName as CompanyName
	
	from Invoice I
	JOIN InvoiceAttorney IA ON IA.ID=I.InvoiceAttorneyID AND IA.Active=1
	JOIN Attorney A on IA.AttorneyID = A.ID
	JOIN TestInvoice TI on TI.ID = I.TestInvoiceID
	JOIN TestInvoice_Test TIT on TIT.TestInvoiceID = TI.ID
	JOIN Company C on C.ID = I.CompanyID
	
	where I.Active = 1 
	AND TIT.isCanceled = 0 
	AND I.CompanyID = @CompanyId
    and TIT.TestDate BETWEEN @StartYear AND @EndYear
)
END
GO
