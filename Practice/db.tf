resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "Employee"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "UserId"
  range_key      = "empnm"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "empnm"
    type = "S"
  }

  attribute {
    name = "age"
    type = "N"
  }

  

  global_secondary_index {
    name               = "Employee"
    hash_key           = "UserId"
    range_key          = "empnm"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["UserId"]
  }

  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}