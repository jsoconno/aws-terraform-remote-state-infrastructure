locals {
  attributes = var.range_key == null ? concat([var.hash_key], var.index_attributes) : concat([var.hash_key], [var.range_key], var.index_attributes)
}

resource "aws_kms_key" "table" {
  count = var.encryption_key_arn == null ? 1 : 0
  
  description = "Encryption key for DynamoDb table."
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = var.tags
}

# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
resource "aws_dynamodb_table" "standard" {
  name           = var.name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = var.hash_key.name
  range_key      = var.range_key == null ? null : var.range_key.name
  stream_enabled = true
  stream_view_type = var.stream_view_type

  dynamic "attribute" {
    for_each = local.attributes
    content {
      name = attribute.value.name
      type = upper(attribute.value.type)
    }
  }

  dynamic "ttl" {
    for_each = var.ttl_attribute_name != null ? [1] : []
    content {
      attribute_name = var.ttl_attribute_name
      enabled        = var.ttl_enabled
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_index_map
    content {
      name               = local_secondary_index.value.name
      range_key          = local_secondary_index.value.range_key
      projection_type    = local_secondary_index.value.protection_type
      non_key_attributes = lookup(local_secondary_index.value, "non_key_attributes", null)
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_index_map
    content {
      name               = global_secondary_index.value.name
      write_capacity     = lookup(global_secondary_index.value, "write_capacity", null)
      read_capacity      = lookup(global_secondary_index.value, "read_capacity", null)
      hash_key           = global_secondary_index.value.hash_key
      range_key          = lookup(global_secondary_index.value, "range_key", null)
      projection_type    = global_secondary_index.value.projection_type
      non_key_attributes = lookup(global_secondary_index.value, "non_key_attributes", null)
    }
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery
  }

  dynamic "replica" {
    for_each = var.replica
    content {
      region_name = replica.value.region
      kms_key_arn = replica.value.kms_key_arn
    }
  }

  server_side_encryption {
    enabled = true
    kms_key_arn = var.encryption_key_arn == null ? aws_kms_key.table[0].arn : var.encryption_key_arn
  }

  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
  }

  tags = var.tags
}