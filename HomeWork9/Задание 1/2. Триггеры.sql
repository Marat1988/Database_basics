
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

/*2. При увольнении сотрудника триггер переносит информацию об уволенном сотруднике в таблицу «Архив сотрудников»*/
CREATE TRIGGER [dbo].[tg_Employees_Delete]
ON [dbo].[Employees]
AFTER DELETE
AS
BEGIN
 INSERT ArchiveEmployees
 SELECT * FROM deleted
END
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
