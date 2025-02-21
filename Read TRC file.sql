--To find the default path of trace file in SQL Server
SELECT
	 path AS [Default Trace File]
	,max_size AS [Max File Size of Trace File]
	,max_files AS [Max No of Trace Files]
	,start_time AS [Start Time]
	,last_event_time AS [Last Event Time]
FROM sys.traces WHERE is_default = 1
GO
--
--How to Load SQL Server Trace File in SQL Server Table
USE tempdb
GO

IF OBJECT_ID('dbo.TraceTable', 'U') IS NOT NULL
	DROP TABLE dbo.TraceTable;

SELECT * INTO TraceTable
FROM ::fn_trace_gettable
('C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\Log\log_36.trc', default)
GO
--else
--SELECT * INTO TraceTable
--FROM ::fn_trace_gettable
--((SELECT path AS [Default Trace File] FROM sys.traces WHERE is_default = 1), default)
--GO

--select * FROM tempdb.dbo.TraceTable WHERE DatabaseName ='LearningCT'

SELECT
	 DatabaseID
	,DatabaseName
	,LoginName
	,HostName
	,ApplicationName
	,StartTime
	,CASE
		WHEN EventClass = 46 THEN 'Database Created'
		WHEN EventClass = 47 THEN 'Database Dropped'
	ELSE 'NONE'
	END AS EventType
 FROM tempdb.dbo.TraceTable WHERE DatabaseName = 'test'
		AND (EventClass = 46 /* Event Class 46 refers to Object:Created */
			OR EventClass = 47) /* Event Class 47 refers to Object:Deleted */
GO