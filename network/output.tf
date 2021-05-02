# network/output.tf

output "public_subnet" {
  value = aws_subnet.lab_public_subnet.id
}

output "public_sg" {
  value = aws_security_group.lab_sg["public"].id
}
