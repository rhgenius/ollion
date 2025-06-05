variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (dev, test, stage, prod)"
  type        = string
}

variable "s3_bucket_id" {
  description = "ID of the S3 bucket for data storage"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket for data storage"
  type        = string
}

variable "kinesis_stream_arn" {
  description = "ARN of the Kinesis data stream"
  type        = string
}

variable "glue_role_arn" {
  description = "ARN of the IAM role for Glue"
  type        = string
  default     = ""
}

variable "glue_job_timeout" {
  description = "Timeout for Glue jobs in minutes"
  type        = number
  default     = 60
}