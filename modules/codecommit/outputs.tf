output "repository_arn" {
  description = "ARN of the CodeCommit repository"
  value       = aws_codecommit_repository.app_repo.arn
}

output "repository_name" {
  description = "Name of the CodeCommit repository"
  value       = aws_codecommit_repository.app_repo.repository_name
}

output "clone_url_http" {
  description = "HTTP clone URL of the CodeCommit repository"
  value       = aws_codecommit_repository.app_repo.clone_url_http
}

output "clone_url_ssh" {
  description = "SSH clone URL of the CodeCommit repository"
  value       = aws_codecommit_repository.app_repo.clone_url_ssh
}