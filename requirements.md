# Задача: Построить витрину для RFM анализа

## Расположение:
`analysis.dm_rfm_segments`

Данные с 2022-01-01. Обновления не нужны.
## Поля витрины: 
* `user_id`
* `recency` (от 1 до 5 зависит от даты последнего заказа, где 5 самый свежий заказ)
* `frequency` (от 1 до 5 зависит от количества заказов, где 5 наибольшее кол-во заказов)
* `monetary_value` (от 1 до 5 зависит от потраченной сумме, где 5 наибольшая сумма)

В каждом сегменте 1-5 должно быть одинаковое кол-во клиентов.

## Решение
1) Построим представления в `analysis`, которые берут данные за 2022 год из `production`
2) Было создано 5 представлений (`!!!` - будет использоваться):
   * `orderitems`
      - `id` | int4
      - `product_id` | int4
      - `product_id` | int4
      - `order_id` | int4
      - `name` | varchar(2048)
      - `price` | numeric(19, 5)
      - `discount` | numeric(19, 5)
      - `quantity` | int4

   * `orders`
      - `order_id` | int4  `!!!`
      - `order_ts` | timestamp  `!!!`
      - `user_id` | int4 `!!!`
      - `bonus_payment` | numeric(19, 5)
      - `payment` | numeric(19, 5)  `!!!`
      - `cost` | numeric(19, 5)
      - `bonus_grant` | numeric(19, 5)
      - `status` | int4 `!!!`

   * `orderstatuses`
      - `id` | int4
      - `key` | varchar(255)

   * `orderstatuslog`
      - `id` | int4
      - `order_id` | int4
      - `status_id` | int4
      - `dttm` | timestamp

   * `products`
      - `id` | int4
      - `name` | varchar(2048)
      - `price` | numeric(19, 5)

   * `users`
      - `id` | int4
      - `name` | varchar(2048)
      - `login` | varchar(2048)

3) Создадим таблицу для витрины `analysis.dm_rfm_segments`
4) Создадим 3 таблицы для каждого показателя: `analysis.tmp_rfm_frequency`, `analysis.tmp_rfm_frequency`, `analysis.tmp_rfm_monetary_value`
5) Заполним таблицы, где определем шкалу через наибольшее значение даты, суммы выручки или кол-ва заказов, в зависимости от требуемого показателя
6) Заполним с помощью арисоединения показателей таблицу `analysis.dm_rfm_segments`
7) Обновим представление `analysis.orders`: удалим старое и с помощью присоединения таблиц `orderstatuslog` и `orders` добавим показатель статуса заказа

