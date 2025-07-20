output "bucket_name" {
  description = "Name of the S3 bucket for storing Terraform state files"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "table_name" {
  description = "Name of the DynamoDB table used for state locking"
  value       = aws_dynamodb_table.terraform_locks.name
}
