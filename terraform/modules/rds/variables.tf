variable "security_groups" {
    type = list(string)
    default = [""]
    description = "Security groups to be attached to the server."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Type of environment, dev or prod."
}

variable "subnet_name" {
  type          = string
  description   = "Network subnet for the applications."
}

variable "application" {
    type = string
    description = "Purpose of the auto scaling group, application to be used."
}

variable "del_protect" {
    type = bool
    default = false
    description = "Set if the database can or cannot be deleted via Terraform."
}