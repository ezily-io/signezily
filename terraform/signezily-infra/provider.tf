provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Automation  = "Terraform"
      App         = var.application
      Environment = var.environment
    }
  }
}

terraform {

  cloud {
    organization = "rainforest"

    workspaces {
      tags = ["signezily"]
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.31.0"
    }
  }
}
