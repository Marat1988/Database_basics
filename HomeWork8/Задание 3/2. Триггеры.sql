
/*1. При добавлении нового покупателя триггер проверяет наличие покупателей с такой же фамилией.
 При нахождении совпадения триггер записывает об этом информацию в специальную таблицу

 4. При добавлении покупателя триггер проверяет есть ли он в таблице продавцов, если запись
 существует добавление нового покупателя отменяется*/
ALTER TRIGGER tg_Buyer_Insert
ON Buyer
AFTER INSERT
AS
BEGIN
 IF EXISTS(SELECT *
		   FROM Buyer p
		   INNER JOIN Seller s ON p.FIO=s.FIO) --4 пункт задания
 BEGIN
  RAISERROR('Такой покупатель существует в таблице продавцов', 16, 1)
  ROLLBACK TRAN
 END
 ELSE
 BEGIN
  IF EXISTS(SELECT * --1 пункт задания
            FROM Buyer p
			INNER JOIN inserted i ON p.FIO=i.FIO AND p.id!=i.Id)
  BEGIN
   INSERT SpecialBuyer (IdBuyer, FIO)
   SELECT id, FIO FROM inserted
   IF (@@ROWCOUNT>0)
   BEGIN
	DELETE FROM Buyer WHERE id IN (SELECT id FROM inserted)
   END
  END
 END
END
GO

/*2. При удалении информации о покупателе триггер переносит
 его историю покупок в таблицу «История покупок»*/
ALTER TRIGGER tg_Buyer_Delete
ON Buyer
INSTEAD OF DELETE
AS
BEGIN
 IF EXISTS(SELECT *
		   FROM deleted d
		   INNER JOIN Document doc ON d.Id=doc.IdBuyer
		   INNER JOIN DocumentLine dl ON doc.Id=dl.IdDocument)
 BEGIN
  INSERT PurchaseHistory (IdBuyer, FIO, NumberDocument, DateDocument, IdProduct, Price, CountProduct)
  SELECT d.Id AS IdBuyer, d.FIO, doc.Id AS NumberDocument, doc.DateCreate AS DateDocument, dl.IdProduct, dl.Price, dl.CountProduct
  FROM deleted d
  INNER JOIN Document doc ON d.Id=doc.IdBuyer
  INNER JOIN DocumentLine dl ON doc.Id=dl.IdDocument
  IF (@@ROWCOUNT>0)
  BEGIN
   DELETE Buyer WHERE id IN (SELECT id FROM deleted)
  END
 END
END
GO

/*3. При добавлении продавца триггер проверяет есть ли он в таблице покупателей, если 
 запись существует добавление нового продавца отменяется*/
CREATE TRIGGER tg_Seller_Insert
ON Seller
AFTER INSERT
AS
BEGIN
 IF EXISTS(SELECT *
		   FROM Seller s
		   INNER JOIN Buyer b ON s.FIO=b.FIO)
 BEGIN
  RAISERROR('Такой продавец существует в таблице покупателей', 16, 1)
  ROLLBACK TRAN
 END
END
GO

/*5. Триггер не позволяет вставлять информацию о продаже таких товаров: яблоки, груши, сливы, кинза.*/
ALTER TRIGGER tg_DocumentLine_Insert
ON DocumentLine
AFTER INSERT
AS
BEGIN
 SELECT *
 FROM inserted
 IF EXISTS(SELECT *
		   FROM inserted i
		   INNER JOIN Product p ON i.IdProduct=p.Id
		   WHERE p.[Name] IN ('Яблоки', 'Груши', 'Сливы', 'Кинза'))
 BEGIN
  RAISERROR('Яблоки, груши, сливы, кинза не продаются', 16, 1)
  ROLLBACK TRAN
 END
END
GO
