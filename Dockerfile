# Use the Python 3.9 slim image
FROM python:3.9-slim

# Set a working directory
WORKDIR /app

# Install system dependencies for pyodbc and ODBC driver
RUN apt-get update && apt-get install -y \
    unixodbc \
    unixodbc-dev \
    curl \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

# Add Microsoft's repository and install ODBC Driver for SQL Server
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql17 \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies, including Jupyter Notebook
RUN pip install --no-cache-dir \
    duckdb \
    pyodbc \
    minio \
    pandas \
    sqlalchemy \
    jupyter \
    trino

# Expose the port for Jupyter Notebook
EXPOSE 8888

# Set the default command to start Jupyter Notebook
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]