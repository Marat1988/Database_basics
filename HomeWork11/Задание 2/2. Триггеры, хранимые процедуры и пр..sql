USE Barbershop
GO;

/*1). Вернуть информацию о самом популярном барбере (по количеству клиентов)*/
CREATE PROCEDURE up_sel_InfoOldWorkEmployees
AS
BEGIN
 SELECT TOP 1 e.Id, e.FIO, COUNT(DISTINCT v.IdClients) AS [Count clients]
 FROM Visits v
 INNER JOIN Employees e ON v.IdEmployees=e.Id
 GROUP BY e.Id, e.FIO
 ORDER BY 3 DESC
END;
GO

/*2. Вернуть топ-3 барберов за месяц (по сумме денег, потраченной клиентами)*/
CREATE PROCEDURE up_sel_InfoTop3Employees
AS
BEGIN
 SELECT TOP 3 e.Id, e.FIO, SUM(Price) AS [Sum price clients]
 FROM LineVisits lv
 INNER JOIN Visits v ON lv.IdVisits=v.Id
 INNER JOIN Employees e ON v.IdEmployees=e.Id
 ORDER BY 3 DESC
END;
GO

/*3. Вернуть топ-3 барберов за всё время (по средней оценке). Количество посещений клиентов не меньше 30*/
CREATE PROCEDURE up_sel_InfoTOP3EmployeesScore
AS
BEGIN
 SELECT TOP 3 em.FIO, AVG(e.Score) AS Score
 FROM Visits v
 INNER JOIN Evaluations e ON v.Id=e.IdVisits
 INNER JOIN Employees em ON v.IdEmployees=em.Id
 GROUP BY em.FIO
 HAVING COUNT(v.Id)>=30
 ORDER BY 2 DESC
END;
GO

/*4. Показать расписание на день конкретного барбера. Информация о барбере и дне передаётся в качестве параметра*/
CREATE PROCEDURE up_sel_ScheduleEmployees
@FIO VARCHAR(50)
AS
BEGIN
 SELECT e.FIO AS Client, v.DateBegin, v.DateEnd
 FROM Visits v
 INNER JOIN Clients c ON v.IdClients=c.Id
 INNER JOIN Employees e ON v.IdEmployees=e.Id
 WHERE e.FIO=@FIO
 ORDER BY v.DateBegin
END;
GO

/*5. Показать свободные временные слоты на неделю конкретного барбера. Информация о барбере и дне передаётся в качестве параметра*/
ALTER PROCEDURE up_sel_InfoFreeScheduleEmployees
@IdEmployees INT, @Date DATE
AS
BEGIN
 DECLARE @StarTimeWorkingDay TIME='08:00:00.000', @EndTimeWorkingDay TIME='18:00:00.000'

 DECLARE @Temp_Time TIME=@StarTimeWorkingDay, @Temp_Date DATE --Для прохода по курсору и присваивания

 DECLARE @Result TABLE (DateVisits DATE, TimeBegin TIME, TimeEnd TIME) --Табличная переменная для итогового результата

 DECLARE @DateVisit DATE, @TimeBegin TIME, @TimeEnd Time --Для курсора

 DECLARE TestCursor CURSOR FOR --Курсор
	SELECT CAST(DateBegin AS DATE) AS DateVisit, CAST(DateBegin AS TIME) AS TimeBegin , CAST(DateEnd AS TIME) AS TimeEnd 
	FROM Visits
	WHERE IdEmployees=@IdEmployees 
		AND CAST(DateBegin AS DATE) BETWEEN @Date AND DATEADD(DAY,7,@Date)
	ORDER BY 1,2

 OPEN TestCursor

 FETCH NEXT FROM TestCursor INTO @DateVisit, @TimeBegin, @TimeEnd
 WHILE @@FETCH_STATUS=0
 BEGIN
  IF @Temp_Date IS NULL
   SET @Temp_Date=@DateVisit

  IF @Temp_Date!=@DateVisit
  BEGIN
	IF @Temp_Time<@EndTimeWorkingDay
	BEGIN
	 INSERT @Result
     SELECT @Temp_Date, @Temp_Time, @EndTimeWorkingDay
	END
    SET @Temp_Date=@DateVisit
	SET @Temp_Time=@StarTimeWorkingDay
  END

  IF @TimeBegin!=@Temp_Time
  BEGIN
   INSERT @Result
   SELECT @DateVisit, @Temp_Time, @TimeBegin
  END
  SET @Temp_Time=@TimeEnd
  FETCH NEXT FROM TestCursor INTO @DateVisit, @TimeBegin, @TimeEnd
 END
 CLOSE TestCursor
 DEALLOCATE TestCursor


 IF @Temp_Time<@EndTimeWorkingDay AND (@Temp_Date IS NOT NULL)
 BEGIN
  INSERT @Result
  SELECT @DateVisit, @Temp_Time, @EndTimeWorkingDay
 END

 SELECT *
 FROM @Result

END;
GO

/*6. Перенести в архив информацию о всех уже завершенных услугах (это те услуги, которые произошли в прошлом)*/

/*6.1 Вешаю триггер на таблицу Visits*/
CREATE TRIGGER tg_DeleteVisits
ON Visits
FOR DELETE
AS
BEGIN
 INSERT ArchiveVisits
 SELECT * FROM deleted
END;
GO

/*6.2 Вешаю триггер на таблицу ListVisits*/
CREATE TRIGGER tg_DeleteListVisits
ON LineVisits
FOR DELETE
AS
BEGIN
 INSERT ArchiveLineVisits
 SELECT * FROM deleted
END;
GO

/*6.3 Процедура удаления*/
ALTER PROCEDURE up_del_DeleteOldVisits
@Date DATETIME
AS
BEGIN
 DELETE FROM Visits WHERE Id IN (SELECT v.Id
								 FROM Visits v
								 INNER JOIN LineVisits lv ON v.Id=lv.IdVisits
								 WHERE v.DateEnd>='20221210'
								 GROUP BY v.Id
								 HAVING COUNT(lv.Id)=COUNT(lv.DateEnd))
END;
GO

/*7. Запретить записывать клиента к барберу на уже занятое время и дату*/
CREATE TRIGGER tg_InsertClient
ON Visits
FOR INSERT
AS
BEGIN
 DECLARE @DataBegin DATETIME, @DateEnd DATETIME, @Id INT, @IdEmployees INT
 SELECT @DataBegin=DateBegin, @DateEnd=DateEnd, @Id=id, @IdEmployees=IdEmployees
 FROM inserted

 IF EXISTS(SELECT *
           FROM Visits v
		   WHERE v.Id!=@Id AND v.IdEmployees=@IdEmployees AND
		   ((@DataBegin BETWEEN v.DateBegin AND v.DateEnd)
		     OR (@DateEnd BETWEEN v.DateBegin AND v.DateEnd)
		     OR (v.DateBegin BETWEEN @DataBegin AND v.DateEnd)
		     OR (v.DateEnd BETWEEN @DataBegin AND v.DateEnd))
		   )
 BEGIN
  RAISERROR('Нельзя записывать клиента к барберу на уже занятое время', 16, 1)
  ROLLBACK TRAN
 END;
END
GO

/*8. Запретить добавление нового джуниор-барбера, если в салоне уже работают 5 джуниор-барберов*/
CREATE TRIGGER tg_InsertEmployees
ON Employees
FOR INSERT
AS
BEGIN
 DECLARE @CountJunior INT

 SELECT @CountJunior=COUNT(id)
 FROM Employees
 WHERE id!=(SELECT id
			FROM inserted) 
	AND Junior=1
 IF (@CountJunior>=5)
 BEGIN
  RAISERROR('Нельзя добавить джуниора-барбера в таблицу, т.к. в салоне уже работают больше 5 джуниоров-барберов', 16, 1)
  ROLLBACK TRAN
 END;
END
GO

/*9. Вернуть информацию о клиентах, которые не поставили ни одного фидбека и ни одной оценки*/
CREATE PROCEDURE up_sel_InfoNotScoreAndCommentClient
AS
BEGIN
 SELECT c.Id, c.FIO
 FROM Visits v
 INNER JOIN Clients c ON v.IdClients=c.Id
 LEFT JOIN Evaluations e ON v.Id=e.IdVisits
 WHERE e.Id IS NULL
END;
GO

/*10. Вернуть информацию о клиентах, которые не посещали барбершоп свыше одного года*/
CREATE PROCEDURE up_sel_InfoNotVisitsClientMoreOneYear
AS
BEGIN
 SELECT vis.FIO, vis.FIO, vis.[Date last visits]
 FROM
 (SELECT c.Id, c.FIO, MAX(v.DateBegin) AS [Date last visits]
  FROM Visits v
  INNER JOIN Clients c ON v.IdClients=c.Id) vis
  WHERE YEAR(vis.[Date last visits])>YEAR(GETDATE())
END;
GO


