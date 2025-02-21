USE my_database
GO
SELECT  members.name as 'members_name', roles.name as 'roles_name',roles.type_desc as 'roles_desc',members.type_desc as 'members_desc'
FROM sys.database_role_members rolemem
INNER JOIN sys.database_principals roles
    ON rolemem.role_principal_id = roles.principal_id
INNER JOIN sys.database_principals members
    ON rolemem.member_principal_id = members.principal_id
	where roles.name = 'db_owner'
ORDER BY members.name
