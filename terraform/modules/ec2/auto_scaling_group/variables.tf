variable "application" {
    type = string
    description = "Purpose of the auto scaling group, application to be used."
}

variable "ami" {
  type          = string
  default       = ""
  description   = "Amazon Machine Image, operating system for the server."
}

variable "subnets_ids" {
  type          = list(string)
  description   = "Network subnet for the applications."
}

variable "instance_type" {
  type          = string
  default       = "t2.large"
  description   = "Instace types, combination of CPU, memory, storage and network capacity."
}

variable "root_size" {
  type          = string
  default       = "100"
  description   = "Root disk space size."
}

variable "security_groups" {
    type = list(string)
    default = [""]
    description = "Security groups to be attached to the server."
}

variable "iam_profile" {
  type = string
  default = null
  description = "Profile used by the autoscaling group."
}

variable "target_group" {
  type = list(string)
  default = null
  description = "Target group ARN to register instance when created."
}

variable "public_ip" {
  type = bool
  default = null
  description = "Set a public IP to the instance."
}

variable "user_data" {
  description = "User data to be supplied to the instance, needs to be Base64-encoded"
  type        = string
  default     = ""
}