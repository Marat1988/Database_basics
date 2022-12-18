
/*Подготовительная часть*/
/*Перевод базы в модель полного восстановления*/
USE master;
GO
ALTER DATABASE SportShop
SET RECOVERY FULL;
GO

/*Создание логических устройств*/
USE master;
GO
/*Обязятельно создайте папку на диске C с названием BackupDataBase*/
/*Для полного резервного копирования*/
EXEC sp_addumpdevice 'disk', 'SportShopFullBackup', 'C:\BackupDataBase\SportShopFullBackup.bak';
GO
/*Для разностной резервной копии*/
EXEC sp_addumpdevice 'disk', 'SportShopDifferentialBackup', 'C:\BackupDataBase\SportShopDifferentialBackup.bak';
GO
/*Для журнала транзакции*/
EXEC sp_addumpdevice 'disk', 'SportShopTransactionLogBackup', 'C:\BackupDataBase\SportShopTransactionLogBackup.trn';
GO

--1). Создайте полную (full backup) резервную копию
USE master;
GO
BACKUP DATABASE SportShop
TO SportShopFullBackup
WITH INIT;
GO

--2). Выполните операции по вставке, обновлению, удалению данных в разных таблицах базы данных
USE SportShop;
GO
INSERT Client (FIO, Email, Telephone, Discount, DateCreate)
VALUES ('Иванов И.И.', 'ivanov@mail.ru', '222-333', 5, '20220202'),
	   ('Петров П.П.', 'petrov@mail.ru', '444-555', 6, '20220702'),
	   ('Сидоров С.С.', 'sidorov@mail.ru', '666-777', 7, GETDATE());
GO
INSERT Employees (FIO, Gender, StartDateWork, Salary)
VALUES ('Синицин А.А.', 1, '20050505', 100000),
	   ('Орлов А.А.', 1, '20100101', 150000);
GO

--3). Создайте разностную (differential backup) резервную копию
USE master;
GO
BACKUP DATABASE SportShop
TO SportShopDifferentialBackup
WITH DIFFERENTIAL;
GO

--4). Выполните операции по вставке, обновлению, удалению данных в разных таблицах базы данных
USE SportShop;
GO
INSERT Client (FIO, Email, Telephone, Discount, DateCreate)
VALUES ('Александров А.А.', 'alex@mail.ru', '888-999', 8, '20210101');
GO

--5). Создайте резервную копию журнала транзакций (log backup)
USE master;
GO
BACKUP LOG SportShop
TO SportShopTransactionLogBackup;
GO

--6). Проведите восстановление из полной резервной копии
USE master;
GO
/*Сначала закрываем все соединения с базой данных*/
DECLARE @kill VARCHAR(8000);
SET @kill = '';
SELECT @kill = @kill + 'kill ' + CONVERT(varchar(5), spid) + ';'
FROM master..sysprocesses
WHERE dbid = db_id('SportShop')
EXEC(@kill);

/*Потом восстанавливаем*/
RESTORE DATABASE SportShop
FROM SportShopFullBackup
WITH REPLACE, NORECOVERY;
GO

--7). Проведите восстановление из разностной резервной копии
USE master;
GO
RESTORE DATABASE SportShop
FROM SportShopDifferentialBackup
WITH NORECOVERY;
GO

--8) Проведите восстановление из резервной копии журнала транзакций.
USE master;
GO
RESTORE LOG SportShop
FROM SportShopTransactionLogBackup
WITH  NORECOVERY;
GO

RESTORE DATABASE SportShop
WITH RECOVERY;
GO

/*Удаление логических устройств*/
USE master;
GO
EXEC sp_dropdevice 'SportShopFullBackup';
GO
EXEC sp_dropdevice 'SportShopDifferentialBackup';
GO
EXEC sp_dropdevice 'SportShopTransactionLogBackup';
GO


