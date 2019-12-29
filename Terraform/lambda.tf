provider "aws" {
  region = "ap-northeast-2"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "../index.js"
  output_path = "lambda_function.zip"
}
resource "aws_lambda_function" "example" {

  # The bucket name as created earlier with "aws s3api create-bucket"
  filename      = "lambda_function.zip"
  function_name = "lambda_function"


  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"

  # "main" is the filename within the zip file (main.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "index.handler"
  runtime = "nodejs10.x"

  role = "${aws_iam_role.lambda_exec.arn}"
}

# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec"

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

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
}
output "base_url" {
  value = aws_api_gateway_deployment.example.invoke_url
}