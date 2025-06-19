CREATE TABLE [dbo].[Patient]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CompanyID] [int] NOT NULL,
[isActiveStatus] [bit] NOT NULL CONSTRAINT [DF_Patient_isActiveStatus] DEFAULT ((1)),
[FirstName] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastName] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSN] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Street1] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Street2] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StateID] [int] NOT NULL,
[ZipCode] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Phone] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WorkPhone] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateOfBirth] [date] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Patient_Active] DEFAULT ((1)),
[DateAdded] [datetime] NULL CONSTRAINT [DF_Patient_DateAdded] DEFAULT (getdate()),
[Temp_InvoiceID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Patient] ADD CONSTRAINT [PK_Patient] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Patient] ON [dbo].[Patient] ([ID], [Active]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Patient] ADD CONSTRAINT [FK_Patient_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Company] ([ID])
GO
ALTER TABLE [dbo].[Patient] ADD CONSTRAINT [FK_Patient_States] FOREIGN KEY ([StateID]) REFERENCES [dbo].[States] ([ID])
GO
