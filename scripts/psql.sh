#!/bin/bash
if [ -z "$1" ]; then
    echo "Please pass an argument to this script"
    exit 1
fi
DB_NAME=$1

# DB connection
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_HOST=localhost
POSTGRES_PORT=5432

echo "Creating database $DB_NAME"

# Idempotent CREATE DATABASE
echo "
    SELECT 'CREATE DATABASE $DB_NAME'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '$DB_NAME')\gexec
" | psql postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT} 

# Handle errors
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then
    echo "Encountered an unexpected error: $EXIT_CODE"
    exit $EXIT_CODE
else 
    echo "Database $DB_NAME created successfully"
fi
