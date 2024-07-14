terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.22.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.1"
    }
  }
}

provider "kubernetes" {
  host                   = var.host
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  token                  = var.token
}

provider "helm" {
  kubernetes {
    host                   = var.host
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
    token                  = var.token
  }
}

provider "postgresql" {
  host            = var.database_host
  port            = var.database_port
  database        = var.database_name
  username        = var.database_user
  password        = var.database_password
  sslmode         = "disable"
  connect_timeout = 15
}
