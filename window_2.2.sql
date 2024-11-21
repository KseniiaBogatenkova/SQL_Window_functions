-- Отберите за каждую дату долю от суммарных продаж (в рублях на дату). Расчеты проводите только по товарам направления ЧИСТОТА.
-- Столбцы в результирующей таблице:
-- DATE_, CITY, SUM_SALES_REL


SELECT 
    sales."DATE" AS DATE_, -- Дата продажи
    shops."CITY", -- Город магазина
    SUM(sales."QTY" * goods."PRICE") AS SUM_SALES_REL -- Доля от общей суммы продаж на дату
FROM sales
JOIN shops ON sales."SHOPNUMBER" = shops."SHOPNUMBER" -- Привязка магазинов
JOIN goods ON sales."ID_GOOD" = goods."ID_GOOD" -- Привязка товаров
WHERE goods."CATEGORY" = 'ЧИСТОТА' -- Фильтрация по категории ЧИСТОТА
GROUP BY sales."DATE", shops."CITY" -- Группировка по дате и городу
ORDER BY sales."DATE", shops."CITY";
