
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
          Action = "states:*",
          Resource = "*"
      }
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
  handler       = "lambda.hello"

  #source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.7"

  }
  # Creating s3 resource for invoking to lambda function
resource "aws_s3_bucket" "bucket2" {
  bucket = "s3lambda2024"
}

# Adding S3 bucket as trigger to my lambda and giving the permissions
resource "aws_s3_bucket_notification" "s3trigger" {
  bucket = aws_s3_bucket.bucket2.id

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
  source_arn    = "arn:aws:s3:::${aws_s3_bucket.bucket2.id}"
}

  #resorce for role
/*resource "aws_iam_role" "stepfn_role" {
  name = "step_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
  
    ]
  })
  }
  
  #resource block for policy
resource "aws_iam_policy" "stepfn_policy" {
  name        = "step_execution_policy1"
  path        = "/"
  description = "policy for step function"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lambda:*",
          "states:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "step-attach" {
  role       = aws_iam_role.stepfn_role.name
  policy_arn = aws_iam_policy.stepfn_policy.arn
}

data "aws_lambda_function" "existing" {
  function_name = aws_lambda_function.test_lambda.function_name
}*/
  

/*resource "aws_sfn_state_machine" "sfn_state_machine"{
  name     = "state-machine-project"
  role_arn = "arn:aws:iam::446611234961:role/service-role/StepFunctions-MyStateMachine-bcnxrxq46-role-bfltkcj7f"


  definition = <<EOF
{
  "Comment": "A Hello World example of the Amazon States Language using an AWS Lambda Function",
  "StartAt": "InvokeLambda1",
  "States": {
    "InvokeLambda1": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.test_lambda.arn}",
      "Next": "InvokeLambda2"
    },
    "InvokeLambda2": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.test_lambda1.arn}",
      "End": true
    }
  }  
}
EOF
}*/



