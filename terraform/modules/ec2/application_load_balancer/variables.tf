variable "application" {
    type = string
    description = "Purpose of the auto scaling group, application to be used."
}

variable "port" {
  type = number
  default = 80
  description = "Port where the application is running."
}

variable "vpc_id" {
  type = string
  description = "VPC where the load balancer will be hosted."
}

variable "security_groups" {
    type = list(string)
    default = [""]
    description = "Security groups to be attached to the load balancer."
}

variable "subnets" {
  type = list(string)
  description   = "Network subnet for the load balancer."
}

variable "acm_arn" {
  type = string
  description   = "ARN for the certificate manager."
}

variable "additional_listener_certs" {
  type = bool
  default = false
  description   = "If we need to add other certificates to the 443 listener"
}

variable "listener_certs_arns" {
  type = list(object({
    app                = string
    certificate_arn   = string
  }))
  default = [
    { app = " ", certificate_arn = " "}
  ]
  description   = "List of certificates to attach to the 443 listener"
}