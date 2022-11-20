// main bucket
resource "aws_s3_bucket" "dev_bucket" {
  bucket = "lucasko-dev-bucket"
  tags = {
    Name        = "lucasko-dev"
    Environment = "dev"
  }

}
// ACL
resource "aws_s3_bucket_acl" "dev_bucket_acl" {
  bucket = aws_s3_bucket.dev_bucket.id
  acl = "private"
}

resource "aws_s3_bucket_versioning" "dev_bucket_versioning" {
  bucket = aws_s3_bucket.dev_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


// logging
resource "aws_s3_bucket" "log_bucket" {
  bucket = "lucasko-log-bucket"
}

resource "aws_s3_bucket_logging" "dev_bucket_logging" {
  bucket = aws_s3_bucket.dev_bucket.id
  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}

resource "aws_s3_bucket_acl" "log_bucket-acl" {
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_lifecycle_configuration" "log_bucket_lifecycle" {
  bucket = aws_s3_bucket.log_bucket.id

  rule {
    id     = "Delete after 1 day "
    status = "Enabled"

    expiration {
      days = 1
    }
  }
}

//resource "aws_s3_bucket_analytics_configuration" "example-entire-bucket" {
//  bucket = aws_s3_bucket.dev_bucket.bucket
//  name   = "EntireBucket"
//
//  storage_class_analysis {
//    data_export {
//      destination {
//        s3_bucket_destination {
//          bucket_arn = aws_s3_bucket.log_bucket.arn
//        }
//      }
//    }
//  }
//}

resource "aws_s3_bucket_metric" "dev_bucket_metric" {
  bucket = aws_s3_bucket.dev_bucket.bucket
  name   = "DevBucket"
  filter {
    prefix = "/"

    tags = {
      priority = "high"
      class    = "blue"
    }
  }
}


resource "aws_s3_bucket_metric" "log_bucket_metric" {
  bucket = aws_s3_bucket.log_bucket.bucket
  name   = "LogBucket"
}


