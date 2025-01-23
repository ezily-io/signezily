variable "vpc_id" {
  type = string
}

variable "cluster_id" {
  type = string
}

variable "application" {
  type        = string
  description = "Purpose of the resources, application to be used."
}

variable "application_fullname" {
  type        = string
  description = "Purpose of the resources, application full name to be used."
}

variable "service_name" {
  type = string
}

variable "lb_subnet_ids" {
  type = list(string)
}

variable "ecs_subnet_ids" {
  type = list(string)
}

variable "containers" {
  description = "container configuration"
  type        = any
}

variable "ecs_execution_role_arn" {
  type = string
}

variable "certificate_arn" {
  type = string
}

### OPTIONAL

variable "desired_count" {
  type = number
  default = 1
  description = "Number of containers to run."
}
variable "ecs_task_definition_arn" {
  type    = string
  default = ""
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "ecs_task_role_arn" {
  type    = string
  default = null
}

variable "lb_internal" {
  type    = bool
  default = true
}

variable "network_lb" {
  type    = bool
  default = false
}

variable "assign_public_ip" {
  description = "Assign Public IP to containers"
  type        = bool
  default     = false
}

variable "memory" {
  type    = number
  default = 512
}

variable "cpu" {
  type    = number
  default = 256
}

variable "awslogs_group" {
  type    = string
  default = null
}

variable "dynamic_capacity_provider_strategy" {
  description = "List of capacity providers with weights"
  type = list(object({
    capacity_provider = string
    weight            = number
    base              = number
  }))
  default = [
    { capacity_provider = "FARGATE_SPOT", weight = 14, base = 1 },
    { capacity_provider = "FARGATE", weight = 1, base = 0 }
  ]
}