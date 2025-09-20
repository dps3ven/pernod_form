resource "aws_iam_role" "iam_for_lambda" {
  name               = "${local.property}_iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_role" "need_to_standardize_role" {
  name = "processContactFormRequest-role-q734fqc7"
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.residency_checker_api.execution_arn}/*/*"
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "s3_access_policy"
  description = "Policy to allow Lambda to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "arn:aws:s3:::vindot-llc-tenants/*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "attach_policy" {
  name       = "attach_lambda_s3_policy"
  roles      = [aws_iam_role.iam_for_lambda.name]
  policy_arn = aws_iam_policy.s3_access_policy.arn
}
