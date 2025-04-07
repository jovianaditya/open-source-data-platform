
  
    

    create table iceberg."bronze"."salesterritory"
      
      
    as (
      

select * from "sqlserver"."Sales"."SalesTerritory"
    );

  