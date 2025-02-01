-- Описание/Пошаговая инструкция выполнения домашнего задания:

--Напишите запрос по своей базе с регулярным выражением, добавьте пояснение, что вы хотите найти.
--Находим все поставщиков, контакты которых начинается на "8952"
select * from shop.suppliers
where concats like '8952%'
;

-- Напишите запрос по своей базе с использованием LEFT JOIN и INNER JOIN, как порядок соединений в FROM влияет на результат? Почему?
-- Выберем данные по поставщикам и продуктам, которые постащик предоставляет
-- При использовании LEFT JOIN будут видны поставщики у которых есть продукты
select *
from shop.suppliers s
left join shop.products p on p.suppliers_id = s.id
;

-- При использовании INNER JOIN будут видны поставщики у которых есть продукты
select *
from shop.suppliers s
inner join shop.products p on p.suppliers_id = s.id
;
-- Порядок соединений важен т.к к примеру при использовании сначала соеднинения INNER JOIN а затем LEFT JOIN.
-- Мы бы получили только тех постащиков у которых есть продукты. При этом все поставщики у которых нет товаров, были бы полностью исключены из рузультатов.

-- Напишите запрос на добавление данных с выводом информации о добавленных строках.
with inserted as(
       insert into shop.categories (id,name)
       values 
       (1,'Вода'),
       (2,'Мясо'),
       (3,'Хлеб'),
       (4,'Сыр')
       returning *
)
select * from inserted;

insert into shop.suppliers (id,name,contacts,address)
values (5,'Поставщик N','+79517555555','Адрес1')
       (6,'Поставщик M','+79993332221','Адрес2')
;

insert into shop.manufacturer (id,name,address,contacts,product_description,price)
values (7,'Производитель хлеба','Адрес3','+79582221133','Хлебо-булочные изделия','Цена')
;

insert into shop.products (id,categoty_id,name,manufacturer_id,suppliers_id)
values (8,3,'Булочка с изюмом','7,5')
;

-- Напишите запрос с обновлением данные используя UPDATE FROM
-- Обновляем цену продукции, основываясь на цене производителя
update shop.products
set price = shop.manufacturer.price
from shop.manufacturer
where shop.products.manufacturer_id = shop.manufacturer.id
;

-- Напишите запрос для удаления данных с оператором DELETE используя join с другой таблицей с помощью using.
-- Удаляем продукты, которые относятся к производителю "Производитель хлеба"
delete from shop.products
using shop.manufacturer
where shop.priducts.manufacturer_id = shop.manufacturer.id
and shop.manufacturer.name = 'Производитель хлеба'
;
