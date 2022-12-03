USE Academy;
GO

/*1. Вывести номера корпусов, если суммарный фонд финансирования расположенных в них кафедр превышает 100000*/
SELECT Building
FROM Departments
GROUP BY Building
HAVING SUM(Financing)>100000;
GO

/*2. Вывести названия групп 5-го курса кафедры “Software Development”, которые имеют более 10 пар в первую неделю.*/
SELECT g.Name AS [Group name], DATEPART(ISO_WEEK, Date) AS [Week], COUNT(l.Id) AS [Count Lectures]
FROM Groups g
INNER JOIN GroupsLectures gl ON g.Id=gl.GroupId
INNER JOIN Lectures l ON gl.LectureId=l.Id
WHERE g.[Year]=5 AND DATEPART(ISO_WEEK, Date)=(SELECT MIN(DATEPART(ISO_WEEK, Date)) AS [First week] FROM Lectures)
GROUP BY g.Name, DATEPART(ISO_WEEK, Date)
HAVING COUNT(l.Id)>10;
GO

/*3. Вывести названия групп, имеющих рейтинг (средний рейтинг всех студентов группы) больше, чем рейтинг группы “D221”.*/
SELECT g.Name AS [Group name], AVG(Rating) AS [Rating group]
FROM Students s
INNER JOIN GroupsStudents gs ON s.Id=gs.StudentId
INNER JOIN Groups g ON gs.GroupId=g.Id
WHERE g.Name<>'D221'
GROUP BY g.Name
HAVING AVG(Rating)>(SELECT AVG(s.Rating) AS [AVG Group D221]
				    FROM Students s
					INNER JOIN GroupsStudents gs ON s.Id=gs.StudentId
					WHERE gs.GroupId=(SELECT Id 
									  FROM Groups 
									  WHERE [Name]='D221')
				   );
GO

/*4. Вывести фамилии и имена преподавателей, ставка которых выше средней ставки профессоров.*/
SELECT s.Name AS [Name teacher], s.Surname AS [Surname teacher]
FROM Teachers s
WHERE IsProfessor=0 AND s.Salary>(SELECT AVG(Salary) AS [AVG salary professors] 
								  FROM Teachers s
								  WHERE IsProfessor=1);
GO

/*5. Вывести названия групп, у которых больше одного куратора.*/
SELECT g.Name AS [Name group]
FROM Groups g
INNER JOIN GroupsCurators gc ON g.Id=gc.GroupId
GROUP BY g.Name
HAVING COUNT(DISTINCT gc.CuratorId)>1;
GO

/*6. Вывести названия групп, имеющих рейтинг (средний рейтинг всех студентов группы) меньше, чем минимальный рейтинг групп 5-го курса.*/
SELECT g.Name AS [Group name]
FROM Groups g
INNER JOIN GroupsStudents gs ON g.Id=gs.GroupId
INNER JOIN Students s ON gs.StudentId=s.Id
WHERE g.Year!=5
GROUP BY g.Name
HAVING  AVG(s.Rating)<(SELECT MIN(Rating) AS [Min rating groups 5 year]
					   FROM
                       (SELECT AVG(s.Rating) AS Rating
					    FROM Groups g
					    INNER JOIN GroupsStudents gs ON g.Id=gs.GroupId
					    INNER JOIN Students s ON gs.StudentId=s.Id
					    WHERE g.Year=5
					    GROUP BY g.Name) info
					  );
GO

/*7. Вывести названия факультетов, суммарный фонд финансирования кафедр которых больше суммарного фонда финансирования кафедр факультета “Computer Science”.*/
SELECT f.Name AS [Name faculties]
FROM Faculties f
INNER JOIN Departments d ON f.Id=d.FacultyId
WHERE f.Name<>'Computer Science'
GROUP BY f.Name
HAVING SUM(d.Financing)>(SELECT SUM(d.Financing) AS [SUM financing departments faculties “Computer Science”]
						 FROM Faculties f
						 INNER JOIN Departments d ON f.Id=d.FacultyId
						 WHERE f.Name='Computer Science');
GO

/*8. Вывести названия дисциплин и полные имена преподавателей, читающих наибольшее количество лекций по ним.
 P.S. Как я понял, сначала нужно выяснить дисциплины, которые читаются больше всех (подзапрос lectures). И далее,
 узнаем полные имена преподавателей, которые преподают эти дисциплины*/
SELECT DISTINCT s.Name AS [Name subject], t.Name + ' ' + t.Surname AS [FIO teacher]
FROM
(SELECT l.SubjectId AS [SubjectId], COUNT(l.Id) AS [Count lectures], MAX(COUNT(l.Id)) OVER() AS [Max count lectures] 
 FROM Lectures l
 GROUP BY l.SubjectId) lectures
INNER JOIN Lectures l1 ON lectures.[SubjectId]=l1.SubjectId
INNER JOIN Teachers t ON l1.TeacherId=t.Id
INNER JOIN Subjects s ON l1.SubjectId=s.Id
WHERE lectures.[Count lectures]=lectures.[Max count lectures];
GO

/*9. Вывести название дисциплины, по которому читается меньше всего лекций.*/
SELECT info.[Subject name]
FROM
(SELECT s.Name AS [Subject name], COUNT(l.id) AS [Count lectures], MIN(COUNT(l.id)) OVER() AS [Min count lectures] 
 FROM Lectures l
 INNER JOIN Subjects s ON l.SubjectId=s.Id
 GROUP BY s.Name) info
WHERE info.[Count lectures]=info.[Min count lectures];
GO

/*10. Вывести количество студентов и читаемых дисциплин на кафедре “Software Development”.*/
SELECT COUNT(DISTINCT s.Id) AS [Count students], COUNT(DISTINCT l.SubjectId) AS [Count subjects]
FROM Departments d
INNER JOIN Groups g ON d.Id=g.DepartmentId
INNER JOIN GroupsStudents gs ON g.Id=gs.GroupId
INNER JOIN Students s ON gs.StudentId=s.Id
INNER JOIN GroupsLectures gl ON g.Id=gl.GroupId
INNER JOIN Lectures l ON gl.LectureId=l.Id
WHERE d.Name='Software Development';
GO