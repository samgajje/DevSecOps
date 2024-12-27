terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "aws_region" {
    type = string
}

variable "vpc_id" {
    type = string
}

variable "key_name" {
    type = string
}
# Define variables

variable "test_ip_address" {
  description = "IP address for SSH access"
  type        = string
}

variable "cidr_block" {
    type = string
  
}
# Configure the AWS Provider

provider "aws"{
    region = var.aws_region
}
resource "aws_vpc" "test_vpc"{
    cidr_block = var.cidr_block
    tags = {
        Name = "test_vpc"
    }
}

resource "aws_internet_gateway" "test_igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "test_igw"
  }
}
resource "aws_subnet" "test_subnet"{
    vpc_id = var.vpc_id
    cidr_block = var.cidr_block
    tags = {
        Name = "test_subnet"
    }
}
resource "aws_security_group" "test_sg" {
  name   = "test_sg"
  vpc_id = var.vpc_id
  ingress{
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["${var.test_ip_address}"]
  }
  
}
resource "aws_instance" "test_instance"{
    ami           = "ami-0c44b239cbfafe2f9"
    instance_type = "t3.small"
    key_name = var.key_name
    subnet_id = "aws_subnet.test_subnet.id"
    vpc_security_group_ids = [aws_security_group.test_sg.id ]
    

}

