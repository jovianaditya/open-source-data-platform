# **DataStack-in-a-Box**
![opensource drawio](https://github.com/user-attachments/assets/76cb6699-b437-4e27-804b-7767d4fdb03f)

DataStack-in-a-Box is a self-managed, on-premise open-source data platform built entirely using Docker. It brings together key components of a modern data stack in a modular and lightweight architecture. The platform uses MinIO as the storage layer, Trino and DuckDB as execution engines, Airflow for orchestration, dbt for transformation, and Metabase for visualization. 

To support streamlined development and deployment, GitLab is integrated for CI/CD. This project was designed to be scalable, cost-effective, and easily reproducible—ideal for teams or individuals looking to run a complete data platform locally or in a controlled environment without relying on fully managed cloud services.


## **Minio**
Minio command:
- Communicate to minio container: docker exec -it <*container_name*> /bin/bash
- Make an alias to connect to localhost: mc alias set <_alias_name_> [http://localhost:9000](http://localhost:9000/) <access-key> <secret-key>
- Show alias that already made: mc alias list
- Make a bucket inside minio storage: mc mb alias/<bucket-name>

Access Minio via web browser: http://localhost:9000
![image](https://github.com/user-attachments/assets/5ba904d7-d24e-487d-836b-b545f4648288)
![image (1)](https://github.com/user-attachments/assets/6a389da8-adac-4f8b-9720-04ea377c2459)

## **Trino**
- Communicate to trino container: docker exec -it <*container_name*> /bin/bash
- By default, when installing Trino and setting it on a specific port (by default, port 8080), it will not let you log in with a password.
![image (2)](https://github.com/user-attachments/assets/e01f8a24-23c5-4d72-b8c9-db0975243f0d)
So you need to follow several steps from this documentation: https://trino.io/docs/current/security/password-file.html
After following several steps from that documentation (add a few lines of config and add new https port default is 8443), you can log in to Trino UI with the password
![image (3)](https://github.com/user-attachments/assets/17d5a6da-39ee-4807-a6fb-836e76237863)

## **dbt**
DBT container likely stops running immediately after starting because it doesn’t have a persistent process keeping it alive. Since dbt is a CLI tool and not a long-running service, the container only runs and then exits unless explicitly kept alive. So it’s a normal thing when you check docker ps and there are no dbt container eventhough you already start your docker compose.

Check if dbt works with trying to extract SQL Server tables and sink it into an iceberg table using dbt:
![image](https://github.com/user-attachments/assets/1fe905e6-6d15-4d5a-86ac-82fd4c9d6ac5)
![image (4)](https://github.com/user-attachments/assets/a2c80cef-6f72-4d56-98da-a420f5678454)
![image (5)](https://github.com/user-attachments/assets/54dc10c7-76f4-435c-8010-2ac4e03ca8c8)

Check the table in DBeaver:
![image (6)](https://github.com/user-attachments/assets/dadac6ac-33bb-4ff7-9dae-8868c1947501)

## **DuckDB**
Besides using dbt Trino, we can also extract the SQL Server table (need to install ODBC Driver for SQL Server) and save it as a file-based format in Minio storage using DuckDB+python.
![image](https://github.com/user-attachments/assets/7fc081e9-437a-413d-ac93-344f3f5a93af)
![image](https://github.com/user-attachments/assets/19c0bffc-67cf-49c5-b35a-b59de91c8b63)

## **Airflow**
In this project, I'm trying to implement a production scenario using CeleryExecutor airflow instead of Sequential (single node executor). 
![image](https://github.com/user-attachments/assets/005d64d1-cb4d-43ef-999e-ef4549a5e08c)

### **How It Works (Using CeleryExecutor in Airflow)**

1. The **Airflow Scheduler** assigns tasks to the **CeleryExecutor**.
2. The **CeleryExecutor** pushes tasks into a queue (e.g., Redis, RabbitMQ).
3. **Multiple Celery Workers** Pick up and execute the tasks in parallel.
4. The workers then report the task status back to Airflow.

**This is a simple DAG, to run my python script that extracts sql server table and converts it into parquet using DuckDB**
![image](https://github.com/user-attachments/assets/70f60dc5-f868-459f-9f04-e6f5b3dd7b98)

**Before you start your scheduler, you need to add the connection in the Admin section to Minio and sql server:**
![image](https://github.com/user-attachments/assets/93efe9f7-7ee7-45a3-8c72-9c5fe9647f6e)
![image](https://github.com/user-attachments/assets/946dad7d-7426-47bc-a25e-43b45933e395)
![image](https://github.com/user-attachments/assets/75d1d236-d986-4324-ba6a-a90391b0743e)

**DAG content:**
![image](https://github.com/user-attachments/assets/74907590-0567-4e76-9676-6293b26f3d60)
![image](https://github.com/user-attachments/assets/4b94f45f-7bdd-4b9d-85ac-9a54f44c2a28)

**Check the parquet file in minio:**
![image](https://github.com/user-attachments/assets/5a95ecdb-75a2-4fa3-91e5-b857e5804a8f)

## **Metabase**
![image (7)](https://github.com/user-attachments/assets/ccc86b7b-2255-47fe-979c-1076d7230de8)

Actually, Trino is not a database but an execution engine. But Metabase can connect to tables from Trino because it exposes table metadata over the JDBC connection.
To connect Metabase to Trino, you need to install Starburst driver first and mount it into /plugins directory inside the Metabase container. https://github.com/starburstdata/metabase-driver/releases/download/6.1.0/starburst-6.1.0.metabase-driver.jar

After running the container, access http://localhost:3000. For the first time, you will need to input several information for Metabase credentials, and then you can add a database connection to the Metabase:
![image (8)](https://github.com/user-attachments/assets/f7d31456-ca73-4f57-b23a-d11d8769357c)
Because you already downloaded the starburst driver and mounted it into /plugins directory in the metabase container, there will be an option for Starburst in the Database Type.

Enter the following information:
- **Database type:** Select *Starburst* in the dropdown. If this option does not appear, review the [requirements](https://docs.starburst.io/clients/metabase.html#requirements) and make sure you have installed the Starburst driver.
- **Display name:** A name for this database in Metabase, such as the catalog name and cluster name (free to decide).
- **Host:** Hostname or IP address of the cluster.
    You can check your IP database (in this case, Trino) with this command:
    docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <_container_name/container_id_>
- **Port:** Port for the cluster. If the cluster is secured with SSL/TLS, make sure to specify the secure port for that connection. 
    But for now, we still can't use SSL/TLS (using port 8443), and there are still open issues: [Connect to Trino via certificates · Issue #126 · starburstdata/metabase-driver](https://github.com/starburstdata/metabase-driver/issues/126). So for now, just use 8080 (without password)
- **Catalog:** The name of the catalog to be used for this database. Use the iceberg catalog.
- **Schema (optional):** A schema within the catalog, limiting data to the subset within that schema.
- **Username:** Username to connect to the cluster.
- **Password:** Password to connect to the cluster. If the cluster is unsecured, leave this field blank. Because use port 8080, no need to enter a password.

After creating a table in trino, check your trino database in the metabase webserver. If there are no tables, you need to manual syncing the database first.

- Go to **Admin Settings** → **Databases**.
- Find your Trino database and click **Sync database schema now**.
- Wait a few minutes and refresh the table list.
![Untitled](https://github.com/user-attachments/assets/68708917-e1f6-452a-8cbb-7bbaa4a1a739)
![image (10)](https://github.com/user-attachments/assets/8a6a36aa-d196-4863-8f69-1ede823d36fc)
![image (11)](https://github.com/user-attachments/assets/185bab10-6c98-4335-a927-8f00798915d3)

## **GitLab**
![image](https://github.com/user-attachments/assets/bafdc35a-0fb1-4ac7-af45-af64d420bcff)
In the web browser, I’m using external_url = ‘gitlab.local’ to access GitLab instead of "localhost://.....". But before that, there are several steps that must be configured.
You need to set up some configuration in your host file:
![image](https://github.com/user-attachments/assets/db87b0b2-dcd9-459d-ad5b-03c24da27e12)
To login into the GitLab you need to enter root as the username. For the initial password you can find with this method:
![image](https://github.com/user-attachments/assets/ba67a554-ebd8-4dd0-b135-4cae1d27746c)
After login with the root username and the initial password, you can change with your desired password from the web-server:
![image](https://github.com/user-attachments/assets/f45d8967-973b-4c6b-9def-ad37c7de5832)
**Configure SSH in GitLab CI/CD**
![image](https://github.com/user-attachments/assets/7b3482c7-dbe4-40ae-a89a-03805f3ee67f)
### **When is SSH Useful for GitLab**
1. **Accessing Git Repositories Remotely**
    - If you're pushing/pulling code from a different machine (e.g., your laptop to your GitLab server), SSH provides a secure and password-free way to authenticate.
    - Even if GitLab is on your own server, you might access it from different devices (workstation, CI/CD runners, etc.).
2. **Using Git Remotely Over SSH**
    - When you set up an SSH key, GitLab allows you to use URLs like:
        
        ```bash
        git clone git@gitlab.yourserver.com:your-repo.git
        ```
   
        Instead of HTTPS, which requires a username and password (or a PAT).
        
3. **Secure Automation (CI/CD, Deployments, Scripts)**
    - If your GitLab server is used for deployments or automated tasks (e.g., fetching repositories inside a container or running CI/CD jobs), SSH allows those processes to authenticate securely without storing plain text credentials.
### **How To Generate SSH Key**

Use this command (can be done in Windows or Linux):
        ```bash
        ssh-keygen
        ```
![image](https://github.com/user-attachments/assets/8a5bd802-b617-47a9-982d-9128ea9f4872)
![image](https://github.com/user-attachments/assets/f8dfd210-7fbc-4b76-862a-26efc5d76e3b)

After that, go to your Git Lab preferences, SSH Keys, and enter the content of your .pub
![image](https://github.com/user-attachments/assets/e5b47a56-ec1d-4262-8e55-2aa18bec2993)
![image (1)](https://github.com/user-attachments/assets/7c1bcef1-7f86-4313-bc32-9bdd3d1db7ab)
![image (2)](https://github.com/user-attachments/assets/11357411-efd7-4ecf-86d8-83ad64aa63e2)

Actually, there are several features of GitLab, like container registry and runner, that can be explored.
Just for info:
- GitLab Container Registry is a Docker container registry that is built into GitLab. It allows you to store, manage, and distribute container images within your GitLab projects. This is particularly useful for CI/CD pipelines, as you can build, push, and pull container images directly within GitLab. It’s like a Docker Hub, but it is embedded in the GitLab.
- GitLab Runner is an application that picks up and executes CI/CD jobs for GitLab
I also provide the Docker Compose for both of them that you can look up.

Last but not least, there is something called Git-Sync.
The git-sync service does exactly what its name suggests - it acts as a one-way synchronization tool:
* It continuously watches your GitLab repository for changes
* When it detects changes, it pulls them from the repository
* It updates your local Airflow DAGs folder with these changes
* Airflow then sees and executes these updated DAG files

The workflow becomes:
* You develop and commit DAG changes to your GitLab repository
* Git-sync automatically pulls those changes to your Airflow DAGs folder
* Airflow scheduler picks up these changes and executes the DAGs

This creates a clean separation between:
* Development and version control (handled in GitLab)
* Execution (handled by Airflow)
And the git-sync container handles the synchronization between these two environments automatically, eliminating the need for manual file copying or deployments.
I also provide the docker compose for Git-Sync that you can adjust.
