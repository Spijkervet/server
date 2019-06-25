data "template_file" "user_data" {
  template = file("scripts/install.sh")
}

data "scaleway_image" "ubuntu-mini" {
  architecture = "x86_64"
  name         = "Ubuntu Bionic"
}

variable "scw_org" {
}

variable "scw_token" {
}

variable "region" {
  default = "ams1"
}

variable "type" {
  default = "START1-XS"
}

resource "scaleway_server" "portainer" {
  image               = data.scaleway_image.ubuntu-mini.id
  type                = var.type
  name                = "portainer"
  security_group      = scaleway_security_group.allowall.id
  dynamic_ip_required = true

  connection {
    host        = scaleway_server.portainer.public_ip
    type        = "ssh"
    user        = "root"
    private_key = file("~/.ssh/id_rsa")
    timeout     = "1m"
  }

  provisioner "file" {
    source      = "scripts/install.sh" 
    destination = "/root/install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/install.sh",
      "/root/install.sh",
    ]
  }
}

resource "scaleway_security_group" "allowall" {
  name        = "portainer-server-allowall"
  description = "allow all traffic"
}

resource "scaleway_security_group_rule" "all_accept" {
  security_group = scaleway_security_group.allowall.id

  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
}

output "portainer-url" {
  value = ["https://${scaleway_server.portainer.public_ip}"]
}

