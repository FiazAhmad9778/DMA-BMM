IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'BMM-SQL\lizzie')
CREATE LOGIN [BMM-SQL\lizzie] FROM WINDOWS
GO
CREATE USER [BMM-SQL\lizzie] FOR LOGIN [BMM-SQL\lizzie]
GO
