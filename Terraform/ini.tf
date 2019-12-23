# Terraform HCL
# Test Create EC2 instance via Terraform
# provider "aws" {
#   region = "ap-northeast-2"
#   shared_credentials_file = "~/.aws/credentials"
#   profile = "default"
# }

# resource "aws_instance" "ubuntu" {
#   ami           = "ami-00379ec40a3e30f87"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "HelloTerraform"
#   }
# }


# resource "aws_iam_role" "iam_for_lambda" {
#   name = "iam_for_lambda"
#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }

provider "aws" {
  region = "ap-northeast-2"
  shared_credentials_file = "~/.aws/credentials"
  profile = "default"
}
data "archive_file" "lambda_zip" {
    type          = "zip"
    source_file   = "../index.js"
    output_path   = "lambda_function.zip"
}

resource "aws_lambda_function" "test_lambda" {
  filename         = "lambda_function.zip"
  function_name    = "test_lambda"
  role             = "${aws_iam_role.iam_for_lambda_tf.arn}"
  handler          = "index.handler"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  runtime          = "nodejs10.x"
}

resource "aws_iam_role" "iam_for_lambda_tf" {
  name = "iam_for_lambda_tf"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}