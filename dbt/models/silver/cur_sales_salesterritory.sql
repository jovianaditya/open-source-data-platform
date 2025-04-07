{{ config(
    alias='salesterritory',
    materialized='table',
    format='ICEBERG',
    schema='silver',
    incremental_strategy= 'merge',
    unique_key=['territoryid']
) }}

SELECT 
    TerritoryID as territoryid
    ,Name as name
    ,CountryRegionCode as countryregioncode
    ,[Group] as group
    ,SalesYTD as salesytd
    ,SalesLastYear as saleslastyear
    ,CostYTD as costytd
    ,CostLastYear as costlastyear
    ,rowguid 
    ,ModifiedDate as modified
    ,CURRENT_TIMESTAMP as ingesttime
FROM AdventureWorks2022.Sales.SalesTerritory;