/*1. Хранимая процедура показывает полную информацию о музыкальных дисках*/
CREATE PROCEDURE up_sel_InfoMusicDisk
AS
BEGIN
 SELECT m.[Name] AS [Name disk], m.DateCreate AS [Date create disk], s.[Name] AS [Name style disk],
	a.[Name] AS [Name album], p.Name AS [Name publisher]
 FROM MusicDisk m
 INNER JOIN StyleDisk s ON m.IdStyleDisk=s.Id
 INNER JOIN Album a ON m.IdAlbum=a.Id
 INNER JOIN Publisher p ON m.IdPublisher=p.Id
END;
GO

/*2. Хранимая процедура показывает полную информацию о всех музыкальных дисках конкретного издателя.
 Название издателя передаётся в качестве параметра*/
CREATE PROCEDURE up_sel_InfoDiskPublisher
@NamePublisher VARCHAR(100)
AS
BEGIN
 SELECT p.Name AS [Name publisher], m.[Name] AS [Name disk], m.DateCreate AS [Date create disk]
 FROM Publisher p
 INNER JOIN MusicDisk m ON p.Id=m.IdPublisher
 WHERE p.[Name]=@NamePublisher
END;
GO

/*3. Хранимая процедура показывает название самого популярного стиля
 4. Популярность стиля определяется по количеству дисков в коллекции*/
CREATE PROCEDURE up_sel_PopularStyteDisk
AS
BEGIN
 SELECT TOP 1 s.[Name] AS [Name style disk], COUNT(m.Id) AS [Count disk]
 FROM StyleDisk s
 INNER JOIN MusicDisk m ON s.Id=m.IdStyleDisk
 GROUP BY s.[Name]
 ORDER BY 2 DESC
END;
GO

/*5. Хранимая процедура отображает информацию о диске конкретного стиля с наибольшим количеством песен. 
 Название стиля передаётся в качестве параметра, если передано слово all, анализ идёт по всем стилям*/
CREATE PROCEDURE up_sel_InfoMaxCountSongsInDisk
@NameStyleDisk VARCHAR(100)='all'
AS
BEGIN
 IF @NameStyleDisk='all'
 BEGIN
  SELECT info.[Name style], info.[Name disk], MAX(info.[Count songs]) AS [Count songs]
  FROM
  (SELECT s.[Name] AS [Name style], md.[Name] AS [Name disk], COUNT(sd.IdSongs) AS [Count songs]
   FROM StyleDisk s
   INNER JOIN MusicDisk md ON s.Id=md.IdStyleDisk
   INNER JOIN SongsDisk sd ON md.Id=sd.IdDisk
   GROUP BY s.[Name], md.[Name]) info
   GROUP BY info.[Name style], info.[Name disk]
 END
 ELSE
 BEGIN
  SELECT info.[Name style], info.[Name disk], MAX(info.[Count songs]) AS [Count songs]
  FROM
  (SELECT s.[Name] AS [Name style], md.[Name] AS [Name disk], COUNT(sd.IdSongs) AS [Count songs]
   FROM StyleDisk s
   INNER JOIN MusicDisk md ON s.Id=md.IdStyleDisk
   INNER JOIN SongsDisk sd ON md.Id=sd.IdDisk
   WHERE s.[Name]=@NameStyleDisk
   GROUP BY s.[Name], md.[Name]) info
   GROUP BY info.[Name style], info.[Name disk] 
 END
END;
GO

/*6. Хранимая процедура удаляет все диски заданного стиля. Название стиля передаётся в качестве параметра. Процедура
 возвращает количество удаленных альбомов*/
CREATE PROCEDURE up_del_StyleDisk
@NameStyleDisk VARCHAR(100), @CountDeleteAlbum INT=0 OUT
AS
BEGIN
 DELETE FROM Album WHERE id IN (SELECT md.IdAlbum
							    FROM StyleDisk s
							    INNER JOIN MusicDisk md ON s.Id=md.IdStyleDisk)
 IF (@@ROWCOUNT>0)
 BEGIN
  SET @CountDeleteAlbum=@@ROWCOUNT
  DELETE FROM MusicDisk WHERE IdAlbum NOT IN (SELECT Id FROM Album)
 END
END;
GO

/*7. Хранимая процедура отображает информацию о самом «старом» альбом и самом «молодом». Старость и молодость определяются по дате выпуска*/
CREATE PROCEDURE up_sel_InfoYoungOldAlbum
AS
BEGIN
 SELECT 'Old album' AS Info, [Name] AS [Name album], MIN(DateCreate) AS 'Release date'
 FROM Album
 GROUP BY [Name]
 UNION
 SELECT 'Young album' AS Info, [Name] AS [Name album], MAX(DateCreate) AS 'Release date'
 FROM Album
 GROUP BY [Name]
END;
GO

/*8. Хранимая процедура удаляет все диски в названии которых есть заданное слово. 
Слово передаётся в качестве параметра. Процедура возвращает количество удаленных альбомов*/
CREATE PROCEDURE up_del_MusicDusk
@NameDisk VARCHAR(100), @CountDeleteAlbum INT=0 OUT
AS
BEGIN
 DELETE FROM Album WHERE id IN (SELECT IdAlbum 
                                FROM MusicDisk
								WHERE [Name] LIKE '%'+@NameDisk+'%')
 IF (@@ROWCOUNT>0)
 BEGIN
  SET @CountDeleteAlbum=@@ROWCOUNT
 END
END
