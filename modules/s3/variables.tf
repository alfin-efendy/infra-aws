variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "mybucket"
}

variable "tags" {
  description = "Tags to apply to the bucket"
  type        = map(string)
  default = {
    Environment = "dev"
  }
}

variable "region" {
  description = "The AWS region to deploy the bucket"
  type        = string
  default     = "ap-southeast-1"
}

variable "isPrivate" {
  description = "Set to true to block public access to the bucket"
  type        = bool
  default     = true
}

variable "isSetVersioning" {
  description = "Set to true to enable versioning on the bucket"
  type        = bool
  default     = true
}

variable "isSetEncryption" {
  description = "Set to true to enable encryption on the bucket"
  type        = bool
  default     = true
}