-- models/marts/core/customer_summary.sql
with customers as (
  select
    id,
    first_name,
    last_name
  from {{ ref('customers') }}
),
orders as (
  select
    user_id,
    first_order,
    most_recent_order,
    number_of_orders
  from {{ ref('orders') }}
),
payments as (
  select
    user_id,
    customer_lifetime_value
  from {{ ref('payments') }}
)
select
  customers.id,
  customers.first_name,
  customers.last_name,
  orders.first_order,
  orders.most_recent_order,
  orders.number_of_orders,
  payments.customer_lifetime_value
from customers
left join orders on customers.id = orders.user_id
left join payments on customers.id = payments.user_id
