CREATE DATABASE Academy;
GO

USE Academy;
GO

/*Создание таблиц*/
CREATE TABLE Assistants
(
	Id INT IDENTITY(1,1),
	TeacherId INT NOT NULL
	CONSTRAINT PK_Assistants_Id PRIMARY KEY (Id)
);
GO

CREATE TABLE Curators
(
	Id INT IDENTITY(1,1),
	TeacherId INT NOT NULL
	CONSTRAINT PK_Curators_Id PRIMARY KEY (Id)
);
GO

CREATE TABLE Deans
(
	Id INT IDENTITY(1,1),
	TeacherId INT NOT NULL
	CONSTRAINT PK_Deans_Id PRIMARY KEY (Id)
);
GO

CREATE TABLE Departments
(
	Id INT IDENTITY(1,1),
	Building INT NOT NULL,
	[Name] NVARCHAR(100) NOT NULL,
	FacultyId INT NOT NULL,
	HeadId INT NOT NULL
	CONSTRAINT PK_Departments_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Departments_Building CHECK (Building BETWEEN 1 AND 5),
	CONSTRAINT CK_Departments_Name CHECK ([Name]<>''),
	CONSTRAINT UQ_Departments_Name UNIQUE ([Name])
);
GO

CREATE TABLE Faculties
(
	Id INT IDENTITY(1,1),
	Building INT NOT NULL,
	[Name] NVARCHAR(100) NOT NULL,
	DeanId INT NOT NULL
	CONSTRAINT PK_Faculties_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Faculties_Building CHECK (Building BETWEEN 1 AND 5),
	CONSTRAINT CK_Faculties_Name CHECK ([Name]<>''),
	CONSTRAINT UQ_Faculties_Name UNIQUE ([Name])
);
GO

CREATE TABLE Groups
(
	Id INT IDENTITY(1,1),
	[Name] NVARCHAR(100) NOT NULL,
	[Year] INT NOT NULL,
	DepartmentId INT NOT NULL
	CONSTRAINT PK_Groups_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Groups_Name CHECK ([Name]<>''),
	CONSTRAINT UQ_Groups_Name UNIQUE ([Name]),
	CONSTRAINT CK_Groups_Year CHECK ([Year] BETWEEN 1 AND 5)
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

CREATE TABLE Heads
(
	Id INT IDENTITY(1,1),
	TeacherId INT NOT NULL
	CONSTRAINT PK_Heads_Id PRIMARY KEY (Id)
);
GO

CREATE TABLE LectureRooms
(
	Id INT IDENTITY(1,1),
	Building INT NOT NULL,
	[Name] NVARCHAR(10) NOT NULL 
	CONSTRAINT PK_LectureRooms_Id PRIMARY KEY (Id),
	CONSTRAINT CK_LectureRooms_Building CHECK (Building BETWEEN 1 AND 5),
	CONSTRAINT CK_LectureRooms_Name CHECK ([Name]<>''),
	CONSTRAINT UQ_LectureRooms_Name UNIQUE ([Name])
);
GO

CREATE TABLE Lectures
(
	Id INT IDENTITY(1,1),
	SubjectId INT NOT NULL,
	TeacherId INT NOT NULL
	CONSTRAINT PK_Lectures_Id PRIMARY KEY (Id)
);
GO

CREATE TABLE Schedules
(
	Id INT IDENTITY(1,1),
	Class INT NOT NULL,
	[DayOfWeek] INT NOT NULL,
	[Week] INT NOT NULL,
	LectureId INT NOT NULL,
	LectureRoomId INT NOT NULL
	CONSTRAINT PK_Schedules_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Schedules_Class CHECK (Class BETWEEN 1 AND 8),
	CONSTRAINT CK_Schedules_DayOfWeek CHECK ([DayOfWeek] BETWEEN 1 AND 7),
	CONSTRAINT CK_Schedules_Week CHECK ([Week] BETWEEN 1 AND 52)
);
GO

CREATE TABLE Subjects
(
	Id INT IDENTITY(1,1),
	[Name] NVARCHAR(100) NOT NULL
	CONSTRAINT PK_Subjects_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Subjects_Name CHECK ([Name]<>''),
	CONSTRAINT UQ_Subjects_Name UNIQUE ([Name])
);
GO

CREATE TABLE Teachers
(
	Id INT IDENTITY(1,1),
	[Name] NVARCHAR(MAX) NOT NULL,
	Surname NVARCHAR(MAX) NOT NULL
	CONSTRAINT PK_Teachers_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Teachers_Name CHECK ([Name]<>''),
	CONSTRAINT CK_Teachers_Surname CHECK (Surname<>'')
);
GO

/*Установка связей между таблицами*/
ALTER TABLE Assistants
ADD CONSTRAINT FK_Assistants_TeacherId FOREIGN KEY (TeacherId) REFERENCES Teachers (Id);
GO

ALTER TABLE Lectures
ADD CONSTRAINT FK_Lectures_SubjectId FOREIGN KEY (SubjectId) REFERENCES Subjects (Id),
	CONSTRAINT FK_Lectures_TeacherId FOREIGN KEY (TeacherId) REFERENCES Teachers (Id);
GO

ALTER TABLE Curators
ADD CONSTRAINT FK_Curators_TeacherId FOREIGN KEY (TeacherId) REFERENCES Teachers (Id);
GO

ALTER TABLE Deans
ADD CONSTRAINT FK_Deans_TeacherId FOREIGN KEY (TeacherId) REFERENCES Teachers (Id);
GO

ALTER TABLE Heads
ADD CONSTRAINT FK_Heads_TeacherId FOREIGN KEY (TeacherId) REFERENCES Teachers (Id);
GO

ALTER TABLE GroupsLectures
ADD CONSTRAINT FK_GroupsLectures_LectureId FOREIGN KEY (LectureId) REFERENCES Lectures (Id),
	CONSTRAINT FK_GroupsLectures_GroupId FOREIGN KEY (GroupId) REFERENCES Groups (Id);
GO

ALTER TABLE GroupsCurators
ADD CONSTRAINT FK_GroupsCurators_GroupId FOREIGN KEY (GroupId) REFERENCES Groups (Id),
	CONSTRAINT FK_GroupsCurators_CuratorId FOREIGN KEY (CuratorId) REFERENCES Curators (Id);
GO

ALTER TABLE Faculties
ADD CONSTRAINT FK_Faculties_DeanId FOREIGN KEY (DeanId) REFERENCES Deans (Id);
GO

ALTER TABLE Schedules
ADD CONSTRAINT FK_Schedules_LectureRoomId FOREIGN KEY (LectureRoomId) REFERENCES LectureRooms (Id),
	CONSTRAINT FK_Schedules_LectureId FOREIGN KEY (LectureId) REFERENCES Lectures (Id);
GO

ALTER TABLE Departments
ADD CONSTRAINT FK_Departments_HeadId FOREIGN KEY (HeadId) REFERENCES Heads (Id),
	CONSTRAINT FK_Departments_FacultyId FOREIGN KEY (FacultyId) REFERENCES Faculties (Id);
GO

ALTER TABLE Groups
ADD CONSTRAINT FK_Groups_DepartmentId FOREIGN KEY (DepartmentId) REFERENCES Departments (Id);
GO

/*Заполнение таблиц тестовыми данными*/

INSERT INTO Teachers (Name, Surname)
VALUES ('Edward', 'Hopper'),
	   ('Alex', 'Carmack'),
	   ('Марат', 'Тухтаров');
GO

INSERT Assistants (TeacherId)
VALUES (3);
GO

INSERT INTO Deans (TeacherId)
VALUES (1);
GO

INSERT INTO Curators (TeacherId)
VALUES (2);
GO

INSERT INTO Heads (TeacherId)
VALUES (3);
GO

INSERT INTO Subjects ([Name])
VALUES ('Основы инфомационных технологий'),
	   ('Программирование на JAVA'),
	   ('Программирование на C#');
GO

INSERT INTO Lectures (SubjectId, TeacherId)
VALUES (1, 1),
	   (1, 2),
	   (1, 3),
	   (2, 1),
	   (2, 2),
	   (3, 3),
	   (2, 3);
GO

INSERT INTO Faculties (Building, [Name], DeanId)
VALUES (5, 'Computer Science', 1);
GO

INSERT INTO Departments (Building, [Name], FacultyId, HeadId)
VALUES (5, 'Software Development', 1, 1)
GO

INSERT INTO Groups ([Name], [Year], DepartmentId)
VALUES ('F505', 5 ,1),
	   ('БВ111', 4, 1),
	   ('БВ112', 3, 1);
GO

INSERT INTO GroupsCurators (CuratorId, GroupId)
VALUES (1, 1),
	   (1, 2),
	   (1, 3);
GO

INSERT INTO GroupsLectures (GroupId, LectureId)
VALUES (1, 1),
	   (1, 2),
	   (1, 3),
	   (1, 4),
	   (1, 5),
	   (1, 6),
	   (1, 7),
	   (2, 1),
	   (2, 2),
	   (2, 3),
	   (2, 4),
	   (2, 5),
	   (2, 6),
	   (2, 7),
	   (3, 1),
	   (3, 3),
	   (3, 5),
	   (3, 7);
GO

INSERT INTO LectureRooms (Building, [Name])
VALUES (5, 'A311'),
	   (5, 'A104');
GO

INSERT INTO Schedules (Class, [DayOfWeek], [Week], LectureId, LectureRoomId)
VALUES (1, 1, 40, 1, 1),
	   (2, 2, 41, 2, 1),
	   (3, 3, 42, 3, 1),
	   (4, 4, 43, 4, 1),
	   (5, 5, 44, 5, 1),
	   (6, 6, 45, 6, 1),
	   (7, 7, 46, 7, 1),
	   (8, 1, 47, 1, 2),
	   (1, 2, 48, 2, 2),
	   (3, 3, 49, 3, 2),
	   (4, 4, 50, 4, 2),
	   (5, 5, 52, 5, 2),
	   (6, 6, 20, 6, 2),
	   (7, 7, 21, 7, 2);
GO