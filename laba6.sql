-- 1 task

create database User_Actions
use User_Actions

CREATE TABLE User_Logs(
    id INT IDENTITY (1, 1) PRIMARY KEY,
    username TEXT NOT NULL,
    user_action TEXT NOT NULL,
    action_date DATE NOT NULL,
    action_time TIME NOT NULL,
    action_result TEXT NOT NULL
);

SET NOCOUNT ON;

CREATE TABLE #Usernames (val NVARCHAR(50));
INSERT INTO #Usernames VALUES ('admin'), ('ivan_ivanov'), ('alex_smith'), ('john_doe'), ('maria_p'), ('user_99'), ('moderator_1');

CREATE TABLE #Actions (val NVARCHAR(50));
INSERT INTO #Actions VALUES ('LOGIN'), ('LOGOUT'), ('VIEW_PAGE'), ('UPDATE_PROFILE'), ('DOWNLOAD_FILE'), ('UPLOAD_FILE'), ('DELETE_ITEM');

CREATE TABLE #Results (val NVARCHAR(50));
INSERT INTO #Results VALUES ('SUCCESS'), ('SUCCESS'), ('SUCCESS'), ('FAILED'), ('TIMEOUT');

DECLARE @StartDate DATE = '2025-01-01';
DECLARE @DaysInYear INT = 365;

;WITH 
E1(N) AS (SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1), -- 10 строк
E2(N) AS (SELECT 1 FROM E1 a, E1 b), 
E4(N) AS (SELECT 1 FROM E2 a, E2 b), 
E6(N) AS (SELECT 1 FROM E4 a, E4 b),
Tally(Num) AS (
    SELECT TOP (1000000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) 
    FROM E6
)
INSERT INTO User_Logs (username, user_action, action_date, action_time, action_result)
SELECT 

    (SELECT TOP 1 val FROM #Usernames ORDER BY ABS(CHECKSUM(NEWID(), t.Num))),

    (SELECT TOP 1 val FROM #Actions ORDER BY ABS(CHECKSUM(NEWID(), t.Num + 1))),

    DATEADD(DAY, ABS(CHECKSUM(NEWID(), t.Num + 2)) % @DaysInYear, @StartDate),

    DATEADD(SECOND, ABS(CHECKSUM(NEWID(), t.Num + 3)) % 86400, CAST('00:00:00' AS TIME)),

    (SELECT TOP 1 val FROM #Results ORDER BY ABS(CHECKSUM(NEWID(), t.Num + 4)))
FROM Tally t;

DROP TABLE #Usernames;
DROP TABLE #Actions;
DROP TABLE #Results;

PRINT 'Генерация 1 000 000 записей успешно завершена!';

-- 2 task

alter database User_Actions add filegroup Sect_frag
go
alter database User_Actions add file(
	name = 'Sect_frag',
	filename = 'D:\SQL\Sect_frag.ndf') to filegroup Sect_frag
go


create partition function pf_Sect_month(date)
as range right for values ('2025-02-01', '2025-03-01', '2025-04-01', 
    '2025-05-01', '2025-06-01', '2025-07-01', 
    '2025-08-01', '2025-09-01', '2025-10-01', 
    '2025-11-01', '2025-12-01')
go


create partition scheme ps_Sect_frag
as partition pf_Sect_month to (
Sect_frag, Sect_frag, Sect_frag, Sect_frag, Sect_frag, Sect_frag, 
Sect_frag, Sect_frag, Sect_frag, Sect_frag, Sect_frag, Sect_frag)
go

-- 3 task

use master

-- создание файла бэкапа
	
backup database [User_Actions] 
to disk = 'D:\SQL\User_Actions_backup.bak' 
with format, 
medianame = 'MSSQL_Backup', 
name = 'Backup';

-- восстановление

go
create procedure backupp @Path varchar(1000)
as
begin
	restore database User_Actions
	from disk = @Path
	with replace
end
go
exec backupp 'D:\SQL\User_Actions.bak'
