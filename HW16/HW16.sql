Шаг 1: Создание пользователей

CREATE USER 'client'@'localhost' IDENTIFIED BY 'client_password';
CREATE USER 'manager'@'localhost' IDENTIFIED BY 'manager_password';

Шаг 2: Создание таблиц

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE manufacturers (
    manufacturer_id INT AUTO_INCREMENT PRIMARY KEY,
    manufacturer_name VARCHAR(100) NOT NULL
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INT,
    manufacturer_id INT,
    price DECIMAL(10,2) NOT NULL,
    additional_params TEXT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(manufacturer_id)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    order_date TIMESTAMP NOT NULL,
    quantity INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

Шаг 3: Создание процедуры выборки товаров с фильтрами и постраничной выдачей

DELIMITER //

CREATE PROCEDURE get_products(
    IN p_category_id INT,
    IN p_manufacturer_id INT,
    IN p_min_price DECIMAL(10,2),
    IN p_max_price DECIMAL(10,2),
    IN p_additional_params TEXT,
    IN p_sort_field VARCHAR(50),
    IN p_sort_order VARCHAR(10),
    IN p_page_number INT,
    IN p_page_size INT
)
BEGIN
    DECLARE v_offset INT;
    SET v_offset = (p_page_number - 1) * p_page_size;

    PREPARE stmt FROM 
    "SELECT product_id, product_name, category_id, manufacturer_id, price, additional_params
     FROM products
     WHERE (category_id = ? OR ? IS NULL)
       AND (manufacturer_id = ? OR ? IS NULL)
       AND (price BETWEEN ? AND ?)
       AND (additional_params LIKE CONCAT('%', ?, '%') OR ? IS NULL)
     ORDER BY ? ?
     LIMIT ? OFFSET ?";

    EXECUTE stmt USING 
        p_category_id, p_category_id,
        p_manufacturer_id, p_manufacturer_id,
        p_min_price, p_max_price,
        p_additional_params, p_additional_params,
        p_sort_field, p_sort_order,
        p_page_size, v_offset;

    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;

Шаг 4: Дать права на запуск процедуры пользователю

GRANT EXECUTE ON PROCEDURE get_products TO 'client'@'localhost';

Шаг 5: Создание процедуры get_orders для просмотра отчета по продажам

DELIMITER //

CREATE PROCEDURE get_orders(
    IN p_start_date TIMESTAMP,
    IN p_end_date TIMESTAMP,
    IN p_group_by VARCHAR(50)
)
BEGIN
    IF p_group_by = 'product' THEN
        SELECT 
            p.product_id, 
            p.product_name, 
            SUM(o.quantity) AS total_quantity, 
            SUM(o.total_amount) AS total_amount
        FROM 
            orders o
        JOIN 
            products p ON o.product_id = p.product_id
        WHERE 
            o.order_date BETWEEN p_start_date AND p_end_date
        GROUP BY 
            p.product_id, p.product_name;
    ELSEIF p_group_by = 'category' THEN
        SELECT 
            c.category_id, 
            c.category_name, 
            SUM(o.quantity) AS total_quantity, 
            SUM(o.total_amount) AS total_amount
        FROM 
            orders o
        JOIN 
            products p ON o.product_id = p.product_id
        JOIN 
            categories c ON p.category_id = c.category_id
        WHERE 
            o.order_date BETWEEN p_start_date AND p_end_date
        GROUP BY 
            c.category_id, c.category_name;
    ELSEIF p_group_by = 'manufacturer' THEN
        SELECT 
            m.manufacturer_id, 
            m.manufacturer_name, 
            SUM(o.quantity) AS total_quantity, 
            SUM(o.total_amount) AS total_amount
        FROM 
            orders o
        JOIN 
            products p ON o.product_id = p.product_id
        JOIN 
            manufacturers m ON p.manufacturer_id = m.manufacturer_id
        WHERE 
            o.order_date BETWEEN p_start_date AND p_end_date
        GROUP BY 
            m.manufacturer_id, m.manufacturer_name;
    ELSE
        SELECT 'Invalid group_by parameter' AS error;
    END IF;
END //

DELIMITER ;

Шаг 6: Дать права на запуск процедуры пользователю manager

GRANT EXECUTE ON PROCEDURE get_orders TO 'manager'@'localhost';

Шаг 7: Примеры использования процедур

CALL get_products(
    1, -- category_id
    1, -- manufacturer_id
    100.00, -- min_price
    500.00, -- max_price
    'param', -- additional_params
    'price', -- sort_field
    'DESC', -- sort_order
    1, -- page_number
    10 -- page_size
);
