provider "aws" {
    access_key	= var.aws_access_key
    secret_key	= var.aws_secret_key
    region	= var.aws_region
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

