variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (dev, test, stage, prod)"
  type        = string
}

variable "queue_name" {
  description = "Name of the SQS queue"
  type        = string
}

variable "fifo_queue" {
  description = "Whether the SQS queue is a FIFO queue"
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Whether to enable content-based deduplication for FIFO queues"
  type        = bool
  default     = false
}

variable "visibility_timeout_seconds" {
  description = "Visibility timeout for the queue in seconds"
  type        = number
  default     = 30
}

variable "message_retention_seconds" {
  description = "Message retention period in seconds"
  type        = number
  default     = 345600 # 4 days
}

variable "max_message_size" {
  description = "Maximum message size in bytes"
  type        = number
  default     = 262144 # 256 KiB
}

variable "delay_seconds" {
  description = "Delay in seconds for messages"
  type        = number
  default     = 0
}

variable "receive_wait_time_seconds" {
  description = "Time in seconds to wait for messages during a receive request"
  type        = number
  default     = 0
}

variable "kms_master_key_id" {
  description = "ID of the KMS key to use for encryption"
  type        = string
  default     = null
}

variable "kms_data_key_reuse_period_seconds" {
  description = "Time in seconds for which Amazon SQS can reuse a data key"
  type        = number
  default     = 300
}

variable "dead_letter_queue_arn" {
  description = "ARN of the dead letter queue"
  type        = string
  default     = null
}

variable "max_receive_count" {
  description = "Maximum number of times a message can be received before being sent to the dead letter queue"
  type        = number
  default     = 5
}

variable "fifo_throughput_limit" {
  description = "Throughput limit for FIFO queues"
  type        = string
  default     = null
}

variable "deduplication_scope" {
  description = "Deduplication scope for FIFO queues"
  type        = string
  default     = null
}

variable "source_arns" {
  description = "List of ARNs that are allowed to send messages to this queue"
  type        = list(string)
  default     = []
}

variable "additional_policy_principals" {
  description = "List of additional AWS principals to include in the SQS queue policy"
  type        = list(string)
  default     = []
}

variable "additional_policy_statements" {
  description = "List of additional policy statements to include in the SQS queue policy"
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

variable "enable_dead_letter_queue" {
  description = "Whether to create a dead letter queue"
  type        = bool
  default     = false
}