provider "aws" {
  access_key                  = "mock_access_key"
  region                      = "us-east-1"
  s3_force_path_style         = true
  secret_key                  = "mock_secret_key"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    firehose       = "http://localhost:4573"
    iam            = "http://localhost:4593"
    kinesis        = "http://localhost:4568"
    s3             = "http://localhost:4572"
    dynamodb       = "http://localhost:4569"
  }
}

resource "aws_kinesis_stream" "kinesis_stream_task1" {
    name             = "kinesis-stream-task1"
    shard_count      = 1
}

resource "aws_s3_bucket" "s3_bucket" {
    bucket = "s3-task1"
    acl    = "private"
}

resource "aws_kinesis_firehose_delivery_stream" "kinesis_firehose_task1" {
    name        = "kinesis-firehose-task1"
    destination = "s3"

    kinesis_source_configuration {
        kinesis_stream_arn =  aws_kinesis_stream.kinesis_stream_task1.arn
        role_arn = aws_iam_role.firehose_role.arn
    }  

    s3_configuration {
        role_arn   = aws_iam_role.firehose_role.arn
        bucket_arn = aws_s3_bucket.s3_bucket.arn
        buffer_interval = 60
    }
}

