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
  bucket = "s3bucket--usw2-az1--x-s3"

  location {
    name = "usw2-az1"
  }
}
