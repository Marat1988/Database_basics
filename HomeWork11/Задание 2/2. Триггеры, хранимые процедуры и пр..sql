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

