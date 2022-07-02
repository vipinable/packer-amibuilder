terraform {
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 4.19.0"
    }
  }
}

#-------VPC------------------
resource "aws_vpc" "vpc" {
  cidr_block           = "172.17.17.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "packer-vpc"
  }
}

#Availability zones

data "aws_availability_zones" "available" {
  state = "available"
}

#Internet Gateway

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw"
  }
}

# Route Tables

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

#Subnets
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = 172.17.17.0/25
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "public_subnet"
  }
}

# Subnet Association

resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
  