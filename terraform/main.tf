module "s3" {
  source = "../modules/s3"
  
  name = var.name != "" ? var.name : var.s3_bucket_name

  tags = var.tags
}

module "dynamodb" {
  source = "../modules/dynamodb"

  name = var.name != "" ? var.name : var.dynamodb_table_name

  hash_key = {
    name = "LockID"
    type = "S"
  }

  index_attributes = [
    {
      name = "LockID"
      type = "S"
    }
  ]

  tags = var.tags
}