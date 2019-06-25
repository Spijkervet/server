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

resource "aws_instance" "instance" {
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "t2.micro"
  key_name        = "${var.ami_key_pair_name}"

  vpc_security_group_ids = [
    "${aws_security_group.instance.id}"
  ]

  tags = {
    Name = "test-instance"
  }


  connection {
    host = "${aws_instance.instance.public_ip}"
    type     = "ssh"
    user     = "ubuntu"
    private_key = "${file("~/.ssh/terraform.pem")}"
    timeout = "2m"
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


  provisioner "remote-exec" {
        inline = [
            "chmod +x ~/provision.sh",
            "~/provision.sh",
        ]
  }

}

resource "aws_security_group" "instance" {
  name = "mailserver"

  ingress {
    from_port = 25 
    to_port = 25 
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80 
    to_port = 80 
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443 
    to_port = 443 
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 110
    to_port = 110 
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 143 
    to_port = 143 
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 465 
    to_port = 465 
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 587 
    to_port = 587 
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 993 
    to_port = 993
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 995 
    to_port = 995
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 4190 
    to_port = 4190 
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0 
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
