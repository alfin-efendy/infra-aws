resource "random_password" "password" {
  length  = 24
  special = true
}

locals {
  kong_db_password      = random_password.password.result
  kong_manager_password = random_password.password.result
}

resource "tls_private_key" "kong_clustering_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}


resource "tls_self_signed_cert" "kong_clustering_cert" {
  #   key_algorithm   = tls_private_key.kong_clustering_key.algorithm
  private_key_pem = tls_private_key.kong_clustering_key.private_key_pem

  subject {
    common_name = "kong_clustering"
  }

  validity_period_hours = 1095 * 24 // 1095 days in hours

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "local_file" "kong_clustering_key" {
  content  = tls_private_key.kong_clustering_key.private_key_pem
  filename = "${path.module}/tls.key"
}

resource "local_file" "kong_clustering_cert" {
  content  = tls_self_signed_cert.kong_clustering_cert.cert_pem
  filename = "${path.module}/tls.crt"
}

resource "kubernetes_secret" "kong_cluster_cert" {
  metadata {
    name      = "kong-cluster-cert"
    namespace = var.namespace
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = base64encode(tls_self_signed_cert.kong_clustering_cert.cert_pem)
    "tls.key" = base64encode(tls_private_key.kong_clustering_key.private_key_pem)
  }
}

resource "postgresql_role" "kong" {
  name     = "kong"
  login    = true
  password = local.kong_db_password
}

resource "postgresql_database" "kong" {
  name       = "kong"
  owner      = postgresql_role.kong.name
  encoding   = "UTF8"
  lc_collate = "en_US.UTF-8"
  lc_ctype   = "en_US.UTF-8"
}

resource "postgresql_grant" "kong" {
  database    = postgresql_database.kong.name
  role        = postgresql_role.kong.name
  privileges  = ["ALL"]
  object_type = "database"
}

resource "kubernetes_config_map" "kong" {
  metadata {
    name      = "kong"
    namespace = var.namespace
    labels = {
      app = "kong"
    }
  }
  data = {
    "POSTGRES_DB"   = postgresql_database.kong.name
    "POSTGRES_PORT" = var.database_port
    "POSTGRES_USER" = postgresql_role.kong.name
  }
}

resource "kubernetes_secret" "postgres-secret" {
  metadata {
    name      = "kong"
    namespace = var.namespace
    labels = {
      app = "kong"
    }
  }
  data = {
    "POSTGRES_PASSWORD" = base64encode(local.kong_db_password)
  }
}

resource "helm_release" "control_plane" {
  chart      = "kong"
  name       = "kong"
  namespace  = var.namespace
  repository = "https://charts.konghq.com"

  values = [templatefile("${path.module}/configs/control-plane.yml", {
    KONG_CLUSTER_CERT      = tls_self_signed_cert.kong_clustering_cert.cert_pem
    KONG_CLUSTER_CERT_KEY  = tls_private_key.kong_clustering_key.private_key_pem
    KONG_DATABASE_HOST     = var.database_host
    KONG_DATABASE          = postgresql_database.kong.name
    KONG_DATABASE_USER     = postgresql_role.kong.name
    KONG_DATABASE_PASSWORD = local.kong_db_password
    KONG_MANAGER_PASSWORD  = local.kong_manager_password
  })]
}
