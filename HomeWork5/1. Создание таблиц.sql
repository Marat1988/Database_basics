CREATE DATABASE Academy;
GO

USE Academy;
GO

/*Создание таблиц*/
CREATE TABLE Departments --Кафедры
(
	Id INT IDENTITY(1,1),
	Financing MONEY NOT NULL CONSTRAINT DF_Departments_Financing DEFAULT(0),
	Name NVARCHAR(100) NOT NULL,
	FacultyId INT NOT NULL
	CONSTRAINT PK_Departments_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Departments_Financing CHECK (Financing>=0),
	CONSTRAINT CK_Departments_Name CHECK (Name<>''),
	CONSTRAINT UQ_Departments_Name UNIQUE (Name)
);
GO

CREATE TABLE Faculties --Факультеты
(
	Id INT IDENTITY(1,1),
	Name NVARCHAR(100) NOT NULL
	CONSTRAINT PK_Faculties_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Faculties_Name CHECK (Name<>''),
	CONSTRAINT UQ_Faculties_Name UNIQUE (Name)
);
GO

CREATE TABLE Groups --Группы
(
	Id INT IDENTITY(1,1),
	Name NVARCHAR(10) NOT NULL,
	Year INT NOT NULL,
	DepartmentId INT NOT NULL
	CONSTRAINT PK_Groups_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Groups_Name CHECK (Name<>''),
	CONSTRAINT CK_Groups_Year CHECK (Year BETWEEN 1 AND 5),
	CONSTRAINT UQ_Groups_Name UNIQUE (Name)
);
GO

CREATE TABLE GroupsLectures --Группы и лекции
(
	Id INT IDENTITY(1,1),
	DayOfWeek INT NOT NULL,
	GroupId INT NOT NULL,
	LectureId INT NOT NULL
	CONSTRAINT PK_GroupsLectures_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Lectures_DayOfWeek CHECK (DayOfWeek BETWEEN 1 AND 7),
);
GO

CREATE TABLE Lectures --Лекции
(
	Id INT IDENTITY(1,1),
	LectureRoom NVARCHAR(MAX) NOT NULL,
	SubjectId INT NOT NULL,
	TeacherId INT NOT NULL
	CONSTRAINT PK_Lectures_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Lectures_LectureRoom CHECK (LectureRoom<>'')
);
GO

CREATE TABLE Subjects --Дисциплины
(
	Id INT IDENTITY(1,1),
	Name NVARCHAR(100) NOT NULL
	CONSTRAINT PK_Subjects_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Subjects_Name CHECK (Name<>''),
	CONSTRAINT UQ_Subjects_Name UNIQUE (Name)
);
GO

CREATE TABLE Teachers --Преподаватели
(
	Id INT IDENTITY(1,1),
	Name NVARCHAR(MAX) NOT NULL,
	Salary MONEY NOT NULL,
	Surname NVARCHAR(MAX) NOT NULL
	CONSTRAINT PK_Teachers_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Teachers_Name CHECK (Name<>''),
	CONSTRAINT CK_Teachers_Salary CHECK (Salary>0),
	CONSTRAINT CK_Teachers_Surname CHECK (Surname<>'')
);
GO

/*Создание связей между таблицами*/
ALTER TABLE Lectures
ADD CONSTRAINT FK_Lectures_SubjectId FOREIGN KEY (SubjectId) REFERENCES Subjects(Id),
	CONSTRAINT FK_Lectures_TeacherId FOREIGN KEY (TeacherId) REFERENCES Teachers(Id);
GO

ALTER TABLE GroupsLectures
ADD CONSTRAINT FK_GroupsLectures_LectureId FOREIGN KEY (LectureId) REFERENCES Lectures(Id),
	CONSTRAINT FK_GroupsLectures_GroupId FOREIGN KEY (GroupId) REFERENCES Groups(Id);
GO

ALTER TABLE Groups
ADD CONSTRAINT FK_Groups_DepartmentId FOREIGN KEY (DepartmentId) REFERENCES Departments(Id);
GO

ALTER TABLE Departments
ADD CONSTRAINT FK_Departments_FacultyId FOREIGN KEY (FacultyId) REFERENCES Faculties(Id);
GO

/*Заполнение тестовых данных*/
INSERT Subjects ([Name])
VALUES ('Основы информационных технологий'),
	   ('Программирование на C#'),
	   ('Разработка мобильных приложений'),
	   ('Компьютерные сети');
GO

INSERT INTO Teachers (Name, Salary, Surname)
VALUES ('Dave', 5000, 'McQueen'),
	   ('Jack', 6000, 'Underhill'),
	   ('Иван', 7000, 'Иванов');
GO

INSERT INTO Lectures (LectureRoom, SubjectId, TeacherId)
VALUES ('D201', 1, 1),
	   ('D201', 1, 2),
	   ('D201', 2, 1),
	   ('D201', 2, 2),
	   ('127', 3, 1),
	   ('128', 4, 3);
GO

INSERT Faculties (Name)
VALUES ('Computer Science'),
	   ('Netwoork and cybersecuruty');
GO

INSERT Departments (Financing, Name, FacultyId)
VALUES (100000, 'Software Development', 1),
	   (200000, 'Компьютерные сети', 2),
	   (300000, 'Android разработка', 1);
GO

INSERT INTO Groups (Name, Year, DepartmentId)
VALUES ('БВ111', 1, 1),
	   ('БВ112', 2, 2),
	   ('БВ113', 3, 3),
	   ('БВ114', 4, 1),
	   ('БВ115', 5, 1);
GO

INSERT INTO GroupsLectures (DayOfWeek, GroupId, LectureId)
VALUES (1, 1, 1),
	   (2, 1, 2),
	   (3, 2, 1),
	   (4, 2, 2),
	   (5, 3, 3),
	   (6, 3, 4),
	   (6, 4, 3),
	   (7, 4, 4),
	   (1, 5, 5),
	   (2, 5, 6);
GO