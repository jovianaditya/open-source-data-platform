{{ config(
    alias='store',
    materialized='table',
    format='ICEBERG',
    schema='silver',
    incremental_strategy= 'merge',
    unique_key=['businessentityid']
) }}

SELECT 
    BusinessEntityID as businessentityid
    ,Name as name
    ,SalesPersonID as salespersonid
    ,Demographics as demographics
    ,rowguid
    ,ModifiedDate as modified
    ,CURRENT_TIMESTAMP as ingesttime
FROM AdventureWorks2022.Sales.Store;