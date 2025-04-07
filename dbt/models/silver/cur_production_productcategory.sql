{{ config(
    alias='productcategory',
    materialized='table',
    format='ICEBERG',
    schema='silver',
    incremental_strategy= 'merge',
    unique_key=['productcategoryid']
) }}

SELECT 
    ProductCategoryID as productcategoryid
    ,Name as name
    ,rowguid
    ,ModifiedDate as modified
    ,CURRENT_TIMESTAMP as ingesttime
FROM AdventureWorks2022.Production.ProductCategory;