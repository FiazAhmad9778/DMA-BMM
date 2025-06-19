SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[IndexFragmentationCleanup]
AS
DECLARE @reIndexRequest VARCHAR(1000)

DECLARE reIndexList CURSOR
FOR
SELECT INDEX_PROCESS
FROM (
    SELECT CASE 
            WHEN avg_fragmentation_in_percent BETWEEN 5
                    AND 30
                THEN 'ALTER INDEX [' + i.NAME + '] ON [' + t.NAME + '] REORGANIZE;'
            WHEN avg_fragmentation_in_percent > 30
                THEN 'ALTER INDEX [' + i.NAME + '] ON [' + t.NAME + '] REBUILD with(ONLINE=ON);'
            END AS INDEX_PROCESS
        ,avg_fragmentation_in_percent
        ,t.NAME
    FROM sys.dm_db_index_physical_stats(NULL, NULL, NULL, NULL, NULL) AS a
    INNER JOIN sys.indexes AS i ON a.object_id = i.object_id
        AND a.index_id = i.index_id
    INNER JOIN sys.tables t ON t.object_id = i.object_id
    WHERE i.NAME IS NOT NULL
    ) PROCESS
WHERE PROCESS.INDEX_PROCESS IS NOT NULL
ORDER BY avg_fragmentation_in_percent DESC

OPEN reIndexList

FETCH NEXT
FROM reIndexList
INTO @reIndexRequest

WHILE @@FETCH_STATUS = 0
BEGIN
    BEGIN TRY

        PRINT @reIndexRequest;

        EXEC (@reIndexRequest);

    END TRY

    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT @ErrorMessage = 'UNABLE TO CLEAN UP INDEX WITH: ' + @reIndexRequest + ': MESSAGE GIVEN: ' + ERROR_MESSAGE()
            ,@ErrorSeverity = 9 
            ,@ErrorState = ERROR_STATE();

    END CATCH;

    FETCH NEXT
    FROM reIndexList
    INTO @reIndexRequest
END

CLOSE reIndexList;

DEALLOCATE reIndexList;

RETURN 0

GO
