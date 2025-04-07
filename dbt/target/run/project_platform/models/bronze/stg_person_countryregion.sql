
  
    

    create table iceberg."bronze"."countryregion"
      
      
    as (
      

select * from "sqlserver"."Person"."CountryRegion"
    );

  