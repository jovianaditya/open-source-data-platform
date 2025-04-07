
  
    

    create table iceberg."bronze"."salesorderdetail"
      
      
    as (
      

select * from "sqlserver"."Sales"."SalesOrderDetail"
    );

  