Создание таблицы query

Сначала запускаем этот скрипт:

CREATE TABLE query (
    searchid SERIAL PRIMARY KEY, -- Уникальный идентификатор запроса
    year INT, -- Год запроса
    month INT, -- Месяц запроса
    day INT, -- День запроса
    userid INT, -- Идентификатор пользователя
    ts BIGINT, -- Время запроса в формате UNIX
    devicetype VARCHAR(50), -- Тип устройства
    deviceid VARCHAR(50), -- Идентификатор устройства
    query VARCHAR(255) -- Текст запроса
);

Вставка данных
Потом запускаем этот скрипт:

INSERT INTO query (year, month, day, userid, ts, devicetype, deviceid, query) VALUES
(2024, 11, 20, 1, 1700450000, 'android', 'dev1', 'к'),
(2024, 11, 20, 1, 1700450060, 'android', 'dev1', 'ку'),
(2024, 11, 20, 1, 1700450200, 'android', 'dev1', 'куп'),
(2024, 11, 20, 1, 1700450800, 'android', 'dev1', 'купить'),
(2024, 11, 20, 1, 1700450900, 'android', 'dev1', 'купить кур'),
(2024, 11, 20, 1, 1700451200, 'android', 'dev1', 'купить куртку'),
(2024, 11, 20, 2, 1700450000, 'ios', 'dev2', 'телефон'),
(2024, 11, 20, 2, 1700450300, 'ios', 'dev2', 'телефон x'),
(2024, 11, 20, 3, 1700450000, 'android', 'dev3', 'платье'),
(2024, 11, 20, 3, 1700450500, 'android', 'dev3', 'платье летнее');


И уже потом запускаем этот скрипт,
Выполнение основного запроса:

WITH ranked_queries AS (
    SELECT 
        year,
        month,
        day,
        userid,
        ts,
        devicetype,
        deviceid,
        query,
        LEAD(query) OVER (PARTITION BY userid, deviceid ORDER BY ts) AS next_query,
        LEAD(ts) OVER (PARTITION BY userid, deviceid ORDER BY ts) AS next_ts
    FROM query
),
is_final_queries AS (
    SELECT 
        year,
        month,
        day,
        userid,
        ts,
        devicetype,
        deviceid,
        query,
        next_query,
        CASE 
            WHEN next_ts IS NULL THEN 1 -- Нет следующего запроса
            WHEN next_ts - ts > 180 THEN 1 -- Следующий запрос более чем через 3 минуты
            WHEN LENGTH(next_query) < LENGTH(query) AND next_ts - ts > 60 THEN 2 -- Следующий запрос короче и больше минуты
            ELSE 0 -- Иначе
        END AS is_final
    FROM ranked_queries
)
SELECT 
    year,
    month,
    day,
    userid,
    ts,
    devicetype,
    deviceid,
    query,
    next_query
FROM is_final_queries
WHERE is_final IN (1, 2) AND devicetype = 'android' -- Фильтруем устройства Android и значения is_final = 1 или 2
ORDER BY year, month, day, ts;
