{{ config(
    alias='countryregion',
    materialized='table',
    format='ICEBERG',
    schema='silver',
    incremental_strategy= 'merge',
    unique_key=['countryregioncode']
) }}

SELECT 
    CountryRegionCode as countryregioncode
    ,Name as name
    ,ModifiedDate as modified
    ,CURRENT_TIMESTAMP as ingesttime
FROM AdventureWorks2022.Person.CountryRegion;