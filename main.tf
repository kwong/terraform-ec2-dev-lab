# root/main.tf

module "compute" {
  source           = "./compute"
  instance_type    = "t2.micro"
  vol_size         = "10"
  key_name         = "ec2-key"
  public_key_path  = "~/.ssh/ec2.pub"
  private_key_path = "~/.ssh/ec2"
  public_subnet    = module.network.public_subnet
  public_sg        = module.network.public_sg
}

module "network" {
  source          = "./network"
  vpc_cidr        = "10.0.0.0/16"
  public_cidr     = "10.0.1.0/24"
  security_groups = local.security_groups
}
