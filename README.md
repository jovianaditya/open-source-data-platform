# DataStack-in-a-Box
![opensource drawio](https://github.com/user-attachments/assets/76cb6699-b437-4e27-804b-7767d4fdb03f)

DataStack-in-a-Box is a self-managed, on-premise open-source data platform built entirely using Docker. It brings together key components of a modern data stack in a modular and lightweight architecture. The platform uses MinIO as the storage layer, Trino and DuckDB as execution engines, Airflow for orchestration, dbt for transformation, and Metabase for visualization. 

To support streamlined development and deployment, GitLab is integrated for CI/CD. This project was designed to be scalable, cost-effective, and easily reproducible—ideal for teams or individuals looking to run a complete data platform locally or in a controlled environment without relying on fully managed cloud services.


## Minio
Minio command:
- Communicate to minio container : docker exec -it <*container_name*> /bin/bash
- Make alias to connect into localhost: mc alias set <_alias_name_> [http://localhost:9000](http://localhost:9000/) <access-key> <secret-key>
- Show alias that already made: mc alias list
- Make a bucket inside minio storage: mc mb alias/<bucket-name>

Access minio via web browser: http://localhost:9000
![image](https://github.com/user-attachments/assets/5ba904d7-d24e-487d-836b-b545f4648288)
![image (1)](https://github.com/user-attachments/assets/6a389da8-adac-4f8b-9720-04ea377c2459)

## Trino
- Communicate to trino container : docker exec -it <*container_name*> /bin/bash
- By default when installing trino and setting on specific port (by default port 8080), it will not let you log in with a password.
![image (2)](https://github.com/user-attachments/assets/e01f8a24-23c5-4d72-b8c9-db0975243f0d)
So you need to follow several steps from this documentation: https://trino.io/docs/current/security/password-file.html
After follow several steps from that documentation (add a few lines of config and add new https port default is 8443), you can log in to Trino UI with password
![image (3)](https://github.com/user-attachments/assets/17d5a6da-39ee-4807-a6fb-836e76237863)

## dbt
DBT container likely stops running immediately after starting because it doesn’t have a persistent process keeping it alive. Since dbt is a CLI tool and not a long-running service, the container only runs and then exits unless explicitly kept alive. So it’s a normal thing when you check docker ps and there are no dbt container eventhough you already start your docker compose.

Check if dbt works with trying to extract sql server tables and sink it into iceberg table using dbt:
![image](https://github.com/user-attachments/assets/1fe905e6-6d15-4d5a-86ac-82fd4c9d6ac5)
![image (4)](https://github.com/user-attachments/assets/a2c80cef-6f72-4d56-98da-a420f5678454)
![image (5)](https://github.com/user-attachments/assets/54dc10c7-76f4-435c-8010-2ac4e03ca8c8)

Check table in DBeaver:
![image (6)](https://github.com/user-attachments/assets/dadac6ac-33bb-4ff7-9dae-8868c1947501)

