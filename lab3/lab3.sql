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

insert into secondDepEmps(name)
    values ('лёша'),
           ('виталик');
-- TODO ЗАПИЛИТЬ АПДЕЙТЫ И ИНСЕРТЫ И ОБЪЯСНИТЬ ЧТО В СКУЭЛАЙТ НЕТ ОБНОВЛЯЕМЫХ ВЬЮЕРОВ


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

insert into educationLevel
    values (6, 'что-то', 123,321),
           (1, 'нечто', 222,11);

-- 3. Представление "Вакансии": номер отдела – должность – количество вакантных ставок.
drop view if exists vacancies;

create view vacancies as
select department, posName, ratesNumberPerDep from staffingTable
    left join positions p on
        staffingTable.position = p.posId
    order by department;

insert into vacancies
    values (1, 'тырыпыры', 123),
           (123, 'кочерга', 312);
