/*1) Вывести таблицу кафедр, но расположить ее поля в обратном порядке.*/
SELECT Id, Financing, Name
FROM Departments
ORDER BY Id DESC;
GO
/*2) Вывести названия групп и их рейтинги, используя в качестве названий выводимых полей “Group Name” и “Group Rating” соответственно.*/
SELECT Name AS [Group Name], Rating AS [Group Rating]
FROM Groups
ORDER BY [Name];
GO
/*3) Вывести для преподавателей их фамилию, процент ставки по отношению к надбавке и процент ставки по отношению к зарплате (сумма ставки и надбавки).*/
SELECT Surname, ROUND(Salary*100/Premium,2) AS [Процент ставки по отношению к надбавке], ROUND(Salary*100/(Premium+Salary),2) AS [Процент ставки по отношению к зарплате]
FROM Teachers
ORDER BY Surname;
GO
/*4) Вывести таблицу факультетов в виде одного поля в следующем формате: “The dean of faculty [faculty] is [dean].”*/
SELECT 'The dean of faculty ' + [Name] + ' is ' + Dean
FROM Faculties
ORDER BY [Name];
GO
/*5) Вывести фамилии преподавателей, которые являются профессорами и ставка которых превышает 1050.*/
SELECT SurName
FROM Teachers
WHERE IsProfessor=1 AND Salary>1050
ORDER BY SurName;
GO
/*6) Вывести названия кафедр, фонд финансирования которых меньше 11000 или больше 25000.*/
SELECT [Name]
FROM Departments
WHERE Financing<11000 OR Financing>25000
ORDER BY [Name];
GO
/*7) Вывести названия факультетов кроме факультета “Computer Science”.*/
SELECT [Name]
FROM Faculties
WHERE [Name]<>'Computer Science'
ORDER BY [Name];
GO
/*8) Вывести фамилии и должности преподавателей, которые не являются профессорами.*/
SELECT Surname, Position
FROM Teachers
WHERE IsProfessor=0
ORDER BY Surname;
GO
/*9) Вывести фамилии, должности, ставки и надбавки ассистентов, у которых надбавка в диапазоне от 160 до 550.*/
SELECT Surname, Position, Salary, Premium
FROM Teachers
WHERE IsAssistant=1 AND Premium BETWEEN 160 AND 550
ORDER BY Surname;
GO
/*10)  Вывести фамилии и ставки ассистентов.*/
SELECT Surname, Salary
FROM Teachers
WHERE IsAssistant=1
ORDER BY Surname;
GO
/*11) Вывести фамилии и должности преподавателей, которые были приняты на работу до 01.01.2000.*/
SELECT Surname, Position
FROM Teachers
WHERE EmploymentDate<'20000101'
ORDER BY Surname;
GO
/*12)  Вывести названия кафедр, которые в алфавитном порядке располагаются до кафедры “Software Development”. 
Выводимое поле должно иметь название “Name of Department”.*/
SELECT [Name] AS 'Name of Department'
FROM Departments
WHERE ASCII(SUBSTRING('Software Development', 1, 1))>ASCII(SUBSTRING(Name, 1, 1))
ORDER BY [Name];
GO
/*13) Вывести фамилии ассистентов, имеющих зарплату (сумма ставки и надбавки) не более 1200.*/
SELECT Surname
FROM Teachers
WHERE IsAssistant=1 AND ((Premium+Salary)<1200)
ORDER BY Surname;
GO
/*14)  Вывести названия групп 5-го курса, имеющих рейтинг  в диапазоне от 2 до 4.*/
SELECT [Name]
FROM Groups
WHERE [Year]=5 AND Rating BETWEEN 2 AND 4
ORDER BY [Name];
GO
/*15) Вывести фамилии ассистентов со ставкой меньше 550 или надбавкой меньше 200.*/
SELECT Surname
FROM Teachers
WHERE IsAssistant=1 AND (Salary<500 OR Premium<200)
ORDER BY Surname;
GO




