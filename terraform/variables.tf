variable "name" {
  type = string
  description = "The name of the S3 bucket and DynamoDb table."
  default = ""
}

variable "s3_bucket_name" {
  type = string
  description = "The name of the s3 bucket.  Optional if the name attribute is provided."
  default = ""
}

variable "dynamodb_table_name" {
  type = string
  description = "The name of the dynamodb table.  Optional if the name attribute is provided."
  default = ""
}

variable "state_file_name" {
  type = string
  description = "The preferred name for the state file.  .tfstate should be added as the file type."
  default = "terraform.tfstate"
}

variable "region" {
  type        = string
  description = "The region where resources will be deployed as part of the Terraform configuration."
  default     = "us-east-1"
}

variable "tags" {
  type        = map(string)
  description = "A map of strings used to add tags during the deployment."
}