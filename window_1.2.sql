-- Выведите список сотрудников с именами сотрудников, получающими самую низкую зарплату в отделе. 
-- Столбцы в результирующей таблице: first_name, last_name, salary, industry, name_ighest_sal. 

-- Минимальная зарплата в отделе с использованием MIN (без оконных функций)

-- Выбираем сотрудников с минимальной зарплатой в своей industry
SELECT 
    first_name, -- Имя сотрудника
    last_name, -- Фамилия сотрудника
    salary, -- Зарплата сотрудника
    industry, -- Отдел сотрудника
    (SELECT CONCAT(first_name, ' ', last_name) 
     FROM Salary subquery 
     WHERE subquery.industry = main.industry 
     ORDER BY subquery.salary ASC LIMIT 1) AS name_lowest_sal -- Имя сотрудника с минимальной зарплатой
FROM Salary main
WHERE salary = (SELECT MIN(subquery.salary) 
                FROM Salary subquery 
                WHERE subquery.industry = main.industry) -- Условие: зарплата равна минимальной в отделе
ORDER BY salary ASC; -- Сортируем результат по возрастанию зарплаты


-- Решение с использованием first/last value

WITH SalaryWithMin AS (
    SELECT 
        first_name, -- Имя сотрудника
        last_name, -- Фамилия сотрудника
        salary, -- Зарплата сотрудника
        industry, -- Отдел сотрудника
        MIN(salary) OVER (PARTITION BY industry) AS min_salary, -- Минимальная зарплата в отделе
        FIRST_VALUE(CONCAT(first_name, ' ', last_name)) 
            OVER (PARTITION BY industry ORDER BY salary ASC) AS name_lowest_sal -- Имя сотрудника с минимальной зарплатой
    FROM Salary
)
SELECT 
    first_name, -- Имя сотрудника
    last_name, -- Фамилия сотрудника
    salary, -- Зарплата сотрудника
    industry, -- Отдел сотрудника
    name_lowest_sal -- Имя сотрудника с минимальной зарплатой
FROM SalaryWithMin
WHERE salary = min_salary -- Условие: зарплата равна минимальной в отделе
ORDER BY salary ASC; -- Сортируем результат по возрастанию зарплаты

