variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, production)"
  type        = string
}

variable "quicksight_edition" {
  description = "Edition of QuickSight to use (STANDARD, ENTERPRISE)"
  type        = string
  default     = "ENTERPRISE"
}

variable "notification_email" {
  description = "Email for QuickSight notifications"
  type        = string
}

variable "create_redshift_datasource" {
  description = "Whether to create a Redshift data source"
  type        = bool
  default     = true
}

variable "create_s3_datasource" {
  description = "Whether to create an S3 data source"
  type        = bool
  default     = true
}

variable "redshift_database_name" {
  description = "Name of the Redshift database"
  type        = string
  default     = "dev"
}

variable "redshift_cluster_endpoint" {
  description = "Endpoint of the Redshift cluster"
  type        = string
  default     = ""
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for QuickSight data source"
  type        = string
  default     = ""
}