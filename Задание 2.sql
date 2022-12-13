/*1. Предоставьте пользователю с логином Олег доступ на чтение всех таблиц*/
USE MusicCollection;
GO

CREATE LOGIN Олег WITH PASSWORD='12345678',
				  DEFAULT_DATABASE=[MusicCollection],
				  DEFAULT_LANGUAGE=[Russian],
				  CHECK_EXPIRATION=OFF,
				  CHECK_POLICY=OFF;
GO

CREATE USER [Олег]
FOR LOGIN [Олег]
WITH DEFAULT_SCHEMA=[dbo];
GO

EXEC sp_addrolemember 'db_datareader', 'Олег';
GO

/*2. Запретите пользователю с логином Олег изменять данные во всех таблицах*/
DENY INSERT, UPDATE, DELETE 
ON SCHEMA::dbo
TO [Олег];
GO

/*3. Запретите всем пользователям, кроме пользователя с логином Дмитрий, читать данные из таблицы альбомов*/
CREATE LOGIN Дмитрий WITH PASSWORD='12345678',
					 DEFAULT_DATABASE=[MusicCollection],
					 DEFAULT_LANGUAGE=[Russian],
					 CHECK_EXPIRATION=OFF,
					 CHECK_POLICY=OFF;
GO

CREATE USER Дмитрий
FOR LOGIN Дмитрий
WITH DEFAULT_SCHEMA=[dbo];
GO

DENY SELECT
ON Album
TO PUBLIC;
GO

GRANT SELECT
ON Album
TO Дмитрий
WITH GRANT OPTION;
GO

GRANT SELECT, INSERT, UPDATE, DELETE 
ON SCHEMA::dbo
TO Дмитрий;
GO