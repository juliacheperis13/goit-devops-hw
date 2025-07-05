output "s3_bucket_name" {
  description = "The name of the S3 bucket for storing Terraform state files"
  value       = module.s3_backend.bucket_name
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table used for state locking"
  value       = module.s3_backend.table_name
}
