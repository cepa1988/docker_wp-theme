#!/bin/bash

set -e

# Define backup file location
BACKUP_FILE="./db-backups/backup.sql"

if [ -f "$BACKUP_FILE" ]; then
  echo "Found backup file: $BACKUP_FILE. Importing..."
  mysql -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" < "$BACKUP_FILE"
  echo "Database import completed successfully."
else
  echo "No backup file found at $BACKUP_FILE. Skipping import."
fi
