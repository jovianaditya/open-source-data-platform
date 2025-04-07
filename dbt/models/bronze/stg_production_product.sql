{{ config(
    alias='product',
    materialized='table',
    format='ICEBERG',
    incremental_strategy= 'merge',
    unique_key=['ProductID']
) }}

select * from {{ source('sql_server_production', 'Product') }}