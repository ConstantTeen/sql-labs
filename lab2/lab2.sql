-- не принята

-- Симонов Константин
-- группа 6103
-- вариант 9
-- Л. р. No2. Выборка данных.

-- Один из запросов надо ​ написать двумя способами​ и
-- объяснить, какой из вариантов будет работать быстрее и почему.
-- Создать упорядоченные списки:

-- 1) сотрудников с указанием названия отдела, должности и оклада;
select name, depName, posName, salary from employees e
join positions p   on e.position = p.posId
join departments d on e.department = d.depId;
--+

-- 2) самых молодых сотрудников в каждом отделе;
select e1.department, e1.name from employees e1
where e1.birthDate = (
                       select max(e2.birthDate) from employees e2
                       where e1.department = e2.department
                     )
order by e1.department;
--+

-- второй вариант:
select e1.department, e1.name from employees e1
where not exists (
                   select * from employees e2
                   where e1.birthDate < e2.birthDate
                         and
                         e1.department = e2.department
                 )
order by e1.department;
--+

-- Пусть длинна таблицы employees = n.
-- Тогда во втором варианте в худшем случае будет n^2 сравнений строк (дат).
-- В первом варианте сравнением строк занимается агрегатная функция max(),
-- работа которой наверняка оптимизируется СУБД.
-- Также хочется верить в то, что exists работает медленнее, чем сравнение чисел.
-- Поэтому второй вариант будет работать дольше.

--+ Первый вариант быстрее, но по другой причине.

-- 3) отделов, в которых меньше пяти сотрудников;
select department, count(*) as empNum from employees
group by department
having count(*) < 5;
-- если в отделе нет сотрудников, то количество(0) < 5
--
-- Если в отделе №n нет сотрудников, то в таблице employees нет ниодного сотрудника (строчки),
-- у которого в поле department был бы номер n. Соответственно, тк group by не знает
-- о существовании других отделов, группы строчек с номером отдела n не будет. Следовательно,
-- having не будет применять count(*) к пустым группам. Или я что-то не понимаю?
--
-- Снизу второй вариант запроса, который учитывает сотрудников не привязанных ни к одому отделу,
-- на случай, если это имелось в виду.
select e.department, count(*) as empNum from departments d
left join employees e on d.depId == e.department
where e.personnelNumber is NOT NULL
group by e.department
having count(*) < 5;
-----------

-- 4) сотрудников пенсионного возраста, занимающих менее одной ставки.
select name from employees
where ratesNumber < 1
      and
      (     sex = 'ж'
            and
            date('now','-60 years') >= birthDate
        or
            sex = 'м'
            and
            date('now','-65 years') >= birthDate
      );
--+

-- Для каждого отдела посчитать количество сотрудников с разным образованием.
select department, education, count(*) empNum from employees
group by department, education
-- неверно, вывод д.б. таким: отдел - вид образования - количество

