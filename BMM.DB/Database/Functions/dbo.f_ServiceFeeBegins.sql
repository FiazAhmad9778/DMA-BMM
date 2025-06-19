SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Bursavich, Andy
-- Create date: 2012.09.28
-- =============================================
CREATE FUNCTION [dbo].[f_ServiceFeeBegins]
(
	@AmortizationDate datetime,
	@ServiceFeeWaivedMonths int
)
RETURNS datetime
AS
BEGIN

	RETURN  DATEADD(MONTH, @ServiceFeeWaivedMonths+1, CONVERT(DATE, CONVERT(CHAR(2), DATEPART(MONTH, @AmortizationDate)) + '/1/' + CONVERT(CHAR(4), DATEPART(YEAR, @AmortizationDate))))

END
GO
