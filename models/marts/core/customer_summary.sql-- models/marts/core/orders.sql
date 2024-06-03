-- models/marts/core/orders.sql
with customer_orders as (
  select
    user_id,
    min(order_date) as first_order,
    max(order_date) as most_recent_order,
    count(id) as number_of_orders
  from PC_HEVODATA_DB.public.pgsql_raw_orders
  group by user_id
)
select
  user_id,
  first_order,
  most_recent_order,
  number_of_orders
from customer_orders
