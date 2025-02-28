SELECT  Groups.[name] AS AGName ,
Databaselist.[database_name] AS DatabaseName
FROM    sys.availability_databases_cluster Databaselist
INNER JOIN sys.availability_groups_cluster Groups ON Databaselist.group_id = Groups.group_id
ORDER BY
DatabaseName;