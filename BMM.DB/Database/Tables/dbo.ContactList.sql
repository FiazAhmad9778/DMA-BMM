CREATE TABLE [dbo].[ContactList]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Active] [bit] NOT NULL CONSTRAINT [DF_CommentType_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_CommentType_DateAdded] DEFAULT (getdate()),
[Temp_AttorneyID] [int] NULL,
[Temp_ProviderID] [int] NULL,
[Temp_PhysicianID] [int] NULL,
[Temp_FacilityID] [int] NULL,
[Temp_CompanyID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ContactList] ADD CONSTRAINT [PK_ContactList] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
