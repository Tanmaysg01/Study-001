/*
resource "aws_s3_bucket" "bucket" {
  bucket = "lambda-sns-bucket"
}

#resourceblock
resource "aws_iam_role" "test_role" {
  name = "lambda_sns_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_policy" "test_policy" {
  name        = "lambda_sns_policy"
  description = "Policy for Lambda Execution"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "s3:*",
          "sns:*",
          "lambda:*",
          "states:*"
          ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = aws_iam_policy.test_policy.arn
  role       = aws_iam_role.test_role.name
}

 data "archive_file" "lambdasns" {
  type        = "zip"
  source_file = "lambdasns.py"
  output_path = "Outputs/lambdasns.zip"
}


resource "aws_lambda_function" "test_lambda" {
  filename      = "Outputs/lambdasns.zip"
  function_name = "lambda_sns"
  role          = aws_iam_role.test_role.arn
  handler       = "lambdasns.notification"

  runtime = "python3.8"

  environment  {
  variables = {
    SNS_TOPIC_ARN = aws_sns_topic.topic.arn,
  }
  }
  depends_on = [aws_sns_topic.topic]

}

# Adding S3 bucket as trigger to my lambda and giving the permissions
  resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  bucket = "lambda-sns-bucket"
  lambda_function {
    lambda_function_arn = aws_lambda_function.test_lambda.arn
    events              = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]

  }
}
  resource "aws_lambda_permission" "test" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${aws_s3_bucket.bucket.id}"
}

*/