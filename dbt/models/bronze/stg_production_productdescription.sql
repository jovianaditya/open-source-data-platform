{{ config(
    alias='productdescription',
    materialized='table',
    format='ICEBERG',
    incremental_strategy= 'merge',
    unique_key=['ProductDescriptionID']
) }}

select * from {{ source('sql_server_production', 'ProductDescription') }}