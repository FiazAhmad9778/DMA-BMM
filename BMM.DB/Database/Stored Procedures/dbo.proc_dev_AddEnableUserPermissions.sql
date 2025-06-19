SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Bursavich, Andrew
-- Create date: 2012.01.09
-- Description:	Adds or enables all permissions for a user
-- =============================================
CREATE PROCEDURE [dbo].[proc_dev_AddEnableUserPermissions]
	@UserID int
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE UserPermissions
	SET AllowView=1, AllowAdd=1, AllowEdit=1, AllowDelete=1, Active=1
	WHERE UserID=@UserID

	INSERT INTO UserPermissions (UserID, PermissionID, AllowView, AllowAdd, AllowEdit, AllowDelete, Active)
	SELECT @UserID, P.ID, 1, 1, 1, 1, 1
	FROM [Permissions] P
	LEFT JOIN UserPermissions UP ON UP.PermissionID=P.ID AND UP.UserID=@UserID
	WHERE P.Active=1 AND UP.ID IS NULL

END
GO
