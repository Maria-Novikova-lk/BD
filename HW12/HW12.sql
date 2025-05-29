1. Структуры таблиц:

CREATE TABLE orders (
    order_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT UNSIGNED,
    order_date DATETIME NOT NULL,
    status VARCHAR(32) NOT NULL
);

CREATE TABLE order_items (
    order_item_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT UNSIGNED,
    product_id BIGINT UNSIGNED,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

2. Хранимая процедура для создания заказа и добавления товаров:

DELIMITER //

CREATE PROCEDURE create_order_and_items(
    IN p_customer_id BIGINT UNSIGNED,
    IN p_order_items JSON
)
BEGIN
    DECLARE v_order_id BIGINT UNSIGNED;
    DECLARE v_product_id BIGINT UNSIGNED;
    DECLARE v_quantity INT;
    DECLARE v_price DECIMAL(10, 2);
    DECLARE v_item_count INT DEFAULT 0;
    DECLARE v_item_count_max INT;

    -- Начало транзакции
    START TRANSACTION;

    -- Вставка нового заказа
    INSERT INTO orders (customer_id, order_date, status)
    VALUES (p_customer_id, NOW(), 'Новый');

    -- Получение ID нового заказа
    SET v_order_id = LAST_INSERT_ID();

    -- Получение количества элементов в JSON
    SET v_item_count_max = JSON_LENGTH(p_order_items);

    -- Цикл по элементам JSON
    WHILE v_item_count < v_item_count_max DO
        -- Получение данных из JSON
        SET v_product_id = JSON_UNQUOTE(JSON_EXTRACT(p_order_items, CONCAT('$[', v_item_count, '].product_id')));
        SET v_quantity = JSON_UNQUOTE(JSON_EXTRACT(p_order_items, CONCAT('$[', v_item_count, '].quantity')));
        SET v_price = JSON_UNQUOTE(JSON_EXTRACT(p_order_items, CONCAT('$[', v_item_count, '].price')));

        -- Вставка элемента заказа
        INSERT INTO order_items (order_id, product_id, quantity, price)
        VALUES (v_order_id, v_product_id, v_quantity, v_price);

        -- Увеличение счетчика
        SET v_item_count = v_item_count + 1;
    END WHILE;

    -- Коммит транзакции
    COMMIT;

EXCEPTION
    -- Откат транзакции в случае ошибки
    ROLLBACK;
    -- Вывод сообщения об ошибке
    SELECT 'Ошибка при создании заказа' AS error_message;
END //

DELIMITER ;

CALL create_order_and_items(
    1,
    '[{"product_id": 101, "quantity": 2, "price": 19.99}, {"product_id": 102, "quantity": 1, "price": 29.99}]'
);

3. Загрузка данных из CSV с использованием LOAD DATA

CREATE TABLE orders (
    order_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT UNSIGNED,
    order_date DATETIME NOT NULL,
    status VARCHAR(32) NOT NULL
);

CREATE TABLE order_items (
    order_item_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT UNSIGNED,
    product_id BIGINT UNSIGNED,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

