# network/main.tf

data "aws_availability_zones" "available" {}

# VPC
resource "aws_vpc" "lab_vpc" {
  cidr_block           = "10.0.0.0/16"
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
  cidr_block              = "10.0.1.0/24"
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
  name        = "allow_ssh"
  description = "allow ssh"
  vpc_id      = aws_vpc.lab_vpc.id

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
