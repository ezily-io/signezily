variable "vpc_id" {
  type          = string
  description   = "ID of the Virtual Private Cloud attributes."
}

variable "vpc_cidr" {
  type          = string
  description   = "ID of the Virtual Private Cloud attributes."
}

variable "intranet_cidr_blocks" {
  type          = list(string)
  default       = []
  description   = "List of CIDR blocks."
}

variable "inbound" {
  type          = list(string)
  default       = [ "" ]
  description   = "Name the type of ingress traffic to accept from Intranet."
}

variable "outbound" {
  type          = list(string)
  default       = [ "" ]
  description   = "Name the type of outgress traffic to accept from Intranet."
}

variable "public_inbound" {
  type          = list(string)
  default       = [ "" ]
  description   = "Name the type of ingress traffic to accept from the Internet."
}

variable "public_outbound" {
  type          = list(string)
  default       = [ "" ]
  description   = "Name the type of outgress traffic to accept from the Internet."
}