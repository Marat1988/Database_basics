CREATE DATABASE SportShop;
GO

USE SportShop;
GO

/*Таблицы*/
CREATE TABLE Employees --Сотрудники
(
	Id INT IDENTITY(1,1),
	FIO VARCHAR(20) NOT NULL,
	Gender BIT NOT NULL,
	StartDateWork DATETIME NOT NULL,
	Salary MONEY NOT NULL
	CONSTRAINT PK_Employees_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Employees_Salary CHECK (Salary>0)
);

CREATE TABLE Post --Должности
(
	Id INT IDENTITY(1,1),
	[Name] VARCHAR(100) NOT NULL
	CONSTRAINT PK_Post_Id PRIMARY KEY (Id),
	CONSTRAINT UQ_Post_Name UNIQUE ([Name]),
	CONSTRAINT CK_Post_Name CHECK ([Name]<>'')
);

CREATE TABLE EmployeesPost --Должности и сотрудники
(
	IdEmployees INT NOT NULL,
	IdPost INT NOT NULL
	CONSTRAINT PK_EmployeesPost_IdEmployees_IdPost PRIMARY KEY (IdEmployees, IdPost)
);

CREATE TABLE Product --Товары
(
	Id INT IDENTITY(1,1),
	[Name] VARCHAR(200) NOT NULL,
	BalanceProduct INT NOT NULL, --Остаток товара
	CostPrice MONEY NOT NULL, --Себестоимость
	PriceShowCase MONEY NOT NULL, --Цена витрины
	IdGroup INT NOT NULL,
	IdManufacturer INT NOT NULL
	CONSTRAINT PK_Product_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Product_Name CHECK ([Name]<>''),
	CONSTRAINT CK_Product_BalanceProduct CHECK (BalanceProduct>=0),
	CONSTRAINT CK_Product_CostPrice CHECK (CostPrice>0),
	CONSTRAINT CK_Product_PriceShowCase CHECK (CostPrice>0),
);

CREATE TABLE [Group] --Группы товаров
(
	Id INT IDENTITY(1,1),
	[Name] VARCHAR(100) NOT NULL
	CONSTRAINT PK_Group_Id PRIMARY KEY (Id),
	CONSTRAINT UQ_Group_Name UNIQUE ([Name]),
	CONSTRAINT CK_Group_Name CHECK ([Name]<>'')
);


CREATE TABLE Manufacturer --Производители/Поставщики товара
(
	Id INT IDENTITY(1,1),
	[Name] VARCHAR(100) NOT NULL
	CONSTRAINT PK_Manufacturer_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Manufacturer_Name CHECK ([Name]<>''),
	CONSTRAINT UQ_Manufacturer_Name UNIQUE ([Name])
);

CREATE TABLE Client --Клиенты
(
	Id INT IDENTITY(1,1),
	FIO VARCHAR(20) NOT NULL,
	Email VARCHAR(50) NOT NULL,
	Telephone VARCHAR(15) NOT NULL,
	Discount MONEY NOT NULL,
	DateCreate DATETIME NOT NULL,
	CONSTRAINT PK_Client_Id PRIMARY KEY (Id)
);

CREATE TABLE Sales --Продажи/Накладные
(
	Id INT IDENTITY(1,1),
	[Date] DATETIME NOT NULL, --Дата продажи
	IdClient INT NOT NULL,
	IdEmployees INT NOT NULL
	CONSTRAINT PK_Sales_Id PRIMARY KEY (Id)
);

CREATE TABLE LineSales --Строки продаж
(
	Id INT IDENTITY(1,1),
	IdSales INT NOT NULL,
	IdProduct INT NOT NULL,
	CostPrice MONEY NOT NULL, --Себестоимость
	PriceShowCase MONEY NOT NULL, --Цена витрины
	[Count] INT NOT NULL, --Количество проданного товара
	Price MONEY NOT NULL, --Цена проданного товара
	Amount AS (CONVERT([MONEY], ROUND([Count]*Price,(2)),(0)))
	CONSTRAINT PK_LineSales_Id PRIMARY KEY (Id),
	CONSTRAINT CK_LineSales_CostPrice CHECK (CostPrice>0),
	CONSTRAINT CK_LineSales_PriceShowCase CHECK (PriceShowCase>0),
	CONSTRAINT CK_LineSales_Count CHECK ([Count]>0),
	CONSTRAINT CK_LineSales_Price CHECK (Price>0)
);

/*Связи между таблицами*/
ALTER TABLE EmployeesPost
ADD CONSTRAINT FK_EmployeesPost_IdEmployees FOREIGN KEY (IdEmployees) REFERENCES Employees (Id) ON DELETE CASCADE,
	CONSTRAINT FK_EmployeesPost_IdPost FOREIGN KEY (IdPost) REFERENCES Post (Id) ON DELETE CASCADE;
GO

ALTER TABLE Product
ADD CONSTRAINT FK_Product_IdGroup FOREIGN KEY (IdGroup) REFERENCES [Group] (Id) ON DELETE CASCADE,
	CONSTRAINT FK_Product_IdManufacturer FOREIGN KEY (IdManufacturer) REFERENCES Manufacturer (Id) ON DELETE CASCADE;
GO

ALTER TABLE Sales
ADD CONSTRAINT FK_Sales_IdClient FOREIGN KEY (IdClient) REFERENCES Client (Id) ON DELETE CASCADE,
	CONSTRAINT FK_Sales_IdEmployees FOREIGN KEY (IdEmployees) REFERENCES Employees (Id) ON DELETE CASCADE;
GO

ALTER TABLE LineSales
ADD CONSTRAINT FK_LineSales_IdSales FOREIGN KEY (IdSales) REFERENCES Sales (Id) ON DELETE CASCADE,
	CONSTRAINT FK_LineSales_IdProduct FOREIGN KEY (IdProduct) REFERENCES Product (Id) ON DELETE CASCADE;
GO

/*Создание дополнительных таблиц для ведения истории по удалению записей*/
CREATE TABLE HistoryEmployees --Сотрудники
(
	Id INT NOT NULL,
	FIO VARCHAR(20) NOT NULL,
	Gender BIT NOT NULL,
	StartDateWork DATETIME NOT NULL,
	Salary MONEY NOT NULL
	CONSTRAINT PK_HistoryEmployees_Id PRIMARY KEY (Id),
	CONSTRAINT CK_HistoryEmployees_Salary CHECK (Salary>0)
);

CREATE TABLE HistoryPost --Должности
(
	Id INT,
	[Name] VARCHAR(100) NOT NULL
	CONSTRAINT PK_HistoryPost_Id PRIMARY KEY (Id),
	CONSTRAINT UQ_HistoryPost_Name UNIQUE ([Name]),
	CONSTRAINT CK_HistoryPost_Name CHECK ([Name]<>'')
);

CREATE TABLE HistoryEmployeesPost --Должности и сотрудники
(
	IdEmployees INT NOT NULL,
	IdPost INT NOT NULL
	CONSTRAINT PK_HistoryEmployeesPost_IdEmployees_IdPost PRIMARY KEY (IdEmployees, IdPost)
);

CREATE TABLE HistoryProduct --Товары
(
	Id INT,
	[Name] VARCHAR(200) NOT NULL,
	BalanceProduct INT NOT NULL, --Остаток товара
	CostPrice MONEY NOT NULL, --Себестоимость
	PriceShowCase MONEY NOT NULL, --Цена витрины
	IdGroup INT NOT NULL,
	IdManufacturer INT NOT NULL
	CONSTRAINT PK_HistoryProduct_Id PRIMARY KEY (Id),
	CONSTRAINT CK_HistoryProduct_Name CHECK ([Name]<>''),
	CONSTRAINT CK_HistoryProduct_BalanceProduct CHECK (BalanceProduct>=0),
	CONSTRAINT CK_HistoryProduct_CostPrice CHECK (CostPrice>0),
	CONSTRAINT CK_HistoryProduct_PriceShowCase CHECK (CostPrice>0),
);

CREATE TABLE HistoryGroup --Группы товаров
(
	Id INT,
	[Name] VARCHAR(100) NOT NULL
	CONSTRAINT PK_HistoryGroup_Id PRIMARY KEY (Id),
	CONSTRAINT UQ_HistoryGroup_Name UNIQUE ([Name]),
	CONSTRAINT CK_HistoryGroup_Name CHECK ([Name]<>'')
);

CREATE TABLE HistoryManufacturer --Производители/Поставщики товара
(
	Id INT,
	[Name] VARCHAR(100) NOT NULL
	CONSTRAINT PK_HistoryManufacturer_Id PRIMARY KEY (Id),
	CONSTRAINT CK_HistoryManufacturer_Name CHECK ([Name]<>''),
	CONSTRAINT UQ_HistoryManufacturer_Name UNIQUE ([Name])
);

CREATE TABLE HistoryClient --Клиенты
(
	Id INT,
	FIO VARCHAR(20) NOT NULL,
	Email VARCHAR(50) NOT NULL,
	Telephone VARCHAR(15) NOT NULL,
	Discount MONEY NOT NULL,
	DateCreate DATETIME NOT NULL,
	CONSTRAINT PK_HistoryClient_Id PRIMARY KEY (Id)
);

CREATE TABLE HistorySales --Продажи/Накладные
(
	Id INT,
	[Date] DATETIME NOT NULL, --Дата продажи
	IdClient INT NOT NULL,
	IdEmployees INT NOT NULL
	CONSTRAINT PK_HistorySales_Id PRIMARY KEY (Id)
);

CREATE TABLE HistoryLineSales --Строки продаж
(
	Id INT,
	IdSales INT NOT NULL,
	IdProduct INT NOT NULL,
	CostPrice MONEY NOT NULL, --Себестоимость
	PriceShowCase MONEY NOT NULL, --Цена витрины
	[Count] INT NOT NULL, --Количество проданного товара
	Price MONEY NOT NULL, --Цена проданного товара
	Amount AS (CONVERT([MONEY], ROUND([Count]*Price,(2)),(0)))
	CONSTRAINT PK_HistoryLineSales_Id PRIMARY KEY (Id),
	CONSTRAINT CK_HistoryLineSales_CostPrice CHECK (CostPrice>0),
	CONSTRAINT CK_HistoryLineSales_PriceShowCase CHECK (PriceShowCase>0),
	CONSTRAINT CK_HistoryLineSales_Count CHECK ([Count]>0),
	CONSTRAINT CK_HistoryLineSales_Price CHECK (Price>0)
);





