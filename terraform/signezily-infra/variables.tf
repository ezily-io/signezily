variable "region" {
  type        = string
  default     = "ap-northeast-1"
  description = "AWS region."
}

variable "application" {
  type        = string
  default     = "documenso"
  description = "Application name."
}

variable "del_protect" {
  type        = bool
  default     = false
  description = "Defines if the RDS database will have deletion protection."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Type of environment, dev or prod."
}

variable "service_name" {
  type        = string
  default     = "app"
  description = "Service name."
}

variable "cluster_id" {
  type        = string
  default     = "arn:aws:ecs:ap-northeast-1:898622234277:cluster/data"
  description = "ECS cluster where the application lives."
}

variable "certificate_arn" {
  type        = string
  default     = "arn:aws:acm:ap-northeast-1:898622234277:certificate/f926aa8b-39df-4849-be62-297fb131be27"
  description = "ACM certificate ARN."
}

variable "cpu" {
  type        = string
  default     = "1024"
  description = "Fargate CPU."
}

variable "memory" {
  type        = string
  default     = "2048"
  description = "Fargate memory."
}

variable "desired_count" {
  type        = number
  default     = 1
  description = "Number of containers to run."
}

variable "port" {
  type        = number
  default     = 3000
  description = "Port where the app executes."
}

variable "docker_image_tag" {
  type        = string
  default     = "latest"
  description = "Docker image tag to be used."
}

variable "app_image_ecr" {
  type        = string
  default     = "898622234277.dkr.ecr.ap-northeast-1.amazonaws.com/signezily"
  description = "ECR API image to be used."
}

variable "marketing_image_ecr" {
  type        = string
  default     = "898622234277.dkr.ecr.ap-northeast-1.amazonaws.com/signezily"
  description = "ECR API image to be used."
}

variable "docs_image_ecr" {
  type        = string
  default     = "898622234277.dkr.ecr.ap-northeast-1.amazonaws.com/signezily"
  description = "ECR API image to be used."
}

variable "env" {
  type = map(any)
  default = {
  }
  description = "Environment variables for the ECS task."
}

variable "secrets" {
  type = map(any)
  default = {
  }
  description = "Secrets from secrets manager for the ECS task."
}