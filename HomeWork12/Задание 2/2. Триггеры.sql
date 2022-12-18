/*1. Триггер не позволяющий добавить уже существующий в коллекции альбом*/
CREATE TRIGGER tg_Album_Insert
ON Album
FOR INSERT
AS
BEGIN
 IF EXISTS(SELECT * 
           FROM Album a
		   INNER JOIN inserted i ON a.[Name]=i.[Name] AND a.Id!=i.Id)
 BEGIN
  RAISERROR('Нельзя добавить альбом в коллекцию, т.к. он уже существует в коллекции', 16, 1)
  ROLLBACK TRAN
 END
END;
GO

/*2. Триггер не позволяющий удалять диски группы The Beatles
  3. При удалении диска триггер переносит информацию об удаленном диске в таблицу «Архив» */
CREATE TRIGGER tg_MusicDisk_Deleted
ON MusicDisk
FOR DELETE
AS
BEGIN
 IF EXISTS (SELECT * FROM 
			deleted d
			INNER JOIN SongsDisk sd ON d.Id=sd.IdDisk
			INNER JOIN Songs s ON sd.IdSongs=s.Id
			INNER JOIN Singer sing ON s.IdSinger=sing.Id
			WHERE sing.[Name]='The Beatles')
 BEGIN
  RAISERROR('Нельзя удалить диски, в которых присутствуют песни группы "The Beatles"', 16, 1)
  ROLLBACK TRAN
 END
 ELSE
 BEGIN
  INSERT HistoryMusicDisk
  SELECT * FROM deleted
 END
END;
GO

/*Прочие триггеры для хранения истории удаления данных из таблиц*/
CREATE TRIGGER tg_Album_Deleted
ON Album
FOR DELETE
AS
BEGIN
  INSERT HistoryAlbum
  SELECT * FROM deleted
END;
GO

CREATE TRIGGER tg_Publisher_Deleted
ON Publisher
FOR DELETE
AS
BEGIN
  INSERT HistoryPublisher
  SELECT * FROM deleted
END;
GO

CREATE TRIGGER tg_StyleDisk_Deleted
ON StyleDisk
FOR DELETE
AS
BEGIN
  INSERT HistoryStyleDisk
  SELECT * FROM deleted
END;
GO

CREATE TRIGGER tg_Songs_Deleted
ON Songs
FOR DELETE
AS
BEGIN
  INSERT HistorySongs
  SELECT * FROM deleted
END;
GO

CREATE TRIGGER tg_SongsDisk_Deleted
ON SongsDisk
FOR DELETE
AS
BEGIN
  INSERT HistorySongsDisk
  SELECT * FROM deleted
END;
GO

CREATE TRIGGER tg_Singer_Deleted
ON Singer
FOR DELETE
AS
BEGIN
  INSERT HistorySinger
  SELECT * FROM deleted
END;
GO

/*4. Триггер не позволяющий добавлять в коллекцию диски музыкального стиля «Dark Power Pop».*/
CREATE TRIGGER tg_MusicDisk_Insert
ON MusicDisk
FOR INSERT
AS
BEGIN
 IF EXISTS(SELECT *
		   FROM MusicDisk
		   WHERE IdStyleDisk=(SELECT id FROM StyleDisk WHERE [Name]='Dark Power Pop'))
 BEGIN
  RAISERROR('Нельзя добавить в коллекцию диски музыкального стиля «Dark Power Pop».', 16, 1)
  ROLLBACK TRAN
 END
END