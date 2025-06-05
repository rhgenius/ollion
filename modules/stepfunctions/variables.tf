variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (dev, test, stage, prod)"
  type        = string
}

variable "state_machine_role_arn" {
  description = "ARN of the IAM role for the Step Functions state machine"
  type        = string
}

variable "definition_file" {
  description = "Path to the state machine definition JSON file"
  type        = string
  default     = ""
}

variable "include_execution_data" {
  description = "Whether to include execution data in logs"
  type        = bool
  default     = true
}

variable "logging_level" {
  description = "Logging level for Step Functions"
  type        = string
  default     = "ALL"
  validation {
    condition     = contains(["ALL", "ERROR", "FATAL", "OFF"], var.logging_level)
    error_message = "Logging level must be one of: ALL, ERROR, FATAL, OFF."
  }
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 30
}

variable "create_event_trigger" {
  description = "Whether to create a CloudWatch Events trigger"
  type        = bool
  default     = false
}

variable "event_schedule_expression" {
  description = "Schedule expression for the CloudWatch Events rule"
  type        = string
  default     = "rate(1 day)"
}

variable "event_role_arn" {
  description = "ARN of the IAM role for the CloudWatch Events rule"
  type        = string
  default     = ""
}

variable "event_input" {
  description = "Input JSON for the Step Functions execution"
  type        = string
  default     = "{}"
}