variable "name" {
    type = string
    description = "Name of the security group."
}

variable "ports" {
  type = list(object({
    from_port = number
    to_port   = number
    protocol  = string
    cidr_blocks = list(string)
  }))
  default = [
    { from_port = 80, to_port = 80, protocol = "TCP", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 443, to_port = 443, protocol = "TCP", cidr_blocks = ["0.0.0.0/0"] }
  ]
  
  description = "Port where the alb should listen."
}

variable "vpc_id" {
  type = string
  description = "VPC where the load balancer will be hosted."
}

variable "create_sg_redirect" {
  type    = bool
  default = false
}