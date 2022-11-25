USE Academy;
GO

/*1). Вывести количество преподавателей кафедры “Software Development”.*/
SELECT COUNT(DISTINCT t.Id) AS [Count teachers]
FROM Departments d
INNER JOIN Groups g ON d.Id=g.DepartmentId
INNER JOIN GroupsLectures gl ON g.Id=gl.GroupId
INNER JOIN Lectures l ON gl.LectureId=l.Id
INNER JOIN Teachers t ON l.TeacherId=t.Id
WHERE d.Name='Software Development';
GO

/*2). Вывести количество лекций, которые читает преподаватель “Dave McQueen”.*/
SELECT COUNT(DISTINCT s.Id) AS [Count lectures]
FROM Lectures l
INNER JOIN Subjects s ON l.SubjectId=s.Id
INNER JOIN Teachers t ON l.TeacherId=t.Id
WHERE t.Name='Dave' AND t.Surname='McQueen';
GO

/*3). Вывести количество занятий, проводимых в аудитории “D201”.*/
SELECT COUNT(Id) AS [Count lectures]
FROM Lectures
WHERE LectureRoom='D201';
GO

/*4). Вывести названия аудиторий и количество лекций, проводимых в них*/
SELECT LectureRoom, COUNT(Id) AS [Count lectures]
FROM Lectures
GROUP BY LectureRoom;
GO

/*5). Вывести количество студентов, посещающих лекции преподавателя “Jack Underhill”*/
/*Данный запрос вывести не предоставляется возможным, т.к. в текущей структуре базы данных отсутствует
какая-либо информация о студентах*/

/*6). Вывести среднюю ставку преподавателей факультета “Computer Science”.*/
SELECT ROUND(AVG(DISTINCT t.Salary),2) AS [AVG salary]
FROM Faculties f
INNER JOIN Departments d ON f.Id=d.FacultyId
INNER JOIN Groups g ON d.Id=g.DepartmentId
INNER JOIN GroupsLectures gl ON g.Id=gl.GroupId
INNER JOIN Lectures l ON gl.LectureId=l.Id
INNER JOIN Teachers t ON l.TeacherId=t.Id
WHERE f.Name='Computer Science';
GO

/*7). Вывести минимальное и максимальное количество студентов среди всех групп.*/
/*Данный запрос вывести не предоставляется возможным, т.к. в текущей структуре базы данных отсутствует
какая-либо информация о студентах*/

/*8). Вывести средний фонд финансирования кафедр.*/
SELECT AVG(Financing) AS [AVG Financing Departments]
FROM Departments;
GO

/*9). Вывести полные имена преподавателей и количество читаемых ими дисциплин.*/
SELECT t.Name+' '+t.Surname AS FIO, COUNT(DISTINCT l.SubjectId) AS [Count subject teacher]
FROM Teachers t
INNER JOIN Lectures l ON t.Id=l.TeacherId
GROUP BY t.Name+' '+t.Surname
ORDER BY 1;
GO

/*10. Вывести количество лекций в каждый день недели.*/
SELECT gl.[DayOfWeek], COUNT(gl.LectureId) AS [Count lectures]
FROM GroupsLectures gl
GROUP BY gl.[DayOfWeek]
ORDER BY 1;
GO

/*11. Вывести номера аудиторий и количество кафедр, чьи лекции в них читаются*/
SELECT l.LectureRoom, COUNT(DISTINCT d.Id) AS [Count departments]
FROM Lectures l
INNER JOIN GroupsLectures gl ON l.Id=gl.LectureId
INNER JOIN Groups g ON gl.GroupId=g.Id
INNER JOIN Departments d ON g.DepartmentId=d.Id
GROUP BY l.LectureRoom
ORDER BY l.LectureRoom;
GO

/*12. Вывести названия факультетов и количество дисциплин, которые на них читаются.*/
SELECT f.Name AS [Name faculties], COUNT(DISTINCT s.Id) AS [Count subjects]
FROM Faculties f
INNER JOIN Departments d ON f.Id=d.FacultyId
INNER JOIN Groups g ON d.Id=g.DepartmentId
INNER JOIN GroupsLectures gl ON g.Id=gl.GroupId
INNER JOIN Lectures l ON gl.LectureId=l.Id
INNER JOIN Subjects s ON l.SubjectId=s.Id
GROUP BY f.Name;
GO

/*13. Вывести количество лекций для каждой пары преподаватель-аудитория*/
SELECT t.Name + ' ' + t.Surname AS FIO, l.LectureRoom, COUNT(l.Id) AS [Count lectures]
FROM Lectures l
INNER JOIN Teachers t ON l.TeacherId=t.Id
GROUP BY t.Name + ' ' + t.Surname, l.LectureRoom
ORDER BY 2,1;
GO