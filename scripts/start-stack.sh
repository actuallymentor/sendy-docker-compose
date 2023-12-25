#!/bin/bash
# NOTE: script is designed to be run from the root of the project

# Shutdown any existing docker stack
cd ~/sendy
docker compose down --remove-orphans

# Get environment variables from .env file
source .env

# Apply configs to swag
bash scripts/apply-configs.sh

echo -e "\n\nStarting sendy docker stack\n\n"
docker compose pull
docker compose up -d --build
# yes | docker system prune -a | grep 'Total reclaimed space'
docker compose ps
echo -e "\n\n✅ Docker stack started\n\n"
echo -e "You can track the status of the docker stack by running: \ndocker compose logs -f"
