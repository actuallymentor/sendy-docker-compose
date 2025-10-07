# Sendy docker provisioning script

The goal of this repository is to automate the setting up of a `docker compose` stack for sendy. 

Advantages of this docker stack:

- [x] Downloads the latest sendy for you
- [x] Configuration is done through a `.env` file and is easy to manage
- [x] Automatically sets up a reverse proxy with (free) TLS certificates
- [x] Allows easy import of your old sendy database (see [database-imports](database-imports/README.md))

## Usage

1. Clone this repository
2. Populate the `.env` file with the required variables, see `.env.example`
3. Run `bash scripts/provision.sh`
    - NOTE: if you changed anything about the sendy `php` settings, you may need to uncomment `--build` in `scripts/start-stack`

I recommend setting up your `A` record to your subdomain and setting `SERVER_IP_OR_DOMAIN` to the live subdomain. The `swag` container needs the domain to resolve to the server ip address to set up the TLS certificates.

Note that the `uploads` folder of sendy is mounted to the host file system for persistence, and so you can easily add and manage files in that folder.

## What does it do?

This script suite:

1. Installs `docker`
2. Starts a `docker compose` sendy stack (apache + mysql)
3. Starts a reverse proxy for sendy

## Requirements

1. You have a domain name
2. You have a server with a public IP address (recommended: Ubuntu 22.04 server with a public IP address, minimum of 1G RAM)
3. You have a subdomain pointing to the server
4. You have a valid sendy license key for your domain

## Extending this docker stack

If you intend to run other services on the same server (for example a URL shortener), you can extend this docker stack by changing two things:

1. Create a new docker compose file in the format `docker-compose.YOUR_SERVICE_NAME.yml`
    - Remember to add the `networks` section to the file, identical to that of the sendy container
2. Create a new proxy config, see `swag/nginx/proxy-confs/example.subdomain.conf.example`
3. Add your subdomains to the `ADDITIONAL_SUBDOMAINS` variable in the `.env` file
