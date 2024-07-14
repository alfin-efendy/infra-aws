variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "eks_version" {
  type = string
}

variable "vpc_params" {
  type = object({
    vpc_cidr               = string
    enable_nat_gateway     = bool
    one_nat_gateway_per_az = bool
    single_nat_gateway     = bool
    enable_vpn_gateway     = bool
    enable_flow_log        = bool
  })
}

variable "eks_params" {
  type = object({
    cluster_endpoint_public_access = bool
    cluster_enabled_log_types      = list(string)
  })
}

variable "eks_managed_node_group_params" {
  type = map(object({
    ami_type                   = string
    min_size                   = number
    max_size                   = number
    desired_size               = number
    instance_types             = list(string)
    capacity_type              = string
    taints                     = set(map(string))
    max_unavailable_percentage = number
  }))
}

variable "postgres_core_params" {
  type = object({
    instance_name             = string
    database_name             = string
    database_user             = string
    database_port             = number
    resources_limits_cpu      = string
    resources_limits_memory   = string
    resources_requests_cpu    = string
    resources_requests_memory = string
    image_tag                 = string
    storage_size              = number
    storage_class             = string
    namespace                 = string
    replicas                  = number
    labels                    = map(string)
  })
}

variable "kong_params" {
  type = object({
    namespace = string
  })

}
