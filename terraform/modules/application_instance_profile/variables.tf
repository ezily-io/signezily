variable "application" {
    type = string
    description = "Purpose of the auto scaling group, application to be used."
}

variable "json_policy" {
  type = string
  description = "Permissions to assign to instance profile."
}