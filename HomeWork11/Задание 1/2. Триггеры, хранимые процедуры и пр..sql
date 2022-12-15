USE Barbershop
GO;

/*1). Вернуть информацию о барбере, который работает в барбершопе дольше всех*/
CREATE PROCEDURE up_sel_InfoOldWorkEmployees
AS
BEGIN
 SELECT TOP 1 Id, FIO, CASE WHEN Junior=1 THEN 'Новичок'
					  ELSE 'Мастер' END AS [Status]
 FROM Employees
 ORDER BY 3
END;
GO

/*2). Вернуть информацию о барбере, который обслужил максимальное количество клиентов в указанном диапазоне дат.
Даты передаются в качестве параметра*/
CREATE PROCEDURE up_sel_BestEmployees
@DateBegin DATETIME, @DateEnd DATETIME
AS
BEGIN
	SELECT TOP 1 e.Id, e.FIO, COUNT(DISTINCT v.IdClients) AS [Count client]
	FROM Visits v
	INNER JOIN Employees e ON v.IdEmployees=e.Id
	WHERE (@DateBegin BETWEEN v.DateBegin AND v.DateEnd)
		OR (@DateEnd BETWEEN v.DateBegin AND v.DateEnd)
		OR (v.DateBegin BETWEEN @DateBegin AND @DateEnd)
		OR (v.DateEnd BETWEEN @DateBegin AND @DateEnd)
	GROUP BY e.Id, e.FIO
	ORDER BY 3 DESC
END;
GO

/*3. Вернуть информацию о клиенте, который посетил барбершоп максимальное количество раз*/
CREATE PROCEDURE up_sel_BestClientVisits
AS
BEGIN
 SELECT TOP 1 c.Id, c.FIO, COUNT(v.Id) AS [Count visits]
 FROM Visits v
 INNER JOIN Clients c ON v.IdClients=c.Id
 GROUP BY c.Id, c.FIO
 ORDER BY 3 DESC
END;
GO

/*4. Вернуть информацию о клиенте, который потратил в барбершопе максимальное количество денег*/
CREATE PROCEDURE up_sel_BestClientMoney
AS
BEGIN
 SELECT TOP 1c.Id, c.FIO, SUM(lv.Price) AS [Sum price]
 FROM LineVisits lv
 INNER JOIN Visits v ON lv.IdVisits=v.Id
 INNER JOIN Clients c ON v.IdClients=c.Id
 GROUP BY c.Id, c.FIO
 ORDER BY 3 DESC
END;
GO

/*5. Вернуть информацию о самой длинной по времени услуге в барбершопе*/
CREATE PROCEDURE up_sel_LongService
AS
BEGIN
	SELECT ls.Id, ls.[Name] AS [Name service], MAX(DATEDIFF(MINUTE, lv.DateBegin, lv.DateEnd)) AS [Time service in minute]
	FROM LineVisits lv
	INNER JOIN ListService ls ON lv.IdListService=ls.Id
	GROUP BY ls.Id, ls.[Name]
END;
GO
