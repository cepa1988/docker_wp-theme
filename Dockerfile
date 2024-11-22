# Base WordPress image
FROM wordpress:php8.0-apache

# Update and install dependencies
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    rsync \
    unzip \
    default-mysql-client \ 
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Verify wp-cli installation
RUN wp --info

# Copy custom entrypoint script
COPY ./scripts/entrypoint.sh /usr/local/bin/scripts/entrypoint.sh

# Ensure the entrypoint script has executable permissions
RUN chmod +x /usr/local/bin/scripts/entrypoint.sh

# Copy db-init folder containing import-db.sh to the container's init directory
COPY ./db-init /docker-entrypoint-initdb.d/

# Ensure the import-db.sh script has executable permissions
RUN chmod +x /docker-entrypoint-initdb.d/import-db.sh

# Expose WordPress port
EXPOSE 80

# Default entrypoint
ENTRYPOINT ["/usr/local/bin/scripts/entrypoint.sh"]
