resource "aws_vpc" "tfb" {
  cidr_block           = var.cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name = "${var.name}"
  }
}

resource "aws_internet_gateway" "tfb" {
  vpc_id = aws_vpc.tfb.id

  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.tfb.id

  tags = {
    Name = "${var.name}-public-route-table"
  }
}

resource "aws_route" "internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.tfb.id
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public.id
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.tfb.id
  cidr_block = var.public_subnet

  tags = {
    Name = "${var.name}-public"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.tfb.id
  cidr_block = var.private_subnet

  tags = {
    Name = "${var.name}-private"
  }
}