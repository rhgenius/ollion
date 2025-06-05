output "cluster_endpoints" {
  description = "Endpoints for EKS clusters"
  value = {
    for k, v in aws_eks_cluster.clusters : k => v.endpoint
  }
}

output "cluster_security_group_ids" {
  description = "Security group IDs for EKS clusters"
  value = {
    for k, v in aws_eks_cluster.clusters : k => v.vpc_config[0].cluster_security_group_id
  }
}

output "cluster_names" {
  description = "Names of the EKS clusters"
  value = {
    for k, v in aws_eks_cluster.clusters : k => v.name
  }
}