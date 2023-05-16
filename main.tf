provider "aws" {
  access_key = "AKIA5QN6KP5J33YEFT56"
  secret_key = "my2E90J32+Ad9IJtSbBpNIf1iPzTKp/EhPosRsHs"
  region     = "us-east-1"
}

resource "aws_vpc" "example" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_subnet" "example" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = var.aws_availability_zone
}

resource "aws_security_group" "example" {
  name        = "example-security-group"
  description = "Example Security Group"
  vpc_id      = aws_vpc.example.id

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

resource "aws_instance" "prometheus_server" {
  ami                    = "ami-0d86c69530d0a048e"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.example.id
  vpc_security_group_ids = [aws_security_group.example.id]
  key_name               = "Wwiktor"

  user_data = <<-EOF
    #!/bin/bash
    # Команди для встановлення Prometheus Stack, Node Exporter та Cadvizor Exporter
    # ...
    EOF

  tags = {
    Name = "prometheus-server"
  }
}

resource "aws_instance" "second_server" {
  ami                    = "ami-0d86c69530d0a048e"
  instance_type          = "t2.micro"
  key_name               = "Wwiktor"

  tags = {
    Name = "SecondServer"
  }
}




