{{ config(
    alias='productcategory',
    materialized='table',
    format='ICEBERG',
    incremental_strategy= 'merge',
    unique_key=['ProductCategoryID']
) }}

select * from {{ source('sql_server_production', 'ProductCategory') }}