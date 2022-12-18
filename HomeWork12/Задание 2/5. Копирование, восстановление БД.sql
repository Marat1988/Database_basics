/*Подготовительная часть*/
/*Перевод базы данных в модель полного восстановления*/
USE master;
GO
ALTER DATABASE MusicCollection
SET RECOVERY FULL;
GO

/*Создание логических устройств*/
USE master;
GO
/*Обязательно создайте папку на диске С с названием BackupDataBase*/
/*Для полного резервного копирования*/
EXEC sp_addumpdevice 'disk', 'MusicCollectionFullBackup', 'C:\BackupDataBase\MusicCollectionFullBackup.bak';
GO
/*Для разностной резервной копии*/
EXEC sp_addumpdevice 'disk', 'MusicCollectionDifferentialBackup', 'C:\BackupDataBase\MusicCollectionDifferentialBackup.bak';
GO
/*Для журнала транзакции*/
EXEC sp_addumpdevice 'disk', 'MusicCollectionTransactionLogBackup', 'C:\BackupDataBase\MusicCollectionTransactionLogBackup.trn';
GO

--1). Создайте полную (full backup) резервную копию
USE master;
GO
BACKUP DATABASE MusicCollection
TO MusicCollectionFullBackup
WITH INIT;
GO

--2). Выполните операции по вставке, обновлению, удалению данных в разных таблицах базы данных
USE MusicCollection;
GO
INSERT Singer ([Name])
VALUES ('Король и шут'),
	   ('Тараканы'),
	   ('Сектор газа');
GO

INSERT Album ([Name], DateCreate)
VALUES ('Русский рок', '20220101'),
	   ('Сборник песен группы "ЛЮБЭ"', GETDATE());
GO

--3). Создайте разностную (differential backup) резервную копию
USE master;
GO
BACKUP DATABASE MusicCollection
TO MusicCollectionDifferentialBackup
WITH DIFFERENTIAL;
GO

--4). Выполните операции по вставке, обновлению, удалению данных в разных таблицах базы данных
USE MusicCollection;
GO
INSERT Singer ([Name])
VALUES ('АРИЯ');
GO

--5). Создайте резервную копию журнала транзакций (log backup)
USE master;
GO
BACKUP LOG MusicCollection
TO MusicCollectionTransactionLogBackup;
GO

--6). Проведите восстановление из полной резервной копии
USE master;
GO
/*Сначала закрываем все соединения с базой данных*/
DECLARE @kill VARCHAR(8000);
SET @kill = '';
SELECT @kill = @kill + 'kill ' + CONVERT(varchar(5), spid) + ';'
FROM master..sysprocesses
WHERE dbid = db_id('MusicCollection')
EXEC(@kill);

/*Потом восстанавливаем*/
RESTORE DATABASE MusicCollection
FROM MusicCollectionFullBackup
WITH REPLACE, NORECOVERY;
GO

--7). Проведите восстановление из разностной резервной копии
USE master;
GO
RESTORE DATABASE MusicCollection
FROM MusicCollectionDifferentialBackup
WITH NORECOVERY;
GO

--8) Проведите восстановление из резервной копии журнала транзакций.
USE master;
GO
RESTORE LOG MusicCollection
FROM MusicCollectionTransactionLogBackup
WITH NORECOVERY;
GO

RESTORE DATABASE MusicCollection
WITH RECOVERY;
GO

/*Удаление логических устройств*/
USE master;
GO
EXEC sp_dropdevice 'MusicCollectionFullBackup';
GO
EXEC sp_dropdevice 'MusicCollectionDifferentialBackup';
GO
EXEC sp_dropdevice 'MusicCollectionTransactionLogBackup'
GO