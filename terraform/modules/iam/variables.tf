variable "application" {
  type        = string
  description = "Purpose of the application to be used."
}

variable "type" {
  type        = string
  default = "Execution"
  description = "Type of role, Execution or Task."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Type of environment, dev or prod."
}

variable "json_policy" {
  type        = string
  description = "Permissions to assign to instance profile."
}