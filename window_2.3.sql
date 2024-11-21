-- Выведите информацию о топ-3 товарах по продажам в штуках в каждом магазине в каждую дату.
-- Столбцы в результирующей таблице:
-- DATE_ , SHOPNUMBER, ID_GOOD


WITH ranked_sales AS (
    SELECT 
        sales."DATE" AS DATE_, -- Дата продажи
        sales."SHOPNUMBER", -- Номер магазина
        sales."ID_GOOD", -- ID товара
        sales."QTY", -- Количество проданных товаров
        ROW_NUMBER() OVER (
            PARTITION BY sales."DATE", sales."SHOPNUMBER" 
            ORDER BY sales."QTY" DESC
        ) AS rank -- Ранжирование товаров по количеству продаж
    FROM sales
)
SELECT 
    DATE_, -- Дата продажи
    "SHOPNUMBER", -- Номер магазина
    "ID_GOOD" -- ID товара
FROM ranked_sales
WHERE rank <= 3 -- Отбираем только топ-3 товара
ORDER BY DATE_, "SHOPNUMBER", rank; -- Сортировка по дате, номеру магазина и рангу
