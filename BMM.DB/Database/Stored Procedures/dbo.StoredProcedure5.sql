SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Procedure [dbo].[StoredProcedure5]
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
As


Select * From InvoicePatient Where DateAdded > '3/25/2014'
	return 


GO
