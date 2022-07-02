terraform {
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 4.19.0"
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" { state = "available" }
data "aws_region" "current" {}

resource "aws_default_vpc" "default" {
  cidr_block       = "172.17.17.0/24"
  instance_tenancy = "default"
  force_destroy = true
  tags = {
    Name = "VPC for packer"
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
  force_destroy = true

  tags = {
    Name = "Subnet for packer"
  }
}