#!/bin/bash
# NOTE: script is designed to be run from the root of the project

# Get environment variables from .env file
source .env

# Overwrite the subdomain in the config with the configures subdomain in the .env
sed -i "s/SENDY_SUBDOMAIN/$SENDY_SUBDOMAIN/g" ./swag/nginx/site-confs/default.conf
sed -i "s/SENDY_MYSQL_PASSWORD/$SENDY_MYSQL_PASSWORD/g" ./sendy/config.php
sed -i "s/PROXY_SERVER_DOMAIN/$PROXY_SERVER_DOMAIN/g" ./sendy/config.php
sed -i "s/SENDY_SUBDOMAIN/$SENDY_SUBDOMAIN/g" ./sendy/config.php
