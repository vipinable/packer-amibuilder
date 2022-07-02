terraform {
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 4.19.0"
    }
  }
}

module "vpc" {
  source = "./module/vpc"
  cidrs = "172.17.17.0/24"
}
  