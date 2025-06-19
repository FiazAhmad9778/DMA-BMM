CREATE TABLE [dbo].[Temp_TestTimeValConversionTEXTToTIME]
(
[TestTimeTEXT] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TestTimeTIME] [time] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Temp_TestTimeValConversionTEXTToTIME] ADD CONSTRAINT [PK_Temp_TestTimeValConversionTEXTToTIME] PRIMARY KEY CLUSTERED  ([TestTimeTEXT]) ON [PRIMARY]
GO
