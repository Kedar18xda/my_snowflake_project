# DBT Project: Customer Summary in Snowflake

This dbt project creates a materialized view `customer_summary` in Snowflake, aggregating data from three tables: `pgsql_raw_customers`, `pgsql_raw_orders`, and `pgsql_raw_payments`. It includes several custom tests to validate the data.

## Prerequisites

- [dbt](https://docs.getdbt.com/docs/installation) installed
- Access to a Snowflake database
- Configured `profiles.yml` file for Snowflake

## Project Structure

my_snowflake_project/
├── models/
│ ├── marts/
│ │ ├── core/
│ │ │ ├── customer_summary.sql
│ │ │ ├── customers.sql
│ │ │ ├── orders.sql
│ │ │ ├── payments.sql
│ │ │ ├── schema.yml
├── macros/
│ │ ├── test_assert_first_order_before_most_recent.sql
│ │ ├── test_assert_non_negative_orders.sql
│ │ ├── test_assert_positive_lifetime_value.sql
│ │ ├── test_assert_valid_customer_names.sql
├── dbt_project.yml
└── README.md

## Setup Instructions

1. **Clone the repository:**

   ```bash
   git clone https://github.com/Kedar18xda/my_snowflake_project
   cd my_snowflake_project

2. **Install dbt:**

If you haven't installed dbt yet, follow the installation instructions from the dbt documentation.

3. **Configure your profiles.yml:**

Ensure your profiles.yml file is configured to connect to your Snowflake instance. This file is typically located in ~/.dbt/profiles.yml. Here is an example configuration:

my_snowflake_profile:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <your-account>
      user: <your-username>
      password: <your-password>
      role: <your-role>
      database: PC_HEVODATA_DB
      warehouse: <your-warehouse>
      schema: public
      threads: 1
      client_session_keep_alive: False

## Build and Run Instructions

1. **Install dependencies:**

Make sure you have installed dbt and your profiles are correctly configured.

2. **Initialize the dbt environment:**

dbt deps

3. **Clean up any previously compiled files:**

dbt clean

4.**Run the dbt models:**

dbt run

5. **Run dbt tests:**

dbt test

## Custom Tests

Custom tests are defined as macros for the customer_summary model in the macros directory and referenced in the schema.yml file.

1. **Test to Ensure First Order Date is Before or Equal to Most Recent Order Date**
Ensure that the first_order date is always before or equal to the most_recent_order date.

2. **Test to Ensure Number of Orders is Positive**
Ensure that number_of_orders is always greater than or equal to 0.

3. **Test to Ensure Valid Customer Names**
Ensure that first_name and last_name are not empty or null.

4. **Test to Ensure No Negative Lifetime Value**
Ensure that the customer_lifetime_value is not negative.

### Custom Test Definitions
**`macros/test_assert_first_order_before_most_recent.sql`:**

{% test assert_first_order_before_most_recent(model, column_name, most_recent_order_column) %}
select *
from {{ model }}
where {{ column_name }} > {{ most_recent_order_column }}
{% endtest %}

**`macros/test_assert_non_negative_orders.sql`:**

{% test assert_non_negative_orders(model, column_name) %}
select *
from {{ model }}
where {{ column_name }} < 0
{% endtest %}

**`macros/test_assert_valid_customer_names.sql`:**

{% test assert_valid_customer_names(model, column_name) %}
select *
from {{ model }}
where {{ column_name }} is null
   or {{ column_name }} = ''
{% endtest %}

**`macros/test_assert_positive_lifetime_value.sql`:**

{% test assert_positive_lifetime_value(model, column_name) %}
select *
from {{ model }}
where {{ column_name }} < 0
{% endtest %}

### Referencing Custom Tests in schema.yml
In the schema.yml, custom tests are referenced and provided the necessary parameters.

version: 2

models:
  - name: customers
    description: "Customer details."
    columns:
      - name: id
        description: "Unique identifier for each customer."
        data_tests:
          - unique
          - not_null
      - name: first_name
        description: "First name of the customer."
      - name: last_name
        description: "Last name of the customer."

  - name: orders
    description: "Order details."
    columns:
      - name: user_id
        description: "ID of the customer who placed the order."
        data_tests:
          - not_null
      - name: first_order
        description: "Date of the first order."
      - name: most_recent_order
        description: "Date of the most recent order."
      - name: number_of_orders
        description: "Total number of orders placed by the customer."

  - name: payments
    description: "Payment details."
    columns:
      - name: user_id
        description: "ID of the customer who made the payment."
        data_tests:
          - not_null
      - name: customer_lifetime_value
        description: "Total amount paid by the customer."

  - name: customer_summary
    description: "Summary of customer details, orders, and payments."
    columns:
      - name: id
        description: "Unique identifier for each customer."
      - name: first_name
        description: "First name of the customer."
        data_tests:
          - assert_valid_customer_names:
              column_name: first_name
      - name: last_name
        description: "Last name of the customer."
        data_tests:
          - assert_valid_customer_names:
              column_name: last_name
      - name: first_order
        description: "Date of the first order."
        data_tests:
          - assert_first_order_before_most_recent:
              column_name: first_order
              most_recent_order_column: most_recent_order
      - name: most_recent_order
        description: "Date of the most recent order."
      - name: number_of_orders
        description: "Total number of orders placed by the customer."
        data_tests:
          - assert_non_negative_orders:
               column_name: number_of_orders
      - name: customer_lifetime_value
        description: "Total amount paid by the customer."
        data_tests:
          - assert_positive_lifetime_value:
               column_name: customer_lifetime_value

## Additional Resources

[dbt Documentation](https://docs.getdbt.com)
[Snowflake Documentation](https://docs.snowflake.com)

## Contact

For any issues or questions, please contact Kedar Deshpande at kedar18@gmail.com.
