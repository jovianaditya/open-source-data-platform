
  
    

    create table iceberg."bronze"."product"
      
      
    as (
      

select * from "sqlserver"."Production"."Product"
    );

  