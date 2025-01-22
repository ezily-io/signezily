variable "path" {
    type = string
    description = "Directory where the files will be created."
}

variable "airbyte_version" {
  type = string
  default = "0.40.32"
  description = "Airbyte version to deploy."
}

variable "db_host" {
  type = string
  description = "Database hostname(DNS)."
}

variable "db_password" {
  type = string
  description = "Database password."
}