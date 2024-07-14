output "env_name" {
  value = local.env_name
}

output "vpc_cidr" {
  value = var.vpc_params.vpc_cidr
}

output "vpc_public_subnets" {
  value = [module.subnet_addrs.network_cidr_blocks["public-1"], module.subnet_addrs.network_cidr_blocks["public-2"]]
}

output "vpc_private_subnets" {
  value = [module.subnet_addrs.network_cidr_blocks["private-1"], module.subnet_addrs.network_cidr_blocks["private-2"]]
}

output "vpc_intra_subnets" {
  value = [module.subnet_addrs.network_cidr_blocks["intra-1"], module.subnet_addrs.network_cidr_blocks["intra-2"]]
}

output "eks_cloudwatch_log_group_arn" {
  value = module.eks.cloudwatch_log_group_arn
}

output "eks_cluster_arn" {
  value = module.eks.cluster_arn
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_ca_certificate" {
  value = module.eks.cluster_certificate_authority_data
}

output "eks_cluster_token" {
  value = data.aws_eks_cluster_auth.default.token
}

output "eks_cluster_iam_role_arn" {
  value = module.eks.cluster_iam_role_arn
}

output "eks_cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "eks_oidc_provider" {
  value = module.eks.oidc_provider
}

output "eks_oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "efs_dns_name" {
  value = aws_efs_file_system.efs.dns_name
}

output "efs_id" {
  value = aws_efs_file_system.efs.id
}