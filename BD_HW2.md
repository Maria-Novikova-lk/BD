Домашнее задание

Добавляем в модель данных дополнительные индексы и ограничения

*Цель:* применять индексы в реальном проекте.

*Описание/Пошаговая инструкция выполнения домашнего задания:*

1.  Проводим анализ возможных запросов\\отчетов\\поиска данных.

2.  Предполагаем возможную кардинальность поля.

3.  Создаем дополнительные индексы - простые или композитные.

4.  На каждый индекс пишем краткое описание зачем он нужен (почему по
    этому полю\\полям).

5.  Думаем какие логические ограничения в БД нужно добавить - например
    какие поля должны быть уникальны, в какие нужно добавить условия,
    чтобы не нарушить бизнес логику. Пример - нельзя провести операцию
    по переводу средств на отрицательную сумму.

6.  Создаем ограничения по выбранным полям.

Описание:

1.  Клиенты:

-   idx\_client\_name индекс на name

-   idx\_client\_contacts индекс на contacts

-   idx\_client\_delivery\_address индекс на address

2.  Цены:

-   idx\_prices\_price индекс на price

-   idx\_prices\_products\_id индекс на products\_id

3.  Покупки:

-   idx\_purchases\_product\_id индекс на product\_id

-   idx\_purchases\_client\_id индекс на client\_id

-   idx\_purchases\_prices\_id индекс на prices\_id

-   idx\_purchases\_purchase\_data индекс на purchase\_data

4.  Продукты:

-   idx\_products\_categoty\_id\_name индекс на categoty\_id\_name

-   idx\_products\_name индекс на name

-   idx\_products\_manufacturer\_id\_name индекс на
    manufacturer\_id\_name

-   idx\_products\_suppliers\_id\_name индекс на suppliers\_id\_name

5.  Поставщики:

-   idx\_suppliers\_name индекс на name

-   idx\_suppliers\_contacts индекс на contacts

-   idx\_suppliers\_address индекс на address

6.  Производитель:

-   idx\_manufacturer\_name индекс на name

-   idx\_manufacturer\_address индекс на address

-   idx\_manufacturer\_contacts индекс на contacts

-   idx\_munufacturer\_profuct\_descriptio индекс на profuct\_descriptio

-   idx\_manufacterer\_price индекс на price

7.  Категории:

-   idx\_categories\_name индекс на name

Скрипт:

 CREATE TABLE `Client`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `contacts` VARCHAR(255) NOT NULL,
    `delivery address` VARCHAR(255) NOT NULL
);
CREATE INDEX idx_client_name ON client(name);
CREATE INDEX idx_client_contacts ON client(contacts);
CREATE INDEX idx_client_delivery_address ON client(delivery_address);

CREATE TABLE `prices`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `products_id` BIGINT NOT NULL,
    `price` BIGINT NOT NULL
);
CREATE INDEX idx_prices_price ON prices(price);
CREATE INDEX idx_prices_products_id ON prices(products_id);

CREATE TABLE `purchases`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `product_id` BIGINT NOT NULL,
    `client_id` BIGINT NOT NULL,
    `prices_id` BIGINT NOT NULL,
    `purchase_data` DATE NOT NULL
);
CREATE INDEX idx_purchases_product_id ON purchases(product_id);
CREATE INDEX idx_purchases_client_id ON purchases(client_id);
CREATE INDEX idx_purchases_prices_id ON purchases(prices_id);
CREATE INDEX idx_purchases_purchase_data ON purchases(purchase_data);

CREATE TABLE `products`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `category_id` VARCHAR(255) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `manufacturer_id` BIGINT NOT NULL,
    `suppliers_id` BIGINT NOT NULL
);
CREATE INDEX idx_products_categoty_id_name ON products(category_id,name);
CREATE INDEX idx_products_name ON products(name);
CREATE INDEX idx_products_manufacturer_id_name ON products(manufacturer_id,name);
CREATE INDEX idx_products_suppliers_id_name ON products(suppliers_id,name);

CREATE TABLE `suppliers` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `contacts` VARCHAR(255) NOT NULL,
    `address` VARCHAR(255) NOT NULL
);
CREATE INDEX idx_suppliers_name ON suppliers(name);
CREATE INDEX idx_suppliers_contacts ON suppliers(contacts);
CREATE INDEX idx_suppliers_address ON suppliers(address);

CREATE TABLE `manufacturer`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `address` VARCHAR(255) NOT NULL,
    `contacts` VARCHAR(255) NOT NULL,
    `Product description` TEXT NOT NULL,
    `price` VARCHAR(255) NOT NULL
);
CREATE INDEX idx_manufacturer_name ON manufacturer(name);
CREATE INDEX idx_manufacturer_address ON manufacturer(address);
CREATE INDEX idx_manufacturer_contacts ON manufacturer(contacts);
CREATE INDEX idx_munufacturer_profuct_descriptio ON manufacturer(product_description);
CREATE INDEX idx_manufacterer_price ON manufacturer(price);

CREATE TABLE `categories`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL
);
CREATE INDEX idx_categories_name ON categoties(name);

ALTER TABLE
    `products` ADD CONSTRAINT `products_suppliers_id_foreign` FOREIGN KEY(`suppliers_id`) REFERENCES `suppliers`(`id`);
ALTER TABLE
    `purchases` ADD CONSTRAINT `purchases_client_id_foreign` FOREIGN KEY(`client_id`) REFERENCES `Client`(`id`);
ALTER TABLE
    `purchases` ADD CONSTRAINT `purchases_prices_id_foreign` FOREIGN KEY(`prices_id`) REFERENCES `prices`(`id`);
ALTER TABLE
    `products` ADD CONSTRAINT `products_manufacturer_id_foreign` FOREIGN KEY(`manufacturer_id`) REFERENCES `manufacturer`(`id`);
ALTER TABLE
    `purchases` ADD CONSTRAINT `purchases_product_id_foreign` FOREIGN KEY(`product_id`) REFERENCES `products`(`id`);
ALTER TABLE
    `products` ADD CONSTRAINT `products_category_id_foreign` FOREIGN KEY(`category_id`) REFERENCES `categories`(`id`);
ALTER TABLE
    `prices` ADD CONSTRAINT `prices_products_id_foreign` FOREIGN KEY(`products_id`) REFERENCES `products`(`id`);
