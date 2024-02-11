resource "aws_iam_role" "test_role" {
  name = "test_role"

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
          Service = "s3.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "iam"
  }
}

resource "aws_iam_policy" "policy" {
  name        = "test_policy"
  path        = "/"
  description = "My test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
       Effect = "Allow",
       Action = "s3:CreateBucket",
       Resource = "arn:aws:s3:::practicebucket2023--usw2-az1--x-s3"
     },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.test_role.name
  policy_arn = aws_iam_policy.test_policy.arn
}

resource "aws_s3_bucket" "s3bucket" {
  bucket = "practicebucket2023"
  tags = {
    Name        = "My bucket"
    Environment = "DevOps"
  }
}
resource "aws_s3_bucket_acl" "s3bucket" {

  bucket = aws_s3_bucket.s3bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.s3bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["123456789012"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.s3bucket.arn,
      "${aws_s3_bucket.s3bucket.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.s3bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_directory_bucket" "s3bucket" {
  bucket = "s3bucket--use1-az1--x-s3"

  location {
    name = "use1-az1"
  }
}
