output "arn" {
  value       = aws_s3_bucket.this.arn
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
}

output "name" {
  value       = aws_s3_bucket.this.id
  description = "The name of the bucket."
}

output "bucket_domian_name" {
  value       = aws_s3_bucket.this.bucket_domain_name
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com."
}

output "kms_key_arn" {
  value = aws_kms_key.this.arn
  description = "ARN of the KMS key used to encrypt S3."
}

output "s3_objects" {
  value = aws_s3_bucket_object.this
  description = "Map of objects uploaded to S3 with the index being the path to the source directory."
}