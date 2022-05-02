# S3
The S3 module is responsible for deploying an S3 bucket that is encrypted with KMS by default and has bucket policies to prevent unencrypted objects and insecure transport. If an IAM role is provided, it will attach a policy to the IAM role that gives it basic Get and Put permissions.

## Minimal Example
```
module "s3" {
    source = "../modules/s3"

    name = "my-unique-bucket"

    tags = {}
}
```

<!-- BEGIN_TF_DOCS -->
The following documentation outlines the providers, resources, inputs, and outputs used in this Terraform configuration.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | <4.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.allow_access_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.allow_access_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_iam_policy_document.allow_access_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acl"></a> [acl](#input\_acl) | The canned ACL applied to the bucket. | `string` | `"private"` | no |
| <a name="input_expiration"></a> [expiration](#input\_expiration) | Specifies a period in the object's are permanently deleted.  Map expects a key of days set to an integer value. | `number` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. | `bool` | `true` | no |
| <a name="input_lifecycle_rule_enabled"></a> [lifecycle\_rule\_enabled](#input\_lifecycle\_rule\_enabled) | Specifies lifecycle rule status. | `bool` | `true` | no |
| <a name="input_logging_bucket"></a> [logging\_bucket](#input\_logging\_bucket) | The bucket that will be used for logging.  If left blank, logging will not be enabled. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the bucket. If omitted, Terraform will assign a random, unique name. Must be lowercase and less than or equal to 63 characters in length. | `string` | `null` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | Policy document to be applied to the bucket. | `string` | `""` | no |
| <a name="input_s3_access_iam_role_names"></a> [s3\_access\_iam\_role\_names](#input\_s3\_access\_iam\_role\_names) | A list of role names that need access to S3. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of strings used to add tags during the deployment. | `map(string)` | n/a | yes |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the bucket. Will be of format arn:aws:s3:::bucketname. |
| <a name="output_bucket_domian_name"></a> [bucket\_domian\_name](#output\_bucket\_domian\_name) | The bucket domain name. Will be of format bucketname.s3.amazonaws.com. |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | ARN of the KMS key used to encrypt S3. |
| <a name="output_name"></a> [name](#output\_name) | The name of the bucket. |
<!-- END_TF_DOCS -->