{% test assert_valid_customer_names(model, column_name) %}
select *
from {{ model }}
where {{ column_name }} is null
   or {{ column_name }} = ''
{% endtest %}