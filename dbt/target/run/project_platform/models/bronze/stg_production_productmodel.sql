
  
    

    create table iceberg."bronze"."productmodel"
      
      
    as (
      

select * from "sqlserver"."Production"."ProductModel"
    );

  