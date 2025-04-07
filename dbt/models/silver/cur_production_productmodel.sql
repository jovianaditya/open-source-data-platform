{{ config(
    alias='productmodel',
    materialized='table',
    format='ICEBERG',
    schema='silver',
    incremental_strategy= 'merge',
    unique_key=['productmodelid']
) }}

SELECT 
    ProductModelID as productmodelid
    ,Name as name
    ,CatalogDescription as catalogdescription
    ,Instructions as instructions
    ,rowguid
    ,ModifiedDate as modified
    ,CURRENT_TIMESTAMP as ingesttime
FROM AdventureWorks2022.Production.ProductModel;