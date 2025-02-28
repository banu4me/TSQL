--SELECT ag.name AS AvailabilityGroupName FROM sys.availability_groups ag;

-- List AG Replica Details 
select n.group_name,n.replica_server_name,n.node_name,rs.role_desc 
from sys.dm_hadr_availability_replica_cluster_nodes n 
join sys.dm_hadr_availability_replica_cluster_states cs 
on n.replica_server_name = cs.replica_server_name 
join sys.dm_hadr_availability_replica_states rs  
on rs.replica_id = cs.replica_id 

--To check Hadr_endpoint 
SELECT e.name AS mirror_endpoint_name
    ,s.name AS login_name
    ,p.permission_name
    ,p.state_desc AS permission_state
    ,e.state_desc endpoint_state
FROM sys.server_permissions p
INNER JOIN sys.endpoints e ON p.major_id = e.endpoint_id
INNER JOIN sys.server_principals s ON p.grantee_principal_id = s.principal_id
WHERE p.class_desc = 'ENDPOINT'
    AND e.type_desc = 'DATABASE_MIRRORING'