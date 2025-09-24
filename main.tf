provider "aws" {
  region = var.region
}

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
      Name        = "web-server-${terraform.workspace}"
      Environment = terraform.workspace
    }
}

