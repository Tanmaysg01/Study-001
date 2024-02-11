resource "aws_iam_role" "step_full_role" {
  name = "full_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
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

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_policy" "step_full_policy" {
  name = "full_policy"
  path = "/"
  description = "policy for step function"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow",
        Action   = "states:*",
        Resource = "*"
      },
      {
        Effect  = "Allow",
        Action  = "iam:ListRoles",
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = "iam:PassRole",
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = "lambda:ListFunctions",
        Resource = "*"
      },
      {
            Effect = "Allow",
            Action = [
                "lambda:InvokeFunction"
            ],
            Resource = [
                "arn:aws:lambda:us-east-1:446611234961:function:lambda:*"
            ]
        },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "full-attach" {
  role       = aws_iam_role.step_full_role.name
  policy_arn = aws_iam_policy.step_full_policy.arn
}