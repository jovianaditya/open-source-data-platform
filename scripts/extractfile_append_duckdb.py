import duckdb
import pandas as pd
from io import BytesIO
from minio import Minio
from sqlalchemy import create_engine
from airflow.hooks.base import BaseHook
from urllib.parse import urlparse

# Tables to export
TABLE_NAMES = ['employees']

# Airflow Connections
sql_conn = BaseHook.get_connection("sqlserver")
minio_conn = BaseHook.get_connection("minio")

# Parse and sanitize MinIO endpoint
parsed_minio = urlparse(minio_conn.host)
minio_endpoint = f"{parsed_minio.hostname or minio_conn.host}:{minio_conn.port or parsed_minio.port or 9000}"

# MinIO client
minio_client = Minio(
    minio_endpoint,
    access_key=minio_conn.login,
    secret_key=minio_conn.password,
    secure=False
)

def fetch_and_upload_data(table_name):
    try:
        # SQLAlchemy engine
        engine = create_engine(
            f"mssql+pyodbc://{sql_conn.login}:{sql_conn.password}@{sql_conn.host}:{sql_conn.port or 1433}/{sql_conn.schema}?driver=ODBC+Driver+17+for+SQL+Server"
        )

        print(f"[INFO] Reading from SQL Server table: {table_name}")
        df = pd.read_sql(f"SELECT * FROM dbo.{table_name}", engine)

        print(f"[INFO] Converting {table_name} to Parquet via DuckDB...")
        duck = duckdb.connect(':memory:')
        duck.register(table_name, df)
        parquet_path = f"/tmp/{table_name}.parquet"
        duck.execute(f"COPY (SELECT * FROM {table_name}) TO '{parquet_path}' (FORMAT PARQUET)")

        # Read file to buffer
        with open(parquet_path, 'rb') as f:
            parquet_buffer = BytesIO(f.read())
        parquet_buffer.seek(0)

        print(f"[INFO] Uploading {table_name}.parquet to MinIO bucket 'bronze'...")
        minio_client.put_object(
            "bronze",
            f"{table_name}.parquet",
            parquet_buffer,
            length=len(parquet_buffer.getvalue())
        )

        print(f"[SUCCESS] Uploaded {table_name}.parquet to MinIO.")

    except Exception as e:
        print(f"[ERROR] Failed to process {table_name}: {e}")
        raise
    finally:
        if 'duck' in locals():
            duck.close()

def main():
    for table in TABLE_NAMES:
        fetch_and_upload_data(table)

if __name__ == "__main__":
    main()