SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************
-- =============================================
-- Author:		John D'Antonio
-- Create date: 4/2/2014
-- Description:	Provider Payments Report
-- =============================================
**************************
** Change History
**************************
** PR   Date         Author    Description 
** --   ----------   -------   ------------------------------------
** 1    04/2/2014    John      Created proc
*******************************/
CREATE PROCEDURE [dbo].[procProviderPaymentsReport]
	@StartDate datetime = null, 
	@EndDate datetime = null,
	@CompanyId int = -1
AS
BEGIN
	SET NOCOUNT ON;
	
	select *
	from (
(
	select P.ID, REPLACE(P.Name,'&','&amp;') as Name, SUM(SIPP.Amount) as Amount, C.LongName as CompanyName
	from Provider as P
	inner join InvoiceProvider as IP on P.ID = IP.ProviderID
	inner join SurgeryInvoice_Providers as SIP on IP.ID = SIP.InvoiceProviderID
	inner join SurgeryInvoice_Provider_Payments as SIPP on SIP.ID = SIPP.SurgeryInvoice_ProviderID
	inner join Company as C on P.CompanyID = C.ID
	where SIPP.DatePaid >= @StartDate 
	and SIPP.DateAdded <= @EndDate
	and P.CompanyID = @CompanyID
	group by P.ID, P.Name, C.LongName
)
union
(
	select P.ID, REPLACE(P.Name,'&','&amp;') as Name, SUM(isnull(TIT.AmountPaidToProvider,0) + isnull(TIT.DepositToProvider, 0)) as Amount, C.LongName as CompanyName
	from Provider as P
	inner join InvoiceProvider as IP on P.ID = IP.ProviderID
	inner join TestInvoice_Test as TIT on IP.ID = TIT.InvoiceProviderID
	inner join Company as C on P.CompanyID = C.ID
	where TIT.Date >= @StartDate 
	and TIT.Date <= @EndDate
	and P.CompanyID = @CompanyID
	group by P.ID, P.Name, C.LongName
)) as res
where res.amount > 0
order by res.Name

END
GO
