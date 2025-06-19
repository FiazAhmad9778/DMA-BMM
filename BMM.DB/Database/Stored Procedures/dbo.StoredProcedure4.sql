SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Procedure [dbo].[StoredProcedure4]
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
As

select I.ID as InvoiceID,I.InvoiceNumber,I.CompanyID,I.InvoicePatientID,IP.Active as [InvoicePatient.Active],IP.PatientID,P.Active as [Patient.Active] from Invoice as Iinner join InvoicePatient as IP on I.InvoicePatientID = IP.IDinner join Patient as P on IP.PatientID = P.IDwhere InvoiceNumber in (1535,1827,1883,1885,1886,1956,2105)and I.CompanyID = 1


	return 


GO
