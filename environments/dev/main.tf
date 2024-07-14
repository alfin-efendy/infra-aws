module "k8s" {
  source                        = "../../modules/kubernetes"
  project_name                  = var.project_name
  environment                   = var.environment
  region                        = var.region
  eks_version                   = var.eks_version
  vpc_params                    = var.vpc_params
  eks_params                    = var.eks_params
  eks_managed_node_group_params = var.eks_managed_node_group_params
}

module "s3_public" {
  source      = "../../modules/s3"
  bucket_name = "${var.project_name}-public-${var.environment}"
  tags = {
    type        = "public"
    environment = var.environment
  }
  region          = var.region
  isPrivate       = false
  isSetVersioning = true
  isSetEncryption = true
}

module "s3_private" {
  source      = "../../modules/s3"
  bucket_name = "${var.project_name}-private-${var.environment}"
  tags = {
    type        = "private"
    environment = var.environment
  }
  region          = var.region
  isPrivate       = true
  isSetVersioning = true
  isSetEncryption = true
}

module "postgres-core" {
  source = "../../modules/postgres"

  host                   = module.k8s.eks_cluster_endpoint
  token                  = module.k8s.eks_cluster_token
  cluster_ca_certificate = module.k8s.eks_cluster_ca_certificate
  nfs_dns_name           = module.k8s.efs_dns_name
  instance_name          = var.postgres_core_params.instance_name
  database_name          = var.postgres_core_params.database_name
  database_user          = var.postgres_core_params.database_user
  database_port          = var.postgres_core_params.database_port
  storage_size           = var.postgres_core_params.storage_size
  storage_class          = var.postgres_core_params.storage_class
  namespace              = var.postgres_core_params.namespace
  replicas               = var.postgres_core_params.replicas
  labels                 = var.postgres_core_params.labels
}

module "kong" {
  source = "../../modules/kong"

  host                   = module.k8s.eks_cluster_endpoint
  token                  = module.k8s.eks_cluster_token
  cluster_ca_certificate = module.k8s.eks_cluster_ca_certificate
  namespace              = var.kong_params.namespace
  database_host          = module.postgres-core.database_host
  database_port          = module.postgres-core.database_port
  database_name          = module.postgres-core.database_name
  database_user          = module.postgres-core.database_user
  database_password      = module.postgres-core.database_password
}
