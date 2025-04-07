{{ config(
    alias='salesorderdetail',
    materialized='table',
    format='ICEBERG',
    schema='silver',
    incremental_strategy= 'merge',
    unique_key=['salesorderid', 'salesorderdetailid']
) }}


SELECT 
    SalesOrderID as salesorderid
    ,SalesOrderDetailID as salesorderdetailid
    ,CarrierTrackingNumber as carriertrackingnumber
    ,OrderQty as orderqty
    ,ProductID as productid
    ,SpecialOfferID as specialofferid
    ,UnitPrice as unitprice
    ,UnitPriceDiscount as unitpricediscount
    ,LineTotal as linetotal
    ,rowguid as rowguid
    ,ModifiedDate as modified
    ,CURRENT_TIMESTAMP as ingesttime
FROM AdventureWorks2022.Sales.SalesOrderDetail;