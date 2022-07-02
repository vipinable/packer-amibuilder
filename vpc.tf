resource "aws_vpc" "packer" {
  cidr_block       = "172.17.17.0/24"
  instance_tenancy = "default"
  tags = {
    Name = "packer"
  }
}