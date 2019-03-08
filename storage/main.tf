resource "aws_s3_bucket" "aws_s3_bucket_id" {
  bucket        = "${var.bucket}"
  force_destroy = true

  tags = {
    Name        = "Openshift Storage Registry"
    Environment = "Dev"
    Project     = "${var.project}"
  }
}

resource "aws_s3_bucket_policy" "b" {
  bucket = "${aws_s3_bucket.aws_s3_bucket_id.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "OpenshiftBucketPolicy",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:ListBucketMultipartUploads"
      ],
      "Resource": "${aws_s3_bucket.aws_s3_bucket_id.arn}"
    },
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListMultipartUploadParts",
        "s3:AbortMultipartUpload"
      ],
      "Resource": "${aws_s3_bucket.aws_s3_bucket_id.arn}/*"
    }
  ]
}
POLICY
}
