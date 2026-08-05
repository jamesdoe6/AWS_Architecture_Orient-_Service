locals {
  prefix = "${var.author}-${var.environment}"
  tags = {
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
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_key_pair" "jeremie-key" {
  key_name   = "${local.prefix}-key"
  public_key = file(var.public_key_path)
}


resource "aws_instance" "jeremie-webserver" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  associate_public_ip_address = true
  tags                        = local.tags
  key_name                    = aws_key_pair.jeremie-key.key_name

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }
}
