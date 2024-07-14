module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "${local.env_name}-cluster"
  cluster_version = var.eks_version

  cluster_endpoint_public_access = var.eks_params.cluster_endpoint_public_access

  cluster_enabled_log_types = var.eks_params.cluster_enabled_log_types

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets
  eks_managed_node_group_defaults = {
    vpc_security_group_ids = [aws_security_group.efs_sg.id]
  }
  eks_managed_node_groups = var.eks_managed_node_group_params
}
