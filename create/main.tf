terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# if you did aws configure
# it will take credentials from .aws/config file

provider "aws" {
  region = "ap-south-1"
}


# we need to create the instance in the default vpc and subnet. 
# so we don't have to specify any vpc or subnet. 
# terraform will automatically create the instance in the default unless specified

resource "aws_security_group" "prod" {
  name        = "prod"
  description = "Allow TLS inbound traffic"
  vpc_id      = "vpc-0acc23cf8265dbf18"

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["157.51.195.186/32"]
  }
   ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Prod_security"
  }
}

resource "aws_instance" "instance1" {
  ami                     = "ami-08e5424edfe926b43"
  instance_type           = "t2.micro"
  key_name                = "Avam"
  associate_public_ip_address = true
  vpc_security_group_ids = [ aws_security_group.prod.id ]
  tags = {
    Env = "prod"
  }
}