-- Отберите данные по продажам за 2.01.2016. Укажите для каждого магазина его адрес, сумму проданных товаров в штуках, сумму проданных товаров в рублях.
-- Столбцы в результирующей таблице:
-- SHOPNUMBER , CITY , ADDRESS, SUM_QTY SUM_QTY_PRICE


SELECT 
    shops."SHOPNUMBER", -- Номер магазина
    shops."CITY", -- Город магазина
    shops."ADDRESS", -- Адрес магазина
    SUM(sales."QTY") AS SUM_QTY, -- Суммарное количество проданных товаров
    SUM(sales."QTY" * goods."PRICE") AS SUM_QTY_PRICE -- Суммарная стоимость проданных товаров
FROM sales
JOIN shops ON sales."SHOPNUMBER" = shops."SHOPNUMBER" -- Объединение с таблицей SHOPS по номеру магазина
JOIN goods ON sales."ID_GOOD" = goods."ID_GOOD" -- Объединение с таблицей GOODS по ID товара
WHERE sales."DATE" = '2016-01-02' -- Отбор данных по дате
GROUP BY shops."SHOPNUMBER", shops."CITY", shops."ADDRESS" -- Группировка по номеру, городу и адресу магазина
ORDER BY shops."SHOPNUMBER"; -- Сортировка по номеру магазина



