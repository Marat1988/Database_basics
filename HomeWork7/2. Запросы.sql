USE Academy;
GO

--1). Вывести названи¤ аудиторий, в которых читает лекции преподаватель Edward Hopper.
SELECT DISTINCT lr.[Name] AS [Name lectureRoom]
FROM Teachers t
INNER JOIN Lectures l ON t.Id=l.TeacherId
INNER JOIN Schedules s ON l.Id=s.LectureId
INNER JOIN LectureRooms lr ON s.LectureRoomId=lr.Id
WHERE t.[Name]='Edward' AND t.Surname='Hopper';
GO

--2). Вывести фамилии ассистентов, читающих лекции в группе “F505”.
SELECT DISTINCT t.Surname AS [Surname teachers]
FROM Teachers t
INNER JOIN Assistants a ON t.Id=a.TeacherId
INNER JOIN Lectures l ON t.Id=l.TeacherId
INNER JOIN GroupsLectures gl ON l.Id=gl.LectureId
INNER JOIN Groups g ON gl.GroupId=g.Id
WHERE g.[Name]='F505';
GO

--3). Вывести дисциплины, которые читает преподаватель “Alex Carmack” для групп 5-го курса.
SELECT DISTINCT s.[Name] AS [Subject name]
FROM Lectures l
INNER JOIN Teachers t ON l.TeacherId=t.Id
INNER JOIN Subjects s ON l.SubjectId=s.Id
INNER JOIN GroupsLectures gl ON l.Id=gl.LectureId
INNER JOIN Groups g ON gl.GroupId=g.Id
WHERE g.[Year]=5 AND t.[Name]='Alex' AND t.Surname='Carmack';
GO

--4). Вывести фамилии преподавателей, которые не читают лекции по понедельникам.
SELECT t.Surname AS [Surname teacher]
FROM Teachers t
WHERE t.Id NOT IN (SELECT t.Id
				   FROM Teachers t
				   INNER JOIN Lectures l ON t.Id=l.TeacherId
				   INNER JOIN Schedules s ON l.Id=s.LectureId
				   WHERE s.[DayOfWeek]=1);
GO

--5). Вывести названия аудиторий, с указанием их корпусов,в которых нет лекций в среду второй недели на третьей паре.
SELECT l.[Name] AS [Name lecture room], l.Building AS [building lecture room]
FROM LectureRooms l
WHERE l.Id NOT IN (SELECT l.Id
				   FROM LectureRooms l
				   INNER JOIN Schedules s ON l.Id=s.LectureRoomId
				   WHERE s.Class=3 AND s.[DayOfWeek]=3 AND s.[Week]=2);
GO

--6). Вывести полные имена преподавателей факультета “Computer Science”, которые не курируют группы кафедры “Software  Development”.
SELECT DISTINCT t.[Name]+' '+t.Surname AS [FIO teacher] 
FROM Teachers t
INNER JOIN Lectures l ON t.Id=l.TeacherId
INNER JOIN GroupsLectures gl ON l.Id=gl.LectureId
INNER JOIN Groups g ON gl.GroupId=g.Id
INNER JOIN Departments d ON g.DepartmentId=d.Id
INNER JOIN Faculties f ON d.FacultyId=f.Id
WHERE f.[Name]='Computer Science' AND t.Id NOT IN (SELECT DISTINCT gk.CuratorId
												   FROM Faculties f
												   INNER JOIN Departments d ON f.Id=d.FacultyId
												   INNER JOIN Groups g ON d.Id=g.DepartmentId
												   INNER JOIN GroupsCurators gk ON g.Id=gk.GroupId
												   WHERE f.[Name]='Computer Science' AND d.[Name]='Software Development');
GO
--7). Вывести список номеров всех корпусов, которые имеются в таблицах факультетов, кафедр и аудиторий
SELECT Building
FROM Faculties
UNION
SELECT Building
FROM Departments
UNION
SELECT Building
FROM LectureRooms;
GO
--8). Вывести полные имена преподавателей в следующем порядке: деканы факультетов, заведующие кафедрами, преподаватели, кураторы, ассистенты.
SELECT INFO.Post, INFO.[FIO teachers]
FROM
(SELECT 0 AS [Order], 'Декан' AS [Post], t.[Name]+' '+t.Surname AS [FIO teachers]
 FROM Deans d
 INNER JOIN Teachers t ON d.TeacherId=t.Id
 UNION ALL
 SELECT 1 AS [Order], 'Заведующий кафедрой' AS [Post], t.[Name]+' '+t.Surname AS [FIO teachers]
 FROM Heads h
 INNER JOIN Teachers t ON h.TeacherId=t.Id
 UNION ALL
 SELECT 2 AS [Order], 'Преподаватель' AS [Post], t.[Name]+' '+t.Surname AS [FIO teachers]
 FROM Teachers t
 UNION ALL
 SELECT 3 AS [Order], 'Куратор' AS [Post], t.[Name]+' '+t.Surname AS [FIO teachers]
 FROM Curators c
 INNER JOIN Teachers t ON c.TeacherId=t.Id
 UNION ALL
 SELECT 4 AS [Order], 'Ассистент' AS [Post], t.[Name]+' '+t.Surname AS [FIO teachers]
 FROM Assistants a
 INNER JOIN Teachers t ON a.TeacherId=t.Id
) INFO
ORDER BY INFO.[Order];
GO
--9). Вывести дни недели (без повторений), в которые имеются занятия в аудиториях “A311” и “A104” корпуса 6.
/*P.S. В текущей структуре базы данных на поле Building (номер корпуса) установлено ограничение (CHECK) от 1 до 5.
Поэтому в условии WHERE я поставил lr.Building=5*/
SELECT DISTINCT s.[DayOfWeek]
FROM LectureRooms lr
INNER JOIN Schedules s ON lr.Id=s.LectureRoomId
WHERE lr.[Name] IN ('A311', 'A104') AND lr.Building=5;
GO


