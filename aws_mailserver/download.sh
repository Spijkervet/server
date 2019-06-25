curl https://raw.githubusercontent.com/hardware/mailserver/master/docker-compose.sample.yml -o files/docker-compose.yml \
&& curl https://raw.githubusercontent.com/hardware/mailserver/master/sample.env -o config/environment \
&& curl https://raw.githubusercontent.com/hardware/mailserver/master/traefik.sample.toml -o config/traefik.toml
