provider "aws" {
  region = var.region
}

module "vpc" {
  source         = "./vpc"
  name           = "web"
  cidr           = "10.0.0.0/24"
  public_subnet  = "10.0.0.0/25"
  private_subnet = "10.0.0.128/25"
}

resource "aws_instance" "frontend" {
  ami                         = var.ami[var.region]
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = module.vpc.public_subnet_id
  associate_public_ip_address = true

  vpc_security_group_ids = [
    "${aws_security_group.frontend_sg.id}"
  ]
}

resource "aws_instance" "backend" {
  ami                         = var.ami[var.region]
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = module.vpc.private_subnet_id
  associate_public_ip_address = false

  vpc_security_group_ids = [
    "${aws_security_group.backend_sg.id}"
  ]
}

resource "aws_elb" "elb" {
  name            = "web-elb"
  subnets         = ["${module.vpc.public_subnet_id}"]
  security_groups = ["${aws_security_group.elb_inbound_sg.id}"]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  instances = ["${aws_instance.frontend.id}"]
}

resource "aws_security_group" "frontend_sg" {
  name        = "frontend"
  description = "Allow HTTP and SSH access from anywhere"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "backend_sg" {
  name        = "backend"
  description = "Allow HTTP access from frontend"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.frontend_sg.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "web_inbound_sg" {
  name        = "web_inbound"
  description = "Allow HTTP from Anywhere"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "elb_inbound_sg" {
  name        = "elb_inbound"
  description = "Allow HTTP from anywhere"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}