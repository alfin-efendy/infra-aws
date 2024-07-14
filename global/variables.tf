variable "project_name" {
  description = "The project name to be used in global resources names"
  type        = string
  default     = "axorez"
}

variable "region" {
    description = "The AWS region to deploy the resources"
    type        = string
    default     = "ap-southeast-1"
}

# TODO: Add more environments
variable "environments" {
  description = "Environments names"
  type        = set(string)
  default     = ["dev"]
}