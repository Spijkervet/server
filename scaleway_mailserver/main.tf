data "template_file" "env" {
  template = "${file("config/environment")}"
  vars = {
    mailserver_domain = "${var.mailserver_domain}"
    mailserver_db_password = "${var.mailserver_db_password}"
    rspamd_password = "${var.rspamd_password}"
  }
}

data "template_file" "traefik" {
  template = "${file("config/traefik.toml")}"
  vars = {
    mailserver_domain = "${var.mailserver_domain}"
    traefik_email = "${var.traefik_email}"
  }
}

data "template_file" "daemon" {
  template = "${file("config/daemon.json")}"
  vars = {}
}

data "scaleway_image" "ubuntu-mini" {
  architecture = "x86_64"
  name         = "Ubuntu Bionic"
}


resource "scaleway_server" "mailserver" {
  image               = data.scaleway_image.ubuntu-mini.id
  type                = var.type
  name                = "mailserver"
  security_group      = scaleway_security_group.allowall.id
  dynamic_ip_required = true

  connection {
    host        = scaleway_server.mailserver.public_ip
    type        = "ssh"
    user        = "root"
    private_key = file("~/.ssh/id_rsa")
    timeout     = "1m"
  }

  provisioner "file" {
    source      = "files"
    destination = "~/files"
  }
  
  provisioner "file" {
    source      = "scripts/provision.sh"
    destination = "~/provision.sh"
  }

  provisioner "file" {
    content     = "${data.template_file.env.rendered}"
    destination = "~/files/.env"
  }

  provisioner "file" {
    content     = "${data.template_file.traefik.rendered}"
    destination = "~/files/traefik.toml"
  }

  provisioner "file" {
    content     = "${data.template_file.daemon.rendered}"
    destination = "~/files/daemon.json"
  }

  provisioner "remote-exec" {
        inline = [
            "chmod +x ~/provision.sh",
            "~/provision.sh",
        ]
  }
}

resource "scaleway_security_group" "allowall" {
  name        = "mail-server-allowall"
  description = "allow all traffic"
}

resource "scaleway_security_group_rule" "tcp_inbound" {
  security_group = scaleway_security_group.allowall.id
  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
}

resource "scaleway_security_group_rule" "tcp_outbound" {
  security_group = scaleway_security_group.allowall.id
  action    = "accept"
  direction = "outbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
}

resource "scaleway_security_group_rule" "udp_outbound" {
  security_group = scaleway_security_group.allowall.id
  action    = "accept"
  direction = "outbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "UDP"
}


output "mail-url" {
  value = ["https://${scaleway_server.mailserver.public_ip}"]
}
