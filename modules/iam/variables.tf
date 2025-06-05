variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (dev, test, stage, prod)"
  type        = string
}

variable "artifact_bucket_arn" {
  description = "ARN of the S3 artifact bucket"
  type        = string
  default     = ""
}

variable "codecommit_repository_arn" {
  description = "ARN of the CodeCommit repository"
  type        = string
  default     = ""
}