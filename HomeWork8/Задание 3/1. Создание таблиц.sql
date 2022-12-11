CREATE DATABASE Sales;
GO

USE Sales;
GO

/*Создание таблиц*/
CREATE TABLE Buyer --Покупатели
(
	Id INT IDENTITY(1,1),
	FIO VARCHAR(20) NOT NULL
	CONSTRAINT PK_Buyer_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Buyer_FIO CHECK (FIO<>'')
);
GO

CREATE TABLE Seller --Продавцы
(
	Id INT IDENTITY(1,1),
	FIO VARCHAR(20) NOT NULL
	CONSTRAINT PK_Seller_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Seller_FIO CHECK (FIO<>''),
	CONSTRAINT UQ_Seller_FIO UNIQUE (FIO)
);
GO

CREATE TABLE Product --Товары
(
	Id INT IDENTITY(1,1),
	[Name] VARCHAR(100) NOT NULL
	CONSTRAINT PK_Product_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Product_Name CHECK ([Name]<>''),
	CONSTRAINT UQ_Product_Name UNIQUE ([Name])
);
GO

CREATE TABLE Document --Документы/Накладные
(
	Id INT IDENTITY(1,1),
	DateCreate DATETIME NOT NULL,
	IdSeller INT NOT NULL,
	IdBuyer INT NOT NULL
	CONSTRAINT PK_Document_Id PRIMARY KEY (Id)
);
GO

CREATE TABLE DocumentLine --Строки документов
(
	Id INT IDENTITY(1,1),
	IdDocument INT NOT NULL,
	IdProduct INT NOT NULL,
	Price MONEY NOT NULL,
	CountProduct INT NOT NULL,
	Amount AS (CONVERT([MONEY], ROUND(Price*CountProduct, (2)), (0)))
	CONSTRAINT PK_DocumentLine_Id PRIMARY KEY (Id),
	CONSTRAINT CK_DocumentLine_Price CHECK (Price>0),
	CONSTRAINT CK_DocumentLine_CountProduct CHECK (CountProduct>0),
);
GO

/*Создание связей между таблицами*/
ALTER TABLE Document
ADD CONSTRAINT FK_Document_IdSeller FOREIGN KEY (IdSeller) REFERENCES Seller (Id),
	CONSTRAINT FK_Document_IdBuyer FOREIGN KEY (IdBuyer) REFERENCES Buyer (Id) ON DELETE CASCADE;
GO

ALTER TABLE DocumentLine
ADD CONSTRAINT FK_DocumentLine_IdDocument FOREIGN KEY (IdDocument) REFERENCES Document (Id) ON DELETE CASCADE,
	CONSTRAINT FK_DocumentLine_IdProduct FOREIGN KEY (IdProduct) REFERENCES Product (Id);
GO

/*Создание специальных таблиц (для заданию)*/
CREATE TABLE SpecialBuyer --Специальная таблица для покупателей
(
	IdBuyer INT NOT NULL,
	FIO VARCHAR(20) NOT NULL
	CONSTRAINT PK_SpecialBuyer_Id PRIMARY KEY (IdBuyer),
);
GO

CREATE TABLE PurchaseHistory --История покупок
(
	IdBuyer INT NOT NULL,
	FIO VARCHAR(20) NOT NULL,
	NumberDocument INT NOT NULL,
	DateDocument DATETIME NOT NULL,
	IdProduct INT NOT NULL,
	Price MONEY NOT NULL,
	CountProduct INT NOT NULL
);
GO