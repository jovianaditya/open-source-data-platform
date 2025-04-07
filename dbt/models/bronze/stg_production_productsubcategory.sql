{{ config(
    alias='productsubcategory',
    materialized='table',
    format='ICEBERG',
    incremental_strategy= 'merge',
    unique_key=['ProductSubCategoryID']
) }}

select * from {{ source('sql_server_production', 'ProductSubCategory') }}