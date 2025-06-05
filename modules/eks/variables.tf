variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (dev, test, stage, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "eks_cluster_names" {
  description = "Names for the EKS clusters"
  type        = map(string)
}

variable "eks_node_group_instance_types" {
  description = "EC2 instance types for EKS node groups"
  type        = map(list(string))
}

variable "eks_node_group_desired_size" {
  description = "Desired size for EKS node groups"
  type        = map(number)
}

variable "eks_node_group_min_size" {
  description = "Minimum size for EKS node groups"
  type        = map(number)
}

variable "eks_node_group_max_size" {
  description = "Maximum size for EKS node groups"
  type        = map(number)
}

variable "eks_cluster_role_arn" {
  description = "ARN of the EKS cluster IAM role"
  type        = string
}

variable "eks_node_role_arn" {
  description = "ARN of the EKS node group IAM role"
  type        = string
}