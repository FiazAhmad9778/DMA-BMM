-- <Migration ID="3028038c-7d72-49ad-b145-562317ef5ced" />
GO

PRINT N'Creating [dbo].[AccountsReceivableHistory]'
GO
CREATE TABLE [dbo].[AccountsReceivableHistory]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[EndingBalance] [money] NOT NULL,
[InsDate] [datetime] NOT NULL
)
GO
PRINT N'Creating primary key [PK_AccountsReceivableHistory] on [dbo].[AccountsReceivableHistory]'
GO
ALTER TABLE [dbo].[AccountsReceivableHistory] ADD CONSTRAINT [PK_AccountsReceivableHistory] PRIMARY KEY CLUSTERED  ([ID])
GO
PRINT N'Creating [dbo].[procAccountsReceivableHistory_Ins]'
GO

CREATE PROCEDURE [dbo].[procAccountsReceivableHistory_Ins]
AS

BEGIN
	SET NOCOUNT ON;

	IF OBJECT_ID(N'tempdb.dbo.#tmp', N'U') IS NOT NULL
		DROP TABLE #tmp

	CREATE TABLE #tmp
	(
		[Type] varchar(max),
		InvoiceNumber int,
		ServiceDate varchar(max),
		DateServiceFeeBegins datetime,
		[Provider] varchar(max),
		ServiceName varchar(max),
		AttorneyFirstName varchar(max),
		AttorneyLastName varchar(max),
		AttorneyDisplayName varchar(max),
		FirmName varchar(max),
		PatientFirstName varchar(max),
		PatientLastName varchar(max),
		PatientDisplayName varchar(max),
		TotalCost decimal(18,2),
		PaymentAmount decimal(18,2),
		PPODiscount decimal(18,2),
		BalanceDue decimal(18,2),
		ServiceFeeDue decimal(18,2),
		EndingBalance decimal(18,2),
		TotalDue decimal(18,2),
		Comment varchar(2000),
		InvoiceCompleted bit,
		DueDate datetime,
		CompanyName varchar(max),
		SortServiceDate datetime,
		StatusType int,
		IsPastDue bit
	)

	declare @Now datetime = getdate()
	insert into #tmp exec procAccountsReceivableReport '1/1/1753', @Now, 2
	insert into AccountsReceivableHistory (EndingBalance, InsDate) values ((select sum(EndingBalance) from #tmp), @Now)	

END
GO
PRINT N'Creating [dbo].[procAccountsReceivableHistory_Sel]'
GO

CREATE PROCEDURE [dbo].[procAccountsReceivableHistory_Sel]
	@StartDate datetime = null, 
	@EndDate datetime = null,
	@CompanyId int = -1
AS

BEGIN
	SET NOCOUNT ON;

	select
		*
	from
		AccountsReceivableHistory arh
	where
		convert(date, arh.InsDate) between @StartDate and @EndDate

END
GO
