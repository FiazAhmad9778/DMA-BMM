SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[svcUpdateAttorneyTerms] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ATQueueIDs TABLE (ID int, Processed int)
	DECLARE @ATIDs TABLE (ID int)
	DECLARE @Process int = 0
	DECLARE @Processed int = 1
	DECLARE @AtID int	

    -- Insert statements for procedure here
	--INSERT INTO @ATQueueIDs
	--(ID, Processed)
	--select ID, @Process
	--from AttorneyTerms
	--where Active = 1

	 --while (select COUNT(*) from @ATQueueIDs where Processed = 0) > 0
    --BEGIN
		--select top 1 @AtID = ID from @ATQueueIDs where Processed = 0
		update AttorneyTerms set Active = 0, Status = 'ENDED'
		where EndDate < GETDATE()
		
		update AttorneyTerms set Status = 'Current'
		where StartDate <= GETDATE() AND Status = '(Scheduled)' AND (EndDate > GETDATE() or EndDate is null)

		--update @AtQueueIDs set Processed = 1 where ID = @AtID
	--END
END

GO
