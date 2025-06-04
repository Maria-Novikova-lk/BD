1:
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    properties TEXT
);

2:
INSERT INTO products (name, description, properties) VALUES
('Ноутбук', 'Профессиональный ноутбук для разработчиков', 'Процессор: Intel Core i7, ОЗУ: 16 ГБ'),
('Монитор', 'Монитор с высоким разрешением', 'Диагональ: 27", Разрешение: 1440x900'),
('Клавиатура', 'Механическая клавиатура', 'Количество клавиш: 104, Подсветка: RGB');

3:
3.1
ALTER TABLE products ADD FULLTEXT(name, description, properties);
3.2
EXPLAIN SELECT * FROM products WHERE MATCH(name, description, properties) AGAINST('ноутбук разработчиков Intel');

Анализ и результаты:
1:
EXPLAIN SELECT * FROM products WHERE name LIKE '%ноутбук%' OR description LIKE '%разработчиков%' OR properties LIKE '%Intel%';

+----+-------------+----------+------------+------+---------------+------+---------+------+------+----------+-------------+
| id | select_type | table    | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra       |
+----+-------------+----------+------------+------+---------------+------+---------+------+------+----------+-------------+
|  1 | SIMPLE      | products | NULL       | ALL  | NULL          | NULL | NULL    | NULL |    3 |    33.33 | Using where |
+----+-------------+----------+------------+------+---------------+------+---------+------+------+----------+-------------+

2:
EXPLAIN SELECT * FROM products WHERE MATCH(name, description, properties) AGAINST('ноутбук разработчиков Intel');

+----+-------------+----------+------------+----------+---------------+------------+---------+-------+------+----------+-----------------------+
| id | select_type | table    | partitions | type     | possible_keys | key        | key_len | ref   | rows | filtered | Extra                 |
+----+-------------+----------+------------+----------+---------------+------------+---------+-------+------+----------+-----------------------+
|  1 | SIMPLE      | products | NULL       | fulltext | name          | name       | 0       | const |    1 |   100.00 | Using where; Ft_hints: no_ranking |
+----+-------------+----------+------------+----------+---------------+------------+---------+-------+------+----------+-----------------------+

Заключение:
В результате выполнения домашнего задания был создан полнотекстовый индекс для таблицы products по полям name, description и properties. Это позволило значительно ускорить поиск по текстовым полям, как показано в результате выполнения команды EXPLAIN.

README
Изменения индексов:

Добавлен полнотекстовый индекс для таблицы products по полям name, description и properties:
ALTER TABLE products ADD FULLTEXT(name, description, properties);Результаты:

Результаты:
Без индекса запрос выполняется с полным сканированием таблицы.
С использованием полнотекстового индекса запрос выполняется значительно быстрее, используя созданный индекс.