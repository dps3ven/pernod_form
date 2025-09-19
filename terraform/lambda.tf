data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda_handler.py"
  output_path = "${path.module}/residency_checker.zip"
}


resource "aws_lambda_function" "lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  description   = "5069 Pernod"
  filename      = "residency_checker.zip"
  function_name = "${local.property}_residency_form"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_handler.lambda_handler"

  #source_code_hash = data.archive_file.lambda.output_base64sha256
  timeout = 600
  publish = false
  runtime = var.runtime

  # environment {
  #   variables = {
  #     LOG_LEVEL = "DEBUG"
  #   }
  # }

}
