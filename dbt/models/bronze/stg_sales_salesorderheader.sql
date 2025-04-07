{{ config(
    alias='salesorderheader',
    materialized='table',
    format='ICEBERG',
    incremental_strategy= 'merge',
    unique_key=['SalesOrderID']
) }}

select * from {{ source('sql_server_sales', 'SalesOrderHeader') }}