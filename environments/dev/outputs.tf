output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "codecommit_repository_url" {
  description = "URL of the CodeCommit repository"
  value       = module.codecommit.clone_url_http
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "eks_cluster_endpoints" {
  description = "Endpoints for EKS clusters"
  value       = module.eks.cluster_endpoints
}

output "eks_cluster_security_group_ids" {
  description = "Security group IDs for EKS clusters"
  value       = module.eks.cluster_security_group_ids
}