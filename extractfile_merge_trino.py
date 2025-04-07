# # TRINO for merge case initial run
# import trino
# from trino.dbapi import connect

# trino_conn = connect(
#     host='trino',
#     port=8080,
#     user='admin',
#     catalog='iceberg',
#     schema='bronze'
# )

# def convert_to_iceberg():
#     try:
#         cursor = trino_conn.cursor()
        
#         # Create schema if it doesn't exist
#         cursor.execute("CREATE SCHEMA IF NOT EXISTS iceberg.bronze")
        
#         # Drop existing staging table if exists
#         cursor.execute("DROP TABLE IF EXISTS iceberg.bronze.employees")
        
#         # Create the staging table
#         cursor.execute("""
#         CREATE TABLE iceberg.bronze.employees 
#         WITH (location = 's3a://bronze/employees')
#         AS 
#         SELECT 
#             id,
#             firstname,
#             lastname,
#             department,
#             hiredate,
#             salary,
#             CAST(modified AS TIMESTAMP(6)) AS modified
#         FROM sqlserver.dbo.employees
#         """)
#         print("Successfully converted to Iceberg format")
        
#     except Exception as e:
#         print(f"Error: {str(e)}")
#     finally:
#         cursor.close()
#         trino_conn.close()

# if __name__ == "__main__":
#     convert_to_iceberg()




# # TRINO for merge case second run
# import trino
# from trino.dbapi import connect

# trino_conn = connect(
#     host='trino',
#     port=8080,
#     user='admin',
#     catalog='iceberg',
#     schema='bronze'
# )

# def convert_to_iceberg():
#     try:
#         cursor = trino_conn.cursor()
#         # Create schema if it doesn't exist
#         cursor.execute("CREATE SCHEMA IF NOT EXISTS iceberg.bronze")
        
#         # Drop existing staging table if exists
#         cursor.execute("DROP TABLE IF EXISTS iceberg.bronze.employees_stg")
        
#         # Create the staging table
#         cursor.execute("""
#         CREATE TABLE iceberg.bronze.employees_stg AS 
#         SELECT 
#             id,
#             firstname,
#             lastname,
#             department,
#             hiredate,
#             salary,
#             CAST(modified AS TIMESTAMP(6)) AS modified
#         FROM sqlserver.dbo.employees
#         WHERE modified > CAST('2023-01-23' AS TIMESTAMP(6))
#         """)
        
#         print("Successfully converted to Iceberg format - Staging table created")

#         # Step 2: Merge the staging data into the existing Iceberg table
#         cursor.execute("""
#         MERGE INTO iceberg.bronze.employees t
#         USING iceberg.bronze.employees_stg s
#         ON t.id = s.id
#         WHEN MATCHED THEN
#         UPDATE SET
#             firstname = s.firstname,
#             lastname = s.lastname,
#             department = s.department,
#             hiredate = s.hiredate,
#             salary = s.salary,
#             modified = s.modified
#         WHEN NOT MATCHED THEN
#         INSERT (id, firstname, lastname, department, hiredate, salary, modified)
#         VALUES (s.id, s.firstname, s.lastname, s.department, s.hiredate, s.salary, s.modified)
#         """)
        
#         print("Data merged into employees table successfully")
        
#     except Exception as e:
#         print(f"Error: {str(e)}")
#     finally:
#         cursor.close()
#         trino_conn.close()

# if __name__ == "__main__":
#     convert_to_iceberg()

from minio import Minio
import trino
from trino.dbapi import connect
from datetime import datetime, timedelta

def get_minio_client():
   return Minio(
       "minio:9000",
       access_key="minioadmin",
       secret_key="minioadmin",
       secure=False
   )

def connect_trino():
   return connect(
       host='trino',
       port=8080,
       user='admin',
       catalog='iceberg',
       schema='bronze'
   )

def check_table_exists(cursor):
   cursor.execute("""
   SELECT table_name 
   FROM iceberg.information_schema.tables 
   WHERE table_schema = 'bronze' AND table_name = 'employees'
   """)
   return cursor.fetchone() is not None

def cleanup_staging_files(minio_client):
   objects = minio_client.list_objects("bronze", prefix="employees_stg", recursive=True)
   for obj in objects:
       minio_client.remove_object("bronze", obj.object_name)

def create_initial_table(cursor):
   cursor.execute("""
   CREATE TABLE iceberg.bronze.employees 
   WITH (location = 's3a://bronze/employees')
   AS SELECT 
       id,
       firstname,
       lastname,
       department,
       hiredate,
       salary,
       CAST(modified AS TIMESTAMP(6)) AS modified
   FROM sqlserver.dbo.employees
   """)

def merge_incremental_data(cursor):
    lookback_date = (datetime.now() - timedelta(days=3)).strftime('%Y-%m-%d')
    
    cursor.execute(f"""
    CREATE TABLE iceberg.bronze.employees_stg 
    WITH (location = 's3a://bronze/employees_stg')
    AS 
    SELECT 
        id,
        firstname,
        lastname,
        department,
        hiredate,
        salary,
        CAST(modified AS TIMESTAMP(6)) AS modified
    FROM sqlserver.dbo.employees
    WHERE modified > CAST('{lookback_date}' AS DATE)
    """)
    
    cursor.execute("""
    MERGE INTO iceberg.bronze.employees t
    USING iceberg.bronze.employees_stg s
    ON t.id = s.id
    WHEN MATCHED THEN
        UPDATE SET
            firstname = s.firstname,
            lastname = s.lastname,
            department = s.department,
            hiredate = s.hiredate,
            salary = s.salary,
            modified = s.modified
    WHEN NOT MATCHED THEN
        INSERT (id, firstname, lastname, department, hiredate, salary, modified)
        VALUES (s.id, s.firstname, s.lastname, s.department, s.hiredate, s.salary, s.modified)
    """)

def convert_to_iceberg():
   minio_client = None
   trino_conn = None
   cursor = None
   
   try:
       minio_client = get_minio_client()
       trino_conn = connect_trino()
       cursor = trino_conn.cursor()
       
       cursor.execute("CREATE SCHEMA IF NOT EXISTS iceberg.bronze")
       
       if not check_table_exists(cursor):
           create_initial_table(cursor)
           print("Initial table creation successful")
       else:
           cleanup_staging_files(minio_client)
           cursor.execute("DROP TABLE IF EXISTS iceberg.bronze.employees_stg")
           print("Old staging files cleaned up")
           
           merge_incremental_data(cursor)
           print("Merge operation completed successfully")
           
   except Exception as e:
       print(f"Error: {str(e)}")
   finally:
       if cursor:
           cursor.close()
       if trino_conn:
           trino_conn.close()

if __name__ == "__main__":
   convert_to_iceberg()