data "aws_caller_identity" "current" {
  # None
}

data "aws_region" "current" {
  # None
}

data "aws_iam_policy_document" "allow_access_dynamodb" {
  statement {
    sid    = "AllowAccessToDynamoDb"
    effect = "Allow"
    actions = [
      "dynamodb:*"
    ]
    resources = [
      aws_dynamodb_table.standard.arn
    ]
  }

  statement {
    sid    = "AllowEncryptDecrypt"
    effect = "Allow"
    actions = [
      "kms:decrypt",
      "kms:encrypt"
    ]
    resources = [
      var.encryption_key_arn == null ? aws_kms_key.table[0].arn : var.encryption_key_arn
    ]
  }
}