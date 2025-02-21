SQL Index Fragmentation and sys.dm_db_index_physical_stats 


02 January,2012 by Jack Vamvas  



Index Fragmentation of an index can severely affect performance. When logical ordering of the key within a page does not match the physical ordering within the data file, fragmentation exists.

I execute index maintenance scripts  for databases on a regular basis.  If I’m executing a  custom job, such as a large UPDATE , I may need to analyse just one index on a single table.

Use the SQL views: sys.sysdatabases,  sys.sysobjects,  sys.sysindexes  to find  , all the relevant ids.  Push the ids as values on the sys.dm_db_index_physical_stats view.

The SQL Server DMV sys.dm_db_index_physical_stats present fragmentation information for data and indexes.

 
USE MyDB
GO
DECLARE @ixId INT,@dbase_id INT,@table_id INT
SELECT @dbase_id=dbid FROM sys.sysdatabases  WHERE name = 'MyDB'
SELECT @table_id=id FROM sys.sysobjects WHERE name = 'MyTable' AND xtype = 'U'
SELECT @ixId=indid FROM sys.sysindexes WHERE id=OBJECT_ID('dbo.MyTable') and [name] = 'MyIndex'

SELECT * FROM sys.dm_db_index_physical_stats(@dbase_id,@table_id,@ixId,NULL,'LIMITED')

