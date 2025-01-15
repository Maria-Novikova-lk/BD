create database shop_db;
select datname from pg_database;

create tablespace my_table LOCATION 'C:\Program Files\PostgreSQL\17\data';
select * from pg_tablespace;

create role readonly wicth password '123';
grant connect on database shop_db to "readonly";
grant select on table in schema shop to "readonly";
alter default privileges grant select on tables to readonly;

select rolname, rolcanlogin from pg_roles;

drop schema if exists shop;
create schema shop;

drop table if exists shop.client cascade; 
create table shop.client (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contacts VARCHAR(255) NOT NULL,
    delivery_address VARCHAR(255) NOT NULL
) tablespace my_table;
comment on culumn shop.client.id is 'ID клиента';
comment on culumn shop.client.name is 'Имя клиента';
comment on culumn shop.client.contacts is 'контакты клиента';
comment on culumn shop.client.delivery_address is 'адрес доставки';

CREATE INDEX idx_client_name ON shop.client(name);
CREATE INDEX idx_client_contacts ON shop.client(contacts);
CREATE INDEX idx_client_delivery_address ON shop.client(delivery_address);


drop table if exists shop.prices cascade;
create table shop.prices (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    products_id BIGINT NOT NULL,
    price BIGINT NOT NULL
) tablespace my_table;
comment on culumn shop.prices.id is 'ID цены';
comment on culumn shop.prices.products_id is 'ID продукта';
comment on culumn shop.prices.price is 'цена';

CREATE INDEX idx_prices_price ON shop.prices(price);
CREATE INDEX idx_prices_products_id ON shop.prices(products_id);


drop table if exists shop.purchases cascade;
create table shop.purchases (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT NOT NULL,
    client_id BIGINT NOT NULL,
    prices_id BIGINT NOT NULL,
    purchase_data DATE NOT NULL
) tablespace my_table;
comment on culumn shop.purchases.id is 'ID покупки';
comment on culumn shop.purchases.product_id is 'ID продукта';
comment on culumn shop.purchases.client_id is 'ID клиента';
comment on culumn shop.purchases.prices_id is 'ID цены';
comment on culumn shop.purchases.purchase_data is 'дата покупки';

CREATE INDEX idx_purchases_product_id ON shop.purchases(product_id);
CREATE INDEX idx_purchases_client_id ON shop.purchases(client_id);
CREATE INDEX idx_purchases_prices_id ON shop.purchases(prices_id);
CREATE INDEX idx_purchases_purchase_data ON shop.purchases(purchase_data);


drop table if exists shop.products cascade;
create table shop.products (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    category_id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    manufacturer_id BIGINT NOT NULL,
    suppliers_id BIGINT NOT NULL
) tablespace my_table;
comment on culumn shop.products.id is 'ID продукта';
comment on culumn shop.products.category_id is 'ID категории продукта';
comment on culumn shop.products.name is 'наименование продукта';
comment on culumn shop.products.manufacturer_id is 'индетфикатор производителя';
comment on culumn shop.products.suppliers_id is 'индетификатор поставщика';

CREATE INDEX idx_products_categoty_id_name ON shop.products(category_id,name);
CREATE INDEX idx_products_name ON shop.products(name);
CREATE INDEX idx_products_manufacturer_id_name ON shop.products(manufacturer_id,name);
CREATE INDEX idx_products_suppliers_id_name ON shop.products(suppliers_id,name);


drop table if exists shop.suppliers cascade;
create table shop.suppliers (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contacts VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL
) tablespace my_table;
comment on culumn shop.suppliers.id is 'ID поставщика';
comment on culumn shop.suppliers.name is 'название постащика';
comment on culumn shop.suppliers.contacts is 'контакты поставщика';
comment on culumn shop.suppliers.address is 'адрес поставщика';

CREATE INDEX idx_suppliers_name ON shop.suppliers(name);
CREATE INDEX idx_suppliers_contacts ON shop.suppliers(contacts);
CREATE INDEX idx_suppliers_address ON shop.suppliers(address);


drop table if exists shop.manufacturer cascade;
create table shop.manufacturer (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    contacts VARCHAR(255) NOT NULL,
    product_description TEXT NOT NULL,
    price VARCHAR(255) NOT NULL
) tablespace my_table;
comment on culumn shop.manufacturer.id is 'ID производителя';
comment on culumn shop.manufacturer.name is 'наименование производителя';
comment on culumn shop.manufacturer.address is 'адрес производителя';
comment on culumn shop.manufacturer.contacts is 'контакты производителя';
comment on culumn shop.manufacturer.product_description is 'описание производителя';
comment on culumn shop.manufacturer.price is 'цена продукта';

CREATE INDEX idx_manufacturer_name ON shop.manufacturer(name);
CREATE INDEX idx_manufacturer_address ON shop.manufacturer(address);
CREATE INDEX idx_manufacturer_contacts ON shop.manufacturer(contacts);
CREATE INDEX idx_munufacturer_profuct_descriptio ON shop.manufacturer(product_description);
CREATE INDEX idx_manufacterer_price ON shop.manufacturer(price);


drop table if exists shop.categories cascade;
create table shop.categories (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
) tablespace my_table;
comment on culumn shop.categories.id is 'ID категории';
comment on culumn shop.categories.name is 'название категории';

CREATE INDEX idx_categories_name ON shop.categoties(name);


ALTER TABLE
    shop.products ADD CONSTRAINT products_suppliers_id_foreign FOREIGN KEY(suppliers_id) REFERENCES shop.suppliers(id);
ALTER TABLE
    shop.purchases ADD CONSTRAINT purchases_client_id_foreign FOREIGN KEY(client_id) REFERENCES shop.client(id);
ALTER TABLE
    shop.purchases ADD CONSTRAINT purchases_prices_id_foreign FOREIGN KEY(prices_id) REFERENCES shop.prices(id);
ALTER TABLE
    shop.products ADD CONSTRAINT products_manufacturer_id_foreign FOREIGN KEY(manufacturer_id) REFERENCES shop.manufacturer(id);
ALTER TABLE
    shop.purchases ADD CONSTRAINT purchases_product_id_foreign FOREIGN KEY(product_id) REFERENCES shop.products(id);
ALTER TABLE
    shop.products ADD CONSTRAINT products_category_id_foreign FOREIGN KEY(category_id) REFERENCES shop.categories(id);
ALTER TABLE
    shop.prices ADD CONSTRAINT prices_products_id_foreign FOREIGN KEY(products_id) REFERENCES shop.products(id);