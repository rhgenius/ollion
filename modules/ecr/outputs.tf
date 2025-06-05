output "repository_arn" {
  description = "ARN of the ECR repository"
  value       = aws_ecr_repository.app_repo.arn
}

output "repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.app_repo.repository_url
}

output "registry_id" {
  description = "Registry ID of the ECR repository"
  value       = aws_ecr_repository.app_repo.registry_id
}