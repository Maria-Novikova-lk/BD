
![drawSQL-image-export-2024-12-08](https://i.imgur.com/ipKPVIT.png)


                                                База данных по интернет – магазину.

     Описание таблиц и полей:

   Категории продуктов (categories):

<!-- -->

-   *Id* – ID категории;

-   *Name* – название категории.

<!-- -->

   Поставщики (suppliers):

<!-- -->

-   *Id* – идентификатор поставщика;

-   *Name* – название поставщика;

-   *Contacts* – контакты поставщика;

-   *Address* – адрес поставщика.

<!-- -->

   Производитель (manufacturer):

<!-- -->

-   *Id* – идентификатор производителя;

-   *Name* – наименование производителя;

-   *Address* – адрес производителя;

-   *Contacts* – контакты производителя;

-   *Product description* – описание продукта;

-   *Price –* цена продукта.

<!-- -->

   Продукты (products):

<!-- -->

-   *Id* – ID продукта;

-   *category\_id –* ID категории продукта;

-   *name – наименование продукта;*

-   *manufacturer\_id –* идентификатор *производителя;*

-   *suppliers\_id –* идентификатор *поставщика.*

<!-- -->

   Клиент (clirnt):

<!-- -->

-   *Id –* ID клиента;

-   *Name –* имя клиента;

-   *Contacts –* контакты клиента;

-   *delivery address –* адрес доставки клиента.

<!-- -->

   Покупки (purchases):

<!-- -->

-   *Id –* ID покупки;

-   *product\_id –* ID продукта;

-   *client\_id –* ID клиента;

-   *prices\_id –* ID цены;

-   *purchase\_data –* дата покупки.

<!-- -->

   Цены (prices):

<!-- -->

-   *Id –* ID цены;

-   *products\_id –* ID продукта;

-   *price –* цена.
