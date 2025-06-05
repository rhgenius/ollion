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

variable "subnet_ids" {
  description = "List of subnet IDs for the Redshift cluster"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the Redshift cluster"
  type        = list(string)
}

variable "node_type" {
  description = "Node type for the Redshift cluster"
  type        = string
  default     = "dc2.large"
}

variable "number_of_nodes" {
  description = "Number of nodes in the Redshift cluster"
  type        = number
  default     = 2
}