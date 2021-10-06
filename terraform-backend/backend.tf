provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "cyber94_test_dpook_s3_bucket_tf" {
  bucket = "cyber94-dpook-bucket"

  versioning{
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  acl = "private"

  tags = {
    Name = "cyber94_test_dpook_s3_bucket"
  }
}

resource "aws_dynamodb_table" "cyber94_dpook_dynamodb_table_lock_calculator_tf" {
  name = "cyber94_dpook_dynamodb_table_lock_calculator"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
