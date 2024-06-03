-- models/marts/core/payments.sql
with customer_payments as (
  select
    o.user_id,
    sum(p.payment_amount) as customer_lifetime_value
  from PC_HEVODATA_DB.public.pgsql_raw_payments p
  join PC_HEVODATA_DB.public.pgsql_raw_orders o
    on p.order_id = o.id
  group by o.user_id
)
select
  user_id,
  customer_lifetime_value
from customer_payments
