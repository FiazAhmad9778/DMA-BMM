-- <Migration ID="74fa7a77-afb0-4b5f-b30f-ce3a7ce1549e" />
GO

PRINT N'Altering [dbo].[f_ConvertDate]'
GO
ALTER FUNCTION [dbo].[f_ConvertDate] 
(
	-- Add the parameters for the function here
	@Date datetime	
)
RETURNS datetime
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result datetime = convert(varchar, @Date, 1)
	
	RETURN @Result

END
GO
PRINT N'Creating [dbo].[procClientPayoffQuotationReport]'
GO

CREATE PROCEDURE [dbo].[procClientPayoffQuotationReport]
	@PatientId int = -1

AS

BEGIN

	SET NOCOUNT ON;

	select
		InvoiceNumber = 'DMA PPO LLC # ' + convert(varchar, i.InvoiceNumber),
		PatientName = trim(p.FirstName) + ' ' + trim(p.LastName),
		Principal = tis.BalanceDue,
		Interest = tis.CumulativeServiceFeeDue,
		BalanceDue = tis.EndingBalance,
		PayoffThroughDate = eomonth(getdate()),
		Attorney = a.LastName + ', ' + a.FirstName
	from
		Invoice i
		inner join InvoiceAttorney ia
			on ia.ID = i.InvoiceAttorneyID
		inner join Attorney a
			on a.ID = ia.AttorneyID
		inner join InvoicePatient invPatient
			on invPatient.ID = i.InvoicePatientID
		inner join Patient p
			on p.ID = invPatient.PatientID
		outer apply dbo.f_GetTestInvoiceSummaryTableMinified(i.ID, null) tis
	where
		i.Active = 1
		and i.CompanyID = 2
		and i.InvoiceTypeID = 1
		and ia.Active = 1
		and invPatient.Active = 1
		and p.ID = 502468	

	union

	select
		InvoiceNumber = 'DMA PPO LLC # ' + convert(varchar, i.InvoiceNumber),
		PatientName = trim(p.FirstName) + ' ' + trim(p.LastName),
		Principal = sis.BalanceDue,
		Interest = sis.CumulativeServiceFeeDue,
		BalanceDue = sis.EndingBalance,
		PayoffThroughDate = eomonth(getdate()),
		Attorney = a.LastName + ', ' + a.FirstName
	from
		Invoice i
		inner join InvoiceAttorney ia
			on ia.ID = i.InvoiceAttorneyID
		inner join Attorney a
			on a.ID = ia.AttorneyID
		inner join InvoicePatient invPatient
			on invPatient.ID = i.InvoicePatientID
		inner join Patient p
			on p.ID = invPatient.PatientID
		outer apply dbo.f_GetSurgeryInvoiceSummaryTableMinified(i.ID, null) sis
	where
		i.Active = 1
		and i.CompanyID = 2
		and i.InvoiceTypeID = 2
		and invPatient.Active = 1
		and p.ID = 502468

END
GO
