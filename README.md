# AWS Terraform Remote State Infrastructure
This repo provides everything needed to stand up a secure by design S3 bucket and DynamoDb table to enable remote state management with Terraform on AWS.

# What is in the box?
An S3 bucket for remote state management and a DynamoDb table for state locking.  Everything is configured using security best practices.  Nothing is public and everything is encrypted / decrypted using KMS keys.

# How to use this configuration.
To use this configuration, simply update the `terraform.tfvars` file with the relevant inputs for your setup and run `terraform init`, `terraform plan -out out.tfplan`, and `terraform apply out.tfplan`.

Once apply is complete, a backend output block will be generated that can be copied and pasted into your `terraform {}` block (usually found in a `versions.tf` file or something similar).