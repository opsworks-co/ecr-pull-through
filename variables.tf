variable "region" {
  description = "AWS region where we are creating rules"
  type        = string
  default     = "" # If unset we are getting region from the data.aws_region
}

variable "registries" {
  description = "List of registries to create rules for"
  type = map(object({
    registry    = string
    username    = optional(string)
    accessToken = optional(string)
  }))

  validation {
    condition = alltrue([
      for k, v in var.registries : (
        (v.username == null && v.accessToken == null) || (v.username != null && v.accessToken != null)
      )
    ])
    error_message = "If 'username' is set for a registry, 'accessToken' must also be provided."
  }
}

variable "tags" {
  description = "Tags that will be assigned to all resources"
  type        = map(string)
  default     = {}
}
