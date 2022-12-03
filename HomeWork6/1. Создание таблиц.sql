--Создание базы данных
CREATE DATABASE Academy
GO;

--Создание таблиц
CREATE TABLE Curators --Кураторы
(
	Id INT IDENTITY(1,1),
	Name NVARCHAR(MAX) NOT NULL,
	Surname NVARCHAR(MAX) NOT NULL
	CONSTRAINT PK_Curators_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Curators_Name CHECK (Name<>''),
	CONSTRAINT CK_Curators_Surname CHECK (Surname<>'')
);
GO

CREATE TABLE Departments --Кафедры
(
	Id INT IDENTITY(1,1),
	Building INT NOT NULL,
	Financing MONEY NOT NULL CONSTRAINT DF_Departments_Financing DEFAULT(0),
	Name NVARCHAR(100) NOT NULL,
	FacultyId INT NOT NULL
	CONSTRAINT PK_Departments_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Departments_Building CHECK (Building BETWEEN 1 AND 5),
	CONSTRAINT CK_Departments_Financing CHECK (Financing>=0),
	CONSTRAINT CK_Departments_Name CHECK (Name<>''),
	CONSTRAINT UQ_Departments_Name UNIQUE (Name)
);
GO

CREATE TABLE Faculties --Факультеты
(
	Id INT IDENTITY(1,1),
	Name NVARCHAR(100) NOT NULL,
	CONSTRAINT PK_Faculties_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Faculties_Name CHECK (Name<>''),
	CONSTRAINT UQ_Faculties_Name UNIQUE (Name)
);
GO

CREATE TABLE Groups --Группы
(
	Id INT IDENTITY(1,1),
	Name NVARCHAR(100) NOT NULL,
	Year INT NOT NULL,
	DepartmentId INT NOT NULL
	CONSTRAINT PK_Groups_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Groups_Name CHECK (Name<>''),
	CONSTRAINT UQ_Groups_Name UNIQUE (Name),
	CONSTRAINT CK_Groups_YEAR CHECK (Year BETWEEN 1 AND 5)
);
GO

CREATE TABLE GroupsCurators --Группы и кураторы
(
	Id INT IDENTITY(1,1),
	CuratorId INT NOT NULL,
	GroupId INT NOT NULL
	CONSTRAINT PK_GroupsCurators_Id PRIMARY KEY (Id)
);
GO

CREATE TABLE GroupsLectures --Группы и лекции
(
	Id INT IDENTITY(1,1),
	GroupId INT NOT NULL,
	LectureId INT NOT NULL
	CONSTRAINT PK_GroupsLectures_Id PRIMARY KEY (Id)
);
GO

CREATE TABLE GroupsStudents --Группы и студенты
(
	Id INT IDENTITY(1,1),
	GroupId INT NOT NULL,
	StudentId INT NOT NULL
	CONSTRAINT PK_GroupsStudents_Id PRIMARY KEY (Id)
);
GO

CREATE TABLE Lectures --Лекции
(
	Id INT IDENTITY(1,1),
	[Date] DATE NOT NULL,
	SubjectId INT NOT NULL,
	TeacherId INT NOT NULL
	CONSTRAINT PK_Lectures_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Lectures_Date CHECK ([Date]<CONVERT(Date, GETDATE()))
);
GO

CREATE TABLE Students --Студенты
(
	Id INT IDENTITY(1,1),
	Name NVARCHAR(MAX) NOT NULL,
	Rating INT NOT NULL,
	Surname NVARCHAR(MAX) NOT NULL
	CONSTRAINT PK_Students_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Students_Name CHECK (Name<>''),
	CONSTRAINT CK_Students_Rating CHECK (Rating BETWEEN 0 AND 5),
	CONSTRAINT CK_Students_Surname CHECK (Surname<>'')
);
GO

CREATE TABLE Subjects --Дисциплины
(
	Id INT IDENTITY(1,1),
	Name NVARCHAR(100) NOT NULL,
	CONSTRAINT PK_Subjects_Id PRIMARY KEY (Id),
	CONSTRAINT CK_Subjects_Name CHECK (Name<>''),
	CONSTRAINT UQ_Subjects_Name UNIQUE (Name)
);
GO

CREATE TABLE Teachers --Преподаватели
(
	Id INT IDENtITY(1,1),
	IsProfessor BIT NOT NULL CONSTRAINT DK_Teachers_IsProfessor DEFAULT(0),
	Name NVARCHAR(MAX) NOT NULL,
	Salary MONEY NOT NULL,
	Surname NVARCHAR(MAX) NOT NULL
	CONSTRAINT PK_Teachers_Id PRIMARY KEY(Id),
	CONSTRAINT CK_Teachers_Name CHECK (Name<>''),
	CONSTRAINT CK_Teachers_Salary CHECK (Salary>0),
	CONSTRAINT CK_Teachers_Surname CHECK (Surname<>'')
);
GO

--Создание связей между таблицами
ALTER TABLE Lectures
ADD CONSTRAINT FK_Lectures_TeacherId FOREIGN KEY (TeacherId) REFERENCES Teachers (Id),
	CONSTRAINT FK_Lectures_SubjectId FOREIGN KEY (SubjectId) REFERENCES Subjects (Id);
GO

ALTER TABLE GroupsLectures
ADD CONSTRAINT FK_GroupsLectures_LectureId FOREIGN KEY (LectureId) REFERENCES Lectures (Id),
	CONSTRAINT FK_GroupsLectures_Groups FOREIGN KEY (GroupId) REFERENCES Groups (Id);
GO

ALTER TABLE GroupsStudents
ADD CONSTRAINT FK_GroupsStudents_GroupId FOREIGN KEY (GroupId) REFERENCES Groups (Id),
	CONSTRAINT FK_GroupsStudents_StudentId FOREIGN KEY (StudentId) REFERENCES Students (Id);
GO

ALTER TABLE GroupsCurators
ADD CONSTRAINT FK_GroupsCurators_GroupId FOREIGN KEY (GroupId) REFERENCES Groups (Id),
	CONSTRAINT FK_GroupsCurators_CuratorId FOREIGN KEY (CuratorId) REFERENCES Curators (Id);
GO

ALTER TABLE Groups
ADD CONSTRAINT FK_Groups_DepartmentId FOREIGN KEY (DepartmentId) REFERENCES Departments (Id);
GO

ALTER TABLE Departments
ADD CONSTRAINT FK_Departments_FacultyId FOREIGN KEY (FacultyId) REFERENCES Faculties (Id);
GO

--Заполнение таблиц тестовыми данными
INSERT INTO Faculties (Name)
VALUES ('Computer Science'),
	   ('Компьютерные сети');
GO

INSERT INTO Departments (Building, Financing, Name, FacultyId)
VALUES (1, 50000, 'Software Development', 1),
	   (1, 60000, 'Разработка ПО', 1),
	   (3, 70000, 'Сетевая безопасность', 2);
GO

INSERT INTO Curators (Name, Surname)
VALUES ('Иван', 'Иванов'),
	   ('Петр', 'Петров');
GO

INSERT INTO Groups (Name, Year, DepartmentId)
VALUES ('БВ111', 5, 1),
	   ('D221', 5, 1),
	   ('БВ113', 3, 2);
GO

INSERT INTO GroupsCurators (CuratorId, GroupId)
VALUES (1, 1),
	   (1, 2),
	   (2, 3);
GO

INSERT INTO Students (Name, Rating, Surname)
VALUES ('Иван', 0, 'Петров'),
	   ('Максим', 1, 'Сидоров'),
	   ('Никита', 2, 'Рудяченко'),
	   ('Максим', 3, 'Пономаренко'),
	   ('Иван', 4, 'Зорин'),
	   ('Даниил', 5, 'Кубиковский');
GO

INSERT INTO GroupsStudents (GroupId, StudentId)
VALUES (1, 1),
	   (1, 2),
	   (2, 3),
	   (2, 4),
	   (3, 5),
	   (3, 6);
GO

INSERT Teachers (IsProfessor, Name, Salary, Surname)
VALUES (1, 'Константин', 15000, 'Хабенский'),
	   (0, 'Михаил', 20000, 'Кержаков');
GO

INSERT Subjects (Name)
VALUES ('Программирование на C#'),
	   ('Программирование на JAVA'),
	   ('Основы компьютерный сетей');
GO

INSERT INTO Lectures (Date, SubjectId, TeacherId)
VALUES ('20221114', 1, 1),
       ('20221114', 1, 2),
	   ('20221115', 1, 2),
	   ('20221116', 2, 1),
	   ('20221117', 2, 2),
	   ('20221118', 1, 2),
	   ('20221119', 2, 1),
	   ('20221119', 3, 1),
	   ('20221119', 3, 2),
	   ('20221120', 3, 1),
	   ('20221120', 3, 2),
	   ('20221121', 1, 1),
	   ('20221122', 2, 2),
	   ('20221123', 3, 1),
	   ('20221124', 3, 2),
	   ('20221125', 1, 2),
	   ('20221126', 2, 1),
	   ('20221127', 3, 1);
GO

INSERT GroupsLectures (GroupId, LectureId)
VALUES (1, 1),
	   (1, 2),
	   (1, 3),
	   (1, 4),
	   (1, 5),
	   (1, 6),
	   (1, 7),
	   (1, 8),
	   (1, 9),
	   (1, 10),
	   (1, 11),
	   (2, 11),
	   (2, 12),
	   (2, 13),
	   (2, 14),
	   (3, 15),
	   (3, 16),
	   (3, 17),
	   (3, 18);
GO