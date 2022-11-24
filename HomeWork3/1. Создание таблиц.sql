/*Создание БД*/
CREATE DATABASE Academy;
GO

USE Academy;
GO

/*Создание таблиц*/
CREATE TABLE Departments
(
	Id INT IDENTITY(1,1),
	Financing MONEY NOT NULL CONSTRAINT DF_Financing DEFAULT(0),
	Name NVARCHAR(100) NOT NULL
	CONSTRAINT PK_Departments_Id PRIMARY KEY (Id),
	CONSTRAINT UQ_Departments_Name UNIQUE (Name),
	CONSTRAINT CK_Departments_Financing CHECK (Financing >= 0),
);
GO

CREATE TABLE Faculties
(
	Id INT IDENTITY(1,1),
	Dean NVARCHAR(MAX) NOT NULL,
	Name NVARCHAR(100) NOT NULL
	CONSTRAINT PK_Faculties_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Faculties_Dean CHECK (Dean<>''),
	CONSTRAINT UQ_Faculties_Name UNIQUE (Name),
	CONSTRAINT CK_Faculties_Name CHECK (Name<>'')
);
GO

CREATE TABLE Groups
(
	Id INT IDENTITY(1,1),
	Name NVARCHAR(10) NOT NULL,
	Rating INT NOT NULL,
	Year INT NOT NULL
	CONSTRAINT PK_Groups_Id PRIMARY KEY (Id),
	CONSTRAINT UQ_Groups_Name UNIQUE (Name),
	CONSTRAINT CK_Groups_Name CHECK (Name<>''),
	CONSTRAINT CK_Groups_Rating CHECK (Rating BETWEEN 0 AND 5),
	CONSTRAINT CK_Groups_Year CHECK (Year BETWEEN 1 AND 5),
);
GO

CREATE TABLE Teachers
(
	Id INT IDENTITY(1,1),
	EmploymentDate DATE NOT NULL,
	IsAssistant BIT NOT NULL CONSTRAINT DF_Teachers_IsAssistant DEFAULT(0),
	IsProfessor BIT NOT NULL CONSTRAINT DF_Teachers_IsProfessor DEFAULT(0),
	Name NVARCHAR(MAX) NOT NULL,
	Position NVARCHAR(MAX) NOT NULL,
	Premium MONEY NOT NULL CONSTRAINT DF_Teachers_Premium DEFAULT(0),
	Salary MONEY NOT NULL,
	Surname NVARCHAR(MAX) NOT NULL
	CONSTRAINT PK_Teachers_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Teachers_EmploymentDate CHECK (EmploymentDate>='19900101'),
	CONSTRAINT CK_Teachers_Name CHECK (Name<>''),
	CONSTRAINT CK_Teachers_Position CHECK (Position<>''),
	CONSTRAINT CK_Teachers_Premium CHECK (Premium>=0),
	CONSTRAINT CK_Teachers_Salary CHECK (Salary>0),
	CONSTRAINT CK_Teachers_Surname CHECK (Surname<>'')
);
GO
/*Заполнение заблиц тестовыми данными*/
INSERT Departments (Financing, Name)
VALUES (10500,'Software development'),
	   (15000, 'Mathematics'),
	   (30000, 'Cybersecurity');
GO

INSERT Faculties (Dean, Name)
VALUES ('Иванов И.И.', 'Разработка программного обеспечения'),
	   ('Петров П.П.', 'Сети и Кибербезопасность');
GO

INSERT Groups (Name, Rating, Year)
VALUES ('БВ111', 4, 5),
	   ('БВ112', 5, 2),
	   ('БВ113', 2, 1);
GO

INSERT Teachers (EmploymentDate, IsAssistant, IsProfessor, Name, Position, Premium, Salary, Surname)
VALUES ('19980101', 1, 0, 'Михаил', 'Доцент', 160, 500, 'Сидоров'),
	   ('20060110', 0, 1, 'Петр', 'Ведущий научный сотрудник', 500, 2000, 'Соловьев'),
	   ('20080130', 1, 0, 'Александр', 'Докторант', 700, 1000, 'Орлов'),
	   ('20090130', 1, 0, 'Кирилл', 'Младший научный сотрудник', 200, 400, 'Синицин'),
	   ('20090130', 1, 0, 'Максим', 'Ассистент', 500, 900, 'Максименко')
GO
	