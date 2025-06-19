SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[procGetGeneralStatistics]

 @StartDate date,
 @EndDate date,
 @CompanyID int 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @InvoiceTestTypeID INT = 1
	DECLARE @InvoiceSurgeryTypeID INT = 2
	DECLARE @TestTypeMRIID INT = 2

	
	
	--Get the invoice table plus the top test dates and surgery dates
	declare @InvoicePlus table(ID int, InvoiceNumber int, CompanyID int, DateOfAccident datetime, InvoiceStatusTypeID int, InvoiceTypeID int, TestInvoiceID int, SurgeryInvoiceID int, Active bit, topTestDate datetime, topSurgeryDate datetime)

	insert into @InvoicePlus
	select ID,InvoiceNumber,CompanyID, DateOfAccident, InvoiceStatusTypeID, InvoiceTypeID, TestInvoiceID int, SurgeryInvoiceID int, Active,
		(select top 1 TestDate
			from TestInvoice as TI
			inner join TestInvoice_Test as TIT on TI.ID = TIT.TestInvoiceID
			inner join Invoice as I on TI.ID = I.TestInvoiceID
			Where I.ID = Inv.ID
			and I.Active = 1
			and TI.Active = 1
			and TIT.Active = 1
			order by TestDate asc) as topTestDate,
		(select top 1 SISD.ScheduledDate
			from SurgeryInvoice as SI
			inner join SurgeryInvoice_Surgery as SIS on SI.ID = SIS.SurgeryInvoiceID
			inner join Invoice as I on SI.ID = I.SurgeryInvoiceID
			inner join SurgeryInvoice_SurgeryDates as SISD on SIS.ID = SISD.SurgeryInvoice_SurgeryID
			where I.ID = Inv.ID
			and I.Active = 1
			and SI.Active = 1
			and SIS.Active = 1
			and SISD.Active = 1
			order by SISD.ScheduledDate asc) as topSurgeryDate
	from Invoice as Inv


	SELECT (SELECT ISNULL(SUM(ISNULL(tit.NumberOfTests, 0)), 0)
				from TestInvoice_Test tit
				inner join Test t on t.ID = tit.TestID
				where t.CompanyID=@CompanyID
				and tit.isCanceled = 0
				and tit.Active = 1
				AND ((CONVERT(DATE, tit.TestDate, 112) BETWEEN @StartDate AND @EndDate) or (CONVERT(DATE, tit.TestDate, 112) BETWEEN @StartDate AND @EndDate))
			) AS TotalTests,
			(SELECT COUNT(*)
				FROM @InvoicePlus I
					INNER JOIN TestInvoice TI ON TI.ID=I.TestInvoiceID AND TI.TestTypeID=@TestTypeMRIID
				WHERE I.Active=1
					AND I.CompanyID=@CompanyID
					AND I.InvoiceTypeID=@InvoiceTestTypeID
					AND ((CONVERT(DATE, I.topSurgeryDate, 112) BETWEEN @StartDate AND @EndDate) or (CONVERT(DATE, I.topTestDate, 112) BETWEEN @StartDate AND @EndDate))
			) AS TotalMRIs,
			(SELECT COUNT(Distinct sis.ID)
					from SurgeryInvoice_Surgery sis
					inner join SurgeryInvoice_SurgeryDates sisd on sisd.SurgeryInvoice_SurgeryID = sis.ID
					inner join Surgery s on sis.SurgeryID = s.ID
					where s.CompanyID = @CompanyID
					and sisd.Active = 1
					and sis.Active = 1
					and sis.isCanceled = 0
					and SurgeryInvoice_SurgeryID = sis.ID -- added individual line on  12/3/2014 by Cherie
					AND ((CONVERT(DATE, sisd.ScheduledDate, 112) BETWEEN @StartDate AND @EndDate)) -- added individual line on  12/3/2014 by Cherie
					--Commented out below on 12/3/2014 by Cherie Walker so that all scheduled dates show up in the surgery count.
					--AND ((CONVERT(DATE, (select top 1 ScheduledDate
					--					 from SurgeryInvoice_SurgeryDates
					--					 where SurgeryInvoice_SurgeryID = sis.ID and Active = 1 -- Added on 10/2/2014 to remove inactive dates by Cherie
					--					 order by ScheduledDate asc), 112) BETWEEN @StartDate AND @EndDate))
			) AS TotalSurgeries,
			(SELECT ISNULL(SUM(ISNULL(P.Amount, 0)), 0)
				FROM Payments p
					inner join Invoice i on i.ID = p.InvoiceID AND i.Active = 1
				where Convert(date, p.DatePaid, 112) between @StartDate and @EndDate
				and p.Active = 1 and i.CompanyID = @CompanyID)
			 AS TotalAmountCollected,
			(SELECT
				(SELECT ISNULL(SUM(ISNULL(ti.DepositToProvider, 0) + ISNULL(ti.AmountPaidToProvider, 0)), 0)
					FROM TestInvoice_Test ti
						 inner join Test t on ti.TestID = t.ID
						 where ti.Active = 1 and t.CompanyID = @CompanyID
						 AND Convert(date, ti.Date, 112) BETWEEN @StartDate AND @EndDate)										
				 +
				(select SUM(spp.Amount)
					from SurgeryInvoice_Provider_Payments spp
						  inner join SurgeryInvoice_Providers sip on spp.SurgeryInvoice_ProviderID = sip.ID
						  inner join InvoiceProvider ip on sip.InvoiceProviderID = ip.ID
						  inner join Provider p on ip.ProviderID = p.ID
						  where spp.Active = 1 and p.CompanyID = @CompanyID
						  AND CONVERT(date, spp.DatePaid, 112) BETWEEN @StartDate AND @EndDate)
				)
			 AS TotalPaymentsMade														

END
GO
