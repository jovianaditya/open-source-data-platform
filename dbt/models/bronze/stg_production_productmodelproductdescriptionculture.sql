{{ config(
    alias='productmodelproductdescriptionculture',
    materialized='table',
    format='ICEBERG',
    incremental_strategy= 'merge',
    unique_key=['ProductModelID','ProductDescriptionID','CultureID']
) }}

select * from {{ source('sql_server_production', 'ProductModelProductDescriptionCulture') }}