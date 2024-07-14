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

variable "nfs_dns_name" {
  description = "The DNS name of the NFS server"
  type        = string
}

variable "instance_name" {
    description = "The name of the PostgreSQL instance"
    type        = string
    default     = "postgres"
}

variable "database_name" {
  description = "The name of the database to create"
  type        = string
  default     = "postgres"
}

variable "database_user" {
  description = "The username for the database"
  type        = string
  default     = "postgres"
}

variable "database_port" {
  description = "The port for the database"
  type        = number
  default     = 5432
}

variable "resources_limits_cpu" {
  description = "The CPU limit for the container"
  type        = string
  default     = "500m"
}

variable "resources_limits_memory" {
  description = "The memory limit for the container"
  type        = string
  default     = "1Gi"
}

variable "resources_requests_cpu" {
  description = "The CPU request for the container"
  type        = string
  default     = "100m"
}

variable "resources_requests_memory" {
  description = "The memory request for the container"
  type        = string
  default     = "128Mi"
}

variable "image_tag" {
  description = "The tag for the image"
  type        = string
  default     = "14"
}

variable "storage_size" {
  description = "The size of the storage in GB"
  type        = number
  default     = 10
}

variable "storage_class" {
  description = "The storage class to use"
  type        = string
  default     = "efs-sc"
}

variable "namespace" {
  description = "The namespace to deploy the database"
  type        = string
  default     = "default"
}

variable "replicas" {
  description = "The number of replicas to deploy"
  type        = number
  default     = 1
}

variable "labels" {
  type        = map(string)
  description = "Labels to add"
  default     = {}
}