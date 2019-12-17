resource "aws_iam_role" "firehose_role" {
    name = "firehose_role_task1"

    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "firehose_policy" {
    name = "firehose_policy_task1"

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "sts:AssumeRole",
                "s3:*",
                "kms:*",
                "logs:*",
                "lambda:*",
                "kinesis:*",
                "glue:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
    role       = aws_iam_role.firehose_role.name
    policy_arn = aws_iam_policy.firehose_policy.arn
}

