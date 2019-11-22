-- Симонов Константин
-- группа 6103
-- вариант 9
-- Л.р. No3. Работа с представлениями.

-- Для созданных представлений необходимо проверить с помощью запросов UPDATE и INSERT,
-- являются ли они обновляемыми, и объяснить полученный результат.

-- 1. Представление "Сотрудники 2-го отдела".
drop view if exists secondDepEmps;

create view secondDepEmps as
    select * from employees
        where department = 2;
-- является обновляемым
insert into secondDepEmps(name)
    values ('лёша'),
           ('виталик');

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
    (
        select count(distinct e1.personnelNumber) from employees e1
            where e1.department = e.department
                and
                  e1.sex like 'ж'
                and
                  e.education = e1.education
    ) females,
    (
        select count(distinct e1.personnelNumber) from employees e1
            where e1.department = e.department
                and
                  e1.sex like 'м'
                and
                  e.education = e1.education
    ) males
from employees e
group by e.department, e.education;
-- не является обновляемым из-за group by как минимум
insert into educationLevel
    values (6, 'что-то', 123,321),
           (1, 'нечто', 222,11);

update educationLevel
    set department = 101
    where males > 3;

-- 3. Представление "Вакансии": номер отдела – должность – количество вакантных ставок.
drop view if exists vacancies;

create view vacancies as
select department, posName, ratesNumberPerDep from staffingTable
    left join positions p on
        staffingTable.position = p.posId
    order by department;
-- не является обновляемым из-за left join
insert into vacancies
    values (1, 'тырыпыры', 123),
           (123, 'кочерга', 312);

update vacancies
    set department = 101
    where ratesNumberPerDep > 100;

-- Для всех попыток использовать UPDATE или INSERT получаю подобную ошибку:
-- [SQLITE_ERROR] SQL error or missing database (cannot modify vacancies because it is a view)