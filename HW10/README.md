## Домашнее задание

Типы данных

Цель:

Подбирать нужные типы данных;  
Определиться с типом ID;  
Изучить тип JSON.

  

Описание/Пошаговая инструкция выполнения домашнего задания:

1. проанализировать типы данных в своем проекте, изменить при необходимости. В README указать что на что поменялось и почему.
2. добавить тип JSON в структуру. Проанализировать какие данные могли бы там хранится. привести примеры SQL для добавления записей и выборки.

1.

```MySQL
CREATE TABLE IF NOT EXISTS purchases
(
    purchase_id   INT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
    product_id    INT UNSIGNED                            NOT NULL REFERENCES product (product_id),
    client_id     INT UNSIGNED                            NOT NULL REFERENCES customer (client_id),
    price_id      INT UNSIGNED                            NOT NULL REFERENCES price (price_id),
    purchase_date DATE                                    NOT NULL,
);
```

Первичные ключи `id` создаем в беззнаковом формате `INT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE`.
Связи между таблицами описываем через `REFERENCES`.


2.

В таблицу `products` добавлено поле `specifications` в формате JSON.
Для демонстрации создадим таблицу и добавим в нее данные.

```MySQL
INSERT INTO products (name, specifications)
VALUES ('TWS Наушники Readme Buts 5',
        '{
          "Тип": "TWS Наушники",
          "Модель": Xiaomi Redmi Buds 5,
          "Страна": "Китай",
          "Производитель": "Xiaomi",
          "Дата начала производства": "2023"
        }');
```

После можно писать выборки по Спецификации
```MySQL
SELECT * FROM products WHERE JSON_EXTRACT(specifications, '$."Страна"') = 'Китай';
```

