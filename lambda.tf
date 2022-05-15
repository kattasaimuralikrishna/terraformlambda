resource "aws_lambda_function" "Lambda" {

  function_name = "Lambda"
  s3_bucket     = "mylambdaterra"
  s3_key        = "main.zip"
  role          = aws_iam_role.forlambda.arn
  handler       = "main.lambda_handler"
  runtime       = "python3.9"
}