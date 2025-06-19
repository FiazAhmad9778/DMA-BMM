IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'BMM-SQL\cwalker')
CREATE LOGIN [BMM-SQL\cwalker] FROM WINDOWS
GO
CREATE USER [BMM-SQL\cwalker] FOR LOGIN [BMM-SQL\cwalker]
GO
