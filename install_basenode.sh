#!/bin/bash
set -e

# This script is used to run a Base blockchain node

installDocker(){
    sudo apt-get update
    sudo apt-get install ca-certificates curl gnupg lsb-release git -y

    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

    sudo curl -L "https://github.com/docker/compose/releases/download/v2.12.2/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    sudo docker run hello-world

}

sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release git -y

echo "Checking docker compose version..."
#COMPOSEV=$(docker compose version)
COMPOSEV2PRESENT=false

if ! [[ -x "$(command -v docker-compose)" ]]; then
  echo 'Error: docker-compose is not installed. Checking v2' >&2
fi

if ! [[ -x "$(command -v docker compose)" ]]; then
  echo "Docker compose Version 2 is not installed either..installing.."
  installDocker
else
  echo "Found docker compose version 2"
  COMPOSEV2PRESENT=true
fi


if ! [[ -x "$(command -v git)" ]]; then
  echo 'Error: git is not installed. installing...' >&2
    sudo apt install git -y
fi


echo "Cloning node repo..."
git clone https://github.com/base-org/node.git

echo "Building node binary..."
cd node

sudo systemctl enable docker
sudo systemctl start docker

sudo docker compose up -d 

echo "Node is running in the background. To view logs, run ' cd node && sudo docker compose logs -f'"
echo "To stop the node, run 'sudo docker compose down'"
echo "To start the node again, run 'sudo docker compose up -d'"
echo "To view the node status, run 'sudo docker compose ps'"