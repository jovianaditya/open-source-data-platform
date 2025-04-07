{{ config(
    alias='customer',
    materialized='table',
    format='ICEBERG',
    schema='silver',
    incremental_strategy= 'merge',
    unique_key=['customerid']
) }}

SELECT 
    CustomerID as customerid
    ,PersonID as personid
    ,StoreID as storeid
    ,TerritoryID as territoryid
    ,AccountNumber as accountnumber
    ,rowguid as rowguid
    ,ModifiedDate as modified
    ,CURRENT_TIMESTAMP as ingesttime
FROM AdventureWorks2022.Sales.Customer;