# DynamoDB
The DynamoDB module is responsible for creating a DynamoDB table usage a KMS key to encrypt the table. The module supports creating a DynamoDB using pay per request, provisioned, and autoscaled methods. Changing the database type to or from autoscaled forces recreation.

## Minimal Example
```
module "dynamodb_table" {
  source   = "../module/dynamodb"

  name     = "my-table"
  hash_key = {
    name = "ID"
    type = "S"
  }

  tags = {}
}
```
<!-- BEGIN_TF_DOCS -->
The following documentation outlines the providers, resources, inputs, and outputs used in this Terraform configuration.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.dynamodb_table_read_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.dynamodb_table_write_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.dynamodb_table_read_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_appautoscaling_target.dynamodb_table_write_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_dynamodb_table.autoscaled](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_dynamodb_table.standard](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_iam_policy.allow_access_dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.allow_access_dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_key.table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.allow_access_dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoscaling_max_read_capacity"></a> [autoscaling\_max\_read\_capacity](#input\_autoscaling\_max\_read\_capacity) | The max read capacity of the scalable target. | `number` | `20` | no |
| <a name="input_autoscaling_max_write_capacity"></a> [autoscaling\_max\_write\_capacity](#input\_autoscaling\_max\_write\_capacity) | The max write capacity of the scalable target. | `number` | `20` | no |
| <a name="input_autoscaling_min_read_capacity"></a> [autoscaling\_min\_read\_capacity](#input\_autoscaling\_min\_read\_capacity) | The min read capacity of the scalable target. | `number` | `20` | no |
| <a name="input_autoscaling_min_write_capacity"></a> [autoscaling\_min\_write\_capacity](#input\_autoscaling\_min\_write\_capacity) | The min write capacity of the scalable target. | `number` | `20` | no |
| <a name="input_autoscaling_policy_scale_in_cooldown"></a> [autoscaling\_policy\_scale\_in\_cooldown](#input\_autoscaling\_policy\_scale\_in\_cooldown) | The amount of time, in seconds, after a scale in activity completes before another scale in activity can start. | `number` | `0` | no |
| <a name="input_autoscaling_policy_scale_out_cooldown"></a> [autoscaling\_policy\_scale\_out\_cooldown](#input\_autoscaling\_policy\_scale\_out\_cooldown) | The amount of time, in seconds, after a scale out activity completes before another scale out activity can start. | `number` | `0` | no |
| <a name="input_autoscaling_policy_target_value"></a> [autoscaling\_policy\_target\_value](#input\_autoscaling\_policy\_target\_value) | The target value for the metric. | `number` | `70` | no |
| <a name="input_billing_mode"></a> [billing\_mode](#input\_billing\_mode) | Controls how you are charged for read and write throughput and how you manage capacity.  Valid values include 'PAY\_PER\_REQUEST', 'PROVISIONED', and 'AUTOSCALED'. | `string` | `"PAY_PER_REQUEST"` | no |
| <a name="input_dynamodb_access_iam_role_names"></a> [dynamodb\_access\_iam\_role\_names](#input\_dynamodb\_access\_iam\_role\_names) | A list of role names that need access to DynamoDb. | `list(string)` | `[]` | no |
| <a name="input_encryption_key_arn"></a> [encryption\_key\_arn](#input\_encryption\_key\_arn) | The ARN of the AWS KMS key to use for table encryption. | `string` | `null` | no |
| <a name="input_global_secondary_index_map"></a> [global\_secondary\_index\_map](#input\_global\_secondary\_index\_map) | Describe a GSI for the table; subject to the normal limits on the number of GSIs, projected attributes, etc. | `any` | `[]` | no |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | The attribute to use as the hash (partition) key. | <pre>object({<br>    name = string<br>    type = string<br>  })</pre> | n/a | yes |
| <a name="input_index_attributes"></a> [index\_attributes](#input\_index\_attributes) | List of nested attribute definitions. Each attribute has two required attributes: name and type.  The type attribute must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data. | <pre>list(object({<br>    name = string<br>    type = string<br>  }))</pre> | `[]` | no |
| <a name="input_local_secondary_index_map"></a> [local\_secondary\_index\_map](#input\_local\_secondary\_index\_map) | Describe an LSI on the table; these can only be allocated at creation so you cannot change this definition after you have created the resource. | `any` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the resource. | `string` | n/a | yes |
| <a name="input_point_in_time_recovery"></a> [point\_in\_time\_recovery](#input\_point\_in\_time\_recovery) | Enable point-in-time recovery options. | `bool` | `false` | no |
| <a name="input_range_key"></a> [range\_key](#input\_range\_key) | The attribute to use as the range (sort) key. | <pre>object({<br>    name = string<br>    type = string<br>  })</pre> | `null` | no |
| <a name="input_read_capacity"></a> [read\_capacity](#input\_read\_capacity) | The number of read units for this table. If the billing\_mode is PROVISIONED, this field is required. | `number` | `20` | no |
| <a name="input_replica"></a> [replica](#input\_replica) | Configuration block(s) with DynamoDB Global Tables V2 (version 2019.11.21) replication configurations.  The attribute 'region' is the region name of the replica.  The attribute kms\_key\_arn is the ARN of the CMK that should be used for the AWS KMS encryption. | <pre>list(object({<br>    region = string<br>    kms_key_arn = string<br>  }))</pre> | `[]` | no |
| <a name="input_stream_view_type"></a> [stream\_view\_type](#input\_stream\_view\_type) | When an item in the table is modified, StreamViewType determines what information is written to the table's stream. | `string` | `"NEW_AND_OLD_IMAGES"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of strings used to add tags during the deployment. | `map(string)` | n/a | yes |
| <a name="input_ttl_attribute_name"></a> [ttl\_attribute\_name](#input\_ttl\_attribute\_name) | The name of the table attribute to store the TTL timestamp in. | `string` | `null` | no |
| <a name="input_ttl_enabled"></a> [ttl\_enabled](#input\_ttl\_enabled) | Indicates whether ttl is enabled (true) or disabled (false). | `bool` | `true` | no |
| <a name="input_write_capacity"></a> [write\_capacity](#input\_write\_capacity) | The number of write units for this table. If the billing\_mode is PROVISIONED, this field is required. | `number` | `20` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The arn of the table. |
| <a name="output_name"></a> [name](#output\_name) | The name of the table. |
| <a name="output_stream_arn"></a> [stream\_arn](#output\_stream\_arn) | The arn of the Table Stream. |
| <a name="output_stream_label"></a> [stream\_label](#output\_stream\_label) | A timestamp, in ISO 8601 format, for this stream. Note that this timestamp is not a unique identifier for the stream on its own. However, the combination of AWS customer ID, table name and this field is guaranteed to be unique. It can be used for creating CloudWatch Alarms. |
<!-- END_TF_DOCS -->