
  
    

    create table iceberg."bronze"."employees"
      
      
    as (
      

select * from "sqlserver"."dbo"."employees"
    );

  