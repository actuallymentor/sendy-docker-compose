# Use the official PHP image with Apache
FROM php:8.3-apache

# Get the license env var
ARG SENDY_LICENSE_KEY

# Set php.ini version
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN echo "error_log = /var/log/apache2/php.log" >> "$PHP_INI_DIR/php.ini"

# Set www-data permissions to resolve file permission issues
ARG USER_UID=1000
ARG USER_GID=1000
RUN usermod -u $USER_UID www-data \
    && groupmod -g $USER_GID www-data

# Install dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    unzip \
    rsync \
    libcurl4-openssl-dev \
    zlib1g-dev \
    libpng-dev \
    libxslt-dev

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install necessary PHP extensions for Sendy
# Note: this is undocumented, I had to conbine `php -m` on my previously working server and trial/error for this list
RUN docker-php-ext-install \
    calendar \
    curl \
    exif \
    gd \
    gettext \
    mysqli \
    pdo_mysql

# Force this dockerfile to always run the step below, so that every restart grabs the latest sendy version
ARG CACHEBUST=1

# Install sendy based on the license key found in the .env, this is done by downloading and unpacking https://sendy.co/download/?license=
RUN echo "Downloading https://sendy.co/download/?license=${SENDY_LICENSE_KEY}" \
    && curl -L -o sendy.zip https://sendy.co/download/?license=${SENDY_LICENSE_KEY} \
    && unzip sendy.zip -d /tmp \
    && rm /tmp/sendy/includes/config.php \
    && rm -rf /tmp/sendy/uploads \
    && rsync -av /tmp/sendy/ /var/www/html/ \
    && rm sendy.zip \
    && rm -rf /tmp/sendy \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    || echo "🚨 Something went wrong with the sendy download, if this is the first time you start this docker stack, this means sendy will not work. If this is not the first time, this means sendy did not auto-update. Please check if the link is live: https://sendy.co/download/?license=${SENDY_LICENSE_KEY}"

# Set up crontab for background actions
RUN apt-get install -y cron
COPY ./sendy/sendy_cronjobs /etc/cron.d/sendy_cronjobs
RUN chmod 0644 /etc/cron.d/sendy_cronjobs
RUN crontab /etc/cron.d/sendy_cronjobs

# HEALTHCHECK instruction to check the health of the container
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1