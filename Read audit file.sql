--Read Auditlog
SELECT event_time,action_id,succeeded,session_id,object_id,class_type,session_server_principal_name,
server_principal_name,database_name,schema_name,object_name,statement FROM sys.fn_get_audit_file ('W:\Adit\Audit_4C11DE35-59C8-43B5-84A3-202561F40FF9_0_131503499814020000.sqlaudit',default,default);  
GO 
--This code wiil generate deleted transaction details  
SELECT  SPID,
Operation,  
[Transaction ID],  
[Begin Time],  
[Transaction Name],  
[Transaction SID], [Begin Time],[End Time],
SUSER_SNAME ([Transaction SID]) username,
[Replicated Records],[Server Name],[Database Name],[Command Type],Command
FROM fn_dblog (NULL, NULL)  
WHERE [Transaction Name] like '%drop%'
--To get transaction id for the delete transaction
SELECT [Transaction Id], [Begin Time], SUSER_SNAME ([Transaction SID]) AS [User]
FROM fn_dblog (NULL, NULL)
WHERE [Transaction Name] = 'DROPOBJ';
GO

--This code will give you the object ID of the dropped table:

SELECT TOP (1) [Lock Information] FROM fn_dblog (NULL, NULL)
WHERE [Transaction Id] = '0000:000002cf'
AND [Lock Information] LIKE '%SCH_M OBJECT%';
GO