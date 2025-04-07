{{ config(
    alias='salesorderdetail',
    materialized='table',
    format='ICEBERG',
    incremental_strategy= 'merge',
    unique_key=['SalesOrderID', 'SalesOrderDetailID']
) }}

select * from {{ source('sql_server_sales', 'SalesOrderDetail') }}