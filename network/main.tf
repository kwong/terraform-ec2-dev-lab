# network/main.tf

data "aws_availability_zones" "available" {}

# VPC
resource "aws_vpc" "lab_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true


  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "lab_vpc"
  }
}

resource "aws_subnet" "lab_public_subnet" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = var.public_cidr
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "lab_public_subnet"
  }
}

# Internet gateway
resource "aws_internet_gateway" "lab_internet_gateway" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = {
    Name = "lab_igw"
  }
}

# Route table config
resource "aws_default_route_table" "lab_public_rt" {
  default_route_table_id = aws_vpc.lab_vpc.default_route_table_id

  tags = {
    Name = "lab_public_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_default_route_table.lab_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.lab_internet_gateway.id
}

# Security group
resource "aws_security_group" "lab_sg" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.lab_vpc.id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
