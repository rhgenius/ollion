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
  default     = "production"  # Changed from "dev" to "production"
}

# Other variables with production-appropriate defaults
# ...

# Data Science Variables with production-appropriate sizing
variable "redshift_node_type" {
  description = "Node type for Redshift cluster"
  type        = string
  default     = "dc2.xlarge"  # Larger instance for production
}

variable "redshift_number_of_nodes" {
  description = "Number of nodes in the Redshift cluster"
  type        = number
  default     = 4  # More nodes for production
}

variable "glue_job_timeout" {
  description = "Timeout for Glue jobs in minutes"
  type        = number
  default     = 120  # Longer timeout for production
}