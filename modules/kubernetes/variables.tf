variable "project_name" {
  description = "A project name to be used in resources"
  type        = string
  default     = "k8s"
}

variable "environment" {
  description = "Dev/Prod, will be used in AWS resources Name tag, and resources names"
  type        = string
  default     = "test"
}

variable "region" {
  description = "AWS region to deploy the resources"
  type        = string
  default     = "ap-southeast-1"
}

variable "eks_version" {
  description = "Kubernetes version, will be used in AWS resources names and to specify which EKS version to create/update"
  type        = string
  default     = "1.30"
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
  default = {
    vpc_cidr               = "10.0.0.0/16"
    enable_nat_gateway     = true
    one_nat_gateway_per_az = true
    single_nat_gateway     = false
    enable_vpn_gateway     = false
    enable_flow_log        = false
  }
}

variable "eks_params" {
  description = "EKS cluster itslef parameters"
  type = object({
    cluster_endpoint_public_access = bool
    cluster_enabled_log_types      = list(string)
  })
  default = {
    cluster_endpoint_public_access = true
    cluster_enabled_log_types      = ["audit", "api", "authenticator", "controllerManager", "scheduler"]
  }
}

variable "eks_managed_node_group_params" {
  description = "EKS Managed NodeGroups setting, one item in the map() per each dedicated NodeGroup"
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
  default = {
    default_group = {
      ami_type                   = "AL2_ARM_64"
      min_size                   = 1
      max_size                   = 2
      desired_size               = 3
      instance_types             = ["t4g.nano"]
      capacity_type              = "ON_DEMAND"
      taints                     = []
      max_unavailable_percentage = 50
    }
  }
}
