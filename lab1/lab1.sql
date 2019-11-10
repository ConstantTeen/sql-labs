-- Симонов Константин
-- группа 6103
-- вариант 9
-- Л. р. No1. Создание и заполнение отношений БД отдела кадров.

drop table if exists departments;
drop table if exists positions;
drop table if exists staffingTable;
drop table if exists employees;

-- 1. Отношение "Отделы" (поля "Идентификатор", "Название отдела").
create table if not exists departments (
    depId integer primary key not null,
    depName varchar unique not null
);

insert into departments(depName)
values ('Департамент анализа данных, принятия решений и финансовых технологий'),
       ('Департамент корпоративных финансов и корпоративного управления'),
       ('Департамент менеджмента'),
       ('Департамент мировой экономики и мировых финансов');

-- 2. Отношение "Должности" (поля "Название должности", "Оклад").
create table if not exists positions(
    posId integer primary key not null,
    posName varchar unique not null,
    salary float not null
);

insert into positions(posName, salary)
values ('Директор (генеральный директор, управляющий) предприятия', 100000),
       ('Финансовый директор (заместитель директора по финансам)',400000),
       ('Главный бухгалтер',200000),
       ('Главный диспетчер', 300000),
       ('Главный инженер', 500000);

-- 3. Отношение "Штатное расписание" (поля "Отдел", "Должность", "Количество ставок на отдел").
create table if not exists staffingTable(
    position integer,
    department integer,
    ratesNumberPerDep integer,
    primary key (position,department),
    foreign key (position,department)
        references staffingTable(position, department),
    foreign key (position)
        references positions(posId),
    foreign key (department)
        references departments(depId)
);

insert into staffingTable(position, department, ratesNumberPerDep)
values (1,3,123),
       (2,3,321),
       (4,1,213),
       (5,2,423),
       (3,4,543);

-- 4. Отношение "Сотрудники":
-- Содержимое поля       Тип     Длина     Дес.     Примечание
-- Табельный номер        N      6         0        первичный ключ
-- ФИО                    C      50                 обязательное поле
-- Паспортные данные      С      100                обязательное поле
-- Пол                    C      1                  значения – 'м' и 'ж', по умолчанию – 'ж'
-- Дата рождения          D                         обязательное поле
-- Образование            C      20
-- Отдел                  N      3         0        составной внешний ключ...
-- Должность              C      30                 ...к таблице "Штатное расписание"
-- Количество ставок      N      3         1        Кратно 0.25, изменяется от 0.25 до 1.5
-- Дата приёма на работу  D                         обязательное поле
-- Адрес                  С      100


create table if not exists employees(
    personnelNumber integer(6) primary key,
    name varchar(50) not null,
    passportData varchar(100) not null,
    sex char(1) default 'ж' check (sex = 'ж' OR sex = 'м'),
    birthDate date not null,
    education varchar(20),
    department integer(3),
    position varchar(30),
    ratesNumber float(3,2) check(ratesNumber*4 in (1,2,3,4,5,6)), -- 0.25:0.25:1.5
    employmentDate date not null,
    address varchar(100),
    foreign key (position,department)
        references staffingTable(position, department)
);


insert into employees(personnelNumber, name, passportData, sex, birthDate, education, department, position, ratesNumber, employmentDate, address)
values (1, 'Ольга Михайловна Кирпич', '75121234', 'ж', '21.06.1960', 'ЮУрГУ', 1, 1, 0.5,'21.06.2019','Москва, ул Керченская, д13 кв37'),
       (2, 'Олег Джеймсович Цаль', '75121235', 'м','21.06.1961', 'ПТУ №2', 2, 1, 0.25,'19.06.2019','Москва, ул Керченская, д2 кв28'),
       (3, 'Виктор Антонович Капица', '75121236', 'м', '21.06.1962', 'УрФУ', 3, 4, 0.5,'20.06.2019','Москва, ул Керченская, д14 кв88'),
       (4, 'Громяко Виталий Олегович ', '75121237', 'м', '21.06.1963', 'ЮУрГУ', 4, 2, 1.5,'23.06.2019', 'Москва, ул Максимова, д4, кв1');