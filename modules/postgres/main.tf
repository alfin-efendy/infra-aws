resource "random_password" "password" {
  length  = 24
  special = true
}

locals {
  db_password = random_password.password.result
}

resource "kubernetes_namespace" "postgres" {
  metadata {
    name = var.namespace
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

resource "kubernetes_config_map" "postgres-config" {
  metadata {
    name      = var.instance_name
    namespace = var.namespace
    labels = {
      app = var.instance_name
    }
  }
  data = {
    "POSTGRES_DB"   = var.database_name
    "POSTGRES_PORT" = var.database_port
    "POSTGRES_USER" = var.database_user
  }
}

resource "kubernetes_secret" "postgres-secret" {
  metadata {
    name      = var.instance_name
    namespace = var.namespace
    labels = {
      app = var.instance_name
    }
  }
  data = {
    "POSTGRES_PASSWORD" = base64encode(local.db_password)
  }
}

resource "kubernetes_persistent_volume" "postgres-pv" {
  metadata {
    name = var.instance_name
    labels = {
      app = var.instance_name
    }
  }
  spec {
    storage_class_name = var.storage_class
    capacity = {
      storage = "${var.storage_size}Gi"
    }
    volume_mode                      = "Filesystem"
    access_modes                     = ["ReadWriteMany"]
    persistent_volume_reclaim_policy = "Retain"
    persistent_volume_source {
      nfs {
        path   = "/${var.namespace}/${var.instance_name}"
        server = var.nfs_dns_name
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "postgres-pvc" {
  metadata {
    name      = var.instance_name
    namespace = var.namespace
    labels = {
      app = var.instance_name
    }
  }
  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = var.storage_class
    resources {
      requests = {
        storage = "${var.storage_size}Gi"
      }
    }
  }
  depends_on = [kubernetes_persistent_volume.postgres-pv]
  timeouts {
    create = "5m"
  }
}

resource "kubernetes_deployment" "postgres" {
  metadata {
    name      = var.instance_name
    namespace = var.namespace
    labels = {
      app = var.instance_name
    }
  }
  spec {
    replicas = var.replicas
    selector {
      match_labels = {
        app = var.instance_name
      }
    }
    template {
      metadata {
        labels = {
          app = var.instance_name
        }
      }
      spec {
        container {
          name              = var.instance_name
          image             = "postgres:${var.image_tag}"
          image_pull_policy = "IfNotPresent"
          port {
            container_port = var.database_port
          }
          resources {
            limits = {
              cpu    = var.resources_limits_cpu
              memory = var.resources_limits_memory
            }
            requests = {
              cpu    = var.resources_requests_cpu
              memory = var.resources_requests_memory
            }
          }
          env {
            name  = "POSTGRES_DB"
            value = kubernetes_config_map.postgres-config.data["POSTGRES_DB"]
          }
          env {
            name  = "POSTGRES_PORT"
            value = kubernetes_config_map.postgres-config.data["POSTGRES_PORT"]
          }
          env {
            name  = "POSTGRES_USER"
            value = kubernetes_config_map.postgres-config.data["POSTGRES_USER"]
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = kubernetes_secret.postgres-secret.data["POSTGRES_PASSWORD"]
          }
          startup_probe {
            exec {
              command = ["sh", "-c", "exec pg_isready -U $${POSTGRES_USER} -d dbname=$${POSTGRES_DB} -h 127.0.0.1 -p $${POSTGRES_PORT}"]
            }
            initial_delay_seconds = 30
            period_seconds        = 3
            failure_threshold     = 5
            success_threshold     = 1
          }
          readiness_probe {
            exec {
              command = ["sh", "-c", "exec pg_isready -U $${POSTGRES_USER} -d dbname=$${POSTGRES_DB} -h 127.0.0.1 -p $${POSTGRES_PORT}"]
            }
            initial_delay_seconds = 60
            period_seconds        = 10
            failure_threshold     = 3
            success_threshold     = 1
          }
          liveness_probe {
            exec {
              command = ["sh", "-c", "exec pg_isready -U $${POSTGRES_USER} -d dbname=$${POSTGRES_DB} -h 127.0.0.1 -p $${POSTGRES_PORT}"]
            }
            initial_delay_seconds = 30
            period_seconds        = 300
            failure_threshold     = 6
            success_threshold     = 1
          }
          volume_mount {
            name       = "data"
            mount_path = "/var/lib/postgresql"
          }
        }
        volume {
          name = "data"
          persistent_volume_claim {
            claim_name = var.instance_name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "postgres" {
  metadata {
    name      = var.instance_name
    namespace = var.namespace
    labels = {
      app = var.instance_name
    }
  }
  spec {
    selector = {
      app = var.instance_name
    }
    port {
      port        = var.database_port
      target_port = var.database_port
    }
  }
}
