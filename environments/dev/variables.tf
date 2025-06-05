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


# Add these variables to your existing variables.tf

variable "emr_release_label" {
  description = "EMR release label"
  type        = string
  default     = "emr-6.6.0"
}

variable "emr_applications" {
  description = "List of applications to install on the EMR cluster"
  type        = list(string)
  default     = ["Spark", "Hadoop", "Hive"]
}

variable "emr_master_instance_type" {
  description = "Instance type for the EMR master node"
  type        = string
  default     = "m5.xlarge"
}

variable "emr_core_instance_type" {
  description = "Instance type for EMR core nodes"
  type        = string
  default     = "m5.xlarge"
}

variable "emr_core_instance_count" {
  description = "Number of EMR core nodes"
  type        = number
  default     = 2
}

variable "domain_name" {
  description = "Domain name for Route53"
  type        = string
  default     = "example.com"
}

variable "rds_database_name" {
  description = "Name of the RDS database"
  type        = string
  default     = "appdb"
}

variable "rds_username" {
  description = "Username for the RDS database"
  type        = string
  default     = "admin"
}

variable "rds_password" {
  description = "Password for the RDS database"
  type        = string
  sensitive   = true
  default     = "changeme" # Use a secure method to provide this in production
}

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