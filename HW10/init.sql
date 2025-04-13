CREATE DATABASE shop_db;
USE shop_db;

CREATE TABLE IF NOT EXISTS client
(
    client_id              INT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
    name            VARCHAR(255)                            NOT NULL,
    contacts        VARCHAR(255)                            NOT NULL,
    delivery_address    VARCHAR(255)                            NOT NULL,
);

CREATE TABLE IF NOT EXISTS prices
(
    price_id   INT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
    product_id INT UNSIGNED                            NOT NULL REFERENCES product (product_id),
    price      numeric CHECK (price > 0),
);

CREATE TABLE purchases
(
    purchase_id   INT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
    product_id    INT UNSIGNED                            NOT NULL REFERENCES product (product_id),
    client_id   INT UNSIGNED                            NOT NULL REFERENCES customer (client_id),
    price_id      INT UNSIGNED                            NOT NULL REFERENCES price (price_id),
    purchase_date DATE                                    NOT NULL,
);

CREATE TABLE IF NOT EXISTS products
(
    id              INT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
    category_id     INT UNSIGNED                            NOT NULL REFERENCES category (category_id),
    name            VARCHAR(255)                            NOT NULL,
    manufacturer_id INT UNSIGNED                            NOT NULL REFERENCES manufacturer (manufacturer_id),
    supplier_id     INT UNSIGNED                            NOT NULL REFERENCES supplier (supplier_id),
    specifications  JSON DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS suppliers
(
    supplier_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
    name        VARCHAR(255)                            NOT NULL,
    contacts    VARCHAR(255)                            NOT NULL,
    address     VARCHAR(255),
);

CREATE TABLE IF NOT EXISTS manufacturers
(
    manufacturer_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
    name            VARCHAR(255)                            NOT NULL,
    address         VARCHAR(255),
    contacts        VARCHAR(255)                            NOT NULL,
    product_description     VARCHAR(1000)                   NOT NULL,
    price      numeric CHECK (price > 0),
);

CREATE TABLE IF NOT EXISTS categories
(
    category_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
    name        VARCHAR(255)                            NOT NULL
);

