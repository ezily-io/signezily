variable "bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
}

variable "acl" {
  description = "The ACL for the S3 bucket."
  type        = string
  default     = "private"
}

variable "enable_versioning" {
  description = "Enable versioning for the S3 bucket."
  type        = bool
  default     = false
}

variable "enable_bucket_policy" {
  description = "Enable bucket policy for the S3 bucket."
  type        = bool
  default     = false
}

variable "bucket_policy" {
  description = "The bucket policy JSON for the S3 bucket."
  type        = string
  default     = ""
}

variable "sse_algorithm" {
  description = "The server-side encryption algorithm."
  type        = string
  default     = "AES256"
}

variable "tags" {
  description = "Tags to apply to the S3 bucket."
  type        = map(string)
  default     = {}
}
