resource "aws_s3_bucket" "my-bucket" {
  bucket = "lucasko-cicd-bucket"
  tags = {
    Name        = "lucasko-cicd"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.my-bucket.id
  acl    = "private"
}