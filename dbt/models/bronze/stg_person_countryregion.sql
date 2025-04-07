{{ config(
    alias='countryregion',
    materialized='table',
    format='ICEBERG',
    incremental_strategy= 'merge',
    unique_key=['CountryRegionCode']
) }}

select * from {{ source('sql_server_person', 'CountryRegion') }}