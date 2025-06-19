SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[procAttorneyListReport] 
	-- Add the parameters for the stored procedure here
	@CompanyID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		a.LastName + ', ' + a.FirstName as AttorneyName,
		f.Name as FirmName,
		CASE
			WHEN a.Street2 is not null THEN 
			a.Street1 + ' ' + a.Street2 + ' ' + a.City + ', ' + s.Abbreviation + ' ' + a.ZipCode
			ELSE
			a.Street1 + ' ' + a.City + ', ' + s.Abbreviation + ' ' + a.ZipCode
		END as AttorneyAddress,
		a.Phone as PhoneNumber,
		a.Email as Email,
		c.LongName as CompanyName,
		CASE
			WHEN a.isActiveStatus = 1 THEN 'Active'
			ELSE 'Inactive'
		END as AttorneyStatus,
		CASE
			WHEN
		(SELECT top 1 atinner1.YearlyInterest FROM AttorneyTerms atinner1
		 WHERE atinner1.TermType = 2 and atinner1.Status = 'Current' and atinner1.AttorneyID = a.ID and atinner1.Active = 1 and atinner1.Deleted = 0) is not null
		 THEN (SELECT top 1 atinner1.YearlyInterest FROM AttorneyTerms atinner1
				WHERE atinner1.TermType = 2 and atinner1.Status = 'Current' and atinner1.AttorneyID = a.ID and atinner1.Active = 1 and atinner1.Deleted = 0)
		 ELSE
			(SELECT top 1 Surgery_YearlyInterest FROM LoanTerms WHERE CompanyID = @CompanyID AND Active = 1 order by DateAdded desc)
		 END as SurgeryYearlyInterest,

		 CASE
			WHEN
		 (SELECT top 1 atinner1.LoanTermsMonths FROM AttorneyTerms atinner1
		 WHERE atinner1.TermType = 2 and atinner1.Status = 'Current' and atinner1.AttorneyID = a.ID and atinner1.Active = 1 and atinner1.Deleted = 0) is not null
		 THEN
			(SELECT top 1 atinner1.LoanTermsMonths FROM AttorneyTerms atinner1
			WHERE atinner1.TermType = 2 and atinner1.Status = 'Current' and atinner1.AttorneyID = a.ID and atinner1.Active = 1 and atinner1.Deleted = 0)
		 ELSE
			(SELECT top 1 Surgery_LoanTermMonths FROM LoanTerms WHERE CompanyID = @CompanyID AND Active = 1 order by DateAdded desc)
		 END as SurgeryLoanTerms,

		 CASE 
			WHEN
		 (SELECT top 1 atinner1.ServiceFeeWaivedMonths FROM AttorneyTerms atinner1
		 WHERE atinner1.TermType = 2 and atinner1.Status = 'Current' and atinner1.AttorneyID = a.ID and atinner1.Active = 1 and atinner1.Deleted = 0) is not null
		 THEN 
			(SELECT top 1 atinner1.ServiceFeeWaivedMonths FROM AttorneyTerms atinner1
			WHERE atinner1.TermType = 2 and atinner1.Status = 'Current' and atinner1.AttorneyID = a.ID and atinner1.Active = 1 and atinner1.Deleted = 0)
		 ELSE
			(SELECT top 1 Surgery_ServiceFeeWaivedMonths FROM LoanTerms WHERE CompanyID = @CompanyID AND Active = 1 order by DateAdded desc)
		 END as SurgeryServiceFeeWaived,

		 CASE
			WHEN
		 (SELECT top 1 atinner1.YearlyInterest FROM AttorneyTerms atinner1
		 WHERE atinner1.TermType = 1 and atinner1.Status = 'Current' and atinner1.AttorneyID = a.ID and atinner1.Active = 1 and atinner1.Deleted = 0) is not null
		 THEN
			(SELECT top 1 atinner1.YearlyInterest FROM AttorneyTerms atinner1
			WHERE atinner1.TermType = 1 and atinner1.Status = 'Current' and atinner1.AttorneyID = a.ID and atinner1.Active = 1 and atinner1.Deleted = 0)
		 ELSE
			(SELECT top 1 Testing_YearlyInterest FROM LoanTerms WHERE CompanyID = @CompanyID AND Active = 1 order by DateAdded desc)
		 END as TestYearlyInterest,

		 CASE
			WHEN
		 (SELECT top 1 atinner1.LoanTermsMonths FROM AttorneyTerms atinner1
		 WHERE atinner1.TermType = 1 and atinner1.Status = 'Current' and atinner1.AttorneyID = a.ID and atinner1.Active = 1 and atinner1.Deleted = 0) is not null
		 THEN 
			(SELECT top 1 atinner1.LoanTermsMonths FROM AttorneyTerms atinner1
			WHERE atinner1.TermType = 1 and atinner1.Status = 'Current' and atinner1.AttorneyID = a.ID and atinner1.Active = 1 and atinner1.Deleted = 0)
		 ELSE
			(SELECT top 1 Testing_LoanTermMonths FROM LoanTerms WHERE CompanyID = @CompanyID AND Active = 1 order by DateAdded desc)
		 END as TestLoanTerms,

		 CASE
			WHEN
		 (SELECT top 1 atinner1.ServiceFeeWaivedMonths FROM AttorneyTerms atinner1
		 WHERE atinner1.TermType = 1 and atinner1.Status = 'Current' and atinner1.AttorneyID = a.ID and atinner1.Active = 1 and atinner1.Deleted = 0) is not null
		 THEN
			(SELECT top 1 atinner1.ServiceFeeWaivedMonths FROM AttorneyTerms atinner1
		 WHERE atinner1.TermType = 1 and atinner1.Status = 'Current' and atinner1.AttorneyID = a.ID and atinner1.Active = 1 and atinner1.Deleted = 0)
		 ELSE
			(SELECT top 1 Testing_ServiceFeeWaivedMonths FROM LoanTerms WHERE CompanyID = @CompanyID AND Active = 1 order by DateAdded desc)
		 END as TestServiceFeeWaived

	FROM Attorney a
	left outer join Firm f on a.FirmID = f.ID
	left outer join States s on a.StateID = s.ID
	left outer join Company c on a.CompanyID = c.ID
	WHERE a.CompanyID = @CompanyID and a.isActiveStatus = 1
	order by a.LastName,a.FirstName
END

GO
