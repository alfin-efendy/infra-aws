data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_eks_cluster_auth" "default" {
  name = module.eks.cluster_name
}

locals {
  env_name = "${var.project_name}-${var.environment}"
  eks_cluster_name = "${local.env_name}-cluster"
}