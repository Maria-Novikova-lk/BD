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
