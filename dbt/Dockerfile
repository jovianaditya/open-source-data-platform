# Use a lightweight Python base image (already includes Python)
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Install git and clean up apt cache in the same layer
RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    rm -rf /var/lib/apt/lists/*

# Install dbt-core and dbt-trino
RUN pip install --upgrade pip && pip install dbt-core dbt-trino

# Set the default command to run when the container starts
CMD ["dbt"]