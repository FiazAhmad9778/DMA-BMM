SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[StoredProcedure7]
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
As

Select * From InvoiceINterestCalculationLog Where INvoiceID = 212564

--Select * From Invoice Where CompanYID = 1 and InvoiceNumber = 3514

	return 


GO
