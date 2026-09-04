terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "web_sg" {
  name        = "myapp-dev-web-sg"
  description = "Security group for Spring Boot Docker application"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow SSH traffic for server management"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow inbound HTTP traffic on Spring Boot default port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "myapp-dev-web-sg"
    Environment = "dev"
    Project     = "spring-boot-docker-deployment"
    ManagedBy   = "Terraform"
  }
}

output "security_group_id" {
  value       = aws_security_group.web_sg.id
  description = "The ID of the newly created security group"
}

output "application_access_instructions" {
  value       = "Access your Spring Boot application at: http://<EC2_PUBLIC_IP>:8080"
  description = "URL format to access the running container application"
}
