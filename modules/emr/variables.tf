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

variable "subnet_id" {
  description = "ID of the subnet for EMR cluster"
  type        = string
}

variable "release_label" {
  description = "EMR release label"
  type        = string
  default     = "emr-6.6.0"
}

variable "applications" {
  description = "List of applications to install on the cluster"
  type        = list(string)
  default     = ["Spark", "Hadoop", "Hive", "Pig"]
}

variable "master_instance_type" {
  description = "Instance type for the master node"
  type        = string
  default     = "m5.xlarge"
}

variable "core_instance_type" {
  description = "Instance type for core nodes"
  type        = string
  default     = "m5.xlarge"
}

variable "core_instance_count" {
  description = "Number of core nodes"
  type        = number
  default     = 2
}

variable "ebs_size" {
  description = "Size of EBS volume in GB"
  type        = number
  default     = 100
}

variable "log_bucket" {
  description = "S3 bucket for EMR logs"
  type        = string
}

variable "data_bucket" {
  description = "S3 bucket for EMR data"
  type        = string
}