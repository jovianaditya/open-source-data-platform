{{ config(
    alias='productmodel',
    materialized='table',
    format='ICEBERG',
    incremental_strategy= 'merge',
    unique_key=['ProductModelID']
) }}

select * from {{ source('sql_server_production', 'ProductModel') }}