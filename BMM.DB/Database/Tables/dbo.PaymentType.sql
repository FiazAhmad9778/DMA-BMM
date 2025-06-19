CREATE TABLE [dbo].[PaymentType]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_PaymentType_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_PaymentType_DateAdded] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PaymentType] ADD CONSTRAINT [PK_PaymentType] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
