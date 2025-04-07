
  
    

    create table iceberg."bronze"."customer"
      
      
    as (
      

select * from "sqlserver"."Sales"."Customer"
    );

  