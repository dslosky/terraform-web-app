### Lambda Layer
# data "archive_file" "lambda_layer_zip_file" {
#   type        = "zip"
#   source_dir = "${path.module}/python"
#   output_path = "${path.module}/packages/python.zip"
# }

# Lambda Layer
resource "aws_lambda_layer_version" "modules_layer" {
  filename            = "${path.module}/packages/python-modules.zip"
  layer_name          = "${module.common.app_name}-layer"
  source_code_hash    = filebase64sha256("${path.module}/packages/python-modules.zip")
  compatible_runtimes = ["python3.9"]
}
