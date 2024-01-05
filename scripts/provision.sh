#!/bin/bash
# NOTE: script is designed to be run from the root of the project

# Get environment variables from .env file
source .env

# Make contatenates list of docker-compose files
compose_files=""
echo -e "Adding $( ls docker-compose.*.yml | wc -l | tr -d '[:space:]' ) docker compose files to .env:"
for file in $(ls docker-compose.*.yml); do
    echo "  - $file"
    compose_files+="$file:"
done

# Remove trailing colon from compose_files by removing last character in the string using sed
compose_files=$(echo $compose_files | sed 's/.$//')

# Replace COMPOSE_FILE line in .env file
sed -iE "s/COMPOSE_FILE=.*/COMPOSE_FILE=$compose_files/" './.env'

# Send locally checked out version to remote
echo -e "\nSending local version to remote $SSH_USER@$SERVER_IP_OR_DOMAIN:$SSH_PORT"
rsync -avzq ./ -e "ssh -p $SSH_PORT" $SSH_USER@$SERVER_IP_OR_DOMAIN:~/sendy/
echo -e "Transfer complete!\n"

# Helpful message
echo "ℹ️  On the remote machine you should run:"
echo -e "cd ~/sendy && bash scripts/install-docker.sh && bash scripts/start-stack.sh\n"
read -p "Press enter to SSH into the machine..."

# SSH into the machine
ssh -p $SSH_PORT $SSH_USER@$SERVER_IP_OR_DOMAIN