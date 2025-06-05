output "db_instance_id" {
  description = "ID of the RDS instance"
  value       = aws_db_instance.db_instance.id
}

output "db_instance_arn" {
  description = "ARN of the RDS instance"
  value       = aws_db_instance.db_instance.arn
}

output "db_instance_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.db_instance.endpoint
}

output "db_instance_address" {
  description = "Address of the RDS instance"
  value       = aws_db_instance.db_instance.address
}

output "db_instance_port" {
  description = "Port of the RDS instance"
  value       = aws_db_instance.db_instance.port
}

output "db_instance_name" {
  description = "Database name"
  value       = aws_db_instance.db_instance.db_name
}

output "db_subnet_group_id" {
  description = "ID of the DB subnet group"
  value       = aws_db_subnet_group.subnet_group.id
}

output "db_parameter_group_id" {
  description = "ID of the DB parameter group"
  value       = aws_db_parameter_group.parameter_group.id
}

output "db_option_group_id" {
  description = "ID of the DB option group (if created)"
  value       = var.create_option_group ? aws_db_option_group.option_group[0].id : null
}