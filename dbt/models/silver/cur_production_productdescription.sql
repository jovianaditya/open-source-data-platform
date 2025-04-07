{{ config(
    alias='productdescription',
    materialized='table',
    format='ICEBERG',
    schema='silver',
    incremental_strategy= 'merge',
    unique_key=['productdescriptionid']
) }}

SELECT 
    ProductDescriptionID as productdescriptionid
    ,Description as description
    ,rowguid
    ,ModifiedDate as modified
    ,CURRENT_TIMESTAMP as ingesttime
FROM AdventureWorks2022.Production.ProductDescription;