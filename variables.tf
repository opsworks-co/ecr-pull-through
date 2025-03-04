variable "region" {
  description = "AWS region where we are creating rules"
  type        = string
  default     = "" # If unset we are getting region from the data.aws_region
}

variable "registries" {
  description = "List of registries to create rules for"
  type = map(object({
    registry                    = string
    username                    = optional(string)
    accessToken                 = optional(string)
    repository_read_access_arns = optional(list(string))
    image_tag_mutability        = optional(string)
    lifecycle_policy = optional(object({
      rules = list(object({
        rulePriority = number
        description  = string
        selection = object({
          tagStatus   = string
          countType   = string
          countNumber = number
        })
        action = object({
          type = string
        })
      }))
    }))
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
