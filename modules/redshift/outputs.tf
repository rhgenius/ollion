output "cluster_id" {
  description = "The ID of the Redshift cluster"
  value       = aws_redshift_cluster.redshift_cluster.id
}

output "cluster_endpoint" {
  description = "The endpoint of the Redshift cluster"
  value       = aws_redshift_cluster.redshift_cluster.endpoint
}

output "cluster_identifier" {
  description = "The identifier of the Redshift cluster"
  value       = aws_redshift_cluster.redshift_cluster.id
}

output "database_name" {
  description = "The name of the Redshift database"
  value       = aws_redshift_cluster.redshift_cluster.database_name
}

output "secret_arn" {
  description = "ARN of the secret containing Redshift credentials"
  value       = aws_secretsmanager_secret.redshift_credentials.arn
}