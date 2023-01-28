module "common" {
    source = "../common"
}

data "archive_file" "lambda_function_zip_file" {
  type        = "zip"
  source_dir = "${path.module}/src"
  output_path = "${path.module}/packages/lambda.zip"
}

# Role to execute lambda
resource "aws_iam_role" "lambda_function_role" {
  name               = "${module.common.app_name}-lambda-role"
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

resource "aws_lambda_function" "fast_api" {
  function_name    = "${module.common.app_name}-fast-api"
  filename         = data.archive_file.lambda_function_zip_file.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_function_zip_file.output_path)
  handler          = "api.handler"
  runtime          = "python3.9"
  role = aws_iam_role.lambda_function_role.arn

  layers = [aws_lambda_layer_version.modules_layer.arn]
  tags = module.common.common_tags
}

resource "aws_lambda_function_url" "fast_api" {
  function_name      = aws_lambda_function.fast_api.function_name
  authorization_type = "NONE"
}
