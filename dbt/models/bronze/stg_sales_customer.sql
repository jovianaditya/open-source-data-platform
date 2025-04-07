{{ config(
    alias='customer',
    materialized='table',
    format='ICEBERG',
    incremental_strategy= 'merge',
    unique_key=['CustomerID']
) }}

select * from {{ source('sql_server_sales', 'Customer') }}