{% test assert_first_order_before_most_recent(model, column_name, most_recent_order_column) %}
select *
from {{ model }}
where {{ column_name }} > {{ most_recent_order_column }}
{% endtest %}
