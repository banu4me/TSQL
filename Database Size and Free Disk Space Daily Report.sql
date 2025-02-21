/*

NAME: Db_Details

PURPOSE:View details of all databases on this SQL server Instance:

Database_name, Database_size_kb,Database_size_mb,DBID,Filename

INPUT PARAMETERS :

EXAMPLE : Db_Details

NOTE:

 */

 CREATE PROCEDURE [dbo].[Db_Details]

AS

BEGIN

 

      set nocount on

    declare @name sysname

    declare @SQL  nvarchar(600)

 

    /* Use temporary table to sum up database size w/o using group by */

    create table #databases (

                  DATABASE_ID int NOT NULL,

                  size decimal(38,2) NOT NULL)

 

    declare c1 cursor for

        select name from master.dbo.sysdatabases

            where has_dbaccess(name) = 1 -- Only look at databases to which we have access

 

    open c1

    fetch c1 into @name

 

    while @@fetch_status >= 0

    begin

        select @SQL = 'insert into #databases

                select '+ convert(sysname, db_id(@name)) + ', sum(size) from '

                + QuoteName(@name) + '.dbo.sysfiles'

        /* Insert row for each database */

        execute (@SQL)

        fetch c1 into @name

    end

    deallocate c1

 

    select 

        DATABASE_NAME = db_name(DATABASE_ID),

        DATABASE_SIZE = size*8,/* Convert from 8192 byte pages to K */

        REMARKS = convert(varchar(254),null)    /* Remarks are NULL */

      into

            #database_list

    from #databases

 

    select 

            DATABASE_NAME,

            round(DATABASE_SIZE,2) as DATABASE_SIZE_KB,

            round((DATABASE_SIZE / 1024),2) as DATABASE_SIZE_MB,

            round(((DATABASE_SIZE / 1024)/1024),2) as DATABASE_SIZE_GB,

            DBID,

            FILENAME

    from

            #database_list

      inner join

            master..sysdatabases

      on

      database_name = name

 

END

 

manageDriveSpace
 

/*

NAME: manageDriveSpace

PURPOSE:Display free space on all Logical Disks attached to OS

The output will display : Drive,MB_Free

INPUT PARAMETERS :

 

EXAMPLE : manageDriveSpace

NOTE:

 

 

*/

 

CREATE PROCEDURE[dbo].[manageDriveSpace]

AS

 

SET NOCOUNT ON;

 

 

create table #FreeSpace(

 Drive char(1),

 MB_Free int)

 

insert into #FreeSpace exec xp_fixeddrives

select  Drive,MB_Free,MB_Free/1024 as 'GB_Free'  from #FreeSpace WHERE Drive IN ('E','F','H','I')

drop table #FreeSpace

emailReportDatabaseDetails
 CREATE PROCEDURE emailReportDatabaseDetails

AS

--create temp table for databases

CREATE TABLE #EmailReportDatabases

(DATABASE_NAME VARCHAR(100),

DATABASE_SIZE_KB INT ,

DATABASE_SIZE_MB INT ,

DATABASE_SIZE_GB INT,

[DBID] INT,

[FILENAME] VARCHAR (200)

)

 

--create temp table fro drives

CREATE TABLE #EmailReportDriveFree

(DRIVE VARCHAR(1),

MB_Free INT,

GB_Free INT

)

 

--insert into staging table for databases

BEGIN

INSERT INTO #EmailReportDatabases

exec dbo.Db_Details

END

 

--display Drive free recordset

exec dbo.manageDriveSpace

--display database recordset

SELECT DATABASE_NAME,DATABASE_SIZE_GB,DATABASE_SIZE_MB,LEFT([FILENAME],1) AS DRIVE_LOCATION

FROM #EmailReportDatabases ORDER BY DRIVE_LOCATION ASC,DATABASE_SIZE_MB DESC

 

 

DROP TABLE #EmailReportDatabases

DROP TABLE #EmailReportDriveFree
