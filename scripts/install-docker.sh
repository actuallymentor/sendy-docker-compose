#!/bin/bash
# Exit if docker is intalled
if which docker > /dev/null 2>&1; then
    echo "✅ Docker is already installed"
    docker --version
    echo "If you suspect that docker is not installed correctly, you can run the following command to uninstall it:"
    echo -e "apt purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin\n"
    exit 0
fi

# As per https://docs.docker.com/engine/install/ubuntu/#set-up-the-repository

# Set up repository
echo -e "\n\nSetting up dependencies to install docker repository keys\n\n"
sudo apt update
sudo apt -y install ca-certificates curl gnupg

echo -e "\n\nSetting up docker repository keys\n\n"
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install
echo -e "\n\nInstalling docker\n\n"
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add the current user to docker for rootless docker running
if [ -z "$USER" ]; then
    USER=$(whoami)
fi
sudo groupadd docker || echo "Docker group already exists, proceeding"
sudo usermod -aG docker $USER
newgrp docker

# Start docker daemon
echo -e "\nStarting docker daemon\n"
sudo service docker start
sudo service docker status