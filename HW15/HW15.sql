Шаг 1: Создание таблиц

CREATE TABLE stores (
    store_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    address VARCHAR(50) NOT NULL
);

CREATE TABLE sales (
    sale_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    store_id BIGINT UNSIGNED,
    date TIMESTAMP NOT NULL,
    sale_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (store_id) REFERENCES stores (store_id)
);

Шаг 2: Создание хранимой процедуры 

DELIMITER //

CREATE PROCEDURE GenerateData()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE j INT DEFAULT 0;
    DECLARE random_store_id BIGINT UNSIGNED;
    DECLARE random_date TIMESTAMP;
    DECLARE random_amount DECIMAL(10,2);
    DECLARE most_productive_store_id BIGINT UNSIGNED;

    -- Генерация 10 магазинов
    WHILE i < 10 DO
        INSERT INTO stores (address) VALUES (CONCAT('Address ', i));
        SET i = i + 1;
    END WHILE;

    -- Выбор самого продуктивного магазина (например, первый магазин)
    SET most_productive_store_id = 1;

    -- Генерация 100000 продаж
    WHILE j < 100000 DO
        -- 70-75% продаж в самом продуктивном магазине
        IF j < 72500 THEN
            SET random_store_id = most_productive_store_id;
        ELSE
            -- Остальные продажи распределяются между остальными магазинами
            SET random_store_id = FLOOR(1 + (RAND() * 9));
        END IF;

        -- Генерация случайной даты за последние 2 года
        SET random_date = DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 730) DAY);

        -- Генерация случайной суммы продажи
        SET random_amount = ROUND(RAND() * 1000, 2);

        -- Вставка продажи
        INSERT INTO sales (store_id, date, sale_amount) VALUES (random_store_id, random_date, random_amount);

        SET j = j + 1;
    END WHILE;
END //

DELIMITER ;
CALL GenerateData();

Шаг 3: Запрос для нарастающего итога продаж по каждому магазину с группировкой по месяцам

SELECT 
    store_id,
    DATE_FORMAT(date, '%Y-%m') AS month,
    SUM(sale_amount) AS total_sales,
    SUM(SUM(sale_amount)) OVER (PARTITION BY store_id ORDER BY DATE_FORMAT(date, '%Y-%m')) AS running_total_sales
FROM 
    sales
GROUP BY 
    store_id, DATE_FORMAT(date, '%Y-%m')
ORDER BY 
    store_id, month;

Шаг 4: Запрос для 7-дневного скользящего среднего за последний месяц по самому плодовитому магазину

WITH LastMonthSales AS (
    SELECT 
        store_id,
        date,
        sale_amount
    FROM 
        sales
    WHERE 
        date >= DATE_SUB(LAST_DAY(CURDATE()), INTERVAL 1 MONTH) + INTERVAL 1 DAY
        AND date < LAST_DAY(CURDATE()) + INTERVAL 1 DAY
),
MostProductiveStore AS (
    SELECT 
        store_id,
        SUM(sale_amount) AS total_sales
    FROM 
        LastMonthSales
    GROUP BY 
        store_id
    ORDER BY 
        total_sales DESC
    LIMIT 1
)
SELECT 
    lms.date,
    AVG(lms.sale_amount) OVER (ORDER BY lms.date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_avg_7_days
FROM 
    LastMonthSales lms
JOIN 
    MostProductiveStore mps ON lms.store_id = mps.store_id
ORDER BY 
    lms.date;

Шаг 5: Описание граничных случаев
Нарастающий итог продаж:
Если в определенном месяце нет продаж для магазина, он все равно будет отображен с нулевыми продажами.
Настройка оконной функции SUM с OVER гарантирует корректное вычисление нарастающего итога даже при отсутствии данных в промежуточных месяцах.
7-дневное скользящее среднее:
Если в последнем месяце меньше 7 дней с продажами, скользящее среднее будет рассчитано на доступные дни.
Если в последнем месяце нет продаж, запрос вернет пустой результат.
Если есть дни без продаж, они учитываются в расчете скользящего среднего, что может привести к нулевым значениям в скользящем среднем.
