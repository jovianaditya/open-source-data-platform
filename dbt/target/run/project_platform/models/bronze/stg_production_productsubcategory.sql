
  
    

    create table iceberg."bronze"."productsubcategory"
      
      
    as (
      

select * from "sqlserver"."Production"."ProductSubCategory"
    );

  