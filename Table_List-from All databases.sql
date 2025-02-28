-- Create a temporary table to hold the results from all databases.
IF OBJECT_ID('tempdb..#UserTableSizes') IS NOT NULL
    DROP TABLE #UserTableSizes;

CREATE TABLE #UserTableSizes
(
    DatabaseName sysname,
    SchemaName   sysname,
    TableName    sysname,
    TotalSpaceMB decimal(18,2)
);

-- Loop through each database (excluding system databases) to collect table size info.
EXEC sp_MSforeachdb '
IF ''?'' NOT IN (''master'',''model'',''msdb'',''tempdb'')
BEGIN
    INSERT INTO #UserTableSizes (DatabaseName, SchemaName, TableName, TotalSpaceMB)
    SELECT
         ''?'' AS DatabaseName,
         sch.name AS SchemaName,
         tbl.name AS TableName,
         CAST(SUM(au.total_pages) * 8.0 / 1024 AS decimal(18,2)) AS TotalSpaceMB
    FROM [?].sys.tables AS tbl
    INNER JOIN [?].sys.schemas AS sch 
         ON tbl.schema_id = sch.schema_id
    INNER JOIN [?].sys.indexes AS idx 
         ON tbl.object_id = idx.object_id
    INNER JOIN [?].sys.partitions AS par 
         ON idx.object_id = par.object_id 
         AND idx.index_id = par.index_id
    INNER JOIN [?].sys.allocation_units AS au 
         ON par.partition_id = au.container_id
    GROUP BY sch.name, tbl.name
END
';

-- Select the gathered information with the server name.
SELECT 
    SERVERPROPERTY('MachineName') AS ServerName,
    DatabaseName,
    SchemaName,
    TableName,
    TotalSpaceMB
FROM #UserTableSizes
ORDER BY DatabaseName, SchemaName, TableName;

-- Clean up the temporary table.
DROP TABLE #UserTableSizes;
