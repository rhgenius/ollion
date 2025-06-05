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
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the ALB"
  type        = list(string)
}

variable "internal" {
  description = "Whether the ALB is internal"
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "Whether to enable deletion protection for the ALB"
  type        = bool
  default     = false
}

variable "log_bucket" {
  description = "S3 bucket for ALB access logs"
  type        = string
}

variable "enable_access_logs" {
  description = "Whether to enable access logs"
  type        = bool
  default     = true
}

variable "target_groups" {
  description = "Map of target groups to create"
  type        = map(object({
    port                   = number
    protocol               = string
    target_type            = string
    health_check_interval  = optional(number)
    health_check_path      = optional(string)
    health_check_port      = optional(string)
    health_check_protocol  = optional(string)
    health_check_timeout   = optional(number)
    healthy_threshold      = optional(number)
    unhealthy_threshold    = optional(number)
    health_check_matcher   = optional(string)
  }))
  default     = {}
}

variable "create_http_listener" {
  description = "Whether to create an HTTP listener"
  type        = bool
  default     = true
}

variable "create_https_listener" {
  description = "Whether to create an HTTPS listener"
  type        = bool
  default     = false
}

variable "redirect_http_to_https" {
  description = "Whether to redirect HTTP to HTTPS"
  type        = bool
  default     = false
}

variable "ssl_policy" {
  description = "SSL policy for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS listener"
  type        = string
  default     = ""
}

variable "default_target_group_key" {
  description = "Key of the default target group in the target_groups map"
  type        = string
  default     = ""
}

variable "listener_rules" {
  description = "Map of listener rules to create"
  type        = map(object({
    priority         = number
    target_group_key = string
    path_patterns    = list(string)
  }))
  default     = {}
}