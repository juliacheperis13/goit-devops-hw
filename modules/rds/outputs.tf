output "aurora_cluster_endpoint" {
  description = "The writer endpoint for the Aurora cluster"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].endpoint : null
}

output "aurora_reader_endpoint" {
  description = "The reader endpoint for the Aurora cluster"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].reader_endpoint : null
}

output "aurora_cluster_id" {
  description = "ID of the Aurora cluster"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].id : null
}

output "aurora_instance_endpoint_writer" {
  description = "Endpoint of the Aurora DB instance writer"
  value       = var.use_aurora ? aws_rds_cluster_instance.aurora_writer[0].endpoint : null
}

output "aurora_instance_endpoint_reader" {
  description = "Endpoint of the Aurora DB instance writer"
  value       = var.use_aurora ? aws_rds_cluster_instance.aurora_readers[0].endpoint : null
}


output "rds_instance_endpoint" {
  description = "Endpoint of the standalone RDS instance"
  value       = var.use_aurora ? null : aws_db_instance.standard[0].endpoint
}

output "rds_instance_id" {
  description = "ID of the RDS instance"
  value       = var.use_aurora ? null : aws_db_instance.standard[0].id
}

output "rds_subnet_group" {
  description = "Subnet group name"
  value       = aws_db_subnet_group.default.name
}
