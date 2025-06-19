-- <Migration ID="a0f2ebe6-a4e6-49b3-8984-6b8d79756376" />
GO

PRINT N'Altering [dbo].[procClientPayoffQuotationReport]'
GO

ALTER PROCEDURE [dbo].[procClientPayoffQuotationReport]
	@PatientId int = -1,
	@PayoffDate datetime = null,
	@DateOfAccident datetime = null
AS

BEGIN

	SET NOCOUNT ON;

	select
		InvoiceNumber = 'DMA PPO LLC # ' + convert(varchar, i.InvoiceNumber),
		PatientName = trim(p.FirstName) + ' ' + trim(p.LastName),
		Principal = tis.BalanceDue - isnull(i.LossesAmount, 0),
		Interest = isnull(iip.NewCumulativeInterest, tis.CumulativeServiceFeeDue),
		BalanceDue = iif(iip.NewCumulativeInterest is null, tis.EndingBalance - isnull(i.LossesAmount, 0), iip.BalanceDue - isnull(i.LossesAmount, 0) + iip.NewCumulativeInterest),
		Complete = i.isComplete,
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
		outer apply dbo.f_GetInvoiceInterestPayoffTable(i.ID, @PayoffDate) iip 
	where
		i.Active = 1
		and i.CompanyID = 2
		and i.InvoiceTypeID = 1
		and (i.DateOfAccident = @DateOfAccident or @DateOfAccident is null)
		and ia.Active = 1
		and invPatient.Active = 1
		and p.ID = @PatientId	

	union

	select
		InvoiceNumber = 'DMA PPO LLC # ' + convert(varchar, i.InvoiceNumber),
		PatientName = trim(p.FirstName) + ' ' + trim(p.LastName),
		Principal = sis.BalanceDue - isnull(i.LossesAmount, 0),
		Interest = isnull(iip.NewCumulativeInterest, sis.CumulativeServiceFeeDue),
		BalanceDue = iif(iip.NewCumulativeInterest is null, sis.EndingBalance, iip.BalanceDue - isnull(i.LossesAmount, 0) + iip.NewCumulativeInterest),
		Complete = i.isComplete,
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
		outer apply dbo.f_GetInvoiceInterestPayoffTable(i.ID, @PayoffDate) iip 
	where
		i.Active = 1
		and i.CompanyID = 2
		and i.InvoiceTypeID = 2
		and (i.DateOfAccident = @DateOfAccident or @DateOfAccident is null)
		and invPatient.Active = 1
		and p.ID = @PatientId

END
GO
