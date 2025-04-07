{{ config(
    alias='salesorderheader',
    materialized='table',
    format='ICEBERG',
    schema='silver',
    incremental_strategy= 'merge',
    unique_key=['salesorderid']
) }}

SELECT 
    SalesOrderID as salesorderid
    ,RevisionNumber as revisionnumber
    ,OrderDate as orderdate
    ,DueDate as duedate
    ,ShipDate as shipdate
    ,Status as status
    ,OnlineOrderFlag as onlineorderflag
    ,SalesOrderNumber as salesordernumber
    ,PurchaseOrderNumber as purchaseordernumber
    ,AccountNumber as accountnumber
    ,CustomerID as customerid
    ,SalesPersonID as salespersonid
    ,TerritoryID as territoryid
    ,BillToAddressID as billtoaddressid
    ,ShipToAddressID as shiptoaddressid
    ,ShipMethodID as shipmethodid
    ,CreditCardID as creditcardid
    ,CreditCardApprovalCode as creditcardapprovalcode
    ,CurrencyRateID as currencyrateid
    ,SubTotal as subtotal
    ,TaxAmt as taxamt
    ,Freight as freight
    ,TotalDue as totaldue
    ,Comment as comment
    ,rowguid
    ,ModifiedDate as modified
    ,CURRENT_TIMESTAMP as ingesttime
FROM AdventureWorks2022.Sales.SalesOrderHeader;