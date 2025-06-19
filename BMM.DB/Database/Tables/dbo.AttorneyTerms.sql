CREATE TABLE [dbo].[AttorneyTerms]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AttorneyID] [int] NOT NULL,
[LoanTermsMonths] [int] NOT NULL,
[YearlyInterest] [decimal] (18, 4) NOT NULL,
[ServiceFeeWaivedMonths] [int] NOT NULL,
[StartDate] [date] NOT NULL,
[EndDate] [date] NULL,
[DateAdded] [datetime] NULL,
[Active] [bit] NULL CONSTRAINT [DF_AttorneyTerms_Active] DEFAULT ((1)),
[Deleted] [bit] NULL CONSTRAINT [DF_AttorneyTerms_Deleted] DEFAULT ((0)),
[TermType] [int] NULL,
[Status] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AttorneyTerms] ADD CONSTRAINT [PK_AttorneyTerms] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
