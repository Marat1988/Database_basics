USE [Academy];
GO

/*1. Вывести все возможные пары строк преподавателей и групп.*/
SELECT t.Name + ' ' + t.Surname AS [FIO teacher], g.Name AS [Name group]
FROM GroupsLectures gl
INNER JOIN Groups g ON gl.GroupId=g.Id
INNER JOIN Lectures l ON gl.LectureId=l.Id
INNER JOIN Teachers t ON l.TeacherId=t.Id
ORDER BY t.Name;
GO
/*2. Вывести названия факультетов, фонд финансирования кафедр которых превышает фонд финансирования факультета.*/
SELECT f.Name
FROM
(SELECT FacultyId, SUM(Financing) AS [General fund of departments]
 FROM Departments
 GROUP BY FacultyId) d
INNER JOIN Faculties f ON d.FacultyId=f.Id
WHERE d.[General fund of departments] > f.Financing
ORDER BY f.Name;
GO
/*3. Вывести фамилии кураторов групп и названия групп, которые они курируют.*/
SELECT c.Surname, g.Name AS [Name group]
FROM GroupsCurators gc
INNER JOIN Curators c ON gc.CuratorId=c.Id
INNER JOIN Groups g ON gc.GroupId=g.Id
ORDER BY c.Surname;
GO
/*4. Вывести имена и фамилии преподавателей, которые читают лекции у группы “P107”.*/
SELECT t.Surname, t.Name
FROM Teachers t
INNER JOIN Lectures l ON t.Id=l.TeacherId
INNER JOIN GroupsLectures gl ON l.Id=gl.LectureId
INNER JOIN Groups g ON gl.GroupId=g.Id
WHERE g.Name='P107'
ORDER BY t.Surname;
GO
/*5. Вывести фамилии преподавателей и названия факультетов на которых они читают лекции.*/
SELECT DISTINCT f.Name AS [Name faculties], t.Name AS [Name teachers]
FROM Faculties f
INNER JOIN Departments d ON f.Id=d.FacultyId
INNER JOIN Groups g ON d.Id=g.DepartmentId
INNER JOIN GroupsLectures gl ON g.Id=gl.GroupId
INNER JOIN Lectures l ON gl.LectureId=l.Id
INNER JOIN Teachers t ON l.TeacherId=t.Id
ORDER BY f.Name;
GO
/*6. Вывести названия кафедр и названия групп, которые к ним относятся.*/
SELECT d.Name AS [Name departments], g.Name AS [Name group] 
FROM Departments d
INNER JOIN Groups g ON d.Id=g.DepartmentId
ORDER BY d.Name;
GO
/*7. Вывести названия дисциплин, которые читает преподаватель “Samantha Adams”.*/
SELECT DISTINCT s.Name
FROM Lectures l
INNER JOIN Teachers t ON l.TeacherId=t.Id
INNER JOIN Subjects s ON l.SubjectId=s.Id
WHERE t.Name='Samantha' AND t.Surname='Adams'
ORDER BY s.Name;
GO
/*8. Вывести названия кафедр, на которых читается дисциплина “Database Theory”.*/
SELECT DISTINCT d.Name AS [Name department]
FROM Departments d
INNER JOIN Groups g ON d.Id=g.DepartmentId
INNER JOIN GroupsLectures gl ON g.Id=gl.GroupId
INNER JOIN Lectures l ON gl.LectureId=l.Id
INNER JOIN Subjects s ON l.SubjectId=s.Id
WHERE s.Name='Database Theory'
ORDER BY d.Name;
GO
/*9. Вывести названия групп, которые относятся к факультету “Computer Science”.*/
SELECT g.Name AS [Name group]
FROM Faculties f
INNER JOIN Departments d ON f.Id=d.FacultyId
INNER JOIN Groups g ON d.Id=g.DepartmentId
WHERE f.Name='Computer Science'
ORDER BY g.Name;
GO
/*10. Вывести названия групп 5-го курса, а также название факультетов, к которым они относятся.*/
SELECT g.Name AS [Name group], f.Name AS [Name faculties]
FROM Faculties f
INNER JOIN Departments d ON f.Id=d.FacultyId
INNER JOIN Groups g ON d.Id=g.DepartmentId
WHERE g.[Year]=5
ORDER BY g.Name;
GO
/*11. Вывести полные имена преподавателей и лекции, которые они читают (названия дисциплин и групп), причем отобрать только те лекции, 
 которые читаются в аудитории “B103”.*/
 SELECT t.Name + ' ' + t.Surname AS [FIO teacher], s.Name AS [Name subject], g.Name AS [Name group]
 FROM Lectures l
 INNER JOIN Teachers t ON l.TeacherId=t.Id
 INNER JOIN Subjects s ON l.SubjectId=s.Id
 INNER JOIN GroupsLectures gl ON l.Id=gl.LectureId
 INNER JOIN Groups g ON gl.GroupId=g.Id
 WHERE l.LectureRoom='B103'
 ORDER BY t.Name;
 GO









