
  
    

    create table iceberg."bronze"."productmodelproductdescriptionculture"
      
      
    as (
      

select * from "sqlserver"."Production"."ProductModelProductDescriptionCulture"
    );

  