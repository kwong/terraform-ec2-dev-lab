data "aws_ami" "server_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

resource "aws_key_pair" "keypair" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "lab" {
  instance_type = var.instance_type
  ami           = data.aws_ami.server_ami.id

  key_name               = aws_key_pair.keypair.id
  vpc_security_group_ids = [var.public_sg]
  subnet_id              = var.public_subnet

  root_block_device {
    volume_size = var.vol_size
  }

  tags = {
    Name = "lab"
  }
}
