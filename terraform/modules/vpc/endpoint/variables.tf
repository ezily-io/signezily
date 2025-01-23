variable "region" {
  type = string
  description = "AWS region."
}

variable "vpc_id" {
  type          = string
  description   = "ID of the Virtual Private Cloud attributes."
}

variable "security_group_ids" {
  type        = list(string)
  description = "AWS Security Group."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets to attach the vpc endpoint."
}
