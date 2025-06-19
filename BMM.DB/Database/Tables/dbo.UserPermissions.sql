CREATE TABLE [dbo].[UserPermissions]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[UserID] [int] NOT NULL,
[PermissionID] [int] NOT NULL,
[AllowView] [bit] NOT NULL,
[AllowAdd] [bit] NOT NULL,
[AllowEdit] [bit] NOT NULL,
[AllowDelete] [bit] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_UserPermissions_Active] DEFAULT ((1)),
[DateAdded] [datetime] NOT NULL CONSTRAINT [DF_UserPermissions_DateAdded] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserPermissions] ADD CONSTRAINT [PK_UserPermissions] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserPermissions] ADD CONSTRAINT [FK_UserPermissions_Permissions] FOREIGN KEY ([PermissionID]) REFERENCES [dbo].[Permissions] ([ID])
GO
ALTER TABLE [dbo].[UserPermissions] ADD CONSTRAINT [FK_UserPermissions_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([ID])
GO
