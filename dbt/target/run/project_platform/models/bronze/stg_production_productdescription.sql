
  
    

    create table iceberg."bronze"."productdescription"
      
      
    as (
      

select * from "sqlserver"."Production"."ProductDescription"
    );

  