
  
    

    create table iceberg."bronze"."salesorderheader"
      
      
    as (
      

select * from "sqlserver"."Sales"."SalesOrderHeader"
    );

  