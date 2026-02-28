# RDS Outputs
output "rds_endpoint" {
  description = "Endpoint звичайної RDS бази даних"
  value       = var.use_aurora ? null : aws_db_instance.standard[0].endpoint
}

output "rds_address" {
  description = "Адреса звичайної RDS бази даних"
  value       = var.use_aurora ? null : aws_db_instance.standard[0].address
}

output "rds_port" {
  description = "Порт звичайної RDS бази даних"
  value       = var.use_aurora ? null : aws_db_instance.standard[0].port
}

# Aurora Outputs
output "aurora_cluster_endpoint" {
  description = "Endpoint Aurora кластера (writer)"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].endpoint : null
}

output "aurora_reader_endpoint" {
  description = "Endpoint Aurora кластера (reader)"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].reader_endpoint : null
}

output "aurora_cluster_port" {
  description = "Порт Aurora кластера"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].port : null
}

# Common Outputs
output "db_subnet_group_name" {
  description = "Ім'я DB Subnet Group"
  value       = aws_db_subnet_group.default.name
}

output "security_group_id" {
  description = "ID Security Group для бази даних"
  value       = aws_security_group.rds.id
}

output "db_name" {
  description = "Ім'я створеної бази даних"
  value       = var.db_name
}