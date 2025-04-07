
  
    

    create table iceberg."bronze"."store"
      
      
    as (
      

select * from "sqlserver"."Sales"."Store"
    );

  