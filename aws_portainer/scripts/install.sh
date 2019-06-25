#!/bin/bash
set -x
apt-get update

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

systemctl start docker

# docker run --name wordpress --restart always -p 80:80 -d wordpress
docker volume create portainer_data
docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer -H unix:///var/run/docker.sock
