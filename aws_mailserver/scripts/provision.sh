#!/bin/bash -x
sudo apt-get update

# docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo systemctl start docker

# docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# mailserver
sudo docker network create http_network
sudo docker network create mail_network
sudo mkdir -p /mnt/docker/traefik/acme

cd /mnt/docker
sudo mv ~/files/docker-compose.yml docker-compose.yml
sudo mv ~/files/.env .env
sudo mv ~/files/traefik.toml traefik/traefik.toml
sudo mv ~/files/daemon.json /etc/docker/daemon.json
sudo service docker restart
source .env
sudo docker-compose up -d
