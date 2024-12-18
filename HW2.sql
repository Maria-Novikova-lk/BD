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