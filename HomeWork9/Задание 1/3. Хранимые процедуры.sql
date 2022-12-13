--1). Хранимая процедура отображает полную информацию о всех товарах
CREATE PROCEDURE up_sel_InfoProduct
AS
BEGIN
 SELECT p.[Name] AS [Name product], p.BalanceProduct AS [Balance product],
	p.CostPrice AS [Cost price], p.PriceShowCase AS [Price show case],
	g.[Name] AS [Group name], m.[Name] AS [Manufacturer name]
 FROM Product p
 INNER JOIN [Group] g ON p.IdGroup=g.Id
 INNER JOIN Manufacturer m ON p.IdManufacturer=m.Id
END;
GO

/*2). Хранимая процедура показывает полную информацию о товаре конкретного вида. Вид товара передаётся в качестве параметра. 
 Например, если в качестве параметра указана обувь, нужно показать всю обувь, которая есть в наличии*/
CREATE PROCEDURE up_sel_InfoAboutProductFromGroup
@NameGroup VARCHAR(100)
AS
BEGIN
 SELECT p.[Name] AS [Name product], p.BalanceProduct AS [Balance product], 
	p.CostPrice AS [Cost price], p.PriceShowCase AS [Price show case]
 FROM [Group] g
 INNER JOIN Product p ON g.Id=p.IdGroup
 WHERE g.[Name]=@NameGroup
END;
GO

/*3). Хранимая процедура показывает топ-3 самых старых клиентов. Топ-3 определяется по дате регистрации*/
CREATE PROCEDURE up_sel_InfoOldClient
AS
BEGIN
 SELECT TOP 3 c.FIO, c.Email, c.Telephone, c.Discount
 FROM Client c
 ORDER BY DateCreate
END;
GO

/*4). Хранимая процедура показывает информацию о самом успешном продавце. Успешность определяется по общей сумме продаж за всё время*/
CREATE PROCEDURE up_sel_BestSeller
AS
BEGIN
 SELECT TOP 1 e.FIO, SUM(ls.Amount) AS Amount
 FROM LineSales ls
 INNER JOIN Sales s ON ls.IdSales=s.Id
 INNER JOIN Employees e ON s.IdEmployees=e.Id
 GROUP BY e.FIO
 ORDER BY 2 DESC
END;
GO

/*5). Хранимая процедура проверяет есть ли хоть один товар указанного производителя в наличии. Название производителя
 передаётся в качестве параметра. По итогам работы хранимая процедура должна вернуть yes в том случае, если товар есть, и no, если товара нет*/
CREATE PROCEDURE up_sel_InfoProductManufacturer
@NameManufacturer VARCHAR(100), @Info VARCHAR(3)='' OUT
AS
BEGIN
 SET @Info='Привет'
 IF EXISTS(SELECT *
		   FROM Manufacturer m
		   INNER JOIN Product p ON m.Id=p.IdManufacturer
		   WHERE m.[Name]= @NameManufacturer)
 BEGIN
  SET @Info = 'YES'
 END
 ELSE
 BEGIN
  SET @Info = 'NO'
 END
END;
GO

/*6). Хранимая процедура отображает информацию о самом популярном производителе среди покупателей. 
 Популярность среди покупателей определяется по общей сумме продаж*/
CREATE PROCEDURE up_sel_InfoPopularManufacturer
AS
BEGIN
 SELECT TOP 1 m.[Name] AS [Name manufacturer], SUM(ls.Amount) AS Amount
 FROM LineSales ls
 INNER JOIN Product p ON ls.IdProduct=p.Id
 INNER JOIN Manufacturer m ON p.IdManufacturer=m.Id
 GROUP BY m.[Name]
 ORDER BY 2 DESC
END;
GO


/*7). Хранимая процедура удаляет всех клиентов, зарегистрированных после указанной даты. 
 Дата передаётся в качестве параметра. Процедура возвращает количество удаленных записей.*/
CREATE PROCEDURE up_del_Clients
@Date DATETIME
AS
BEGIN
 DELETE Client WHERE DateCreate>@Date
END
