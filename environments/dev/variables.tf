variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "ollion-devops"
}

variable "environment" {
  description = "Environment (dev, test, stage, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "repository_name" {
  description = "Name of the CodeCommit repository"
  type        = string
  default     = "ollion-app-repo"
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "ollion-app-images"
}

variable "eks_cluster_names" {
  description = "Names for the EKS clusters"
  type        = map(string)
  default     = {
    test  = "ollion-test-cluster"
    stage = "ollion-stage-cluster"
    prod  = "ollion-prod-cluster"
  }
}

variable "eks_node_group_instance_types" {
  description = "EC2 instance types for EKS node groups"
  type        = map(list(string))
  default     = {
    test  = ["t3.medium"]
    stage = ["t3.large"]
    prod  = ["m5.large"]
  }
}

variable "eks_node_group_desired_size" {
  description = "Desired size for EKS node groups"
  type        = map(number)
  default     = {
    test  = 2
    stage = 2
    prod  = 3
  }
}

variable "eks_node_group_min_size" {
  description = "Minimum size for EKS node groups"
  type        = map(number)
  default     = {
    test  = 1
    stage = 1
    prod  = 2
  }
}

variable "eks_node_group_max_size" {
  description = "Maximum size for EKS node groups"
  type        = map(number)
  default     = {
    test  = 3
    stage = 4
    prod  = 5
  }
}


# Data Science Variables
variable "redshift_node_type" {
  description = "Node type for Redshift cluster"
  type        = string
  default     = "dc2.large"
}

variable "redshift_number_of_nodes" {
  description = "Number of nodes in the Redshift cluster"
  type        = number
  default     = 2
}

variable "glue_job_timeout" {
  description = "Timeout for Glue jobs in minutes"
  type        = number
  default     = 60
}


# Add these variables at the end of the file

variable "quicksight_notification_email" {
  description = "Email for QuickSight notifications"
  type        = string
  default     = "admin@example.com"
}

variable "quicksight_edition" {
  description = "Edition of QuickSight to use (STANDARD, ENTERPRISE)"
  type        = string
  default     = "ENTERPRISE"
}

variable "redshift_database_name" {
  description = "Name of the Redshift database"
  type        = string
  default     = "dev"
}