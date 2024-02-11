resource "aws_iam_role" "test_role" {
  name = "glue_role"

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
          Service = "glue.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "test_policy" {
  name        = "glue_policy"
  path        = "/"
  description = "My test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "glue:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
                "s3:*",
                "s3-object-lambda:*"
            ],
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
    ]
  })
}

resource "aws_iam_role_policy_attachment" "glue_policy_attachment" {
  policy_arn = aws_iam_policy.test_policy.arn
  role       = aws_iam_role.test_role.name
}



resource "aws_glue_catalog_database" "database" {
  name = "mycatalogdatabase"
}

resource "aws_glue_catalog_table" "table" {
  name          = "mycatalogtable"
  database_name = "mycatalogdatabase"
  depends_on = [ aws_glue_catalog_database.database ]
}

resource "aws_glue_crawler" "crawler" {
  database_name = aws_glue_catalog_database.database.name
  name          = "test"
  role          = "arn:aws:iam::875716031392:role/service-role/AWSGlueServiceRole-glue"

  s3_target {
    path = "s3://terraform-code-glue/folder/Book1.csv"
  }
}