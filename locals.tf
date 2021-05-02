# root/locals.tf
locals {
  security_groups = {
    public = {
      name        = "public_sg"
      description = "public access security group"
      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
  }
}
