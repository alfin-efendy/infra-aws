variable "host" {
  description = "kubernetes cluster endpoint"
  type        = string
}

variable "cluster_ca_certificate" {
  description = "kubernetes cluster certificate authority data"
  type        = string
}

variable "token" {
  description = "kubernetes cluster token"
  type        = string
}

variable "namespace" {
  description = "The namespace to deploy the database"
  type        = string
  default     = "default"
}

variable "database_host"{
    description = "The host of the database"
    type        = string
}

variable "database_port"{
    description = "The port of the database"
    type        = number
}

variable "database_name"{
    description = "The name of the database"
    type        = string
}

variable "database_user"{
    description = "The user of the database"
    type        = string
}

variable "database_password"{
    description = "The password of the database"
    type        = string
}