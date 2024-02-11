 
resource "aws_s3_bucket" "example_bucket" {
  bucket = "bucket2024tsg"
}
 
resource "aws_iam_role" "lambda_execution_role11" {
  name = "lambda_execution_role11"
 
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
"Service": "lambda.amazonaws.com"
      }
    }
  ]
}
EOF
}
 
resource "aws_iam_role_policy_attachment" "lambda_execution_role_policy2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
role = aws_iam_role.lambda_execution_role11.name
}
 
resource "aws_lambda_function" "hello_world_lambda1" {
filename = "outputs/lambda_function1.zip"  # Specify the path to your Python Lambda function code
  function_name = "helloWorldLambda1"
  role          = aws_iam_role.lambda_execution_role11.arn
  handler       = "your_lambda_function.handler"
  runtime       = "python3.8"
}
