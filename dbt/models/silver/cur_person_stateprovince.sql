{{ config(
    alias='stateprovince',
    materialized='table',
    format='ICEBERG',
    schema='silver',
    incremental_strategy= 'merge',
    unique_key=['stateprovinceid']
) }}

SELECT 
    StateProvinceID as stateprovinceid
    ,StateProvinceCode as stateprovincecode
    ,CountryRegionCode as countryregioncode
    ,IsOnlyStateProvinceFlag as isonlystateprovinceflag
    ,Name as name
    ,TerritoryID as territoryid
    ,rowguid
    ,ModifiedDate as modified
    ,CURRENT_TIMESTAMP as ingesttime
FROM AdventureWorks2022.Person.StateProvince;