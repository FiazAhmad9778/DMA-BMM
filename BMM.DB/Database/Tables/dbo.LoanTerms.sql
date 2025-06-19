CREATE TABLE [dbo].[LoanTerms]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CompanyID] [int] NOT NULL,
[Testing_YearlyInterest] [decimal] (18, 4) NOT NULL,
[Testing_LoanTermMonths] [int] NOT NULL,
[Testing_ServiceFeeWaivedMonths] [int] NOT NULL,
[Surgery_YearlyInterest] [decimal] (18, 4) NOT NULL,
[Surgery_LoanTermMonths] [int] NOT NULL,
[Surgery_ServiceFeeWaivedMonths] [int] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_LoanTerms_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_LoanTerms_DateAdded] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LoanTerms] ADD CONSTRAINT [PK_LoanTerms] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LoanTerms] ADD CONSTRAINT [FK_LoanTerms_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Company] ([ID])
GO
