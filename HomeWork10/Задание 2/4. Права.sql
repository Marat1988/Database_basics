/*1. Предоставьте пользователю с логином Олег доступ на чтение всех таблиц*/
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

CREATE ROLE DenyTableAlbumRead; --Создаем роль для запрета на таблицу Album
GO

ALTER ROLE [DenyTableAlbumRead]
ADD MEMBER Олег; --Добавляем в нее Олега.
GO

GRANT SELECT ON Album --Разрешаем Дмитрию SELECT на таблицу альбомов
TO Дмитрий;
GO

DENY SELECT ON Album --Запрещаем пользователям из роли [DenyTableAlbumRead] на таблицу альбомов
TO [DenyTableAlbumRead]; /*P.S. ХЗ другого способа не нашел.*/
GO

/*4. Предоставьте возможность чтения данных из таблицы стилей пользователям с логинами: Борис, Диана, Николай, Ирина.*/
/*Создаем пользователей*/
CREATE LOGIN Борис WITH PASSWORD='12345678',
				   DEFAULT_DATABASE=[MusicCollection],
				   DEFAULT_LANGUAGE=[Russian],
				   CHECK_EXPIRATION=OFF,
				   CHECK_POLICY=OFF;
GO

CREATE USER Борис
FOR LOGIN [Борис]
WITH DEFAULT_SCHEMA=[dbo];
GO

CREATE LOGIN Диана WITH PASSWORD='12345678',
				   DEFAULT_DATABASE=[MusicCollection],
				   DEFAULT_LANGUAGE=[Russian],
				   CHECK_EXPIRATION=OFF,
				   CHECK_POLICY=OFF;
GO

CREATE USER Диана
FOR LOGIN Диана
WITH DEFAULT_SCHEMA=[dbo];
GO

CREATE LOGIN Ирина WITH PASSWORD='12345678',
				   DEFAULT_DATABASE=[MusicCollection],
				   DEFAULT_LANGUAGE=[Russian],
				   CHECK_EXPIRATION=OFF,
				   CHECK_POLICY=OFF;
GO

CREATE USER Ирина
FOR LOGIN Ирина
WITH DEFAULT_SCHEMA=[dbo];
GO

CREATE LOGIN Николай WITH PASSWORD='12345678',
					 DEFAULT_DATABASE=[MusicCollection],
					 DEFAULT_LANGUAGE=[Russian],
					 CHECK_EXPIRATION=OFF,
					 CHECK_POLICY=OFF;
GO

CREATE USER Николай
FOR LOGIN Николай
WITH DEFAULT_SCHEMA=[dbo];
GO

/*Создаем роль. Будет служить для разрешения та таблицу StyleDisk*/
CREATE ROLE GrantSelectTableMusicStyle;
GO

/*Добавляем пользователетей в эту роль*/
ALTER ROLE GrantSelectTableMusicStyle 
ADD MEMBER Борис;
GO

ALTER ROLE GrantSelectTableMusicStyle 
ADD MEMBER Диана;
GO

ALTER ROLE GrantSelectTableMusicStyle 
ADD MEMBER Николай;
GO

ALTER ROLE GrantSelectTableMusicStyle 
ADD MEMBER Ирина;
GO

GRANT SELECT ON StyleDisk
TO GrantSelectTableMusicStyle;
GO

