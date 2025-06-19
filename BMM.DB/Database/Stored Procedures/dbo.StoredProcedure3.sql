SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Procedure [dbo].[StoredProcedure3]
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
As

Select * From Patient Where CompanyID = 1 and Patient.Temp_InvoiceID in (1513, 1535)
	/* set nocount on */
	return 


GO
