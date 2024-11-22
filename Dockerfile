# Base WordPress image
FROM wordpress:php8.0-apache

# Update and install dependencies
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    rsync \
    unzip \
    default-mysql-client \
    npm \
    gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
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

# Set working directory for theme development
WORKDIR /var/www/html/wp-content/themes/custom-theme

# Copy package.json and webpack files for build setup
COPY ./wp-content/themes/custom-theme/package.json ./
COPY ./wp-content/themes/custom-theme/webpack.config.js ./
COPY ./wp-content/themes/custom-theme/tailwind.config.js ./

# Install Node.js dependencies
RUN npm install

# Expose WordPress port
EXPOSE 80

# Default entrypoint
ENTRYPOINT ["/usr/local/bin/scripts/entrypoint.sh"]
