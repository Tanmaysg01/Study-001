  #resorce for role
  resource "aws_iam_role" "stepfn_role" {
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
  name        = "step_execution_policy"
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
  

resource "aws_sfn_state_machine" "sfn_state_machine"{
  name     = "my-state-machine"
  role_arn = "arn:aws:iam::446611234961:role/service-role/StepFunctions-MyStateMachine-bcnxrxq46-role-bfltkcj7f"



  definition = <<EOF
{
  "Comment": "A Hello World example of the Amazon States Language using an AWS Lambda Function",
  "StartAt": "HelloWorld",
  "States": {
    "HelloWorld": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.test_lambda.arn}",
      "End": true
    }
  }
}
EOF
}
