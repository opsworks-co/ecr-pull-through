variable "region" {
  description = "AWS region where we are creating rules"
  type        = string
  default     = "" # If unset we are getting region from the data.aws_region
}

variable "registries" {
  description = "List of registries to create rules for"
  type = map(object({
    registry    = string
    username    = string
    accessToken = string
  }))
}

variable "tags" {
  description = "Tags that will be assigned to all resources"
  type        = map(string)
  default     = {}
}
