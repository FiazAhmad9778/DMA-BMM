SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brad Conley
-- Create date: 11/14/2014
-- Description:	Return data for Provider Invoice Report
-- =============================================
CREATE PROCEDURE [dbo].[procProviderInvoiceReport] 
	-- Add the parameters for the stored procedure here
	@StartDate datetime = null,
	@EndDate datetime = null,
	@CompanyId int = -1,
	@ProviderId int = -1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	select *
	from (
(
	select P.ID, 
	REPLACE(P.Name,'&','&amp;') as Name, 
	SUM(SIPP.Amount) as CostofGoods, 
	C.LongName as CompanyName,
	'Surgery' as InvoiceType,
	I.InvoiceNumber as InvoiceNumber,
	--dbo.f_ServiceFeeBegins(dbo.f_GetFirstSurgeryDate(I.ID), I.ServiceFeeWaivedMonths) as DateServiceFeeBegins,
	dbo.f_GetFirstSurgeryDate(I.ID) as DateServiceFeeBegins,
	(select inP.FirstName + ' ' + inP.LastName
	 from InvoicePatient inP
	 where inP.ID = I.InvoicePatientID) as Patient,
	 
	 (select inA.LastName + ', ' + inA.FirstName
	 from InvoiceAttorney inA
	 where inA.ID = I.InvoiceAttorneyID) as Attorney,
	 	 	
	 (select SUM(SIPS.Cost)
	 from SurgeryInvoice_Provider_Services SIPS
	 where SIPS.SurgeryInvoice_ProviderID = SIP.ID) as TotalInvoiceAmount
	
	from Provider as P
	inner join InvoiceProvider as IP on P.ID = IP.ProviderID
	inner join SurgeryInvoice_Providers as SIP on IP.ID = SIP.InvoiceProviderID
	inner join SurgeryInvoice_Provider_Payments as SIPP on SIP.ID = SIPP.SurgeryInvoice_ProviderID
	inner join SurgeryInvoice SI on SI.ID = SIP.SurgeryInvoiceID
	inner join SurgeryInvoice_Provider_Services SIPS on SIPS.SurgeryInvoice_ProviderID = SIP.ID
	inner join Invoice I on I.SurgeryInvoiceID = SI.ID
	inner join Company as C on P.CompanyID = C.ID
	where
	--dbo.f_ServiceFeeBegins(dbo.f_GetFirstSurgeryDate(I.ID), I.ServiceFeeWaivedMonths) >= @StartDate 
	--and dbo.f_ServiceFeeBegins(dbo.f_GetFirstSurgeryDate(I.ID), I.ServiceFeeWaivedMonths) <= @EndDate	
	dbo.f_GetFirstSurgeryDate(I.ID) >= @StartDate 
	and dbo.f_GetFirstSurgeryDate(I.ID) <= @EndDate	
	and P.CompanyID = @CompanyId
	and (@ProviderId = -1 or P.ID = @ProviderId)
	group by P.ID, P.Name, C.LongName, I.InvoiceNumber, I.ID, I.ServiceFeeWaivedMonths, I.InvoicePatientID, I.InvoiceAttorneyID, SIP.ID	
)
union
(
	select P.ID, 
	REPLACE(P.Name,'&','&amp;') as Name, 
	SUM(isnull(TIT.AmountToProvider,0)) as CostofGoods, 
	C.LongName as CompanyName,
	'Test' as InvoiceType,
	I.InvoiceNumber as InvoiceNumber,
	
	--dbo.f_ServiceFeeBegins(dbo.f_GetFirstTestDate(I.ID), I.ServiceFeeWaivedMonths) as DateServiceFeeBegins,	
	dbo.f_GetFirstTestDate(I.ID) as DateServiceFeeBegins,
	(select inP.FirstName + ' ' + inP.LastName
	 from InvoicePatient inP
	 where inP.ID = I.InvoicePatientID) as Patient,
	 
	 (select inA.LastName + ', ' + inA.FirstName
	 from InvoiceAttorney inA
	 where inA.ID = I.InvoiceAttorneyID) as Attorney,
	 
	 SUM(TIT.TestCost) as  TotalInvoiceAmount
	 
	
	from Provider as P
	inner join InvoiceProvider as IP on P.ID = IP.ProviderID
	inner join TestInvoice_Test as TIT on IP.ID = TIT.InvoiceProviderID
	inner join TestInvoice TI on TI.ID = TIT.TestInvoiceID
	inner join Invoice I on I.TestInvoiceID = TI.ID
	inner join Company as C on P.CompanyID = C.ID
	where
	--dbo.f_ServiceFeeBegins(dbo.f_GetFirstTestDate(I.ID), I.ServiceFeeWaivedMonths) >= @StartDate 
	--and dbo.f_ServiceFeeBegins(dbo.f_GetFirstTestDate(I.ID), I.ServiceFeeWaivedMonths) <= @EndDate
	dbo.f_GetFirstTestDate(I.ID)>= @StartDate
	and dbo.f_GetFirstTestDate(I.ID) <= @EndDate
	and TIT.Active = 1
	and P.CompanyID = @CompanyId
	and (@ProviderId = -1 or P.ID = @ProviderId)
	group by P.ID, P.Name, C.LongName, I.InvoiceNumber, I.ID, I.ServiceFeeWaivedMonths, I.InvoicePatientID, I.InvoiceAttorneyID
)) as res

order by res.Name
   
END
GO
