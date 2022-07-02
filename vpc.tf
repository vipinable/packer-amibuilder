terraform {
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 4.19.0"
    }
  }
}
resource "aws_vpc" "packer" {
  cidr_block       = "172.17.17.0/24"
  instance_tenancy = "default"
  tags = {
    Name = "packer"
  }
}