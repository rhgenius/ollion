variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "codecommit_repository_arn" {
  description = "ARN of the CodeCommit repository"
  type        = string
}

variable "ecr_repository_url" {
  description = "URL of the ECR repository"
  type        = string
}

variable "codebuild_role_arn" {
  description = "ARN of the CodeBuild service role"
  type        = string
}