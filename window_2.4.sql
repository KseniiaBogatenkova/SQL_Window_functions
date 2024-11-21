-- Выведите для каждого магазина и товарного направления сумму продаж в рублях за предыдущую дату. Только для магазинов Санкт-Петербурга.
-- Столбцы в результирующей таблице:
-- DATE_, SHOPNUMBER, CATEGORY, PREV_SALES


WITH sales_with_lag AS (
    SELECT 
        sales."DATE" AS DATE_, -- Текущая дата
        sales."SHOPNUMBER", -- Номер магазина
        goods."CATEGORY", -- Товарное направление
        SUM(sales."QTY" * goods."PRICE") AS SALES_RUB, -- Сумма продаж в рублях
        LAG(SUM(sales."QTY" * goods."PRICE")) OVER (
            PARTITION BY sales."SHOPNUMBER", goods."CATEGORY" 
            ORDER BY sales."DATE"
        ) AS PREV_SALES -- Сумма продаж за предыдущую дату
    FROM sales
    JOIN goods ON sales."ID_GOOD" = goods."ID_GOOD" -- Присоединение товаров
    JOIN shops ON sales."SHOPNUMBER" = shops."SHOPNUMBER" -- Присоединение магазинов
    WHERE shops."CITY" = 'СПб' -- Фильтруем Петербург
    GROUP BY sales."DATE", sales."SHOPNUMBER", goods."CATEGORY" -- Группировка по дате, магазину и категории
)
SELECT 
    DATE_, -- Текущая дата
    "SHOPNUMBER", -- Номер магазина
    "CATEGORY", -- Товарное направление
    PREV_SALES -- Сумма продаж за предыдущую дату
FROM sales_with_lag
WHERE PREV_SALES IS NOT NULL -- Вывод только записей с предыдущей датой
ORDER BY DATE_, "SHOPNUMBER", "CATEGORY"; -- Сортировка для удобства
