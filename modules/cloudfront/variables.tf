variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (dev, test, stage, prod)"
  type        = string
}

variable "s3_origin_domain_name" {
  description = "Domain name of the S3 bucket origin"
  type        = string
}

variable "s3_origin_id" {
  description = "ID for the S3 origin"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  type        = string
}

variable "s3_bucket_id" {
  description = "ID of the S3 bucket"
  type        = string
}

variable "default_root_object" {
  description = "Default root object for the CloudFront distribution"
  type        = string
  default     = "index.html"
}

variable "price_class" {
  description = "Price class for the CloudFront distribution"
  type        = string
  default     = "PriceClass_100" # Use PriceClass_100 for lowest cost (US, Canada, Europe)
}

variable "wait_for_deployment" {
  description = "Whether to wait for the distribution to be deployed"
  type        = bool
  default     = false
}