locals {
  prefix = "${var.author}-${var.environment}"
  tag = {
    Project     = var.project
    Environment = var.environment
    Author      = var.author
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-24.04-amd64-server-*"]
  }
}

resource "aws_instance" "jeremie-webserver" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  tags = local.tag
  associate_public_ip_address = true
#   vpc_security_group_ids = var.vpc_security_group_ids

  lifecycle {
    create_before_destroy = true
    prevent_destroy = false
  }

}
