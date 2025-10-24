# main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "us-east-1"
}

# Security group
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg_using_terraform"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# EC2 instance
resource "aws_instance" "app_server" {
  ami           = "ami-0360c520857e3138f"  # Ubuntu 22.04 LTS in us-east-1  
  instance_type = "t3.micro"               # or "t3.micro" for Free Tier
  key_name      = var.key_name
  security_groups = [aws_security_group.ec2_sg.name]

  monitoring = true   # Enables basic CloudWatch monitoring

  root_block_device {
    volume_type = "gp2"   # General Purpose SSD
    volume_size = 8       # 8 GB
    delete_on_termination = true
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              
              echo "${var.ghcr_pat}" | docker login ghcr.io -u falgunitagadkar --password-stdin
              docker pull ghcr.io/falgunitagadkar/my-node-app:latest
              docker run -d -p 80:8080 ghcr.io/falgunitagadkar/my-node-app:latest
              EOF

  tags = {
    Name = "NodeAppServer"
  }
}
