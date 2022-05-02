data "aws_iam_policy_document" "allow_access_s3" {
  count = length(var.s3_access_iam_role_names)

  statement {
    sid    = "AllowAccessToListBucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.this.arn
    ]
  }

  statement {
    sid    = "AllowAccessToPutObject"
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.this.arn}/*"
    ]
  }
}

# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
# Condition variables for S3: https://docs.aws.amazon.com/service-authorization/latest/reference/list_amazons3.html#amazons3-s3_x-amz-server-side-encryption
data "aws_iam_policy_document" "this" {
  source_json = var.policy == null ? null : var.policy

  statement {
    sid    = "DenyIncorrectEncryptionHeader"
    effect = "Deny"
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.this.id}/*"
    ]
    principals {
      identifiers = ["*"]
      type        = "*"
    }
    condition {
      test     = "StringNotEquals"
      values   = ["aws:kms"]
      variable = "s3:x-amz-server-side-encryption"
    }
  }

  statement {
    sid    = "DenyUnEncryptedObject Uploads"
    effect = "Deny"
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.this.id}/*"
    ]
    principals {
      identifiers = ["*"]
      type        = "*"
    }
    condition {
      test     = "Null"
      values   = ["true"]
      variable = "s3:x-amz-server-side-encryption"
    }
  }

  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"
    actions = [
      "s3:*"
    ]
    resources = [
      aws_s3_bucket.this.arn,
      "arn:aws:s3:::${aws_s3_bucket.this.id}/*"
    ]
    principals {
      identifiers = ["*"]
      type        = "*"
    }
    condition {
      test     = "Bool"
      values   = ["false"]
      variable = "aws:SecureTransport"
    }
  }

  depends_on = [
    aws_s3_bucket.this,
    aws_s3_bucket_public_access_block.this
  ]
}
