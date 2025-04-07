{{ config(
    alias='productmodelproductdescriptionculture',
    materialized='table',
    format='ICEBERG',
    schema='silver',
    incremental_strategy= 'merge',
    unique_key=['productmodelid','productdescriptionid','cultureid']
) }}

SELECT 
    ProductModelID as productmodelid
    ,ProductDescriptionID as productdescriptionid
    ,CultureID as cultureid
    ,ModifiedDate as modifieddate
    ,CURRENT_TIMESTAMP as ingesttime
FROM AdventureWorks2022.Production.ProductModelProductDescriptionCulture;