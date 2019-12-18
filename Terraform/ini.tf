# Terraform HCL
# Test Create EC2 instance via Terraform
provider "aws" {
  region = "ap-northeast-2"
  shared_credentials_file = "~/.aws/credentials"
  profile = "default"
}

resource "aws_instance" "ubuntu" {
  ami           = "ami-00379ec40a3e30f87"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloTerraform"
  }
}