CREATE TABLE [dbo].[TestInvoice_Test_CPTCodes]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[TestInvoice_TestID] [int] NOT NULL,
[CPTCodeID] [int] NOT NULL,
[Amount] [decimal] (18, 2) NOT NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_TestInvoice_Test_CPTCodes_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_TestInvoice_Test_CPTCodes_DateAdded] DEFAULT (getdate()),
[Temp_CompanyID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[TestInvoice_Test_CPTCodes] ADD CONSTRAINT [PK_TestInvoice_Test_CPTCodes] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_TestInvoice_Test_CPTCodes_missing_31] ON [dbo].[TestInvoice_Test_CPTCodes] ([TestInvoice_TestID], [Active]) INCLUDE ([Amount]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TestInvoice_Test_CPTCodes] ADD CONSTRAINT [FK_TestInvoice_Test_CPTCodes_TestInvoice_Test] FOREIGN KEY ([TestInvoice_TestID]) REFERENCES [dbo].[TestInvoice_Test] ([ID])
GO
