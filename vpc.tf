terraform {
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 4.19.0"
    }
  }
}

resource "aws_default_vpc" "default" {
  force_destroy = true
  tags = {
    Name = "Default VPC"
  }
}