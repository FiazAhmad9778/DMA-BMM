IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'AppUser')
CREATE LOGIN [AppUser] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [AppUser] FOR LOGIN [AppUser]
GO
