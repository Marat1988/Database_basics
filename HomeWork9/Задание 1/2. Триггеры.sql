
/*1. При добавлении нового товара триггер проверяет его наличие на складе, если такой товар есть и новые данные о товаре совпадают с уже существующими данными, вместо
добавления происходит обновление информации о количестве товара*/
CREATE TRIGGER [dbo].[tg_Product_Insert]
ON [dbo].[Product]
INSTEAD OF INSERT
AS
BEGIN
 DECLARE @BalanceProduct INT=(SELECT BalanceProduct FROM inserted)
 IF EXISTS(SELECT *
		   FROM Product p
		   INNER JOIN inserted i ON p.[Name]=i.[Name] AND p.CostPrice=i.CostPrice AND p.PriceShowCase=i.PriceShowCase
		   WHERE p.Id!=i.Id)
 BEGIN
   DECLARE @id INT=0
   SELECT @id=p.Id 
   FROM Product p
   INNER JOIN inserted i ON p.[Name]=i.[Name] AND p.CostPrice=i.CostPrice AND p.PriceShowCase=i.PriceShowCase AND p.Id!=i.Id
   IF (@id!=0)
   BEGIN
    UPDATE Product SET BalanceProduct=BalanceProduct+@BalanceProduct WHERE Id=@id
   END
 END
 ELSE
 BEGIN
  INSERT Product ([Name], BalanceProduct, CostPrice, PriceShowCase, IdGroup, IdManufacturer)
  SELECT [Name], BalanceProduct, CostPrice, PriceShowCase, IdGroup, IdManufacturer FROM inserted
 END
END;
GO

/*2.История*/
CREATE TRIGGER [dbo].[tg_Employees_Delete]
ON [dbo].[Employees]
AFTER DELETE
AS
BEGIN
 INSERT HistoryEmployees
 SELECT * FROM deleted
END;
GO

CREATE TRIGGER [dbo].[tg_Post_Delete]
ON [dbo].[Post]
AFTER DELETE
AS
BEGIN
 INSERT HistoryPost
 SELECT * FROM deleted
END;
GO

CREATE TRIGGER [dbo].[tg_EmployeesPost_Delete]
ON [dbo].[EmployeesPost]
AFTER DELETE
AS
BEGIN
 INSERT HistoryEmployeesPost
 SELECT * FROM deleted
END;
GO

CREATE TRIGGER [dbo].[tg_Product_Delete]
ON [dbo].[Product]
AFTER DELETE
AS
BEGIN
 INSERT HistoryProduct
 SELECT * FROM deleted
END;
GO

CREATE TRIGGER [dbo].[tg_Group_Delete]
ON [dbo].[Group]
AFTER DELETE
AS
BEGIN
 INSERT HistoryGroup
 SELECT * FROM deleted
END;
GO

CREATE TRIGGER [dbo].[tg_Manufacturer_Delete]
ON [dbo].[Manufacturer]
AFTER DELETE
AS
BEGIN
 INSERT HistoryManufacturer
 SELECT * FROM deleted
END;
GO

CREATE TRIGGER [dbo].[tg_Client_Delete]
ON [dbo].[Client]
AFTER DELETE
AS
BEGIN
 INSERT HistoryClient
 SELECT * FROM deleted
END;
GO

CREATE TRIGGER [dbo].[tg_Sales_Delete]
ON [dbo].[Sales]
AFTER DELETE
AS
BEGIN
 INSERT HistorySales
 SELECT * FROM deleted
END;
GO

CREATE TRIGGER [dbo].[tg_LineSales_Delete]
ON [dbo].[LineSales]
AFTER DELETE
AS
BEGIN
 INSERT HistoryLineSales (Id, IdSales, IdProduct, CostPrice,  PriceShowCase, [Count], Price)
 SELECT Id, IdSales, IdProduct, CostPrice,  PriceShowCase, [Count], Price FROM deleted
END;
GO


/*3. Триггер запрещает добавлять нового продавца, если количество существующих продавцов больше 6.*/
CREATE TRIGGER [dbo].[tg_Employees_Insert]
ON [dbo].[Employees]
AFTER INSERT
AS
BEGIN
DECLARE @CountEmployees INT
SELECT @CountEmployees=COUNT(id)
FROM Employees
IF @CountEmployees>6
BEGIN
 RAISERROR('Добавление запрещено, т.к. количество сотрудников/продавцов превышает 6', 16, 1)
 ROLLBACK TRAN
END
END
GO
