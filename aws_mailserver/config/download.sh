curl https://raw.githubusercontent.com/hardware/mailserver/master/docker-compose.sample.yml -o docker-compose.yml \
&& curl https://raw.githubusercontent.com/hardware/mailserver/master/sample.env -o .env \
&& curl https://raw.githubusercontent.com/hardware/mailserver/master/traefik.sample.toml -o traefik.toml
