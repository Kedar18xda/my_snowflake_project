-- models/marts/core/customers.sql
select
  id,
  first_name,
  last_name
from PC_HEVODATA_DB.public.pgsql_raw_customers
