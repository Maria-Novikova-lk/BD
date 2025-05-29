-- Создание таблиц
CREATE TABLE categories IF NOT EXISTS (
    category_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(32) NOT NULL
);

CREATE TABLE products IF NOT EXISTS (
    product_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(32) NOT NULL,
    category_id BIGINT UNSIGNED,
    price DECIMAL(10, 2),
    rating INT,
    status VARCHAR(32) NOT NULL, -- "В наличии" или "Распродан"
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Вставка данных в таблицу categories
INSERT INTO categories (title) VALUES ('Electronics'), ('Books'), ('Clothing');

-- Вставка данных в таблицу products
INSERT INTO products (title, category_id, price, rating, status) VALUES
('Laptop', 1, 999.99, 4, 'В наличии'),
('Smartphone', 1, 499.99, 5, 'В наличии'),
('Book1', 2, 19.99, 3, 'В наличии'),
('Book2', 2, 29.99, 4, 'Распродан'),
('T-Shirt', 3, 9.99, 5, 'В наличии'),
('Jeans', 3, 49.99, 4, 'В наличии');

Выборка самого дорогого и самого дешевого товара в каждой категории:

SELECT 
    c.title AS category_title,
    MAX(p.price) AS max_price,
    MIN(p.price) AS min_price,
    COUNT(p.product_id) AS product_count,
    (SELECT p1.title 
     FROM products p1 
     WHERE p1.category_id = c.category_id 
     ORDER BY p1.price DESC 
     LIMIT 1) AS most_expensive_product,
    (SELECT p2.title 
     FROM products p2 
     WHERE p2.category_id = c.category_id 
     ORDER BY p2.price ASC 
     LIMIT 1) AS least_expensive_product
FROM 
    categories c
JOIN 
    products p ON c.category_id = p.category_id
GROUP BY 
    c.category_id, c.title;

Выборка с использованием ROLLUP:

SELECT 
    c.title AS category_title,
    COUNT(p.product_id) AS product_count,
    GROUPING(c.category_id) AS is_total
FROM 
    categories c
JOIN 
    products p ON c.category_id = p.category_id
GROUP BY 
    c.category_id, c.title WITH ROLLUP;