data "template_file" "user_data" {
  template = "${file("scripts/install.sh")}"
}

resource "aws_instance" "instance" {
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "t2.micro"
  key_name        = "${var.ami_key_pair_name}"
  user_data = "${data.template_file.user_data.rendered}"

  vpc_security_group_ids = [
    "${aws_security_group.instance.id}"
  ]

  tags = {
    Name = "test-instance"
  }
}

resource "aws_security_group" "instance" {
  name = "allow_all_tcp"
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
