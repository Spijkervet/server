provider "cloudflare" {
  email = var.cloudflare_email
  token = var.cloudflare_token
}

variable "cloudflare_email" {
}

variable "cloudflare_token" {
}

variable "cloudflare_zone" {
}

resource "cloudflare_record" "aws" {
  domain = var.cloudflare_zone
  name   = "aws"
  value  = scaleway_server.portainer.public_ip
  type   = "A"
  ttl    = 3600
}

