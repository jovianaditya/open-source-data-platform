{{ config(
    alias='product',
    materialized='table',
    format='ICEBERG',
    schema='silver',
    incremental_strategy= 'merge',
    unique_key=['productid']
) }}

SELECT 
    ProductID as productid
    ,Name as name
    ,ProductNumber as productnumber
    ,MakeFlag as makeflag
    ,FinishedGoodsFlag as finishedgoodsflag
    ,Color as color
    ,SafetyStockLevel as safetystocklevel
    ,ReorderPoint as reorderpoint
    ,StandardCost as standardcost
    ,ListPrice as listprice
    ,[Size] as [size]
    ,SizeUnitMeasureCode as sizeunitmeasurecode
    ,WeightUnitMeasureCode as weightunitmeasurecode
    ,Weight as weight
    ,DaysToManufacture as daystomanufacture
    ,ProductLine as productline
    ,Class as class
    ,[Style] as [style]
    ,ProductSubcategoryID as productsubcategoryid
    ,ProductModelID as productmodelid
    ,SellStartDate as sellstartdate
    ,SellEndDate as sellenddate
    ,DiscontinuedDate as discontinueddate
    ,rowguid
    ,ModifiedDate as modified
    ,CURRENT_TIMESTAMP as ingesttime
FROM AdventureWorks2022.Production.Product;