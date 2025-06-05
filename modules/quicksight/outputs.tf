output "quicksight_account_id" {
  description = "The ID of the QuickSight account"
  value       = aws_quicksight_account_subscription.subscription.id
}

output "analysts_group_arn" {
  description = "The ARN of the QuickSight analysts group"
  value       = aws_quicksight_group.analysts.arn
}

output "redshift_datasource_arn" {
  description = "The ARN of the QuickSight Redshift data source"
  value       = var.create_redshift_datasource ? aws_quicksight_data_source.redshift[0].arn : ""
}

output "s3_datasource_arn" {
  description = "The ARN of the QuickSight S3 data source"
  value       = var.create_s3_datasource ? aws_quicksight_data_source.s3[0].arn : ""
}