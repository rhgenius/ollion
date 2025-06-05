variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (dev, test, stage, prod)"
  type        = string
}

variable "topic_name" {
  description = "Name of the SNS topic"
  type        = string
}

variable "display_name" {
  description = "Display name of the SNS topic"
  type        = string
  default     = null
}

variable "fifo_topic" {
  description = "Whether the SNS topic is a FIFO topic"
  type        = bool
  default     = false
}

variable "kms_master_key_id" {
  description = "ID of the KMS key to use for encryption"
  type        = string
  default     = null
}

variable "additional_policy_principals" {
  description = "List of additional AWS principals to include in the SNS topic policy"
  type        = list(string)
  default     = []
}

variable "additional_policy_statements" {
  description = "List of additional policy statements to include in the SNS topic policy"
  type        = list(object({
    sid                  = string
    effect               = string
    actions              = list(string)
    principal_type       = string
    principal_identifiers = list(string)
    conditions           = list(object({
      test     = string
      variable = string
      values   = list(string)
    }))
  }))
  default     = []
}

variable "subscriptions" {
  description = "Map of subscriptions to create for the SNS topic"
  type        = map(object({
    protocol             = string
    endpoint             = string
    filter_policy        = optional(string)
    dead_letter_queue_arn = optional(string)
  }))
  default     = {}
}