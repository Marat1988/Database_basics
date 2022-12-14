/*Создание БД и таблиц*/
CREATE DATABASE MusicCollection;
GO

USE MusicCollection;
GO

CREATE TABLE Album
(
	Id INT IDENTITY(1,1),
	[Name] VARCHAR(100) NOT NULL
	CONSTRAINT PK_Album_Id PRIMARY KEY (Id),
	CONSTRAINT UQ_Album_Name UNIQUE ([Name])
);
GO

/*Тестовые данные*/
INSERT INTO Album ([Name])
VALUES ('Пробный альбом1'),
	   ('Пробный альбом2');
GO

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

CREATE ROLE [ЗапретНаТаблицуАльбомов]; --Создаем роль
GO

ALTER ROLE [ЗапретНаТаблицуАльбомов] ADD MEMBER Олег; --Добавляем в нее Олега.
GO

GRANT SELECT ON Album --Разрешаем Дмитрию SELECT на таблицу альбомов
TO Дмитрий;
GO

DENY SELECT ON Album --Запрещаем пользователям из роли [ЗапретНаТаблицеАльбомов] на таблицу альбомов
TO [ЗапретНаТаблицуАльбомов];
GO

/*P.S. ХЗ другого способа не нашел.*/
