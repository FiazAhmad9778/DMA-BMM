SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[StoredProcedure6]
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
As
Select * From Patient  
Where Temp_InvoiceID in (2135,2136,2198,2315,2344 
)
and CompanyID = 1


	return 


GO
