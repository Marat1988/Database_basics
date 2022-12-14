# <b>HomeWork6</b>

Запросы:<br>
<ol>
<li>Вывести номера корпусов, если суммарный фонд финансирования расположенных в них кафедр превышает 100000.</li>
<li>Вывести названия групп 5-го курса кафедры “Software Development”, которые имеют более 10 пар в первую неделю.</li>
<li>Вывести названия групп, имеющих рейтинг (средний рейтинг всех студентов группы) больше, чем рейтинг группы “D221”.</li>
<li>Вывести фамилии и имена преподавателей, ставка которых выше средней ставки профессоров.</li>
<li>Вывести названия групп, у которых больше одного куратора.</li>
<li>Вывести названия групп, имеющих рейтинг (средний рейтинг всех студентов группы) меньше, чем минимальный рейтинг групп 5-го курса.</li>
<li>Вывести названия факультетов, суммарный фонд финансирования кафедр которых больше суммарного фонда финансирования кафедр факультета “Computer Science”.</li>
<li>Вывести названия дисциплин и полные имена преподавателей, читающих наибольшее количество лекций по ним.</li>
<li>Вывести название дисциплины, по которому читается меньше всего лекций.</li>
<li>Вывести количество студентов и читаемых дисциплин на кафедре “Software Development”.</li>
</ol>
Структура базы данных

![Схема базы данных](https://user-images.githubusercontent.com/108996479/205450008-0feb10ae-d660-4e43-a037-f3a1216a2a0d.png)

Описание

База данных <b>Академия</b> (<i>Academy</i>) содержит информацию о сотрудниках, внутреннем устройстве академии и читаемых лекциях. Преподаватели, читающие лекции в академии представлены в виде таблицы <b>Преподаватели</b> (<i>Teachers</i>), в которой собрана основная информация, такая как: имя, фамилия и данные о зарплате. Также в базе данных присутствует информация о группах, хранимая в таблице <b>Группы</b> (<i>Groups</i>). Данные о факультетах и кафедрах содержатся в таблицах <b>Факультеты</b> (<i>Faculties</i>) и <b>Кафедры</b> (<i>Departments</i>) соответственно. Помимо этого, база данных хранит информацию, связанную с проводимыми лекциями. Расписание лекций содержится в таблице <b>Лекции</b> (<i>Lectures</i>), а описание дисциплин, по которым читаются лекции, в таблице <b>Дисциплины</b> (<i>Subjects</i>). Информация о студентах содержится в таблице <b>Студенты</b> (<i>Students</i>).

Таблицы

Ниже представлено детальное описание структуры каждой таблицы.
<ol>
<li>
  <b>Кураторы (Curators)</b>
  <ul>
    <li><b>Идентификатор (Id). Уникальный идентификатор куратора.</b>
      <ul>
        <li>Тип данных — int.</li>
        <li>Авто приращение.</li>  
        <li>Не может содержать null-значения.</li>  
        <li>Первичный ключ.</li>  
      </ul>
    </li>
    <li><b>Имя (Name). Имя куратора.</b>
      <ul>
        <li>Тип данных — nvarchar(max).</li>
        <li>Не может содержать null-значения.</li>
        <li>Не может быть пустым.</li>
      </ul>
    </li>
    <li><b>Фамилия (Surname). Фамилия куратора.</b>
      <ul>
        <li>Тип данных — nvarchar(max).</li>
        <li>Не может содержать null-значения.</li>
        <li>Не может быть пустым.</li>
      </ul>
    </li>
  </ul>
</li>
<li>
  <b>Кафедры (Departments)</b>
  <ul>
    <li><b>Идентификатор (Id). Уникальный идентификатор куратора.</b>
      <ul>
        <li>Тип данных — int.</li>
        <li>Авто приращение.</li>  
        <li>Не может содержать null-значения.</li>  
        <li>Первичный ключ.</li>  
      </ul>
    </li>
    <li><b>Корпус (Building). Номер корпуса, в котором располагается кафедра.</b>
      <ul>
        <li>Тип данных — nvarchar(max).</li>
        <li>Не может содержать null-значения.</li>
        <li>Не может быть пустым.</li>
      </ul>
    </li>
    <li><b>Финансирование (Financing). Фонд финансирования кафедры.</b>
      <ul>
        <li>Тип данных — money.</li>
        <li>Не может содержать null-значения.</li>
        <li>Не может быть меньше 0.</li>
        <li>Значение по умолчанию — 0.</li>
      </ul>
    </li>
    <li><b>Название (Name). Название кафедры.</b>
      <ul>
        <li>Тип данных — nvarchar(100).</li>
        <li>Не может содержать null-значения.</li>
        <li>Не может быть пустым.</li>
        <li>Должно быть уникальным.</li>
      </ul>
    </li>
    <li><b>Идентификатор факультета (FacultyId). Факультет, в состав которого входит кафедра.</b>
      <ul>
        <li>Тип данных — int.</li>
        <li>Не может содержать null-значения.</li>
        <li>Внешний ключ.</li>
      </ul>
    </li>
  </ul>
</li>
<li>
  <b>Факультеты (Faculties)</b>
  <ul>
    <li><b>Идентификатор (Id). Уникальный идентификатор факультета.</b>
      <ul>
        <li>Тип данных — int.</li>
        <li>Авто приращение.</li>  
        <li>Не может содержать null-значения.</li>  
        <li>Первичный ключ.</li>  
      </ul>
    </li>
    <li><b>Название (Name). Название факультета.</b>
      <ul>
        <li>Тип данных — nvarchar(100).</li>
        <li>Не может содержать null-значения.</li>
        <li>Не может быть пустым.</li>
        <li>Должно быть уникальным.</li>
      </ul>
    </li>
  </ul>
</li>
<li>
  <b>Группы (Groups)</b>
  <ul>
    <li><b>Идентификатор (Id). Уникальный идентификатор группы.</b>
      <ul>
        <li>Тип данных — int.</li>
        <li>Авто приращение.</li>  
        <li>Не может содержать null-значения.</li>  
        <li>Первичный ключ.</li>  
      </ul>
    </li>
    <li><b>Название (Name). Название группы.</b>
      <ul>
        <li>Тип данных — nvarchar(10).</li>
        <li>Не может содержать null-значения.</li>
        <li>Не может быть пустым.</li>
        <li>Должно быть уникальным.</li>
      </ul>
    </li>
    <li><b>Курс (Year). Курс (год) на котором обучается группа.</b>
      <ul>
        <li>Тип данных — int.</li>
        <li>Не может содержать null-значения.</li>
        <li>Должно быть в диапазоне от 1 до 5.</li>
      </ul>
    </li>
    <li><b>Идентификатор кафедры (DepartmentId). Кафедра, в состав которой входит группа.</b>
      <ul>
        <li>Тип данных — int.</li>
        <li>Не может содержать null-значения.</li>
        <li>Внешний ключ.</li>
      </ul>
    </li>
  </ul>
</li>
<li>
  <b>Группы и кураторы (GroupsCurators)</b>
  <ul>
    <li><b>Идентификатор (Id). Уникальный идентификатор группы и куратора.</b>
      <ul>
        <li>Тип данных — int.</li>
        <li>Авто приращение.</li>  
        <li>Не может содержать null-значения.</li>  
        <li>Первичный ключ.</li>  
      </ul>
    </li>
    <li><b>Идентификатор куратора (CuratorId). Куратор.</b>
      <ul>
        <li>Тип данных — int.</li>
        <li>Не может содержать null-значения.</li>
        <li>Внешний ключ.</li>
      </ul>
    </li>
    <li><b>Идентификатор группы (GroupId). Группа.</b>
      <ul>
        <li>Тип данных — int.</li>
        <li>Не может содержать null-значения.</li>
        <li>Внешний ключ.</li>
      </ul>
    </li>
  </ul>
</li>
<li>
  <b>Группы и лекции (GroupsLectures)</b>
  <ul>
    <li><b>Идентификатор (Id). Уникальный идентификатор группы и куратора.</b>
      <ul>
        <li>Тип данных — int.</li>
        <li>Авто приращение.</li>  
        <li>Не может содержать null-значения.</li>  
        <li>Первичный ключ.</li>  
      </ul>
    </li>
    <li><b>Идентификатор группы (GroupId). Группа.</b>
      <ul>
        <li>Тип данных — int.</li>
        <li>Не может содержать null-значения.</li>
        <li>Внешний ключ.</li>
      </ul>
    </li>
    <li><b>Идентификатор лекции (LectureId). Лекция.</b>
      <ul>
        <li>Тип данных — int.</li>
        <li>Не может содержать null-значения.</li>
        <li>Внешний ключ.</li>
      </ul>
    </li>
  </ul>
</li>
<li>
  <b>Группы и студенты (GroupsStudents)</b>
  <ul>
    <li><b>Идентификатор (Id). Уникальный идентификатор группы и студенты.</b>
      <ul>
        <li>Тип данных — int.</li>
        <li>Авто приращение.</li>  
        <li>Не может содержать null-значения.</li>  
        <li>Первичный ключ.</li>  
      </ul>
    </li>
    <li><b>Идентификатор группы (GroupId). Группа.</b>
      <ul>
        <li>Тип данных — int.</li>
        <li>Не может содержать null-значения.</li>
        <li>Внешний ключ.</li>
      </ul>
    </li>
    <li><b>Идентификатор студента (StudentId). Студент.</b>
      <ul>
        <li>Тип данных — int.</li>
        <li>Не может содержать null-значения.</li>
        <li>Внешний ключ.</li>
      </ul>
    </li>
  </ul>
</li>
<li>
  <b>Лекции (Lectures)</b>
  <ul>
    <li><b>Идентификатор (Id). Уникальный идентификатор лекции.</b>
      <ul>
        <li>Тип данных — int.</li>
        <li>Авто приращение.</li>  
        <li>Не может содержать null-значения.</li>  
        <li>Первичный ключ.</li>  
      </ul>
    </li>
    <li><b>Дата проведения (Date). Дата проведения лекции.</b>
      <ul>
        <li>Тип данных — date.</li>
        <li>Не может содержать null-значения.</li>
        <li>Не может быть больше текущей даты.</li>
      </ul>
    </li>
    <li><b>Идентификатор дисциплины (SubjectId). Дисциплина, по которой читается лекция.</b>
      <ul>
        <li>Тип данных — int.</li>
        <li>Не может содержать null-значения.</li>
        <li>Внешний ключ.</li>
      </ul>
    </li>
    <li><b>Идентификатор преподавателя (TeacherId). Преподаватель, который читает лекцию.</b>
      <ul>
        <li>Тип данных — int.</li>
        <li>Не может содержать null-значения.</li>
        <li>Внешний ключ.</li>
      </ul>
    </li>
  </ul>
</li>
<li>
  <b>Студенты (Students)</b>
  <ul>
    <li><b>Идентификатор (Id). Уникальный идентификатор студенты.</b>
      <ul>
        <li>Тип данных — int.</li>
        <li>Авто приращение.</li>  
        <li>Не может содержать null-значения.</li>  
        <li>Первичный ключ.</li>  
      </ul>
    </li>
    <li><b>Имя (Name). Имя студента.</b>
      <ul>
        <li>Тип данных — nvarchar(max).</li>
        <li>Не может содержать null-значения.</li>
        <li>Не может быть пустым.</li>
      </ul>
    </li>
    <li><b>Рейтинг (Rating). Рейтинг студента.</b>
      <ul>
        <li>Тип данных — int.</li>
        <li>Не может содержать null-значения.</li>
        <li>Должно быть в диапазоне от 0 до 5.</li>
      </ul>
    </li>
    <li><b>Фамилия (Surname). Фамилия студента.</b>
      <ul>
        <li>Тип данных — nvarchar(max).</li>
        <li>Не может содержать null-значения.</li>
        <li>Не может быть пустым.</li>
      </ul>
    </li>
  </ul>
</li>
<li>
  <b>Дисциплины (Subjects)</b>
  <ul>
    <li><b>Идентификатор (Id). Уникальный идентификатор дисциплины.</b>
      <ul>
        <li>Тип данных — int.</li>
        <li>Авто приращение.</li>  
        <li>Не может содержать null-значения.</li>  
        <li>Первичный ключ.</li>  
      </ul>
    </li>
    <li><b>Название (Name). Название дисциплины.</b>
      <ul>
        <li>Тип данных — nvarchar(100).</li>
        <li>Не может содержать null-значения.</li>
        <li>Не может быть пустым.</li>
        <li>Должно быть уникальным.</li>
      </ul>
    </li>
  </ul>
</li>
<li>
  <b>Преподаватели (Teachers)</b>
  <ul>
    <li><b>Идентификатор (Id). Уникальный идентификатор преподавателя.</b>
      <ul>
        <li>Тип данных — int.</li>
        <li>Авто приращение.</li>  
        <li>Не может содержать null-значения.</li>  
        <li>Первичный ключ.</li>  
      </ul>
    </li>
    <li><b>Профессор (IsProfessor). Является ли преподаватель профессором.</b>
      <ul>
        <li>Тип данных — bit.</li>
        <li>Не может содержать null-значения.</li>
        <li>Значение по умолчанию — 0.</li>
      </ul>
    </li>
    <li><b>Имя (Name). Имя преподавателя.</b>
      <ul>
        <li>Тип данных — nvarchar(max).</li>
        <li>Не может содержать null-значения.</li>
        <li>Не может быть пустым.</li>
      </ul>
    </li>
    <li><b>Ставка (Salary). Ставка преподавателя.</b>
      <ul>
        <li>Тип данных — money.</li>
        <li>Не может содержать null-значения.</li>
        <li>Не может быть меньше либо равно 0.</li>
      </ul>
    </li>
    <li><b>Фамилия (Surname). Фамилия преподавателя.</b>
      <ul>
        <li>Тип данных — nvarchar(max).</li>
        <li>Не может содержать null-значения.</li>
        <li>Не может быть пустым.</li>
      </ul>
    </li>
  </ul>
</li>
</ol>
