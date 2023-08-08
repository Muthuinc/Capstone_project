
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


# it will take credentials from the jenkins pipeline

provider "aws" {
  region = "ap-south-1"
}


#creating the security group for our dev environment

resource "aws_security_group" "dev" {
  name        = "dev"
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
   ingress {
    description      = "TLS from VPC"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
   ingress {
    description      = "TLS from VPC"
    from_port        = 9090
    to_port          = 9090
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
   ingress {
    description      = "TLS from VPC"
    from_port        = 9115
    to_port          = 9115
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
   ingress {
    description      = "TLS from VPC"
    from_port        = 9100
    to_port          = 9100
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
    Name = "dev_security"
  }
}

resource "aws_instance" "instance1" {
  ami                     = "ami-08e5424edfe926b43"
  instance_type           = "t2.micro"
  key_name                = "Avam"
  associate_public_ip_address = true
  vpc_security_group_ids = [ aws_security_group.dev.id ]
  tags = {
    
    Env = "dev"
  }
}
