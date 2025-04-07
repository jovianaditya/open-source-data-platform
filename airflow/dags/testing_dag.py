from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.dummy import DummyOperator
from airflow.utils.dates import days_ago
from datetime import timedelta
import pendulum

# Import main function from script
from scripts.extractfile_append_duckdb import main

args = {
    'owner': 'jovianaditya',
    'start_date': pendulum.now("Asia/Jakarta").subtract(days=1),
    'depends_on_past': False,
    'retries': 3,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    dag_id='extract_table_duckdb',
    default_args=args,
    description='Extract SQL Server table using Python + DuckDB',
    concurrency=5,
    dagrun_timeout=timedelta(hours=18),
    schedule_interval='00 21 * * *',  # 21:00 Jakarta time
    tags=['duckdb', 'sqlserver'],
    catchup=False
)

start = DummyOperator(
    task_id='start',
    dag=dag
)

finish = DummyOperator(
    task_id='finish',
    dag=dag
)

run_extract = PythonOperator(
    task_id='run_duckdb_extract',
    python_callable=main,
    dag=dag
)

start >> run_extract >> finish
