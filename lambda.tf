resource "aws_lambda_function" "func" {
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  function_name = local.function_name

  runtime = "python3.9"
  handler = "lambda.lambda_handler"
  role    = aws_iam_role.iam_for_lambda.arn

  environment {
    variables = {
      HOSTED_ZONE_ID = data.aws_route53_zone.primary.zone_id
      SERVER_PREFIX  = local.server
      DOMAIN_NAME    = local.domain_name
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda,
    aws_cloudwatch_log_group.lambda_logs
  ]
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda.zip"
  source {
    content  = file("${path.module}/lambda.py")
    filename = "lambda.py"
  }
}
