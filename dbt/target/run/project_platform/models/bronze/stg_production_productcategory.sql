
  
    

    create table iceberg."bronze"."productcategory"
      
      
    as (
      

select * from "sqlserver"."Production"."ProductCategory"
    );

  