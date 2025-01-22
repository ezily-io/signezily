variable "cidr" {
    type = string
    default = "10.0.0.0/16"
    description = "VPC cidr"
}

variable "name" {
    type = string
    default = "main"
    description = "VPC cidr"
}

variable "region" {
  type = string
  description = "AWS region."
}