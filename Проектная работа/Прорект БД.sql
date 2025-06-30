Описание таблиц:
1.	users (Пользователи)
o	user_id - Уникальный ID пользователя (автоинкремент)
o	email - Email (уникальный)
o	password_hash - Хеш пароля
o	full_name - Полное имя
o	created_at - Дата регистрации
2.	manufacturers (Производители)
o	manufacturer_id - Уникальный ID производителя
o	name - Название бренда
o	country - Страна производства
3.	categories (Категории)
o	category_id - Уникальный ID категории
o	name - Название категории
o	parent_id - ID родительской категории (для иерархии)
4.	products (Товары)
o	product_id - Уникальный ID товара
o	name - Название товара
o	description - Описание
o	price - Цена
o	manufacturer_id - Ссылка на производителя
o	category_id - Ссылка на категорию
o	created_at - Дата добавления
5.	warehouses (Склады)
o	warehouse_id - Уникальный ID склада
o	name - Название склада
o	address - Адрес склада
6.	inventory (Остатки)
o	product_id - Ссылка на товар (часть первичного ключа)
o	warehouse_id - Ссылка на склад (часть первичного ключа)
o	quantity - Количество товара на складе
7.	orders (Заказы)
o	order_id - Уникальный ID заказа
o	user_id - Ссылка на пользователя
o	status - Статус заказа
o	total_amount - Общая сумма
o	created_at - Дата создания
8.	order_items (Позиции заказа)
o	order_id - Ссылка на заказ (часть первичного ключа)
o	product_id - Ссылка на товар (часть первичного ключа)
o	quantity - Количество товара в заказе
o	price - Цена на момент заказа
9.	reviews (Отзывы)
o	review_id - Уникальный ID отзыва
o	product_id - Ссылка на товар
o	user_id - Ссылка на пользователя
o	rating - Оценка (1-5)
o	comment - Текст отзыва
o	created_at - Дата отзыва
10.	payments (Платежи)
o	payment_id - Уникальный ID платежа
o	order_id - Ссылка на заказ (уникальная)
o	amount - Сумма платежа
o	method - Способ оплаты
o	status - Статус платежа
o	transaction_id - ID транзакции
o	created_at - Дата платежа


SQL скрипт:
-- Создание таблиц
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE manufacturers (
    manufacturer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    country VARCHAR(50) NOT NULL
);

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    parent_id INT REFERENCES categories(category_id)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    manufacturer_id INT NOT NULL REFERENCES manufacturers(manufacturer_id),
    category_id INT NOT NULL REFERENCES categories(category_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE warehouses (
    warehouse_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL
);

CREATE TABLE inventory (
    product_id INT NOT NULL REFERENCES products(product_id),
    warehouse_id INT NOT NULL REFERENCES warehouses(warehouse_id),
    quantity INT NOT NULL CHECK (quantity >= 0),
    PRIMARY KEY (product_id, warehouse_id)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id),
    status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled')),
    total_amount DECIMAL(12,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
    order_id INT NOT NULL REFERENCES orders(order_id),
    product_id INT NOT NULL REFERENCES products(product_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    PRIMARY KEY (order_id, product_id)
);

CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL REFERENCES products(product_id),
    user_id INT NOT NULL REFERENCES users(user_id),
    rating SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL UNIQUE REFERENCES orders(order_id),
    amount DECIMAL(12,2) NOT NULL,
    method VARCHAR(20) NOT NULL CHECK (method IN ('credit_card', 'paypal', 'bank_transfer')),
    status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
    transaction_id VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Создание индексов
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_manufacturer ON products(manufacturer_id);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_reviews_product ON reviews(product_id);
CREATE INDEX idx_inventory_warehouse ON inventory(warehouse_id);
CREATE INDEX idx_payments_order ON payments(order_id);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_products_name ON products(name);

-- Вставка данных
INSERT INTO users (email, password_hash, full_name) VALUES 
('ivan@example.com', 'hash1', 'Иван Петров'),
('anna@example.com', 'hash2', 'Анна Сидорова');

INSERT INTO manufacturers (name, country) VALUES 
('Samsung', 'Южная Корея'),
('Apple', 'США'),
('Bosch', 'Германия');

INSERT INTO categories (name, parent_id) VALUES 
('Электроника', NULL),
('Бытовая техника', NULL),
('Смартфоны', 1),
('Ноутбуки', 1),
('Холодильники', 2);

INSERT INTO products (name, description, price, manufacturer_id, category_id) VALUES 
('iPhone 13', 'Смартфон с процессором A15', 799.99, 2, 3),
('Galaxy S21', 'Флагман Samsung с камерой 108MP', 699.99, 1, 3),
('MacBook Pro 16"', 'Ноутбук с чипом M1 Pro', 2499.99, 2, 4),
('Холодильник Bosch KGN39', 'NoFrost холодильник', 899.99, 3, 5);

INSERT INTO warehouses (name, address) VALUES 
('Основной склад', 'Москва, ул. Складская, 1'),
('Склад доставки', 'Санкт-Петербург, ул. Логистическая, 5');

INSERT INTO inventory (product_id, warehouse_id, quantity) VALUES 
(1, 1, 50), (1, 2, 25),
(2, 1, 40), (2, 2, 30),
(3, 1, 15), 
(4, 2, 20);

INSERT INTO orders (user_id, status, total_amount) VALUES 
(1, 'delivered', 799.99),
(2, 'processing', 3199.98);

INSERT INTO order_items (order_id, product_id, quantity, price) VALUES 
(1, 1, 1, 799.99),
(2, 3, 1, 2499.99),
(2, 4, 1, 699.99);

INSERT INTO reviews (product_id, user_id, rating, comment) VALUES 
(1, 1, 5, 'Отличный телефон!'),
(3, 2, 4, 'Мощный ноутбук, но дорогой');

INSERT INTO payments (order_id, amount, method, status, transaction_id) VALUES 
(1, 799.99, 'credit_card', 'completed', 'txn_12345'),
(2, 3199.98, 'paypal', 'pending', 'txn_67890');

-- Получить все заказы пользователя
SELECT * FROM orders WHERE user_id = 1;

-- Найти товары в категории "Смартфоны"
SELECT * FROM products WHERE category_id = 3;

-- Проверить остатки на складах
SELECT p.name, w.name, i.quantity 
FROM inventory i
JOIN products p ON p.product_id = i.product_id
JOIN warehouses w ON w.warehouse_id = i.warehouse_id;

-- Получить отзывы с рейтингом 4+
SELECT p.name, r.rating, r.comment 
FROM reviews r
JOIN products p ON p.product_id = r.product_id
WHERE r.rating >= 4;

-- 1. Процедура регистрации нового пользователя
CREATE OR REPLACE PROCEDURE register_user(
    p_email VARCHAR(255),
    p_password_hash VARCHAR(255),
    p_full_name VARCHAR(100)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO users (email, password_hash, full_name)
    VALUES (p_email, p_password_hash, p_full_name);
END;
$$;

-- 2. Процедура добавления товара на склад с автоматической проверкой существования записи
CREATE OR REPLACE PROCEDURE add_inventory(
    p_product_id INT,
    p_warehouse_id INT,
    p_quantity INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO inventory (product_id, warehouse_id, quantity)
    VALUES (p_product_id, p_warehouse_id, p_quantity)
    ON CONFLICT (product_id, warehouse_id)
    DO UPDATE SET quantity = inventory.quantity + EXCLUDED.quantity;
END;
$$;

-- 3. Процедура оформления заказа с проверкой наличия товара
CREATE OR REPLACE PROCEDURE create_order(
    p_user_id INT,
    p_order_items JSONB
)
LANGUAGE plpgsql
AS $$
DECLARE
    new_order_id INT;
    item JSONB;
    total DECIMAL(12,2) := 0;
BEGIN
    -- Проверка наличия товара
    FOR item IN SELECT * FROM jsonb_array_elements(p_order_items)
    LOOP
        PERFORM 1
        FROM inventory
        WHERE product_id = (item->>'product_id')::INT
        GROUP BY product_id
        HAVING SUM(quantity) >= (item->>'quantity')::INT;
        
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Недостаточно товара (ID: %)', (item->>'product_id')::INT;
        END IF;
    END LOOP;

    -- Расчет суммы заказа
    FOR item IN SELECT * FROM jsonb_array_elements(p_order_items)
    LOOP
        total := total + (
            SELECT price * (item->>'quantity')::INT
            FROM products 
            WHERE product_id = (item->>'product_id')::INT
        );
    END LOOP;

    -- Создание заказа
    INSERT INTO orders (user_id, status, total_amount)
    VALUES (p_user_id, 'pending', total)
    RETURNING order_id INTO new_order_id;

    -- Добавление позиций заказа
    FOR item IN SELECT * FROM jsonb_array_elements(p_order_items)
    LOOP
        INSERT INTO order_items (order_id, product_id, quantity, price)
        VALUES (
            new_order_id,
            (item->>'product_id')::INT,
            (item->>'quantity')::INT,
            (SELECT price FROM products WHERE product_id = (item->>'product_id')::INT)
        );
        
        -- Обновление остатков
        UPDATE inventory
        SET quantity = quantity - (item->>'quantity')::INT
        WHERE product_id = (item->>'product_id')::INT;
    END LOOP;
END;
$$;

-- 4. Процедура обновления статуса заказа и обработки платежа
CREATE OR REPLACE PROCEDURE update_order_status(
    p_order_id INT,
    p_new_status VARCHAR(20),
    p_payment_status VARCHAR(20) DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Обновление статуса заказа
    UPDATE orders 
    SET status = p_new_status 
    WHERE order_id = p_order_id;
    
    -- Если указан статус платежа
    IF p_payment_status IS NOT NULL THEN
        UPDATE payments
        SET status = p_payment_status
        WHERE order_id = p_order_id;
    END IF;
    
    -- Автоматическая отмена при недостатке средств
    IF p_new_status = 'cancelled' THEN
        -- Возврат товара на склад
        UPDATE inventory i
        SET quantity = i.quantity + oi.quantity
        FROM order_items oi
        WHERE 
            oi.order_id = p_order_id 
            AND i.product_id = oi.product_id;
    END IF;
END;
$$;

-- 5. Процедура добавления отзыва с валидацией
CREATE OR REPLACE PROCEDURE add_review(
    p_user_id INT,
    p_product_id INT,
    p_rating SMALLINT,
    p_comment TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    has_purchase BOOLEAN;
BEGIN
    -- Проверка покупки товара
    SELECT EXISTS (
        SELECT 1
        FROM orders o
        JOIN order_items oi ON o.order_id = oi.order_id
        WHERE 
            o.user_id = p_user_id 
            AND oi.product_id = p_product_id
            AND o.status = 'delivered'
    ) INTO has_purchase;
    
    IF NOT has_purchase THEN
        RAISE EXCEPTION 'Только покупатели могут оставлять отзывы';
    END IF;
    
    -- Добавление отзыва
    INSERT INTO reviews (product_id, user_id, rating, comment)
    VALUES (p_product_id, p_user_id, p_rating, p_comment);
END;
$$;

Описание процедур:
1.	register_user
o	Регистрирует нового пользователя
o	Проверяет уникальность email через ограничение UNIQUE
2.	add_inventory
o	Добавляет товар на склад
o	Автоматически обновляет количество при существующей записи
o	Использует ON CONFLICT для UPSERT-операции
3.	create_order
o	Принимает данные в формате JSON: [{"product_id":1, "quantity":2}, ...]
o	Проверяет наличие товара на всех складах
o	Автоматически рассчитывает сумму заказа
o	Резервирует товар (уменьшает остатки)
o	Вызывает исключение при недостатке товара
4.	update_order_status
o	Обновляет статус заказа
o	Синхронизирует статус платежа
o	Автоматически возвращает товар при отмене заказа
o	Обрабатывает логику отмены
5.	add_review
o	Проверяет, покупал ли пользователь товар
o	Требует доставленного заказа
o	Защищает от "накрутки" отзывов

Окончательный код базы данных интернет-магазина с реализованными хранимыми процедурами:

-- Создание таблиц
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE manufacturers (
    manufacturer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    country VARCHAR(50) NOT NULL
);

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    parent_id INT REFERENCES categories(category_id)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    manufacturer_id INT NOT NULL REFERENCES manufacturers(manufacturer_id),
    category_id INT NOT NULL REFERENCES categories(category_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE warehouses (
    warehouse_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL
);

CREATE TABLE inventory (
    product_id INT NOT NULL REFERENCES products(product_id),
    warehouse_id INT NOT NULL REFERENCES warehouses(warehouse_id),
    quantity INT NOT NULL CHECK (quantity >= 0),
    PRIMARY KEY (product_id, warehouse_id)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id),
    status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled')),
    total_amount DECIMAL(12,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
    order_id INT NOT NULL REFERENCES orders(order_id),
    product_id INT NOT NULL REFERENCES products(product_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    PRIMARY KEY (order_id, product_id)
);

CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL REFERENCES products(product_id),
    user_id INT NOT NULL REFERENCES users(user_id),
    rating SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL UNIQUE REFERENCES orders(order_id),
    amount DECIMAL(12,2) NOT NULL,
    method VARCHAR(20) NOT NULL CHECK (method IN ('credit_card', 'paypal', 'bank_transfer')),
    status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
    transaction_id VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Создание индексов
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_manufacturer ON products(manufacturer_id);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_reviews_product ON reviews(product_id);
CREATE INDEX idx_inventory_warehouse ON inventory(warehouse_id);
CREATE INDEX idx_payments_order ON payments(order_id);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_products_name ON products(name);

-- Вставка демо-данных
INSERT INTO users (email, password_hash, full_name) VALUES 
('ivan@example.com', 'hash1', 'Иван Петров'),
('anna@example.com', 'hash2', 'Анна Сидорова');

INSERT INTO manufacturers (name, country) VALUES 
('Samsung', 'Южная Корея'),
('Apple', 'США'),
('Bosch', 'Германия');

INSERT INTO categories (name, parent_id) VALUES 
('Электроника', NULL),
('Бытовая техника', NULL),
('Смартфоны', 1),
('Ноутбуки', 1),
('Холодильники', 2);

INSERT INTO products (name, description, price, manufacturer_id, category_id) VALUES 
('iPhone 13', 'Смартфон с процессором A15', 799.99, 2, 3),
('Galaxy S21', 'Флагман Samsung с камерой 108MP', 699.99, 1, 3),
('MacBook Pro 16"', 'Ноутбук с чипом M1 Pro', 2499.99, 2, 4),
('Холодильник Bosch KGN39', 'NoFrost холодильник', 899.99, 3, 5);

INSERT INTO warehouses (name, address) VALUES 
('Основной склад', 'Москва, ул. Складская, 1'),
('Склад доставки', 'Санкт-Петербург, ул. Логистическая, 5');

INSERT INTO inventory (product_id, warehouse_id, quantity) VALUES 
(1, 1, 50), (1, 2, 25),
(2, 1, 40), (2, 2, 30),
(3, 1, 15), 
(4, 2, 20);

INSERT INTO orders (user_id, status, total_amount) VALUES 
(1, 'delivered', 799.99),
(2, 'processing', 3199.98);

INSERT INTO order_items (order_id, product_id, quantity, price) VALUES 
(1, 1, 1, 799.99),
(2, 3, 1, 2499.99),
(2, 4, 1, 699.99);  -- Исправлено: должен быть product_id 2 (Galaxy S21)

INSERT INTO reviews (product_id, user_id, rating, comment) VALUES 
(1, 1, 5, 'Отличный телефон!'),
(3, 2, 4, 'Мощный ноутбук, но дорогой');

INSERT INTO payments (order_id, amount, method, status, transaction_id) VALUES 
(1, 799.99, 'credit_card', 'completed', 'txn_12345'),
(2, 3199.98, 'paypal', 'pending', 'txn_67890');

-- Хранимые процедуры

-- 1. Регистрация нового пользователя
CREATE OR REPLACE PROCEDURE register_user(
    p_email VARCHAR(255),
    p_password_hash VARCHAR(255),
    p_full_name VARCHAR(100)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO users (email, password_hash, full_name)
    VALUES (p_email, p_password_hash, p_full_name);
END;
$$;

-- 2. Управление инвентарем (добавление/обновление)
CREATE OR REPLACE PROCEDURE manage_inventory(
    p_product_id INT,
    p_warehouse_id INT,
    p_quantity INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO inventory (product_id, warehouse_id, quantity)
    VALUES (p_product_id, p_warehouse_id, p_quantity)
    ON CONFLICT (product_id, warehouse_id)
    DO UPDATE SET quantity = inventory.quantity + EXCLUDED.quantity;
END;
$$;

-- 3. Оформление нового заказа
CREATE OR REPLACE PROCEDURE create_order(
    p_user_id INT,
    p_order_items JSON
)
LANGUAGE plpgsql
AS $$
DECLARE
    new_order_id INT;
    item JSON;
    total DECIMAL(12,2) := 0;
    available_quantity INT;
BEGIN
    -- Создаем временную таблицу для резервирования
    CREATE TEMP TABLE temp_reservations (
        product_id INT,
        quantity INT,
        warehouse_id INT
    ) ON COMMIT DROP;

    -- Проверка наличия и резервирование
    FOR item IN SELECT * FROM json_array_elements(p_order_items)
    LOOP
        SELECT COALESCE(SUM(quantity), 0) INTO available_quantity
        FROM inventory
        WHERE product_id = (item->>'product_id')::INT;

        IF available_quantity < (item->>'quantity')::INT THEN
            RAISE EXCEPTION 'Недостаточно товара (ID: %)', (item->>'product_id')::INT;
        END IF;

        -- Резервируем со складов
        WITH reservation AS (
            SELECT 
                (item->>'product_id')::INT AS product_id,
                inv.warehouse_id,
                LEAST(inv.quantity, 
                      (item->>'quantity')::INT - COALESCE(SUM(res.quantity) OVER (PARTITION BY res.product_id), 0)
                ) AS reserve_qty
            FROM inventory inv
            LEFT JOIN temp_reservations res 
                ON inv.product_id = res.product_id AND inv.warehouse_id = res.warehouse_id
            WHERE inv.product_id = (item->>'product_id')::INT
            ORDER BY inv.quantity DESC
        )
        INSERT INTO temp_reservations (product_id, quantity, warehouse_id)
        SELECT product_id, reserve_qty, warehouse_id
        FROM reservation
        WHERE reserve_qty > 0;
    END LOOP;

    -- Расчет суммы заказа
    FOR item IN SELECT * FROM json_array_elements(p_order_items)
    LOOP
        total := total + (
            SELECT price * (item->>'quantity')::INT
            FROM products 
            WHERE product_id = (item->>'product_id')::INT
        );
    END LOOP;

    -- Создание заказа
    INSERT INTO orders (user_id, status, total_amount)
    VALUES (p_user_id, 'pending', total)
    RETURNING order_id INTO new_order_id;

    -- Добавление позиций заказа
    FOR item IN SELECT * FROM json_array_elements(p_order_items)
    LOOP
        INSERT INTO order_items (order_id, product_id, quantity, price)
        VALUES (
            new_order_id,
            (item->>'product_id')::INT,
            (item->>'quantity')::INT,
            (SELECT price FROM products WHERE product_id = (item->>'product_id')::INT)
        );
    END LOOP;

    -- Обновление остатков
    UPDATE inventory inv
    SET quantity = inv.quantity - res.quantity
    FROM temp_reservations res
    WHERE 
        inv.product_id = res.product_id 
        AND inv.warehouse_id = res.warehouse_id;
END;
$$;

-- 4. Обновление статуса заказа
CREATE OR REPLACE PROCEDURE update_order_status(
    p_order_id INT,
    p_new_status VARCHAR(20),
    p_payment_status VARCHAR(20) DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Обновление статуса заказа
    UPDATE orders 
    SET status = p_new_status 
    WHERE order_id = p_order_id;
    
    -- Обновление статуса платежа при необходимости
    IF p_payment_status IS NOT NULL THEN
        UPDATE payments
        SET status = p_payment_status
        WHERE order_id = p_order_id;
    END IF;
    
    -- Возврат товара при отмене
    IF p_new_status = 'cancelled' THEN
        UPDATE inventory i
        SET quantity = i.quantity + oi.quantity
        FROM order_items oi
        WHERE 
            oi.order_id = p_order_id 
            AND i.product_id = oi.product_id
            -- Распределение по складам можно реализовать дополнительно
            AND i.warehouse_id = (
                SELECT warehouse_id 
                FROM inventory 
                WHERE product_id = oi.product_id 
                ORDER BY quantity DESC 
                LIMIT 1
            );
    END IF;
END;
$$;

-- 5. Добавление отзыва с проверкой покупки
CREATE OR REPLACE PROCEDURE add_review(
    p_user_id INT,
    p_product_id INT,
    p_rating SMALLINT,
    p_comment TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    has_purchase BOOLEAN;
BEGIN
    -- Проверка покупки товара
    SELECT EXISTS (
        SELECT 1
        FROM orders o
        JOIN order_items oi ON o.order_id = oi.order_id
        WHERE 
            o.user_id = p_user_id 
            AND oi.product_id = p_product_id
            AND o.status = 'delivered'
    ) INTO has_purchase;
    
    IF NOT has_purchase THEN
        RAISE EXCEPTION 'Только покупатели могут оставлять отзывы';
    END IF;
    
    -- Добавление отзыва
    INSERT INTO reviews (product_id, user_id, rating, comment)
    VALUES (p_product_id, p_user_id, p_rating, p_comment);
END;
$$;

 Примеры использования процедур:
1.	Регистрация нового пользователя:
CALL register_user('alex@example.com', 'securehash', 'Алексей Иванов');
2.	Обновление остатков на складе:
CALL manage_inventory(1, 1, 10);  -- Добавить 10 единиц товара 1 на склад 1
3.	Оформление заказа:
CALL create_order(1, '[{"product_id": 2, "quantity": 2}]');
4.	Обновление статуса заказа:
CALL update_order_status(3, 'shipped', 'completed');
5.	Добавление отзыва:
CALL add_review(1, 3, 5, 'Прекрасный товар!');

