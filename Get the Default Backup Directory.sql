-- get the default backup directory
DECLARE    @BackupDirectory varchar(1000)

EXEC master.dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE',
N'Software\Microsoft\MSSQLServer\MSSQLServer',N'BackupDirectory',@BackupDirectory OUTPUT;

SELECT  @BackupDirectory;

