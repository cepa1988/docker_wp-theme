#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Wait for the database to be ready
echo "Waiting for the database to be available..."
until mysqladmin ping -h"${WORDPRESS_DB_HOST%:*}" --silent; do
    sleep 2
done

# Check if there's a .sql backup file in /db-backups and import it if found
echo "Checking for database backup..."
BACKUP_FILE="/db-backups/backup.sql"  # Path to the backup file

if [ -f "$BACKUP_FILE" ]; then
    echo "Found backup file: $BACKUP_FILE. Importing database..."
    mysql -h"${WORDPRESS_DB_HOST%:*}" -u"${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" "${WORDPRESS_DB_NAME}" < "$BACKUP_FILE"
    echo "Database import completed successfully."
    IMPORTED_BACKUP=true
else
    echo "No backup file found at $BACKUP_FILE. Skipping database import."
    IMPORTED_BACKUP=false
fi

# Check if WordPress is installed; if not, download and set it up
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "WordPress not found, downloading..."
    wp core download --path=/var/www/html --allow-root

    echo "Configuring WordPress..."
    wp config create \
        --path=/var/www/html \
        --dbname="${WORDPRESS_DB_NAME}" \
        --dbuser="${WORDPRESS_DB_USER}" \
        --dbpass="${WORDPRESS_DB_PASSWORD}" \
        --dbhost="${WORDPRESS_DB_HOST}" \
        --allow-root

    echo "Installing WordPress..."
    wp core install \
        --path=/var/www/html \
        --url="${WORDPRESS_SITE_URL}" \
        --title="${WORDPRESS_SITE_TITLE}" \
        --admin_user="${WORDPRESS_ADMIN_USER}" \
        --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
        --allow-root \
        --skip-email
else
    echo "WordPress installation skipped."
fi

# Configure WordPress for development or production
if [ "$WORDPRESS_ENV" = "development" ]; then
    echo "Setting WordPress environment to development."
    cat <<EOL >> /var/www/html/wp-config.php

// Development environment settings
    define('WP_DEBUG', true);
    define('WP_DEBUG_DISPLAY', true);
    define('WP_DEBUG_LOG', true);
EOL
else
    echo "Setting WordPress environment to production (default)."
fi

# Ensure correct permissions for WordPress
echo "Ensuring correct permissions for WordPress..."
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Start Apache
echo "Starting Apache..."
exec apache2-foreground
