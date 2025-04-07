{{ config(
    alias='salesterritory',
    materialized='table',
    format='ICEBERG',
    incremental_strategy= 'merge',
    unique_key=['TerritoryID']
) }}

select * from {{ source('sql_server_sales', 'SalesTerritory') }}