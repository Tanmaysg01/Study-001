resource "aws_s3_bucket" "buckets3" {
  bucket = "bucketendpoint123"

   tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.mainvpc.id
  service_name = "com.amazonaws.us-east-1.s3"
}

resource "aws_vpc_endpoint_route_table_association" "vpcendpoint" {
  route_table_id  = aws_route_table.route1.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}