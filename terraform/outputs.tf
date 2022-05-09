output "backend" {
    value = <<EOT
    backend "s3" {
      bucket = "${module.s3.name}"
      key    = "state/${var.state_file_name}"
      region = "${data.aws_region.current.name}"
      encrypt = true
      kms_key_id = "${module.s3.kms_key_arn}"
      dynamodb_table = "${module.dynamodb.name}"
    }
    EOT
    description = "Backend configuration for Terraform projects using this as its automation baseline."
}