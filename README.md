# terraform-ec2-dev-lab

This repo contains Terraform config files for deploying a simple t2.micro instance on EC2 which I use mostly for testing random stuff.

## How to use

```sh
$ git clone https://github.com/kwong/terraform-ec2-dev-lab.git
$ cd ec2-dev-lab
$ terraform init
$ terraform plan # optional
$ terraform apply --auto-approve
```

The public IP of the ec2 instance is generated as an output and can be used to SSH to the instance once the execution is completed.

```sh
$ ssh -i <path_to_private_key> ubuntu@<instance_ip>
```

To destroy the created infrastructure, simply run `terraform destroy --auto-approve`