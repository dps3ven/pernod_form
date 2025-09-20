data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/package"
  output_path = "${path.module}/residency_checker.zip"
  depends_on  = [null_resource.pip_install]
}

resource "null_resource" "pip_install" {
  provisioner "local-exec" {
    command = <<EOF
rm -rf ${path.module}/package
mkdir -p ${path.module}/package
cp ${path.module}/lambda_handler.py ${path.module}/package/
python3 -m pip install pyyaml -t ${path.module}/package/
EOF
  }
  triggers = {
    requirements = filemd5("${path.module}/requirements.txt")
    handler      = filemd5("${path.module}/lambda_handler.py")
  }
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

resource "aws_lambda_function" "lambda_dev" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  description   = "5069 Pernod"
  filename      = "residency_checker.zip"
  function_name = "${local.property}_residency_form_dev"
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

