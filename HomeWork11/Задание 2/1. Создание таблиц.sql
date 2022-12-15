CREATE DATABASE Barbershop;
GO

USE Barbershop;
GO

CREATE TABLE Employees --Сотрудники (барбере)
(
	Id INT IDENTITY(1,1),
	FIO VARCHAR(50) NOT NULL,
	Junior BIT NOT NULL, --Статус. Если истина, то значит новичок
	DateBegin DATETIME NOT NULL
	CONSTRAINT PK_Employees_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Employees_FIO CHECK (FIO<>''),
	CONSTRAINT UQ_Employees_FIO UNIQUE (FIO)
);
GO

CREATE TABLE ListService --Список услуг
(
	Id INT IDENTITY(1,1),
	[Name] VARCHAR(100) NOT NULL
	CONSTRAINT PK_ListService_Id PRIMARY KEY (Id),
	CONSTRAINT CK_ListService_Name CHECK ([Name]<>''),
	CONSTRAINT UQ_ListService_Name UNIQUE ([Name])
);
GO

CREATE TABLE Clients --Клиенты
(
	Id INT IDENTITY(1,1),
	FIO VARCHAR(50) NOT NULL
	CONSTRAINT PK_Clients_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Clients_Name CHECK (FIO<>''),
	CONSTRAINT UQ_Clients_Name UNIQUE (FIO)
);
GO

CREATE TABLE Visits --Визиты
(
	Id INT IDENTITY(1,1),
	IdEmployees INT NOT NULL,
	IdClients INT NOT NULL,
	DateBegin DATETIME NOT NULL, --Расписание. Дата начала
	DateEnd DATETIME NOT NULL, --Дата конца
	CONSTRAINT PK_Visits_Id PRIMARY KEY (Id),
	CONSTRAINT CK_VisitsDate CHECK(DateBegin<=DateEnd)
);
GO

CREATE TABLE LineVisits --Услуги, оказанные во время визита клиента
(
	Id INT IDENTITY(1,1),
	IdVisits INT NOT NULL,
	IdListService INT NOT NULL,
	DateBegin DATETIME NOT NULL, --Дата начала услуги
	DateEnd DATETIME, --Дата окончания услуги
	Price MONEY NOT NULL
	CONSTRAINT PK_LineVisits_Id PRIMARY KEY (Id),
	CONSTRAINT CK_LineVisitsDate CHECK(DateBegin<=DateEnd),
	CONSTRAINT CK_LineVisitsDate_Price CHECK(Price>0),
);
GO

CREATE TABLE Evaluations --Оценки
(
	Id INT IDENTITY(1,1),
	IdVisits INT NOT NULL,
	Score TINYINT NOT NULL,
	Comment VARCHAR(1000) NOT NULL,
	DateCreate DATETIME NOT NULL
	CONSTRAINT PK_Evaluations_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Evaluations_Score CHECK (Score BETWEEN 1 AND 10)
);
GO

/*Архивы*/
CREATE TABLE ArchiveVisits
(
	Id INT NOT NULL,
	IdEmployees INT NOT NULL,
	IdClients INT NOT NULL,
	DateBegin DATETIME NOT NULL, --Расписание. Дата начала
	DateEnd DATETIME NOT NULL, --Дата конца
	CONSTRAINT PK_ArchiveVisits_Id PRIMARY KEY (Id),
	CONSTRAINT CK_ArchiveVisitsDate CHECK(DateBegin<=DateEnd)
);
GO

CREATE TABLE ArchiveLineVisits
(
	Id INT,
	IdVisits INT NOT NULL,
	IdListService INT NOT NULL,
	DateBegin DATETIME NOT NULL, --Дата начала услуги
	DateEnd DATETIME NOT NULL, --Дата окончания услуги
	Price MONEY NOT NULL
	CONSTRAINT PK_ArchiveLineVisitsLineVisits_Id PRIMARY KEY (Id),
	CONSTRAINT CK_ArchiveLineVisitsLineVisitsDate CHECK(DateBegin<=DateEnd),
	CONSTRAINT CK_ArchiveLineVisitsLineVisitsDate_Price CHECK(Price>0),
);
GO


/*Создание связей между таблицами*/
ALTER TABLE LineVisits
ADD CONSTRAINT FK_LineVisits_IdVisits FOREIGN KEY (IdVisits) REFERENCES Visits (Id) ON DELETE CASCADE,
	CONSTRAINT FK_LineVisits_IdListService FOREIGN KEY (IdListService) REFERENCES ListService (Id);
GO

ALTER TABLE Visits
ADD CONSTRAINT FK_Visits_IdEmployees FOREIGN KEY (IdEmployees) REFERENCES Employees (Id),
	CONSTRAINT FK_Visits_IdClients FOREIGN KEY (IdClients) REFERENCES Clients(Id);
GO

ALTER TABLE Evaluations
ADD CONSTRAINT FK_Evaluations_IdVisits FOREIGN KEY (IdVisits) REFERENCES Visits (Id) ON DELETE CASCADE;
GO

