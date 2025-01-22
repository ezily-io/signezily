variable "application" {
  type        = string
  description = "Purpose of the auto scaling group, application to be used."
}

variable "port" {
  type        = number
  description = "Port where the application is running."
}

variable "protocol" {
  type        = string
  default     = "TCP"
  description = "Protocol to use"
}

variable "vpc_id" {
  type        = string
  description = "VPC where the load balancer will be hosted."
}

variable "security_groups" {
  type        = list(string)
  default     = [""]
  description = "Security groups to be attached to the load balancer."
}

variable "subnets" {
  type        = list(string)
  description = "Network subnet for the load balancer."
}

variable "acm_arn" {
  type        = string
  description = "ARN for the certificate manager."
}

variable "internal" {
  type        = bool
  default     = false
  description = "NLB needs to be internal or internet facing"
}

variable "enable_cross_zone_load_balancing" {
  type        = bool
  default     = false
  description = "Enables the capability for the NLB to serve cross zone traffic"
}