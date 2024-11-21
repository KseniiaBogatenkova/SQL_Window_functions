-- Выведите список сотрудников с именами сотрудников, получающими самую высокую зарплату в отделе. 
-- Столбцы в результирующей таблице: first_name, last_name, salary, industry, name_ighest_sal. 
-- Последний столбец - имя сотрудника для данного отдела с самой высокой зарплатой.

-- Максимальная зарплата в отделе с использованием MAX (без оконных функций)

SELECT 
    first_name, -- Имя сотрудника
    last_name, -- Фамилия сотрудника
    salary, -- Зарплата сотрудника
    industry, -- Отдел сотрудника
    (SELECT CONCAT(first_name, ' ', last_name) 
     FROM Salary subquery 
     WHERE subquery.industry = main.industry 
     ORDER BY subquery.salary DESC LIMIT 1) AS name_highest_sal -- Имя сотрудника с максимальной зарплатой
FROM Salary main
WHERE salary = (SELECT MAX(subquery.salary) 
                FROM Salary subquery 
                WHERE subquery.industry = main.industry) -- Условие: зарплата равна максимальной в отделе
ORDER BY salary DESC; -- Сортируем результат по убыванию зарплаты


               
-- Решение с использованием first/last value

WITH SalaryWithMax AS (
    SELECT 
        first_name, -- Имя сотрудника
        last_name, -- Фамилия сотрудника
        salary, -- Зарплата сотрудника
        industry, -- Отдел сотрудника
        MAX(salary) OVER (PARTITION BY industry) AS max_salary, -- Максимальная зарплата в отделе
        FIRST_VALUE(CONCAT(first_name, ' ', last_name)) 
            OVER (PARTITION BY industry ORDER BY salary DESC) AS name_highest_sal -- Имя сотрудника с максимальной зарплатой
    FROM Salary
)
SELECT 
    first_name, -- Имя сотрудника
    last_name, -- Фамилия сотрудника
    salary, -- Зарплата сотрудника
    industry, -- Отдел сотрудника
    name_highest_sal -- Имя сотрудника с максимальной зарплатой
FROM SalaryWithMax
WHERE salary = max_salary -- Условие: зарплата равна максимальной в отделе
ORDER BY salary DESC; -- Сортируем результат по убыванию зарплаты


