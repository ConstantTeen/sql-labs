-- Симонов Константин
-- группа 6103
-- вариант 9
-- Л.р. No3. Работа с представлениями.

-- Для созданных представлений необходимо проверить с помощью запросов UPDATE и INSERT,
-- являются ли они обновляемыми, и объяснить полученный результат.

-- 1. Представление "Сотрудники 2-го отдела".
drop view if exists secondDepEmps;

create view secondDepEmps as
select *
from employees
where department = 2;
-- является обновляемым
insert into secondDepEmps(name, passportData, birthDate, employmentDate, department)
values ('лёша', '75121234', '2000-06-21', '2019-06-21', 2),
       ('витя', '75123434', '1990-06-11', '2018-05-02', 2);
-- [SQLITE_ERROR] SQL error or missing database (cannot modify secondDepEmps because it is a view)

update secondDepEmps
set name = 'егорка'
where personnelNumber > 3;

-- 2. Представление "Образовательный уровень сотрудников" (с указанием
-- количества людей с высшим, средним и другими уровнями образования), по
-- отделам, с учетом пола: отдел – вид образования – количество мужчин –
-- количество женщин.
drop view if exists educationLevel;

create view educationLevel as
select e.department,
       e.education,
       count(
               case
                   when e.sex like 'м' then 1
                   else NULL
                   end
           ) as males,
       count(
               case
                   when e.sex like 'ж' then 1
                   else NULL
                   end
           ) as females
from employees e
group by e.department, e.education;

-- не является обновляемым из-за group by как минимум

-- 3. Представление "Вакансии": номер отдела – должность – количество вакантных ставок.
drop view if exists vacancies;

create view vacancies as
select d.depId,
       p.posName,
       s.ratesNumberPerDep -
       (
           select case when sum(e.ratesNumber) is NULL then 0 else sum(e.ratesNumber) end
           from employees e
           where e.position = p.posId
             and e.department = d.depId
       ) as vacantRates
from departments d,
     positions p,
     staffingTable s
where s.department = d.depId
  and s.position = p.posId
order by d.depId;
-- не является обновляемым, тк 3е поле - выражение



