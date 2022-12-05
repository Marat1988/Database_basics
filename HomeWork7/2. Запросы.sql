USE Academy;
GO

--1). ¬ывести названи¤ аудиторий, в которых читает лекции преподаватель УEdward HopperФ.
SELECT DISTINCT lr.[Name] AS [Name lectureRoom]
FROM Teachers t
INNER JOIN Lectures l ON t.Id=l.TeacherId
INNER JOIN Schedules s ON l.Id=s.LectureId
INNER JOIN LectureRooms lr ON s.LectureRoomId=lr.Id
WHERE t.[Name]='Edward' AND t.Surname='Hopper';
GO