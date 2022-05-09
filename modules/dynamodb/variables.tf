variable "name" {
  type        = string
  description = "The name of the resource."

  validation {
    condition = (
      length(var.name) >= 3
    )
    error_message = "The name of the table must be at least three characters long."
  }
}

variable "hash_key" {
  type = object({
    name = string
    type = string
  })
  description = "The attribute to use as the hash (partition) key."

  validation {
    condition = (
      contains(["S", "N", "B"], var.hash_key.type)
    )
    error_message = "Hash key type must be one of: S, N, or B."
  }
}

variable "range_key" {
  type = object({
    name = string
    type = string
  })
  description = "The attribute to use as the range (sort) key."
  default = null

  validation {
    condition = (
      var.range_key == null ? true : contains(["S", "N", "B"], var.range_key.type)
    )
    error_message = "Range key must be one of: S, N, or B."
  }
}

variable "stream_view_type" {
  type = string
  description = "When an item in the table is modified, StreamViewType determines what information is written to the table's stream."
  default = "NEW_AND_OLD_IMAGES"

  validation {
    condition = (
      contains(["KEYS_ONLY", "NEW_IMAGE", "OLD_IMAGE", "NEW_AND_OLD_IMAGES"], var.stream_view_type)
    )
    error_message = "Must be one of: KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, or NEW_AND_OLD_IMAGES."
  }
}

variable "index_attributes" {
  type = list(object({
    name = string
    type = string
  }))
  description = "List of nested attribute definitions. Each attribute has two required attributes: name and type.  The type attribute must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data."
  default = []
}

variable "ttl_attribute_name" {
  type = string
  description = "The name of the table attribute to store the TTL timestamp in."
  default = null
}

variable "ttl_enabled" {
  type = bool
  description = "Indicates whether ttl is enabled (true) or disabled (false)."
  default = true
}

variable "local_secondary_index_map" {
  type = any
  description = "Describe an LSI on the table; these can only be allocated at creation so you cannot change this definition after you have created the resource."
  default = []
}

variable "global_secondary_index_map" {
  type = any
  description = "Describe a GSI for the table; subject to the normal limits on the number of GSIs, projected attributes, etc."
  default = []
}

variable "point_in_time_recovery" {
  type = bool
  description = "Enable point-in-time recovery options."
  default = false
}

variable "replica" {
  type = list(object({
    region = string
    kms_key_arn = string
  }))
  description = "Configuration block(s) with DynamoDB Global Tables V2 (version 2019.11.21) replication configurations.  The attribute 'region' is the region name of the replica.  The attribute kms_key_arn is the ARN of the CMK that should be used for the AWS KMS encryption."
  default = []
}

variable "encryption_key_arn" {
  type = string
  description = "The ARN of the AWS KMS key to use for table encryption."
  default = null
}

variable "dynamodb_access_iam_role_names" {
  type = list(string)
  description = "A list of role names that need access to DynamoDb."
  default = []
}

# Autoscaling variables
variable "autoscaling_min_read_capacity" {
  type = number
  description = "The min read capacity of the scalable target."
  default = 20
}

variable "autoscaling_max_read_capacity" {
  type = number
  description = "The max read capacity of the scalable target."
  default = 40000
}

variable "autoscaling_min_write_capacity" {
  type = number
  description = "The min write capacity of the scalable target."
  default = 20
}

variable "autoscaling_max_write_capacity" {
  type = number
  description = "The max write capacity of the scalable target."
  default = 40000
}

variable "autoscaling_policy_target_value" {
  type = number
  description = "The target value for the metric."
  default = 70
}

variable "autoscaling_policy_scale_in_cooldown" {
  type = number
  description = "The amount of time, in seconds, after a scale in activity completes before another scale in activity can start."
  default = 0
}

variable "autoscaling_policy_scale_out_cooldown" {
  type = number
  description = "The amount of time, in seconds, after a scale out activity completes before another scale out activity can start."
  default = 0
}

variable "tags" {
  type        = map(string)
  description = "A map of strings used to add tags during the deployment."
}