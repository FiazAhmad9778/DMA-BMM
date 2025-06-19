SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************
-- =============================================
-- Author:		John D'Antonio
-- Create date: 4/2/2014
-- Description:	Total Tests and SUrgeries Report
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    04/3/2014    John      Created proc
*******************************/
CREATE PROCEDURE [dbo].[procGetAllTestsAndProceduresReport]
	@Year int = -1,
	@CompanyID int = -1,
	@AttorneyId int = -1
AS
BEGIN
	SET NOCOUNT ON;
	
declare @tempTable table (AttorneyName varchar(200), AttorneyID int, ProviderName varchar(500), ProviderID int, [Month] int, TestCount int, SurgeryCount int, UniqueSurgeryCount int, UniqueTotalSurgeryCount int, CompanyName varchar(500))

--Get the test information
insert into @tempTable
select A.LastName + ' ' + A.FirstName as AttorneyName,
	A.ID,
	P.Name as ProviderName,
	P.ID,
	MONTH(TIT.TestDate) as [Month],
	SUM(TIT.NumberOfTests) as TestCount,
	0,
	0,
	0,
	C.LongName
from Attorney as A
inner join InvoiceAttorney as IA on A.ID = IA.AttorneyID
inner join Invoice as I on I.InvoiceAttorneyID = IA.ID
inner join TestInvoice as TI on I.TestInvoiceID = TI.ID
inner join TestInvoice_Test as TIT on TI.ID = TIT.TestInvoiceID
inner join InvoiceProvider as IP on TIT.InvoiceProviderID = IP.ID
inner join Provider as P on IP.ProviderID = P.ID
inner join Company as C on I.CompanyID = C.ID
where I.InvoiceTypeID = 1 --tests
and A.CompanyID = @CompanyID
AND (@AttorneyId = -1 or A.ID = @AttorneyId)
and YEAR(TIT.TestDate) = @Year
and TIT.NumberOfTests > 0
group by A.LastName, A.FirstName, P.Name, A.ID, P.ID, Month(TIT.TestDate), C.LongName
order by A.LastName, A.FirstName, Month(TIT.TestDate)

--Get the surgery information
insert into @tempTable
select A.LastName + ' ' + A.FirstName as AttorneyName,
	A.ID,
	P.Name as ProviderName,
	P.ID,
	MONTH(SISDs.ScheduledDate) as [Month],
	0,
	COUNT(SIS.ID) as SurgeryCount,
	COUNT(distinct sisds.ID) as UniqueSurgeryCount,
	(select COUNT(distinct I.ID)
		from Attorney as A2
		inner join InvoiceAttorney as IA on A2.ID = IA.AttorneyID
		inner join Invoice as I on I.InvoiceAttorneyID = IA.ID
		inner join SurgeryInvoice as SI on I.SurgeryInvoiceID = SI.ID
		inner join SurgeryInvoice_Providers as SIPs on SI.ID = SIPs.SurgeryInvoiceID
		inner join SurgeryInvoice_Surgery as SIS on SI.ID = SIS.SurgeryInvoiceID
		inner join SurgeryInvoice_SurgeryDates as SISDs on SIS.ID = SISDs.SurgeryInvoice_SurgeryID 
		where I.InvoiceTypeID = 2 -- surgery
		and A2.CompanyID = @CompanyID
		AND (@AttorneyId = -1 or A2.ID = @AttorneyId)
		and YEAR(SISDs.ScheduledDate) = @Year
		and A.ID = A2.ID) as UniqueTotalSurgeryCount,
	C.LongName
from Attorney as A
inner join InvoiceAttorney as IA on A.ID = IA.AttorneyID
inner join Invoice as I on I.InvoiceAttorneyID = IA.ID
inner join SurgeryInvoice as SI on I.SurgeryInvoiceID = SI.ID
inner join SurgeryInvoice_Providers as SIPs on SI.ID = SIPs.SurgeryInvoiceID
inner join SurgeryInvoice_Surgery as SIS on SI.ID = SIS.SurgeryInvoiceID
inner join InvoiceProvider as IP on SIPs.InvoiceProviderID = IP.ID
inner join Provider as P on IP.ProviderID = P.ID
inner join SurgeryInvoice_SurgeryDates as SISDs on SIS.ID = SISDs.SurgeryInvoice_SurgeryID 
inner join Company as C on I.CompanyID = C.ID
where I.InvoiceTypeID = 2 -- surgery
and A.CompanyID = @CompanyID
AND (@AttorneyId = -1 or A.ID = @AttorneyId)
and YEAR(SISDs.ScheduledDate) = @Year
group by A.LastName, A.FirstName, P.Name, A.ID, P.ID, Month(SISDs.ScheduledDate), C.LongName
order by A.LastName, A.FirstName, Month(SISDs.ScheduledDate)

----FIND DUPLICATES IF THERE IS A PROBLEM
--select AttorneyID, ProviderID, Month, COUNT(SurgeryCount) as cc
--from @tempTable
--group by AttorneyID, ProviderID, Month

--select *
--from @tempTable
--where AttorneyID = 33143
--and ProviderID = 40602
--and Month = 4

--Put the information together and return for the report
select tt.CompanyName,
	tt.AttorneyName,
	tt.AttorneyID,
	tt.ProviderName,
	tt.ProviderID,
	isnull((select TestCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0 and tt2.Month = 1),0) as JanTestCount,
	isnull((select TestCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0 and tt2.Month = 2),0) as FebTestCount,
	isnull((select TestCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0 and tt2.Month = 3),0) as MarTestCount,
	isnull((select TestCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0 and tt2.Month = 4),0) as AprTestCount,
	isnull((select TestCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0 and tt2.Month = 5),0) as MayTestCount,
	isnull((select TestCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0 and tt2.Month = 6),0) as JunTestCount,
	isnull((select TestCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0 and tt2.Month = 7),0) as JulTestCount,
	isnull((select TestCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0 and tt2.Month = 8),0) as AugTestCount,
	isnull((select TestCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0 and tt2.Month = 9),0) as SepTestCount,
	isnull((select TestCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0 and tt2.Month = 10),0) as OctTestCount,
	isnull((select TestCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0 and tt2.Month = 11),0) as NovTestCount,
	isnull((select TestCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0 and tt2.Month = 12),0) as DecTestCount,
	isnull((select sum(TestCount) from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and TestCount > 0),0) as TotalTestCount,
	
	isnull((select SurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0 and tt2.Month = 1),0) as JanSurgeryCount,
	isnull((select SurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0 and tt2.Month = 2),0) as FebSurgeryCount,
	isnull((select SurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0 and tt2.Month = 3),0) as MarSurgeryCount,
	isnull((select SurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0 and tt2.Month = 4),0) as AprSurgeryCount,
	isnull((select SurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0 and tt2.Month = 5),0) as MaySurgeryCount,
	isnull((select SurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0 and tt2.Month = 6),0) as JunSurgeryCount,
	isnull((select SurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0 and tt2.Month = 7),0) as JulSurgeryCount,
	isnull((select SurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0 and tt2.Month = 8),0) as AugSurgeryCount,
	isnull((select SurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0 and tt2.Month = 9),0) as SepSurgeryCount,
	isnull((select SurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0 and tt2.Month = 10),0) as OctSurgeryCount,
	isnull((select SurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0 and tt2.Month = 11),0) as NovSurgeryCount,
	isnull((select SurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0 and tt2.Month = 12),0) as DecSurgeryCount,
	isnull((select Sum(SurgeryCount) from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and SurgeryCount > 0),0) as TotalSurgeryCount,
	
	isnull((select UniqueSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0 and tt2.Month = 1),0) as JanUniqueSurgeryCount,
	isnull((select UniqueSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0 and tt2.Month = 2),0) as FebUniqueSurgeryCount,
	isnull((select UniqueSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0 and tt2.Month = 3),0) as MarUniqueSurgeryCount,
	isnull((select UniqueSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0 and tt2.Month = 4),0) as AprUniqueSurgeryCount,
	isnull((select UniqueSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0 and tt2.Month = 5),0) as MayUniqueSurgeryCount,
	isnull((select UniqueSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0 and tt2.Month = 6),0) as JunUniqueSurgeryCount,
	isnull((select UniqueSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0 and tt2.Month = 7),0) as JulUniqueSurgeryCount,
	isnull((select UniqueSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0 and tt2.Month = 8),0) as AugUniqueSurgeryCount,
	isnull((select UniqueSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0 and tt2.Month = 9),0) as SepUniqueSurgeryCount,
	isnull((select UniqueSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0 and tt2.Month = 10),0) as OctUniqueSurgeryCount,
	isnull((select UniqueSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0 and tt2.Month = 11),0) as NovUniqueSurgeryCount,
	isnull((select UniqueSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0 and tt2.Month = 12),0) as DecUniqueSurgeryCount,
	isnull((select top 1 UniqueTotalSurgeryCount from @tempTable as tt2 where tt2.AttorneyID = tt.AttorneyID and tt2.ProviderID = tt.ProviderID and UniqueSurgeryCount > 0),0) as TotalUniqueSurgeryCount
	
from @tempTable as tt
group by tt.AttorneyName, tt.AttorneyID, tt.ProviderID, tt.ProviderName,tt.CompanyName

END
GO
