variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (dev, test, stage, prod)"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the Route53 hosted zone"
  type        = string
}

variable "records" {
  description = "Map of DNS records to create"
  type        = map(object({
    type    = string
    ttl     = optional(number, 300)
    records = list(string)
  }))
  default     = {}
}

variable "alias_records" {
  description = "Map of alias records to create"
  type        = map(object({
    type  = string
    alias = object({
      name                   = string
      zone_id                = string
      evaluate_target_health = optional(bool, false)
    })
  }))
  default     = {}
}