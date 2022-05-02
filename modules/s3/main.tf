# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key
resource "aws_kms_key" "this" {
  description             = "Encryption key for s3 bucket."
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = var.tags
}

# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias
resource "aws_kms_alias" "alias" {
  name          = "alias/s3-${var.name}"
  target_key_id = aws_kms_key.this.key_id
}

# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "this" {
  bucket        = var.name
  acl           = var.acl
  force_destroy = var.force_destroy

  versioning {
    enabled = var.versioning_enabled
  }

  dynamic "logging" {
    for_each = var.logging_bucket == "" ? [] : tolist(var.logging_bucket)
    content {
      target_bucket = each.value
      target_prefix = var.name
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.this.arn
      }
    }
  }

  lifecycle_rule {
    id      = "log"
    enabled = var.lifecycle_rule_enabled

    tags = var.tags

    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA" # or "ONEZONE_IA"
    }

    noncurrent_version_transition {
      days          = 60
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      days = 90
    }

    dynamic "expiration" {
      for_each = var.expiration == null ? [] : [var.expiration]
      content {
        days = expiration.value
      }
    }
  }

  tags = var.tags
}

# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
resource "aws_iam_policy" "allow_access_s3" {
  count = length(var.s3_access_iam_role_names)

  name   = "S3Access-${upper(aws_s3_bucket.this.id)}-${count.index}"
  policy = data.aws_iam_policy_document.allow_access_s3[count.index].json
}

# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
resource "aws_iam_role_policy_attachment" "allow_access_s3" {
  count = length(var.s3_access_iam_role_names)

  role       = var.s3_access_iam_role_names[count.index]
  policy_arn = aws_iam_policy.allow_access_s3[count.index].arn
}

resource "aws_s3_bucket_object" "this" {
  for_each = {for object in var.s3_objects:  object.source_dir => object.target_key}

  bucket = aws_s3_bucket.this.id
  source = each.key
  key = each.value
  server_side_encryption = "aws:kms"
  acl    = "private"
  kms_key_id = aws_kms_key.this.arn
  source_hash = filemd5(each.key)
}