SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[procSearchInvoice_GetByFirstServiceDate]


 @SearchDate datetime

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

declare @SearchDateStr varchar(10) = Convert(varchar(10),@SearchDate,101)
declare @TopDateTable table(InvID int, InvoicePatientID int, TopTestDate datetime, TopSurgeryDate datetime)

insert into @TopDateTable
select Inv.ID, Inv.InvoicePatientID, 
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


select distinct P.ID
from @TopDateTable
inner join InvoicePatient as IP on InvoicePatientID = IP.ID
inner join Patient as P on PatientID = P.ID
where Convert(varchar(10),TopSurgeryDate,101) = @SearchDateStr
or Convert(varchar(10),TopTestDate,101) = @SearchDateStr

END
GO
