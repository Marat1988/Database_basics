CREATE DATABASE MusicCollection;
GO

USE MusicCollection;
GO

/*Таблицы*/
CREATE TABLE Album --Альбомы
(
	Id INT IDENTITY(1,1),
	[Name] VARCHAR(100) NOT NULL,
	DateCreate DATETIME NOT NULL
	CONSTRAINT PK_Album_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Album_Name CHECK ([Name]<>''),
	CONSTRAINT UQ_Album_Name UNIQUE ([Name])
);
GO

CREATE TABLE Publisher --Издатели музыкальных дисков
(
	Id INT IDENTITY(1,1),
	[Name] VARCHAR(100) NOT NULL,
	CONSTRAINT PK_Publisher_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Publisher_Name CHECK ([Name]<>''),
	CONSTRAINT UQ_Publisher_Name UNIQUE ([Name])
);
GO

CREATE TABLE StyleDisk --Музыкальные стили дисков
(
	Id INT IDENTITY(1,1),
	[Name] VARCHAR(100) NOT NULL,
	CONSTRAINT PK_StyleDisk_Id PRIMARY KEY (Id),
	CONSTRAINT CK_StyleDisk_Name CHECK ([Name]<>''),
	CONSTRAINT UQ_StyleDisk_Name UNIQUE ([Name])
);
GO

CREATE TABLE MusicDisk --Музыкальный диск
(
	Id INT IDENTITY(1,1),
	[Name] VARCHAR(100) NOT NULL,
	DateCreate DATETIME NOT NULL,
	CountSongs INT NOT NULL,
	IdAlbum INT NOT NULL,
	IdStyleDisk INT NOT NULL,
	IdPublisher INT NOT NULL
	CONSTRAINT PK_MusicDisk_Id PRIMARY KEY (Id),
	CONSTRAINT CK_MusicDisk_Name CHECK ([Name]<>''),
	CONSTRAINT CK_MusicDisk_CountSongs CHECK (CountSongs>0)
);
GO

CREATE TABLE Songs --Песни
(
	Id INT IDENTITY(1,1),
	[Name] VARCHAR(100) NOT NULL,
	IdSinger INT NOT NULL
	CONSTRAINT PK_Songs_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Songs_Name CHECK ([Name]<>'')
);
GO

CREATE TABLE SongsDisk --Песни и диски
(
	IdSongs INT NOT NULL,
	IdDisk INT NOT NULL
	CONSTRAINT PK_SongsDisk PRIMARY KEY (IdSongs, IdDisk)
);
GO

CREATE TABLE Singer --Певцы (Исполнители песен)
(
	Id INT IDENTITY(1,1),
	[Name] VARCHAR(100) NOT NULL,
	CONSTRAINT PK_Singer_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Singer_Name CHECK ([Name]<>''),
	CONSTRAINT UQ_Singer_Name UNIQUE ([Name])
);
GO

/*Связи между таблицами*/
ALTER TABLE MusicDisk
ADD CONSTRAINT FK_MusicDisk_IdAlbum FOREIGN KEY (IdAlbum) REFERENCES Album (Id),
	CONSTRAINT FK_MusicDisk_IdStyleDisk FOREIGN KEY (IdStyleDisk) REFERENCES StyleDisk (Id),
	CONSTRAINT FK_MusicDisk_IdPublisher FOREIGN KEY (IdPublisher) REFERENCES Publisher (Id);
GO

ALTER TABLE MusicDisk NOCHECK CONSTRAINT [FK_MusicDisk_IdAlbum];
GO
ALTER TABLE MusicDisk NOCHECK CONSTRAINT [FK_MusicDisk_IdStyleDisk];
GO
ALTER TABLE MusicDisk NOCHECK CONSTRAINT [FK_MusicDisk_IdPublisher];
GO

ALTER TABLE SongsDisk
ADD CONSTRAINT FK_SongsDisk_IdSongs FOREIGN KEY (IdSongs) REFERENCES Songs (Id),
	CONSTRAINT FK_SongsDisk_IdDisk FOREIGN KEY (IdDisk) REFERENCES MusicDisk (Id);
GO

ALTER TABLE Songs
ADD CONSTRAINT FK_Songs_IdSinger FOREIGN KEY (IdSinger) REFERENCES Singer (Id);
GO

/*Дополнительная таблица для архива музыкальных дисков*/
CREATE TABLE ArchiveMusicDisk
(
	Id INT NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	DateCreate DATETIME NOT NULL,
	CountSongs INT NOT NULL,
	IdAlbum INT NOT NULL,
	IdStyleDisk INT NOT NULL,
	IdPublisher INT NOT NULL
	CONSTRAINT PK_ArchiveMusicDisk_Id PRIMARY KEY (Id),
);
GO

ALTER TABLE ArchiveMusicDisk
ADD CONSTRAINT FK_ArchiveMusicDisk_IdAlbum FOREIGN KEY (IdAlbum) REFERENCES Album (Id),
	CONSTRAINT FK_ArchiveMusicDisk_IdStyleDisk FOREIGN KEY (IdStyleDisk) REFERENCES StyleDisk (Id),
	CONSTRAINT FK_ArchiveMusicDisk_IdPublisher FOREIGN KEY (IdPublisher) REFERENCES Publisher (Id);
GO

ALTER TABLE ArchiveMusicDisk NOCHECK CONSTRAINT [FK_ArchiveMusicDisk_IdAlbum];
GO
ALTER TABLE ArchiveMusicDisk NOCHECK CONSTRAINT [FK_ArchiveMusicDisk_IdStyleDisk];
GO
ALTER TABLE ArchiveMusicDisk NOCHECK CONSTRAINT [FK_ArchiveMusicDisk_IdPublisher];
GO