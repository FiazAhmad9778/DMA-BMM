SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[StoredProcedure1]
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
As
Select * from InvoiceProvider where InvoiceProvider.Temp_CompanyID = 1 and InvoiceProvider.Temp_InvoiceID  = 3212
	return 


GO
