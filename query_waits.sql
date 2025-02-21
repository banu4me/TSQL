SELECT spid, waittime, lastwaittype 
FROM master..sysprocesses 
WHERE waittime > 1000