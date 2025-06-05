variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (dev, test, stage, prod)"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket for data storage"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet for the SageMaker notebook instance"
  type        = string
  default     = ""
}

variable "security_group_ids" {
  description = "List of security group IDs for the SageMaker notebook instance"
  type        = list(string)
  default     = []
}

variable "notebook_instance_type" {
  description = "Instance type for the SageMaker notebook instance"
  type        = string
  default     = "ml.t3.medium"
}

variable "notebook_volume_size" {
  description = "Volume size in GB for the SageMaker notebook instance"
  type        = number
  default     = 50
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository for SageMaker models"
  type        = string
  default     = ""
}