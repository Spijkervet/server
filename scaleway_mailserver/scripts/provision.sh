#!/bin/bash -x
apt-get update

# docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
systemctl start docker

# docker compose
curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# mailserver
docker network create http_network
docker network create mail_network
mkdir -p /mnt/docker/traefik/acme

cd /mnt/docker
mv ~/files/docker-compose.yml docker-compose.yml
mv ~/files/.env .env
mv ~/files/traefik.toml traefik/traefik.toml
mv ~/files/daemon.json /etc/docker/daemon.json
service docker restart
source .env
docker-compose up -d
