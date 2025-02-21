-- Get I/O utilization by database (IO Usage By Database)
-- Helps determine which database is using the most I/O resources on the instance
-- Scripts adopted from SQL Server 2008 R2 Diagnostic Information Queries (February 2013).sql

SELECT 
	DB_NAME(database_id) AS [Database Name],
	CAST(SUM(num_of_bytes_read + num_of_bytes_written)/1048576 AS DECIMAL(12, 2)) AS io_in_mb
FROM 
	sys.dm_io_virtual_file_stats(NULL, NULL) AS [DM_IO_STATS]
GROUP BY database_id;

