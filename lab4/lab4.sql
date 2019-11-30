-- Симонов Константин
-- группа 6103
-- вариант 9
-- Л.р. No4. Изучение операций реляционной алгебры.​

-- Необходимо написать на языке SQL запросы, которые реализуют операции реляционной алгебры.
-- Если для демонстрации операций РА недостаточно отношений, созданных во время
-- выполнения работы No1, то следует создать дополнительные отношения.

--Выборка

select *
from employees
where department = 3;

--Проекция

select distinct personnelNumber, name, education
from employees;

--Вспомогательная таблица:
create table candidates
(
    personnelNumber integer(6) primary key,
    name            varchar(50)  not null,
    passportData    varchar(100) not null,
    sex             char(1) default 'ж' check (sex = 'ж' OR sex = 'м'),
    birthDate       date         not null,
    education       varchar(20),
    department      integer(3),
    position        varchar(30),
    ratesNumber     float(3, 2) check (ratesNumber * 4 in (1, 2, 3, 4, 5, 6)), -- 0.25:0.25:1.5
    employmentDate  date         not null,
    address         varchar(100),
    foreign key (position, department)
        references staffingTable (position, department)
);

insert into candidates(personnelNumber, name, passportData, sex, birthDate, education, department, position,
                       ratesNumber, employmentDate, address)
values (1, 'Ольга Михайловна Кирпич', '75121234', 'ж', '2000-06-21', 'ЮУрГУ', 3, 1, 0.5, '2019-06-21',
        'Москва, ул Случайно-совпаденченская, д13 кв37'),
       (2, 'Олег Джеймсович Цаль', '75121235', 'м', '2005-06-21', 'ПТУ №2', 2, 1, 0.25, '2019-06-19',
        'Москва, ул Керченская, д2 кв28'),
       (3, 'Игорь Антонович Капица', '75121236', 'м', '1992-06-21', 'УрФУ', 2, 1, 0.5, '2019-06-20',
        'Москва, ул Керченская, д14 кв88'),
       (4, 'Громяко Виталина Олеговна ', '75121237', 'ж', '1943-06-21', 'ЮУрГУ', 4, 2, 1.5, '2018-06-23',
        'Москва, ул Максимова, д4, кв1');

--Объединение

select *
from employees
union
select *
from candidates;

--Пересечение

select *
from employees e
where exists(select *
             from candidates c
             where e.personnelNumber = c.personnelNumber
               and e.name like c.name
               and e.passportData like c.passportData
               and e.sex like c.sex
               and e.birthDate like c.birthDate
               and e.education like c.education
               and e.department = c.department
               and e.position = c.position
               and e.ratesNumber = c.ratesNumber
               and e.employmentDate like c.employmentDate
               and e.address = c.address);
-- второй вариант
select *
from employees e1
where (select * from employees e2 where e1.personnelNumber = e2.personnelNumber) in (select * from candidates);

--Разность

select *
from employees e
where not exists(select *
                 from candidates c
                 where e.personnelNumber = c.personnelNumber
                   and e.name like c.name
                   and e.passportData like c.passportData
                   and e.sex like c.sex
                   and e.birthDate like c.birthDate
                   and e.education like c.education
                   and e.department = c.department
                   and e.position = c.position
                   and e.ratesNumber = c.ratesNumber
                   and e.employmentDate like c.employmentDate
                   and e.address = c.address);
-- второй вариант
select *
from employees e1
where (select * from employees e2 where e1.personnelNumber = e2.personnelNumber) not in (select * from candidates);

--Произведение

select *
from employees,
     candidates;

--Соединение

select *
from employees e,
     candidates c
where e.personnelNumber = c.personnelNumber;