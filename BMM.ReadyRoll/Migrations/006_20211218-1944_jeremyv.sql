-- <Migration ID="5c3124c8-6884-458c-982a-1b1afad54f2a" />
GO

PRINT N'Altering [dbo].[procClientPayoffQuotationReport]'
GO

ALTER PROCEDURE [dbo].[procClientPayoffQuotationReport]
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
		and p.ID = @PatientId	

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
		and p.ID = @PatientId

END
GO
