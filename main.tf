# root/main.tf

module "compute" {
  source          = "./compute"
  instance_type   = "t2.micro"
  vol_size        = "10"
  key_name        = "ec2-key"
  public_key_path = "~/.ssh/ec2.pub"
  public_subnet   = module.network.public_subnet
  public_sg       = module.network.public_sg
}

module "network" {
  source = "./network"
}
