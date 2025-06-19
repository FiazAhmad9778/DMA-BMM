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
CREATE PROCEDURE [dbo].[procGetAllTestsAndProceduresReport_GrandTotals]
	@Year int = -1,
	@CompanyID int = -1,
	@AttorneyId int = -1
AS
BEGIN
	SET NOCOUNT ON;

declare @tempTable as table(janSurgery int, febSurgery int, marSurgery int, aprSurgery int, maySurgery int, junSurgery int, julSurgery int, augSurgery int, sepSurgery int, octSurgery int,novSurgery int, [decSurgery] int, totalSurgery int,
							janTest int, febTest int, marTest int, aprTest int, mayTest int, junTest int, julTest int, augTest int, sepTest int, octTest int,novTest int, [decTest] int, totalTest int)

declare @SurgeryStuffs as table(attorneyID int, attorneyName varchar(500), invoiceID int, month int)
declare @TestStuffs as table(attorneyID int, attorneyName varchar(500), invoiceID int, month int, testCount int)

--Get surgery totals
insert into @SurgeryStuffs
select A.ID as AttorneyID, 
			A.FirstName + ' ' + A.LastName as AttorneyName, 
			I.ID as InvoiceID, 
			MONTH(SISDs.ScheduledDate) as [Month]
		from Attorney as A
		inner join InvoiceAttorney as IA on A.ID = IA.AttorneyID
		inner join Invoice as I on I.InvoiceAttorneyID = IA.ID
		inner join SurgeryInvoice as SI on I.SurgeryInvoiceID = SI.ID
		inner join SurgeryInvoice_Providers as SIPs on SI.ID = SIPs.SurgeryInvoiceID
		inner join SurgeryInvoice_Surgery as SIS on SI.ID = SIS.SurgeryInvoiceID
		inner join SurgeryInvoice_SurgeryDates as SISDs on SIS.ID = SISDs.SurgeryInvoice_SurgeryID 
		where I.InvoiceTypeID = 2 -- surgery
		and A.CompanyID = @CompanyID
		AND (@AttorneyId = -1 or A.ID = @AttorneyId)
		and YEAR(SISDs.ScheduledDate) = @Year
		group by I.ID, A.FirstName, A.LastName, A.ID, SISDs.ScheduledDate, MONTH(sisds.ScheduledDate)
		
--Get test stuff
insert into @TestStuffs
select A.ID as AttorneyID, 
			A.FirstName + ' ' + A.LastName as AttorneyName, 
			I.ID as InvoiceID, 
			MONTH(TIT.TestDate) as [Month],
			TIT.NumberOfTests as TestCount
from Attorney as A
inner join InvoiceAttorney as IA on A.ID = IA.AttorneyID
inner join Invoice as I on I.InvoiceAttorneyID = IA.ID
inner join TestInvoice as TI on I.TestInvoiceID = TI.ID
inner join TestInvoice_Test as TIT on TI.ID = TIT.TestInvoiceID
where I.InvoiceTypeID = 1 --tests
and A.CompanyID = @CompanyID
AND (@AttorneyId = -1 or A.ID = @AttorneyId)
and YEAR(TIT.TestDate) = @Year
group by I.ID, A.LastName, A.FirstName,A.ID,  Month(TIT.TestDate), TIT.NumberOfTests
order by A.LastName, A.FirstName, Month(TIT.TestDate)		
		
--combine everything and return it
insert into @tempTable
select 
	isnull((select COUNT(attorneyid) from @SurgeryStuffs where month = 1),0),
	isnull((select COUNT(attorneyid) from @SurgeryStuffs where month = 2),0),
	isnull((select COUNT(attorneyid) from @SurgeryStuffs where month = 3),0),
	isnull((select COUNT(attorneyid) from @SurgeryStuffs where month = 4),0),
	isnull((select COUNT(attorneyid) from @SurgeryStuffs where month = 5),0),
	isnull((select COUNT(attorneyid) from @SurgeryStuffs where month = 6),0),
	isnull((select COUNT(attorneyid) from @SurgeryStuffs where month = 7),0),
	isnull((select COUNT(attorneyid) from @SurgeryStuffs where month = 8),0),
	isnull((select COUNT(attorneyid) from @SurgeryStuffs where month = 9),0),
	isnull((select COUNT(attorneyid) from @SurgeryStuffs where month = 10),0),
	isnull((select COUNT(attorneyid) from @SurgeryStuffs where month = 11) ,0),
	isnull((select COUNT(attorneyid) from @SurgeryStuffs where month = 12) ,0),
	isnull((select COUNT(attorneyid) from @SurgeryStuffs),	0),
	isnull((select SUM(testCount) from @TestStuffs where month = 1),0),
	isnull((select SUM(testCount) from @TestStuffs where month = 2),0),
	isnull((select SUM(testCount) from @TestStuffs where month = 3),0),
	isnull((select SUM(testCount) from @TestStuffs where month = 4),0),
	isnull((select SUM(testCount) from @TestStuffs where month = 5),0),
	isnull((select SUM(testCount) from @TestStuffs where month = 6),0),
	isnull((select SUM(testCount) from @TestStuffs where month = 7),0),
	isnull((select SUM(testCount) from @TestStuffs where month = 8),0),
	isnull((select SUM(testCount) from @TestStuffs where month = 9),0),
	isnull((select SUM(testCount) from @TestStuffs where month = 10),0),
	isnull((select SUM(testCount) from @TestStuffs where month = 11) ,0),
	isnull((select SUM(testCount) from @TestStuffs where month = 12) ,0),
	isnull((select SUM(testCount) from @TestStuffs), 0)
	
select * from @tempTable

END
GO
