provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}

variable "cloudflare_email" {}

variable "cloudflare_token" {}

variable "cloudflare_zone" {}

resource "cloudflare_record" "aws" {
  domain = "${var.cloudflare_zone}"
  name   = "aws"
  value  = "${aws_instance.instance.public_ip}"
  type   = "A"
  ttl    = 120
}

resource "cloudflare_record" "mail" {
  domain = "${var.cloudflare_zone}"
  name   = "mail"
  value  = "${aws_instance.instance.public_ip}"
  type   = "A"
  ttl    = 120 
}

resource "cloudflare_record" "mx" {
  domain = "${var.cloudflare_zone}"
  name   = "@" 
  value  = "mail.${var.mailserver_domain}"
  type   = "MX"
  ttl    = 120 
}

resource "cloudflare_record" "spam" {
  domain = "${var.cloudflare_zone}"
  name   = "spam" 
  value  = "mail.${var.mailserver_domain}"
  type   = "CNAME"
  ttl    = 120 
}

resource "cloudflare_record" "webmail" {
  domain = "${var.cloudflare_zone}"
  name   = "webmail" 
  value  = "mail.${var.mailserver_domain}"
  type   = "CNAME"
  ttl    = 120 
}

resource "cloudflare_record" "postfixadmin" {
  domain = "${var.cloudflare_zone}"
  name   = "postfixadmin" 
  value  = "mail.${var.mailserver_domain}"
  type   = "CNAME"
  ttl    = 120 
}

resource "cloudflare_record" "spf1" {
  domain = "${var.cloudflare_zone}"
  name   = "@" 
  value  = "v=spf1 a mx ip4:SERVER_IPV4 ~all" 
  type   = "TXT"
  ttl    = 120 
}

resource "cloudflare_record" "_dmarc" {
  domain = "${var.cloudflare_zone}"
  name   = "_dmarc" 
  value = "v=DMARC1; p=reject; rua=mailto:postmaster@${var.mailserver_domain}; ruf=mailto:admin@${var.mailserver_domain}; fo=0; adkim=s; aspf=s; pct=100; rf=afrf; sp=reject"
  type   = "TXT"
  ttl    = 120 
}

resource "cloudflare_record" "domainkey" {
  domain = "${var.cloudflare_zone}"
  name   = "mail._domainkey" 
  value = "v=DKIM1; k=rsa; p=replace_me"
  type   = "TXT"
  ttl    = 120 
}



