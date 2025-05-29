
1. Исправленные определения:

CREATE TABLE categories IF NOT EXISTS (
    category_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(32) NOT NULL
);

CREATE TABLE products IF NOT EXISTS (
    product_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(32) NOT NULL,
    category_id BIGINT UNSIGNED,
    price INT UNSIGNED,
    rating TINYINT UNSIGNED,
    status ENUM('В наличии', 'Распродан') NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories (category_id)
);



2. Скрипт для генерации категорий и товаров

DELIMITER //

CREATE PROCEDURE generate_categories_and_products()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE cat_id BIGINT UNSIGNED;

    WHILE i <= 20 DO
        -- Создаем категорию
        INSERT INTO categories (title) VALUES (CONCAT('Категория ', i));
        SET cat_id = LAST_INSERT_ID();

        
        DECLARE j INT DEFAULT 1;
        DECLARE base_price INT DEFAULT 100; -- базовая цена
        WHILE j <= 10000 DO
            INSERT INTO products (title, category_id, price, rating, status)
            VALUES (
                CONCAT('Товар ', j),
                cat_id,
                base_price + j + (i * 100000), 
                FLOOR(RAND() * 6), -- рейтинг от 0 до 5
                IF(RAND() < 0.5, 'В наличии', 'Распродан')
            );
            SET j = j + 1;
        END WHILE;

        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;
CALL generate_categories_and_products();

3.Запрос для вывода товаров с постраничной выдачей


SELECT * FROM (
    SELECT 
        p.*, 
        CASE WHEN p.status = 'В наличии' THEN 1 ELSE 2 END AS sort_order,
        ROW_NUMBER() OVER (ORDER BY 
            CASE WHEN p.status = 'В наличии' THEN 1 ELSE 2 END,
            p.price ASC
        ) AS rn
    FROM products p
) sub
WHERE rn BETWEEN ((@page -1) *50 +1) AND (@page *50);
