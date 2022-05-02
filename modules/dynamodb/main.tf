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
  count = var.billing_mode != "AUTOSCALED" ? 1 : 0

  name           = var.name
  billing_mode   = var.billing_mode
  read_capacity  = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity = var.billing_mode == "PROVISIONED" ? var.write_capacity : null
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

# Terraform recommends using a lifecycle block to ignore read and write capacty when autoscaled.
# Because lifecycle blocks are not allowed to have dynamic expressions, the resource must be duplicated.

# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
resource "aws_dynamodb_table" "autoscaled" {
  count = var.billing_mode == "AUTOSCALED" ? 1 : 0

  name           = var.name
  billing_mode   = "PROVISIONED"
  read_capacity  = var.autoscaling_min_read_capacity
  write_capacity = var.autoscaling_min_write_capacity
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

  lifecycle {
    ignore_changes = [read_capacity, write_capacity]
  }
}

# Enable table read and write autoscaling
# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target
resource "aws_appautoscaling_target" "dynamodb_table_read_target" {
  count = var.billing_mode == "AUTOSCALED" ? 1 : 0

  max_capacity       = var.autoscaling_max_read_capacity
  min_capacity       = var.autoscaling_min_read_capacity
  resource_id        = "table/${aws_dynamodb_table.autoscaled[0].name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy
resource "aws_appautoscaling_policy" "dynamodb_table_read_policy" {
  count = var.billing_mode == "AUTOSCALED" ? 1 : 0

  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_read_target[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb_table_read_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_read_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_table_read_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = var.autoscaling_policy_target_value
    scale_in_cooldown = var.autoscaling_policy_scale_in_cooldown
    scale_out_cooldown = var.autoscaling_policy_scale_out_cooldown
  }
}

# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target
resource "aws_appautoscaling_target" "dynamodb_table_write_target" {
  count = var.billing_mode == "AUTOSCALED" ? 1 : 0

  max_capacity       = var.autoscaling_max_write_capacity
  min_capacity       = var.autoscaling_min_write_capacity
  resource_id        = "table/${aws_dynamodb_table.autoscaled[0].name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy
resource "aws_appautoscaling_policy" "dynamodb_table_write_policy" {
  count = var.billing_mode == "AUTOSCALED" ? 1 : 0

  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_write_target[0].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb_table_write_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_write_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_table_write_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = var.autoscaling_policy_target_value
    scale_in_cooldown = var.autoscaling_policy_scale_in_cooldown
    scale_out_cooldown = var.autoscaling_policy_scale_out_cooldown
  }
}

# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
resource "aws_iam_policy" "allow_access_dynamodb" {
  name   = "DynamoDbAccess-${upper(var.name)}"
  policy = data.aws_iam_policy_document.allow_access_dynamodb.json
}

# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
resource "aws_iam_role_policy_attachment" "allow_access_dynamodb" {
  count = length(var.dynamodb_access_iam_role_names)

  role       = var.dynamodb_access_iam_role_names[count.index]
  policy_arn = aws_iam_policy.allow_access_dynamodb.arn
}