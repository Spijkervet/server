# Scaleway server (START1-XS) with Rancher installed

To automatically setup and provision the server:
```
terraform init
terraform apply
```

Set the following environment variables:

```
TF_VAR_scw_org
TF_VAR_scw_token
TF_VAR_cloudflare_token
TF_VAR_cloudflare_email
TF_VAR_cloudflare_zone
TF_VAR_rancher_server_url
```
