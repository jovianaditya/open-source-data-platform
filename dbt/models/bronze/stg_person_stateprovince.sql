{{ config(
    alias='stateprovince',
    materialized='table',
    format='ICEBERG',
    incremental_strategy= 'merge',
    unique_key=['StateProvinceID']
) }}

select * from {{ source('sql_server_person', 'StateProvince') }}