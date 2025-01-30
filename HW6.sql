--1. Создать индекс к какой-либо из таблиц вашей БД
-- Возьмем таблицу продуктов.
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

--Создаем индекс, это позволит ускорить поиск и сортировку данных.
--Создание может занять время и дополнительное место на диске, поэтому необходим
-- анализ, какие индексы необходимы, для оптимизации производительности запросов.
CREATE INDEX idx_products_categoty_id_name ON shop.products(category_id,name);
CREATE INDEX idx_products_name ON shop.products(name);
CREATE INDEX idx_products_manufacturer_id_name ON shop.products(manufacturer_id,name);
CREATE INDEX idx_products_suppliers_id_name ON shop.products(suppliers_id,name);



--2. Прислать текстом результат команды explain, в которой используется данный индекс
--Чтобы получить результат команды explain, необходимо выполнить запрос, который будет использовать данный индекс.
--Выполняем запрос для получения всех продуктов с определнным "индентификатором производителя".
select * from shop.products where shop.products.manufacturer_id = 1;

--Теперь используем команду explain для анализа запроса.
explain select * from shop.products where shop.products.manufacturer_id = 1;

/* План азпроса:
 * Index Scan using idx_products_manufacturer_id on products  (cost=0.15..8.17 rows=1 width=64)
 *   Index Cond: (manufacturer_id = 1)
 * (2 rows)
 */



--3. Реализовать индекс для полнотекстового поиска.
--Создадим индекс для поля name таблицы продуктов.
--используем расширения pg_trgm и btree_gin для улучшения производительности и точности поиска.
create extension pg_trgm;
create extension btree_gin;
--индекс для поиска по названию продукта
create index idx_products_name on shop.products using gin (name);



--4. Реализовать индекс на часть таблицы или индекс на поле с функцией/
--индекс для продуктов у которых длина названия больше 5 символов.
--Это ускорит запросы, для поиска продукта по их названию.
create index idx_products_name_length on shop.products (name)
where length(name) > 3;



--5. Создать индекс на несколько полей.
create index idx_products_name_category_id_manufacturer_id on shop.products(name,category_id,manufacturer_id);
--Таблицы продуктов, создаем индекс на полях название, категоря и производитель продукта.