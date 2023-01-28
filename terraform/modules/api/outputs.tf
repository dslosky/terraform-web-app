output "function_url" {
  value = aws_lambda_function_url.fast_api.function_url
}

output "lambda_arn" {
  value = aws_lambda_function.fast_api.arn
}
