output "table_id" {
  description = "ID of the DynamoDB table"
  value       = aws_dynamodb_table.table.id
}

output "table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.table.arn
}

output "table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.table.name
}

output "table_hash_key" {
  description = "Hash key of the DynamoDB table"
  value       = aws_dynamodb_table.table.hash_key
}

output "table_range_key" {
  description = "Range key of the DynamoDB table"
  value       = aws_dynamodb_table.table.range_key
}

output "global_secondary_index_names" {
  description = "Names of the global secondary indexes"
  value       = [for gsi in aws_dynamodb_table.table.global_secondary_index : gsi.name]
}