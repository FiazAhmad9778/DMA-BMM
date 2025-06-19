SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Procedure [dbo].[StoredProcedure2]
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
As
Select * From TestInvoice_Test where TestInvoice_Test.Temp_CompanyID = 1 and TestInvoice_Test.Temp_InvoiceID in (1535, 1513)
order by ID
	return 


GO
