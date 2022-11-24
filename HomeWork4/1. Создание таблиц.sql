CREATE DATABASE [Academy];
go

USE [Academy];
GO

/*Создание таблиц*/
CREATE TABLE Curators
(
	Id INT IDENTITY(1,1),
	Name NVARCHAR(MAX) NOT NULL,
	Surname NVARCHAR(MAX) NOT NULL
	CONSTRAINT PK_Curators_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Curators_Name CHECK (Name<>''),
	CONSTRAINT CK_Curators_Surname CHECK (Surname<>'')
);
GO

CREATE TABLE Departments
(
	Id INT IDENTITY(1,1),
	Financing MONEY NOT NULL CONSTRAINT DF_Departments_Financing DEFAULT(0),
	Name NVARCHAR(100) NOT NULL,
	FacultyId INT NOT NULL
	CONSTRAINT PK_Departments_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Departments_Financing CHECK (Financing>=0),
	CONSTRAINT CK_Departments_Name CHECK (Name<>''),
	CONSTRAINT UQ_Departments_Name UNIQUE (Name),
);
GO

CREATE TABLE Faculties
(
	Id INT IDENTITY(1,1),
	Financing MONEY NOT NULL CONSTRAINT DF_Faculties_Financing DEFAULT(0),
	Name NVARCHAR(100) NOT NULL
	CONSTRAINT PK_Faculties_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Faculties_Financing CHECK (Financing>=0),
	CONSTRAINT CK_Faculties_Name CHECK (Name<>''),
	CONSTRAINT UQ_Faculties_Name UNIQUE (Name)
);
GO

CREATE TABLE Groups
(
	Id INT IDENTITY(1,1),
	Name NVARCHAR(10) NOT NULL,
	Year INT NOT NULL,
	DepartmentId INT NOT NULL
	CONSTRAINT PK_Groups_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Groups_Name CHECK (Name<>''),
	CONSTRAINT UQ_Groups_Name UNIQUE (Name),
	CONSTRAINT CK_Groups_Year CHECK (Year BETWEEN 1 AND 5)
);
GO

CREATE TABLE GroupsCurators
(
	Id INT IDENTITY(1,1),
	CuratorId INT NOT NULL,
	GroupId INT NOT NULL
	CONSTRAINT PK_GroupsCurators_Id PRIMARY KEY (Id)
);
GO

CREATE TABLE GroupsLectures
(
	Id INT IDENTITY(1,1),
	GroupId INT NOT NULL,
	LectureId INT NOT NULL
	CONSTRAINT PK_GroupsLectures_Id PRIMARY KEY (Id)
);
GO

CREATE TABLE Lectures
(
	Id INT IDENTITY(1,1),
	LectureRoom NVARCHAR(MAX) NOT NULL,
	SubjectId INT NOT NULL,
	TeacherId INT NOT NULL
	CONSTRAINT PK_Lectures_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Lectures_LectureRoom CHECK (LectureRoom<>'')
);
GO

CREATE TABLE Subjects
(
	Id INT IDENTITY(1,1),
	Name NVARCHAR(500) NOT NULL,
	CONSTRAINT PK_Subjects_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Subjects_Name CHECK (Name<>''),
	CONSTRAINT UQ_Subjects_Name UNIQUE (Name)
);
GO

CREATE TABLE Teachers
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
/*=======================================================================*/
/*Создание связей между таблицами*/
ALTER TABLE Departments
ADD CONSTRAINT FK_Departments_FacultyId FOREIGN KEY (FacultyId) REFERENCES Faculties (Id);
GO

ALTER TABLE GroupsCurators
ADD CONSTRAINT FK_GroupsCurators_CuratorId FOREIGN KEY (CuratorId) REFERENCES Curators (Id),
	CONSTRAINT FK_GroupsCurators_GroupId FOREIGN KEY (GroupId) REFERENCES Groups (Id);
GO

ALTER TABLE Groups
ADD CONSTRAINT FK_Groups_DepartmentId FOREIGN KEY (DepartmentId) REFERENCES Departments (Id);
GO

ALTER TABLE GroupsLectures
ADD CONSTRAINT FK_GroupsLectures_GroupId FOREIGN KEY (GroupId) REFERENCES Groups (Id),
	CONSTRAINT FK_GroupsLectures_LectureId FOREIGN KEY (LectureId) REFERENCES Lectures (Id);
GO

ALTER TABLE Lectures
ADD CONSTRAINT FK_Lectures_TeacherId FOREIGN KEY (TeacherId) REFERENCES Teachers (Id),
	CONSTRAINT FK_Lectures_SubjectId FOREIGN KEY (SubjectId) REFERENCES Subjects (Id)
GO
/*=======================================================================*/
/*Заполнение тестовыми данными*/
INSERT Curators (Name, Surname)
VALUES ('Иван', 'Иванов'),
		('Петр', 'Петров');
GO

INSERT Faculties (Financing, Name)
VALUES (5000, 'Computer Science'),
	   (100000, 'Networks and cybersecurity');
GO

INSERT INTO Departments (Financing, Name, FacultyId)
VALUES (8000, 'Разработка ПО', 1),
	   (9000, 'Компьютерные сети', 2),
	   (10000, 'Android разработка', 1);
GO

INSERT INTO Groups (Name, Year, DepartmentId)
VALUES ('P107', 5, 1),
	   ('БВ111', 3, 1),
	   ('БВ112', 4, 2),
	   ('БВ113', 5, 1),
	   ('БВ114', 1, 2);
GO

INSERT INTO GroupsCurators (CuratorId, GroupId)
VALUES (1, 1),
       (1, 2),
	   (1, 3),
	   (1, 4),
	   (2, 5);
GO

INSERT Subjects (Name)
VALUES ('Database Theory'),
	   ('Программирование на С++'),
	   ('Программирование на С#'),
	   ('Компьютерные сети'),
	   ('Информационные технологии');
GO

INSERT Teachers (Name, Salary, Surname)
VALUES ('Samantha', 10000, 'Adams'),
	   ('Сидоров', 20000, 'Егор');
GO

INSERT INTO Lectures (LectureRoom, SubjectId, TeacherId)
VALUES ('B103', 1, 1),
	   ('112', 1, 2),
	   ('113', 2, 1),
	   ('114', 2, 2),
	   ('115', 3, 1),
	   ('116', 3, 2),
	   ('117', 4, 1),
	   ('118', 4, 2),
	   ('119', 5, 1),
	   ('120', 5, 2);
GO

INSERT GroupsLectures (GroupId, LectureId)
VALUES (1, 1),
	   (1, 2),
	   (2, 3),
	   (2, 4),
	   (3, 5),
	   (3, 6),
	   (4, 7),
	   (4, 8),
	   (5, 9),
	   (5, 10);
GO
