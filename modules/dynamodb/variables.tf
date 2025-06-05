variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (dev, test, stage, prod)"
  type        = string
}

variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "billing_mode" {
  description = "Billing mode for the table (PROVISIONED or PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
  validation {
    condition     = contains(["PROVISIONED", "PAY_PER_REQUEST"], var.billing_mode)
    error_message = "Billing mode must be either PROVISIONED or PAY_PER_REQUEST."
  }
}

variable "read_capacity" {
  description = "Read capacity units for the table (if PROVISIONED)"
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "Write capacity units for the table (if PROVISIONED)"
  type        = number
  default     = 5
}

variable "hash_key" {
  description = "Hash key (partition key) name"
  type        = string
}

variable "hash_key_type" {
  description = "Hash key type (S, N, or B)"
  type        = string
  default     = "S"
  validation {
    condition     = contains(["S", "N", "B"], var.hash_key_type)
    error_message = "Hash key type must be one of: S (string), N (number), or B (binary)."
  }
}

variable "range_key" {
  description = "Range key (sort key) name"
  type        = string
  default     = null
}

variable "range_key_type" {
  description = "Range key type (S, N, or B)"
  type        = string
  default     = "S"
  validation {
    condition     = contains(["S", "N", "B"], var.range_key_type)
    error_message = "Range key type must be one of: S (string), N (number), or B (binary)."
  }
}

variable "attributes" {
  description = "Additional attributes for GSIs and LSIs"
  type        = list(object({
    name = string
    type = string
  }))
  default     = []
}

variable "global_secondary_indexes" {
  description = "Global secondary indexes"
  type        = list(object({
    name               = string
    hash_key           = string
    range_key          = optional(string)
    projection_type    = string
    non_key_attributes = optional(list(string))
    read_capacity      = optional(number)
    write_capacity     = optional(number)
  }))
  default     = []
}

variable "local_secondary_indexes" {
  description = "Local secondary indexes"
  type        = list(object({
    name               = string
    range_key          = string
    projection_type    = string
    non_key_attributes = optional(list(string))
  }))
  default     = []
}

variable "ttl_attribute" {
  description = "Attribute name for TTL"
  type        = string
  default     = ""
}

variable "ttl_enabled" {
  description = "Whether TTL is enabled"
  type        = bool
  default     = false
}

variable "point_in_time_recovery_enabled" {
  description = "Whether point-in-time recovery is enabled"
  type        = bool
  default     = true
}

variable "server_side_encryption_enabled" {
  description = "Whether server-side encryption is enabled"
  type        = bool
  default     = true
}

variable "server_side_encryption_kms_key_arn" {
  description = "ARN of the KMS key for server-side encryption"
  type        = string
  default     = null
}

variable "enable_autoscaling" {
  description = "Whether to enable auto scaling for the table"
  type        = bool
  default     = false
}

variable "autoscaling_read_target_value" {
  description = "Target utilization percentage for read auto scaling"
  type        = number
  default     = 70
}

variable "autoscaling_read_max_capacity" {
  description = "Maximum read capacity units for auto scaling"
  type        = number
  default     = 100
}

variable "autoscaling_write_target_value" {
  description = "Target utilization percentage for write auto scaling"
  type        = number
  default     = 70
}

variable "autoscaling_write_max_capacity" {
  description = "Maximum write capacity units for auto scaling"
  type        = number
  default     = 100
}