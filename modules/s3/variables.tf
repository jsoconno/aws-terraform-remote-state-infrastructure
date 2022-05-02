variable "name" {
  type        = string
  description = "The name of the bucket. If omitted, Terraform will assign a random, unique name. Must be lowercase and less than or equal to 63 characters in length."
  default     = null
}

variable "acl" {
  type        = string
  description = "The canned ACL applied to the bucket."
  default     = "private"
}

variable "force_destroy" {
  type        = bool
  description = "A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  default     = true
}

variable "versioning_enabled" {
  type        = bool
  description = "Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket."
  default     = true
}

variable "logging_bucket" {
  type        = string
  description = "The bucket that will be used for logging.  If left blank, logging will not be enabled."
  default     = ""
}

variable "lifecycle_rule_enabled" {
  type        = bool
  description = "Specifies lifecycle rule status."
  default     = true
}

variable "expiration" {
  type        = number
  description = "Specifies a period in the object's are permanently deleted.  Map expects a key of days set to an integer value."
  default     = null
}

variable "policy" {
  type        = string
  description = "Policy document to be applied to the bucket."
  default     = ""
}

variable "s3_access_iam_role_names" {
  type = list(string)
  description = "A list of role names that need access to S3."
  default = []
}

variable "s3_objects" {
  type        = list(
    object({
      source_dir = string
      target_key = string
    })
  )
  description = "List of objects to be uploaded to S3.  The source_dir attribute is the absolute or relative filepath to the object (e.g. ../path/to/file.txt).  The target_key attribute is where the object should be stored in s3 (e.g. prefix/file.txt)."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "A map of strings used to add tags during the deployment."
}