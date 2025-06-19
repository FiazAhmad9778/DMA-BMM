CREATE TABLE [dbo].[InvoiceContactList]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Active] [bit] NOT NULL CONSTRAINT [DF_ContactListLog_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_ContactListLog_DateAdded] DEFAULT (getdate()),
[Temp_AttorneyID] [int] NULL,
[Temp_PhysicianID] [int] NULL,
[Temp_ProviderID] [int] NULL,
[Temp_Invoice] [int] NULL,
[Temp_FacilityID] [int] NULL,
[Temp_CompanyID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InvoiceContactList] ADD CONSTRAINT [PK_ContactListLog] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
