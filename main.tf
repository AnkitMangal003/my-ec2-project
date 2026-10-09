terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "ankit-aws-lab-20261010"   # your bucket name from Step 2
    key    = "ec2/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

# Finds the latest Amazon Linux image automatically
data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# The server itself
resource "aws_instance" "my_server" {
  ami           = data.aws_ssm_parameter.ami.value
  instance_type = "t3.micro"

  tags = {
    Name = "my-first-terraform-server"
  }
}

output "server_ip" {
  value = aws_instance.my_server.public_ip
}