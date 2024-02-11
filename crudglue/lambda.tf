resource "aws_s3_bucket" "lambdabucket" {
  bucket = "lambdabucketglueprojects"
}

#resourceblock
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"
 
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
resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_execution_policy"
  description = "Policy for Lambda Execution"
 
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
            Effect = "Allow",
            Action = [
                "s3:GetObject",
                "s3:PutObject"
            ],
            Resource = [
                "arn:aws:s3:::aws-glue-*/*",
                "arn:aws:s3:::*/*aws-glue-*/*",
                "arn:aws:s3:::aws-glue-*"
            ]
       },
       {
            Effect = "Allow",
            Action = [
                "tag:GetResources"
            ],
            Resource = [
                "*"
            ]
       },
       {
            Effect = "Allow",
            Action = [
                "s3:CreateBucket"
            ],
            Resource = [
                "arn:aws:s3:::aws-glue-*"
            ]
       },
       {
            Effect = "Allow",
            Action = [
                "logs:GetLogEvents"
            ],
            Resource = [
                "arn:aws:logs:*:*:/aws-glue/*"
            ]
       },
       {
            Effect = "Allow",
            Action = [
                "s3:*",
                "s3-object-lambda:*"
            ],
            Resource = "*"
        },
    ]
  })
}
 
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.lambda_role.name
}
 
 data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda.py"
  output_path = "Outputs/lambda.zip"
}
 
 resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "Outputs/lambda.zip"
  function_name = "lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda.glue"
 
  #source_code_hash = data.archive_file.lambda.output_base64sha256
 
  runtime = "python3.7"
 
  }
   
# # Adding S3 bucket as trigger to my lambda and giving the permissions
# resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
#   bucket = "s3lambda2023"
#   lambda_function {
#     lambda_function_arn = aws_lambda_function.test_lambda.arn
#     events              = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]
 
#   }
# }
#   resource "aws_lambda_permission" "test" {
#   statement_id  = "AllowS3Invoke"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.test_lambda.function_name
#   principal     = "s3.amazonaws.com"
#   source_arn    = "arn:aws:s3:::s3lambda2023"
# }
 
 