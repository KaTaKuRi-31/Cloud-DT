terraform {
  cloud {
    organization = "CloudDT"

    workspaces {
      name = "Cloud-DT"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_security_group" "example" {
  name        = "dt-security-group"
  description = "DT security groups"
  vpc_id      = "vpc-06ddd4af58c50d08f"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dt-security-group"
  }
}

data "aws_ami" "ecs_optimized_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.202*-x86_64-ebs"]
  }
}

resource "aws_instance" "ecs_instance" {
  ami           = data.aws_ami.ecs_optimized_ami.id
  instance_type = "t2.micro"

  tags = {
    Name = "DT-EC2"
  }
}