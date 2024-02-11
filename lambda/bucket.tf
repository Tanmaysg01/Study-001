resource "aws_s3_bucket" "example" {
  bucket = "s3lambda2023"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}