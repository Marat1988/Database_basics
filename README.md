# Теория базы данных. Программирование MS SQL Server БК

<b>HomeWork3</b>

Запросы:<br>
<ol>
<li>Вывести таблицу кафедр, но расположить ее поля в обратном порядке.</li>
<li>Вывести названия групп и их рейтинги, используя в качестве названий выводимых полей “Group Name” и “Group Rating” соответственно.</li>
<li>Вывести для преподавателей их фамилию, процент ставки по отношению к надбавке и процент ставки по отношению к зарплате (сумма ставки и надбавки).</li>
<li>Вывести таблицу факультетов в виде одного поля в следующем формате: “The dean of faculty [faculty] is [dean].”.</li>
<li>Вывести фамилии преподавателей, которые являются профессорами и ставка которых превышает 1050.</li>
<li>Вывести названия кафедр, фонд финансирования которых меньше 11000 или больше 25000.</li>
<li>Вывести названия факультетов кроме факультета “Computer Science”.</li>
<li>Вывести фамилии и должности преподавателей, которые не являются профессорами.</li>
<li>Вывести фамилии, должности, ставки и надбавки ассистентов, у которых надбавка в диапазоне от 160 до 550.</li>
<li>Вывести фамилии и ставки ассистентов.</li>
<li>Вывести фамилии и должности преподавателей, которые были приняты на работу до 01.01.2000.</li>
<li>Вывести названия кафедр, которые в алфавитном порядке располагаются до кафедры “Software Development”. Выводимое поле должно иметь название “Name of Department”.</li>
<li>Вывести фамилии ассистентов, имеющих зарплату (сумма ставки и надбавки) не более 1200.</li>
<li>Вывести названия групп 5-го курса, имеющих рейтинг в диапазоне от 2 до 4.</li>
<li>Вывести фамилии ассистентов со ставкой меньше 550 или надбавкой меньше 200.</li>
</ol>
Структура базы данных

![Схема базы данных](https://user-images.githubusercontent.com/108996479/203820131-878c2133-2717-4665-a0e2-a9714ae52e57.png)

Описание

База данных <b>Академия</b> (<i>Academy</i>) содержит информацию о сотрудниках и внутреннем устройстве академии. Преподаватели, читающие лекции в академии представлены в виде таблицы <b>Преподаватели</b> (<i>Teachers</i>), в которой собрана основная информация, такая как: имя, фамилия, данные о зарплате, а также дата приема на работу. Также в базе данных присутствует информация о группах, хранимая в таблице <b>Группы</b> (<i>Groups</i>). Данные об факультетах и кафедрах содержатся в таблицах <b>Факультеты</b> (<i>Faculties</i>) и <b>Кафедры</b> (<i>Departments</i>) соответственно.

Таблицы

Ниже представлено детальное описание структуры каждой таблицы.
<ol>
<li>
  <b>Кафедры (Departments)</b>
  <ul>
    <li><b>Идентификатор (Id). Уникальный идентификатор кафедры.</b>
      <ul>
        <li>Тип данных — int.</li>
        <li>Авто приращение.</li>  
        <li>Не может содержать null-значения.</li>  
        <li> Первичный ключ.</li>  
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
        <li> Должно быть уникальным.</li>  
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
        <li>Не может содержать null-значения</li>  
        <li> Первичный ключ.</li>  
      </ul>  
    </li>
  </ul>  
</li>
</ol>
