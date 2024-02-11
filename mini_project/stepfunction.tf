  #resorce for role
resource "aws_iam_role" "state_role" {
  name = "step_test_role"

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
resource "aws_iam_policy" "state_policy1" {
  name        = "state_execution_policy"
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

resource "aws_iam_role_policy_attachment" "step-attach1" {
  role       = aws_iam_role.state_role.name
  policy_arn = aws_iam_policy.state_policy1.arn
}
  

resource "aws_sfn_state_machine" "sfn_state_machine1"{
  name     = "my-state-machine"
  role_arn = "arn:aws:iam::446611234961:role/service-role/StepFunctions-MyStateMachine-bcnxrxq46-role-bfltkcj7f"


  definition = <<EOF
{
  "Comment": "A Hello World example of the Amazon States Language using an AWS Lambda Function",
  "StartAt": "InvokeLambda1",
  "States": {
    "InvokeLambda1": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.test_lambda1.arn}",
      "End": true
    }
  }
}
EOF
}


