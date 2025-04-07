{{ config(
    alias='store',
    materialized='table',
    format='ICEBERG',
    incremental_strategy= 'merge',
    unique_key=['BusinessEntityID']
) }}

select * from {{ source('sql_server_sales', 'Store') }}